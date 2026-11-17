#!/usr/bin/env python3
"""Emit a partition optimised for the *second-order* panel error at a given `c`.

The panel error of `panels.py --order 2` is `B(a,b,c)·h³/4` with

    B = W₂·Om + 2·W₁·L + W·S,
    W₂ = (1/400)·e^{−a²/400}·(1/200 + b²/40000 + c² + 2(b/200)|c|),
    W₁ = (1/400)(b/200 + |c|),   W = (1/400)/(1 + a²/400),
    Om ≈ |Ω(a)|,  L = 5/(2a) (a ≥ 1) or 10,  S = 5/a² (a ≥ 1) or 33.

Minimising `E(h,a) + λ/h` gives `h = (4λ/(3B))^{1/3}`, so a coarser partition
where `B` is large.  `edges_779.txt` was built from the *first-order* model at
`c = 0`, which is why its `c = 6/5` chain comes out five times wider than the
`c = 0` one.
"""
import argparse, bisect, math
from fractions import Fraction as F
import mpmath as mp

mp.mp.dps = 25

_N = 4000
_grid = [10 ** (-2 + (math.log10(80) + 2) * i / _N) for i in range(_N + 1)]
_om = [abs(float(mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * t / 2)) - mp.log(mp.pi))) for t in _grid]


def q_abs(a):
    i = bisect.bisect_left(_grid, a)
    if i <= 0:
        return _om[0]
    if i >= len(_grid):
        return _om[-1]
    x0, x1 = _grid[i - 1], _grid[i]
    y0, y1 = _om[i - 1], _om[i]
    return y0 + (y1 - y0) * (a - x0) / (x1 - x0)


def Bconst(a, b, c):
    W2 = (1 / 400) * math.exp(-a * a / 400) * (1 / 200 + b * b / 40000 + c * c + 2 * (b / 200) * abs(c))
    W1 = (1 / 400) * (b / 200 + abs(c))
    W = (1 / 400) / (1 + a * a / 400)
    Om = q_abs(a)
    L = 5 / (2 * a) if a >= 1 else 10.0
    S = 5 / (a * a) if a >= 1 else 33.0
    return W2 * Om + 2 * W1 * L + W * S


def build(lam, c, den, n0, t1):
    edges = [F(0)]
    a = F(0)
    while a < t1:
        af = float(a)
        h = (4 * lam / (3 * Bconst(af, af, c))) ** (1 / 3)
        h = max(h, 1.0 / n0)
        b = F(int(min(round((af + h) * den), t1 * den)), den)
        if b <= a:
            b = a + F(1, den)
        edges.append(b)
        a = b
    if edges[-1] < t1:
        edges.append(F(t1))
    return edges


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lam", type=float, required=True)
    ap.add_argument("--c", default="6/5")
    ap.add_argument("--den", type=int, default=1000)
    ap.add_argument("--n0", type=int, default=125)
    ap.add_argument("--t1", type=float, default=80.0)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    c = float(F(a.c))
    e = build(a.lam, c, a.den, a.n0, a.t1)
    with open(a.out, "w") as f:
        for x in e:
            f.write(f"{x.numerator}/{x.denominator}\n")
    print(f"wrote {a.out}: {len(e)-1} panels, min h={float(min(e[i+1]-e[i] for i in range(len(e)-1))):.4f}")


if __name__ == "__main__":
    main()
