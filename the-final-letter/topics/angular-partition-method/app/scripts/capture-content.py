"""Persistent Playwright capture worker for verify-content.mjs (JSON lines).

Uses the preinstalled 3D Python runtime; no project npm dependency or browser
download. One browser/page is reused, while every capture has the same deadline.
"""

import json
import signal
import sys
import time
from pathlib import Path
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

from playwright.sync_api import sync_playwright


class CaptureSession:
    def __init__(self, playwright, browser_path, timeout_ms):
        self.timeout_ms = timeout_ms
        self.browser = playwright.chromium.launch(
            executable_path=browser_path,
            headless=True,
            timeout=timeout_ms,
            args=[
                "--disable-gpu",
                "--enable-unsafe-swiftshader",
                "--use-angle=swiftshader",
                "--hide-scrollbars",
                "--no-sandbox",
                "--disable-dev-shm-usage",
            ],
        )
        self.page = self.browser.new_page(
            viewport={"width": 1440, "height": 900}, device_scale_factor=1
        )
        self.page.set_default_timeout(timeout_ms)
        self.page.set_default_navigation_timeout(timeout_ms)
        self.errors = []
        self.page.on("pageerror", lambda error: self.errors.append(str(error)))
        self.page.on("console", self.console_message)
        self.page.on(
            "requestfailed",
            lambda request: self.errors.append(f"{request.url}: {request.failure}"),
        )
        self.page.on("response", self.response)
        self.url = None
        self.capture_mode = True

    def console_message(self, message):
        if message.type == "error" and not message.location.get("url", "").endswith(
            "/favicon.ico"
        ):
            self.errors.append(message.text)

    def response(self, response):
        if response.status >= 400 and not response.url.endswith("/favicon.ico"):
            self.errors.append(f"HTTP {response.status}: {response.url}")

    def open(self, url, width, height, fresh=False, capture_mode=True, moment=None):
        # Set the mode BEFORE navigation. Stopping a busy renderer after READY
        # can be too late; all verifier paths (including the probe) use this URL.
        self.capture_mode = capture_mode
        if capture_mode:
            parts = urlsplit(url)
            query = dict(parse_qsl(parts.query, keep_blank_values=True))
            query["capture"] = "1"
            if moment is not None:
                query["t"] = str(moment)
            else:
                query.setdefault("t", "0")
            url = urlunsplit(parts._replace(query=urlencode(query)))
        self.page.set_viewport_size({"width": width, "height": height})
        if fresh or url != self.url:
            self.errors.clear()
            # Poll readiness ourselves so a 404/runtime error does not wait for
            # another slow resource or module to finish loading first.
            self.page.goto(url, wait_until="commit")
            self.url = url
        self.wait_ready()

    def wait_ready(self):
        deadline = time.monotonic() + self.timeout_ms / 1000
        painted = False
        while True:
            if self.errors:
                raise RuntimeError(self.errors[0])
            state = self.page.evaluate("""() => ({
                error: window.__SCENE_ERROR__ ? String(window.__SCENE_ERROR__) : null,
                complete: document.readyState === 'complete',
                canvas: !!document.querySelector('canvas'),
                hasReady: window.__SCENE_READY__ !== undefined,
                captureMode: window.__CAPTURE_MODE__ === true,
                collectorError: window.__verifyErrors?.[0] || null,
                ready: document.readyState === 'complete'
                  && (window.__SCENE_READY__ === undefined || window.__SCENE_READY__ === true)
                  && (!document.fonts || document.fonts.status === 'loaded')
                  && [...document.images].every(i => i.complete && i.naturalWidth > 0)
            })""")
            if state["error"] or state["collectorError"]:
                raise RuntimeError(state["error"] or state["collectorError"])
            if state["complete"] and state["canvas"]:
                if not state["hasReady"]:
                    raise RuntimeError(
                        "Canvas capture requires __SCENE_READY__ after assets and target frame render"
                    )
                if self.capture_mode and not state["captureMode"]:
                    raise RuntimeError(
                        "Canvas ignored capture=1: acknowledge __CAPTURE_MODE__ and stop continuous rendering from startup"
                    )
            if state["ready"]:
                if painted:
                    return
                # Cross a paint boundary; this is not a substitute for the scene's
                # own ready signal, which must follow required loads and rendering.
                self.page.evaluate(
                    "() => new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)))"
                )
                painted = True
                continue  # recheck READY/ERROR after the paint boundary
            painted = False
            if time.monotonic() >= deadline:
                raise TimeoutError(
                    "Readiness timed out: required assets/render or __SCENE_READY__ incomplete"
                )
            self.page.wait_for_timeout(50)

    def probe(self):
        return self.page.evaluate("""() => ({
            ok: true, hasSeek: typeof window.__seek === 'function',
            hasCapture: typeof window.__capture === 'function' && typeof window.__restore === 'function',
            captureMode: window.__CAPTURE_MODE__ === true,
            sceneReady: window.__SCENE_READY__ === true,
            title: document.title, canvases: document.querySelectorAll('canvas').length,
            svgs: document.querySelectorAll('svg').length, nodes: document.querySelectorAll('*').length,
            errors: window.__verifyErrors || []
        })""")

    def capture(self, path, moment=None):
        hooks = self.probe()
        paired = hooks["hasCapture"]
        legacy = not paired and hooks["hasSeek"]
        capture_error = None
        try:
            if paired:
                self.page.evaluate(
                    "t => window.__capture(t === null ? undefined : t)", moment
                )
            elif legacy:
                self.page.evaluate("t => window.__seek(t === null ? 0 : t)", moment)
            elif moment is not None:
                raise RuntimeError(
                    "Loop capture requires window.__seek or paired capture hooks"
                )
            # A hook may load a state/texture asynchronously or change the camera.
            # Its target frame, not an earlier page-ready event, gates capture.
            self.wait_ready()
            self.page.screenshot(path=str(path), timeout=self.timeout_ms)
            if self.errors:
                raise RuntimeError(self.errors[0])
        except Exception as error:
            capture_error = error
            self.url = None
            raise
        finally:
            if paired:
                restore_start = len(self.errors)
                try:
                    # evaluate awaits a returned Promise. Cross the restore's
                    # paint boundary too, so redraw errors belong to this shot.
                    self.page.evaluate("() => window.__restore()")
                    scene_error = self.page.evaluate("""async () => {
                        await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
                        return String(window.__SCENE_ERROR__ || window.__verifyErrors?.[0] || '');
                    }""")
                    restore_errors = self.errors[restore_start:]
                    if restore_errors or scene_error:
                        raise RuntimeError(
                            restore_errors[0] if restore_errors else scene_error
                        )
                except Exception as error:
                    # An explicit retry must reload the damaged page, including
                    # at the same URL. Never hide errors by clearing a live page.
                    self.url = None
                    detail = f"Restore failed: {error}"
                    if capture_error is not None:
                        raise RuntimeError(
                            f"{capture_error}\n{detail}"
                        ) from capture_error
                    raise RuntimeError(detail) from error
            elif legacy:
                # Old templates have no state-preserving restore contract. Discard
                # their parked page instead of guessing whether to resume animation.
                self.url = None
        return {"path": str(path)}

    def close(self):
        self.browser.close()


def main():
    signal.signal(signal.SIGTERM, lambda signum, frame: sys.exit(1))
    session = None
    with sync_playwright() as playwright:
        try:
            for line in sys.stdin:
                try:
                    request = json.loads(line)
                    operation = request["op"]
                    if operation == "start":
                        session = CaptureSession(
                            playwright, request["browser"], request["timeout"]
                        )
                        result = {"started": True}
                    elif operation == "close":
                        break
                    else:
                        session.open(
                            request["url"],
                            request.get("width", 1440),
                            request.get("height", 900),
                            fresh=request.get("fresh", False),
                            moment=request.get("time"),
                        )
                        if operation == "probe":
                            result = session.probe()
                        elif operation == "capture":
                            result = session.capture(
                                Path(request["path"]), request.get("time")
                            )
                        else:
                            raise ValueError(f"Unknown operation: {operation}")
                    print(json.dumps({"ok": True, "result": result}), flush=True)
                except Exception as error:  # noqa: BLE001 - serialize failures at the worker protocol boundary
                    print(json.dumps({"ok": False, "error": str(error)}), flush=True)
        finally:
            if session:
                session.close()


if __name__ == "__main__":
    main()
