#!/usr/bin/env python3
"""Choose a near-optimal panel partition for the density certificate.

The per-panel error is

    E(h, a) = |Omega(a)| h^3 / (4 wden) + (1e-4 + lip h/2) h sw
    lip = 6/a (a >= 1), 10 (a < 1);   sw = 1/(400 + a^2)

so the total certificate half-width is `sum_p E_p + 1/10000`.  For a fixed
panel count the optimal partition minimises `sum_p E_p`, which is a Lagrange
problem: minimise `E(h,a) + lam/h` pointwise in `h` and tune `lam`.

This script prints the predicted panel count and half-width for a scan of
`lam`, then writes the resulting edges to `edges.txt` (one rational per line).
"""

import math
import sys
from fractions import Fraction as F

import mpmath as mp

mp.mp.dps = 30


def omega(t):
    tf = mp.mpf(t)
    return mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * tf / 2)) - mp.log(mp.pi)


def lip_sw(a):
    lip = 6.0 / a if a >= 1 else 10.0
    sw = 1.0 / (400.0 + a * a)
    return lip, sw


def E(h, a, wden):
    lip, sw = lip_sw(a)
    q = abs(float(omega(a)))
    return q * h ** 3 / (4 * wden) + (1e-4 + lip * h / 2) * h * sw


def dEdh(h, a, wden):
    lip, sw = lip_sw(a)
    q = abs(float(omega(a)))
    return 3 * q * h * h / (4 * wden) + 1e-4 * sw + lip * sw * h


def solve_h(lam, a, wden, lo=1e-7, hi=3.0):
    """h with dE/dh + (-lam/h^2) = 0, i.e. h^2 dE/dh = lam."""
    f = lambda h: h * h * dEdh(h, a, wden) - lam
    if f(hi) < 0:
        return hi
    for _ in range(200):
        mid = 0.5 * (lo + hi)
        if f(mid) < 0:
            lo = mid
        else:
            hi = mid
    return 0.5 * (lo + hi)


def integrate(lam, wden, t0=1e-6, t1=60.0, n=4000):
    """Return (panels, K, edges) for the Lagrangian solution."""
    ts = [t0 * (t1 / t0) ** (i / n) for i in range(n + 1)]
    # integral evaluated in log t
    N = 0.0
    S = 0.0
    edges = []
    for i in range(n):
        ta, tb = ts[i], ts[i + 1]
        tm = 0.5 * (ta + tb)
        h = solve_h(lam, tm, wden)
        dl = math.log(tb / ta)
        N += dl * tm / h
        S += dl * tm * E(h, tm, wden) / h
    return N, S + 1e-4


def build(lam, wden, h0):
    """Wanted edges: [0,1] uniform at h0, then the Lagrangian h(a)."""
    n0 = int(round(1 / h0))
    e = [F(i, n0) for i in range(n0 + 1)]
    a = 1.0
    while a < 60.0:
        h = solve_h(lam, a, wden)
        b = min(a + h, 60.0)
        e.append(F(int(round(b * 10 ** 9)), 10 ** 9) if b < 60 else F(60))
        a = b
    return e


if __name__ == "__main__":
    wden = int(sys.argv[1]) if len(sys.argv) > 1 else 400
    for lam in [1e-9, 3e-9, 1e-8, 3e-8, 1e-7, 3e-7]:
        N, K = integrate(lam, wden)
        print(f"lam={lam:.0e}  panels={N:7.1f}  K={K:.5e}  densityTerm half={2*K:.5e}")
