#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""010/rigorous/probe_lf.py — per-box |f'| bounds over the I3(T) path.

Reports the sum of the curvature bounds `Lf` that `I3_certificate(...,
Lf_const=None)` uses, the resulting midpoint-rule error budget, and the worst
boxes.  It documents *why* the unconditional T=15 count is currently UNDECIDED:
the interval enclosure of `f' = (log xi)''` over a step box is dominated by the
phase error of the eta series (which grows like the box height) and is amplified
near the removable singularities `t_k = 2 pi k / ln 2`; the sum of the bounds is
~10^2x the true total.  Read-only.
"""
import math
import os
import sys
from concurrent.futures import ProcessPoolExecutor
from fractions import Fraction as F

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def one(task):
    box, K = task
    import mpmath as mp
    mp.mp.dps = 40
    import eta_interval as E
    E.fast_mode()
    E._D = 10 ** 18
    s_lo, s_hi, t_lo, t_hi = box
    _, fp = E.xi_logderiv(F(s_lo), F(s_hi), F(t_lo), F(t_hi), K, 10)
    Lf = mp.sqrt((abs(fp.re.v) + fp.re.e) ** 2 + (abs(fp.im.v) + fp.im.e) ** 2)
    return (s_lo, s_hi, t_lo, t_hi, float(fp.re.e), float(Lf))


def main(T=15, steps=12, K=40):
    T = F(T)
    h = F(1, 2)
    path = [((h, h), (F(1), h)), ((F(1), h), (F(1), T)), ((F(1), T), (h, T))]
    boxes = []
    for (P, Q) in path:
        dx, dy = Q[0] - P[0], Q[1] - P[1]
        n = max(1, int(math.ceil(steps * math.sqrt(float(dx * dx + dy * dy)))))
        for i in range(n):
            ax, ay = P[0] + dx * i / n, P[1] + dy * i / n
            bx, by = P[0] + dx * (i + 1) / n, P[1] + dy * (i + 1) / n
            boxes.append((str(min(ax, bx)), str(max(ax, bx)), str(min(ay, by)), str(max(ay, by))))
    res = []
    # worker count configurable so this can run alongside a long certificate
    with ProcessPoolExecutor(max_workers=int(os.environ.get("PROBE_WORKERS", "8"))) as ex:
        for r in ex.map(one, [(b, K) for b in boxes]):
            res.append(r)
    res.sort(key=lambda r: -r[5])
    tot = sum(r[5] for r in res)
    # each path segment is subdivided into steps*length intervals, so ds = 1/steps
    print("boxes=%d  sum Lf=%.1f  sum err(Iim) = sum(Lf)/(8*steps^2) = %.3f  (N half-width %.3f)"
          % (len(res), tot, tot / (8.0 * steps * steps),
             tot / (8.0 * steps * steps) / math.pi), file=sys.stderr)
    print("top 25 by Lf:  (sigma_lo,sigma_hi, t_lo, t_hi, fp_err_re, Lf)")
    for r in res[:25]:
        print("  %s %s  %s %s   err=%.3e  Lf=%.3f" % r)
    import statistics
    print("median Lf=%.3f" % statistics.median([r[5] for r in res]))


if __name__ == "__main__":
    main()
