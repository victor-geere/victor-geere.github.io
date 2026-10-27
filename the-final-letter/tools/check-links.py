#!/usr/bin/env python3
"""Check that the-final-letter is self-contained and internally linked.

The folder is self-contained when no relative link points outside it. Curated
documents (the numbered sections, topics, the two evidence annexes, and the
paper bundle) must also have no broken links. The two snapshot trees (`archive/`
and `rh/`) are imported evidence; their pre-existing dangling references are
reported but do not fail the check. Links to `BUILD.log` are skipped: the
log is a local build artefact, ignored by Git, and absent in a fresh checkout.
"""
from __future__ import annotations

import collections
import re
import sys
import urllib.parse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SNAPSHOTS = ("archive", "rh")
SKIP_PREFIXES = ("http://", "https://", "mailto:", "data:", "javascript:", "#", "//")
ATTR = re.compile(r'(?:href|src)="([^"]+)"')
MD = re.compile(r"\]\(([^)\s]+)\)")
CSS = re.compile(r"url\(\s*['\"]?([^'\")]+)['\"]?\s*\)")
SRCSET = re.compile(r'srcset="([^"]+)"')


def group_of(rel: Path) -> str:
    top = rel.parts[0]
    if top in ("summary", "summary-rh", "archive", "rh"):
        return top
    if top == "topics":
        return "topics"
    if top == "geometric-dynamical-phase-transitions":
        return "bundle"
    return "letter"


def tokens(text: str):
    for m in ATTR.finditer(text):
        yield m.group(1)
    for m in MD.finditer(text):
        yield m.group(1)
    for m in CSS.finditer(text):
        yield m.group(1)
    for m in SRCSET.finditer(text):
        for candidate in m.group(1).split(","):
            part = candidate.strip().split(" ")[0]
            if part:
                yield part


def target_is_path(link: str) -> bool:
    """Skip MathJax fragments such as ``[a](k)`` that merely look like links."""
    return "." in link or "/" in link


def main() -> int:
    outside = collections.Counter()
    broken = collections.Counter()
    checked = 0
    for path in ROOT.rglob("*"):
        if path.suffix.lower() not in (".md", ".html"):
            continue
        if any(part in ("__pycache__", ".pytest_cache") for part in path.parts):
            continue
        rel = path.relative_to(ROOT)
        where = group_of(rel)
        for link in tokens(path.read_text(errors="ignore")):
            link = link.strip()
            if not link or link.startswith(SKIP_PREFIXES):
                continue
            base = urllib.parse.unquote(link.split("#", 1)[0].split("?", 1)[0])
            if not base or not target_is_path(base) or "\\" in base or "{" in base:
                continue
            # BUILD.log is a local build artefact (ignored by Git), so a link to
            # it is expected to be absent in a fresh checkout.
            if base.rsplit("/", 1)[-1] == "BUILD.log":
                continue
            checked += 1
            target = (path.parent / base).resolve()
            try:
                target.relative_to(ROOT)
            except ValueError:
                outside[where] += 1
                continue
            if not target.exists():
                broken[where] += 1

    curated = ("letter", "topics", "summary", "summary-rh", "bundle")
    snapshot = ("archive", "rh")
    curated_broken = sum(broken[g] for g in curated)
    snapshot_broken = sum(broken[g] for g in snapshot)
    external = sum(outside.values())

    print(f"checked {checked} internal links in {ROOT}")
    print(f"external (must be 0): {external}")
    print(f"broken in curated documents (must be 0): {curated_broken}")
    print(f"dangling inside snapshots (informational): {snapshot_broken}")
    if curated_broken:
        for g in curated:
            if broken[g]:
                print(f"  {g}: {broken[g]}")
    if snapshot_broken:
        for g in snapshot:
            if broken[g]:
                print(f"  {g}: {broken[g]}")
    if external:
        print("FAIL: links leave the-final-letter")
        return 1
    if curated_broken:
        print("FAIL: curated documents contain broken links")
        return 1
    print("OK: self-contained; curated links resolve")
    return 0


if __name__ == "__main__":
    sys.exit(main())
