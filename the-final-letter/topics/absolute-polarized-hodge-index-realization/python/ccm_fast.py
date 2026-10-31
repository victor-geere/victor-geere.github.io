"""Fast double-precision evaluation of the CCM probe matrix.

This is a cross-check of the slow mpmath probe, not a certificate.  It uses
fixed-order Gauss-Legendre quadrature and vectorised NumPy operations.
"""

from __future__ import annotations

import numpy as np

__all__ = ["fast_matrix", "H_fast", "N_fast", "PROBE_MPMATH"]

PROBE_MPMATH = np.array([
    [0.00044081, 0.07959511, 0.17925334, 0.18075945],
    [-0.07802292, 0.00112864, 0.17658168, 0.25477669],
    [-0.17780529, -0.17469374, 0.00083405, 0.17726313],
    [-0.18043486, -0.25383145, -0.17563086, 0.00100229],
])

_NODES, _WEIGHTS = np.polynomial.legendre.leggauss(100)


def _phi(x, A):
    return np.where(np.abs(x) <= A, np.cos(np.pi * x / (2 * A)), 0.0)


def _F(k, x, A):
    return np.sin(k * np.pi * x / (2 * A)) * _phi(x, A)


def H_fast(i, j, x, A):
    lo = max(-A, x - A)
    hi = min(A, x + A)
    if lo >= hi:
        return 0.0
    y = 0.5 * (hi - lo) * _NODES + 0.5 * (hi + lo)
    z = x - y
    vals = _F(i, y, A) * np.exp(-z) * _F(j, -z, A)
    return 0.5 * (hi - lo) * float(np.dot(_WEIGHTS, vals))


def _lambda(n):
    m = n
    p = 2
    while p * p <= m:
        if m % p == 0:
            while m % p == 0:
                m //= p
            return np.log(p) if m == 1 else 0.0
        p += 1
    return np.log(m) if m > 1 else 0.0


def N_fast(i, j, A, c):
    h0 = H_fast(i, j, 0.0, A)
    total = 0.0
    nmax = int(np.exp(2 * A)) + 2
    for n in range(2, nmax):
        lam = _lambda(n)
        if lam:
            total += lam * H_fast(i, j, np.log(n), A)

    # Gauss-Legendre on [eps, 2A], with the small [0,eps] strip.
    eps = 1e-8
    x = 0.5 * (2 * A - eps) * _NODES + 0.5 * (2 * A + eps)
    h = np.array([H_fast(i, j, float(t), A) for t in x])
    f = (np.exp(2 * x) * h - h0) / (np.exp(2 * x) - 1)
    total += 0.5 * (2 * A - eps) * float(np.dot(_WEIGHTS, f))
    total += h0 * eps
    total += c * h0
    return total


def fast_matrix(K=4, A=1.5):
    c = (np.log(np.pi) + np.euler_gamma) / 2
    return np.array([[N_fast(i + 1, j + 1, A, c) for j in range(K)] for i in range(K)])


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    m = fast_matrix()
    print("fast matrix:\n", np.round(m, 8))
    print("max abs diff vs mpmath:", np.max(np.abs(m - PROBE_MPMATH)))
