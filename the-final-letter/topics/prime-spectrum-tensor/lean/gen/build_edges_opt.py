#!/usr/bin/env python3
"""Emit the non-uniform edge list used by the compact density certificates.

Edges are on a grid of `1/den` so that every panel width is `m/den` with a
small integer `m`; this keeps the denominators of the cumulative rational
partial sums bounded (a fine grid such as `1e-9` makes them explode).

The grid follows the Lagrangian solution of `optimise.py`: minimise
`E(h,a) + lam/h` pointwise, where `E` is the panel error of `panels.py`.
"""

import argparse
import bisect
import math
from fractions import Fraction as F

import mpmath as mp

mp.mp.dps = 25

_N = 4000
_grid = [10 ** (-2 + (math.log10(60) + 2) * i / _N) for i in range(_N + 1)]
_om = [abs(float(mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * t / 2)) - mp.log(mp.pi)))
       for t in _grid]


def q_abs(a):
    i = bisect.bisect_left(_grid, a)
    if i <= 0:
        return _om[0]
    if i >= len(_grid):
        return _om[-1]
    x0, x1 = _grid[i - 1], _grid[i]
    y0, y1 = _om[i - 1], _om[i]
    return y0 + (y1 - y0) * (a - x0) / (x1 - x0)


LIPC = 6.0


def lip_sw(a):
    lip = LIPC / a if a >= 1 else 10.0
    return lip, 1.0 / (400.0 + a * a)


def dEdh(h, a, wden):
    lip, sw = lip_sw(a)
    return 3 * q_abs(a) * h * h / (4 * wden) + 1e-4 * sw + lip * sw * h


def solve_h(lam, a, wden):
    lo, hi = 1e-9, 2.0
    if hi * hi * dEdh(hi, a, wden) < lam:
        return hi
    for _ in range(80):
        mid = 0.5 * (lo + hi)
        if mid * mid * dEdh(mid, a, wden) < lam:
            lo = mid
        else:
            hi = mid
    return 0.5 * (lo + hi)


def build(lam, den, wden, n0, t1=60.0):
    edges = [F(i, n0) for i in range(n0 + 1)]
    k = den                                    # edge index in units of 1/den; a = k/den
    while True:
        a = F(k, den)
        if a >= t1:
            break
        h = solve_h(lam, float(a), wden)
        m = max(1, int(round(h * den)))
        k = min(k + m, int(t1 * den))
        edges.append(F(k, den))
    return edges


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--lam", type=float, default=3e-8)
    ap.add_argument("--den", type=int, default=1000)
    ap.add_argument("--wden", type=int, default=400)
    ap.add_argument("--n0", type=int, default=125)
    ap.add_argument("--t1", type=float, default=60.0, help="upper end of the partition")
    ap.add_argument("--out", default="edges.txt")
    ap.add_argument("--lip-c", default="6", help="Lipschitz coefficient C in |Omega'| <= C/t")
    a = ap.parse_args()
    from fractions import Fraction as _F
    LIPC = float(_F(a.lip_c))
    e = build(a.lam, a.den, a.wden, a.n0, t1=a.t1)
    with open(a.out, "w") as f:
        for x in e:
            f.write(f"{x.numerator}/{x.denominator}\n")
    print(f"wrote {a.out}: {len(e)-1} panels, min h={float(min(e[i+1]-e[i] for i in range(len(e)-1))):.4f}")
