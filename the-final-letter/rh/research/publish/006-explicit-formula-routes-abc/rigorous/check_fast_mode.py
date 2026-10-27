#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""010/rigorous/check_fast_mode.py — validate the CERTIFIED FAST MODE of eta_interval.

The engine's soundness contract (see `eta_interval.set_precision`) is

    EPS  >=  accumulated rounding error at the working precision,

with `EPS(work) = 10^-(work - 20)`.  The fast mode is `work = 60`, `EPS = 1e-40`.
This script checks:

  1. bookkeeping — `fast_mode()` really sets `work = 60`, `EPS = 1e-40`, and the
     resulting EPS dominates `10^-work`;
  2. containment — at several `(sigma, t)` the fast-mode `eta_box` still contains
     mpmath's `altzeta` value, i.e. the fast mode is not lying about its error;
  3. widths — reports the enclosure widths in both modes for comparison.

Each mode is evaluated in its own subprocess, so mpmath's global precision and the
`ivmath` caches cannot bleed between them.

Exit 0 iff every containment check passes.

    python3 check_fast_mode.py            # full check (spawns two subprocesses)
    python3 check_fast_mode.py --mode fast    # internal: one mode, raw table
"""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

TESTS = [("0.5", "14.134725141734693", 60), ("0.5", "20.0", 60),
         ("0.49", "14.134725141734693", 60), ("0.51", "14.0", 60)]


def _run_mode(mode):
    """Run this file in a subprocess for `mode` and return the raw stdout lines."""
    out = subprocess.run([sys.executable, os.path.abspath(__file__), "--mode", mode],
                         capture_output=True, text=True)
    if out.returncode != 0:
        raise SystemExit("subprocess --mode %s failed:\n%s\n%s" % (mode, out.stdout, out.stderr))
    return [ln for ln in out.stdout.splitlines() if ln.strip()]


def _one_mode(mode):
    """Compute the test enclosures in the requested mode; print `sigma t vlo vhi`."""
    import mpmath as mp
    mp.mp.dps = 60
    import eta_interval as E
    info = E.fast_mode() if mode == "fast" else E.set_precision(E.DEFAULT_WORK, scale_eps=False)
    print("# mode=%s work=%d eps=%s prec=%d" % (mode, info["work"], mp.nstr(info["eps"], 3), info["prec"]))
    for (sig, t, K) in TESTS:
        box = E.eta_box(mp.mpf(sig), mp.mpf(sig), mp.mpf(t), mp.mpf(t), K)
        print("%s %s %s %s" % (sig, t, mp.nstr(box.re.lo, 30), mp.nstr(box.re.hi, 30)),
              flush=True)


def main(argv):
    if "--mode" in argv:
        _one_mode(argv[argv.index("--mode") + 1])
        return 0

    import mpmath as mp
    mp.mp.dps = 60
    import eta_interval as E

    # 1. bookkeeping
    info = E.fast_mode()
    fails = []
    ok_work = info["work"] == 60
    ok_eps = abs(info["eps"] - mp.mpf("1e-40")) < mp.mpf("1e-55")
    ok_dom = info["eps"] >= mp.mpf(10) ** (-60)
    print("[%s] fast_mode: work = %d (want 60)" % ("PASS" if ok_work else "FAIL", info["work"]))
    print("[%s] fast_mode: EPS = %s (want 1e-40)" % ("PASS" if ok_eps else "FAIL", mp.nstr(info["eps"], 3)))
    print("[%s] fast_mode: EPS >= 10^-work  (contract)" % ("PASS" if ok_dom else "FAIL"))
    if not (ok_work and ok_eps and ok_dom):
        fails.append("bookkeeping")

    # restore the default state for this process (not strictly needed)
    E.set_precision(E.DEFAULT_WORK, scale_eps=False)

    # 2/3. containment in each mode
    tables = {m: [] for m in ("slow", "fast")}
    for mode in ("slow", "fast"):
        for ln in _run_mode(mode):
            if ln.startswith("#"):
                continue
            sig, t, vlo, vhi = ln.split()
            tables[mode].append((sig, t, mp.mpf(vlo), mp.mpf(vhi)))

    print("\n  sigma  t                     slow width   fast width   fast contains value")
    for (sig, t, K), (_, _, slo, shi), (_, _, flo, fhi) in zip(TESTS, tables["slow"], tables["fast"]):
        ref = mp.altzeta(mp.mpf(sig) + 1j * mp.mpf(t))
        re_ref = mp.re(ref)
        contains = flo <= re_ref <= fhi
        tag = "PASS" if contains else "FAIL"
        if not contains:
            fails.append("fast containment sigma=%s t=%s" % (sig, t))
        print("  [%s] %-5s %-20s %.3e   %.3e   %s"
              % (tag, sig, t, float(shi - slo), float(fhi - flo), contains))

    print("\n%d fail(s)" % len(fails))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
