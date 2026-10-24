#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""010/rigorous/scan_i3_boxes.py — enclosure check of every I3(T) midpoint-rule box.

`I3_certificate(T, steps_per_unit, K, Lf_const=None)` evaluates `xi_logderiv` on
each step box of the Route-B path.  Near `Re s = 1`, `t_k = 2 pi k / ln 2` the
ordinary quotient engines can fail or return an envelope too wide for the
division; `xi_logderiv` falls back to the local Taylor enclosure `zeta_local_box`
in that case.  This script enumerates exactly the boxes a given `(T,
steps_per_unit)` uses, evaluates `xi_logderiv` on each, and reports the ones that
raise.  It is the check that found the `t in [113/12, 19/2]` box (used to be the
only failure at `T = 15`), and it runs the boxes in parallel.

    python3 scan_i3_boxes.py [T] [steps_per_unit] [K]

Exit 0 iff every box encloses without raising.  Read-only.
"""
import math
import os
import sys
from concurrent.futures import ProcessPoolExecutor
from fractions import Fraction as F

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

HERE = os.path.dirname(os.path.abspath(__file__))


def _evaluate(task):
    box, K = task
    import mpmath as mp
    mp.mp.dps = 40
    import eta_interval as E
    E.fast_mode()
    E._D = 10 ** 18
    s_lo, s_hi, t_lo, t_hi = box
    try:
        E.xi_logderiv(F(s_lo), F(s_hi), F(t_lo), F(t_hi), K, 10)
        return (box, "ok")
    except Exception as ex:                       # noqa: BLE001 - report and continue
        return (box, "%s: %s" % (type(ex).__name__, ex))


def i3_boxes(T, steps_per_unit):
    """Exactly the boxes `I3_certificate(T, steps_per_unit)` feeds to xi_logderiv."""
    T, h = F(T), F(1, 2)
    path = [((h, h), (F(1), h)), ((F(1), h), (F(1), T)), ((F(1), T), (h, T))]
    out = []
    for (P, Q) in path:
        dx, dy = Q[0] - P[0], Q[1] - P[1]
        n = max(1, int(math.ceil(steps_per_unit * math.sqrt(float(dx * dx + dy * dy)))))
        for i in range(n):
            ax, ay = P[0] + dx * i / n, P[1] + dy * i / n
            bx, by = P[0] + dx * (i + 1) / n, P[1] + dy * (i + 1) / n
            out.append((str(min(ax, bx)), str(max(ax, bx)),
                        str(min(ay, by)), str(max(ay, by))))
    return out


def main(argv):
    T = argv[0] if len(argv) > 0 else 15
    steps = int(argv[1]) if len(argv) > 1 else 12
    K = int(argv[2]) if len(argv) > 2 else 40
    boxes = i3_boxes(T, steps)
    print("scanning %d boxes (T=%s, steps/unit=%d, K=%d)" % (len(boxes), T, steps, K), flush=True)
    fails = 0
    # Worker count is configurable so this tool can be run alongside long
    # certificates without saturating every core (SCAN_WORKERS, default 8).
    with ProcessPoolExecutor(max_workers=int(os.environ.get("SCAN_WORKERS", "8"))) as ex:
        for box, res in ex.map(_evaluate, [(b, K) for b in boxes]):
            if res != "ok":
                fails += 1
                print("FAIL", box, res, flush=True)
    print("done, %d failing box(es)" % fails, flush=True)
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
