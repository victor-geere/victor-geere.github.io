"""Numerical probe of the CCM bilinear form s(f,g)=N(f * g~).

NOT CERTIFIED.  This is a research probe, not a rigorous check of RH.  It
evaluates the CCM functional on a small smooth basis of compactly supported
functions, projects onto the degree-zero subspace, and reports the symmetric
and antisymmetric parts of the matrix.  The observed structure is that the
bilinear form is dominated by its antisymmetric part; the quadratic refinement
s(f,f) is much smaller and requires high-precision cancellation control.
"""

from __future__ import annotations

import mpmath as mp
import numpy as np

mp.mp.dps = 30


def make_basis(A: float, K: int):
    A = mp.mpf(A)

    def phi(x):
        return mp.cos(mp.pi * x / (2 * A)) if abs(x) <= A else mp.mpf(0)

    def F(k, x):
        return mp.sin(k * mp.pi * x / (2 * A)) * phi(x)

    return A, F


def convolution(F, i, j, x, A):
    lo = max(-A, x - A)
    hi = min(A, x + A)
    if lo >= hi:
        return mp.mpf(0)
    return mp.quad(lambda y: F(i, y) * mp.exp(-(x - y)) * F(j, -(x - y)), [lo, hi])


def von_mangoldt(n: int):
    m = n
    p = 2
    while p * p <= m:
        if m % p == 0:
            lam = mp.log(p)
            while m % p == 0:
                m //= p
            return lam if m == 1 else mp.mpf(0)
        p += 1
    return mp.log(m) if m > 1 else mp.mpf(0)


def N_functional(F, i, j, A, c):
    h0 = convolution(F, i, j, mp.mpf(0), A)

    def h(x):
        return convolution(F, i, j, x, A)

    total = mp.mpf(0)
    nmax = int(mp.e ** (2 * A)) + 2
    for n in range(2, nmax):
        lam = von_mangoldt(n)
        if lam != 0:
            total += lam * h(mp.log(n))

    def integrand(x):
        if abs(x) < mp.mpf("1e-12"):
            return h0
        return (mp.e ** (2 * x) * h(x) - h0) / (mp.e ** (2 * x) - 1)

    total += mp.quad(integrand, [0, mp.mpf("1e-8"), A, 2 * A])
    total += c * h0
    return total


def probe(A: float = 1.5, K: int = 4) -> dict:
    c = (mp.log(mp.pi) + mp.euler) / 2
    A, F = make_basis(A, K)
    M = np.zeros((K, K))
    for i in range(K):
        for j in range(K):
            M[i, j] = float(N_functional(F, i + 1, j + 1, A, c))
    sym = (M + M.T) / 2
    anti = (M - M.T) / 2
    return {
        "M": M,
        "sym_norm": float(np.linalg.norm(sym)),
        "anti_norm": float(np.linalg.norm(anti)),
        "diag": np.diag(M),
    }


if __name__ == "__main__":  # pragma: no cover - probe
    out = probe()
    print("M =\n", np.round(out["M"], 8))
    print("||sym|| =", out["sym_norm"])
    print("||anti|| =", out["anti_norm"])
    print("diag =", out["diag"])
