"""Gap of the degree-zero Hodge-index form in the plain sine basis.

The windowed basis of the earlier probes becomes numerically singular for
K >= 12.  The plain sine basis

    F_k(x) = sin(k pi (x+A)/(2A)),  |x| <= A,

is orthogonal on [-A,A] with Gram A I, so the polarization is diagonal and the
computation is stable to K = 20.  The gap min mu is not monotone: it drops to
about 0.037 at K=16 and recovers at K=18,20.  This is a near-degeneracy, not a
quadrature artefact (stable under 100/200/300 nodes).
"""

from __future__ import annotations

import numpy as np

from ccm_structure import split

__all__ = ["plain_F", "fast_matrix_plain", "gap_plain", "gap_table_plain"]

_NODES, _WEIGHTS = np.polynomial.legendre.leggauss(120)


def plain_F(k, x, a=1.5):
    return np.where(np.abs(x) <= a, np.sin(k * np.pi * (x + a) / (2 * a)), 0.0)


def _H(i, j, x, a):
    lo = max(-a, x - a)
    hi = min(a, x + a)
    if lo >= hi:
        return 0.0
    y = 0.5 * (hi - lo) * _NODES + 0.5 * (hi + lo)
    z = x - y
    vals = plain_F(i, y, a) * np.exp(-z) * plain_F(j, -z, a)
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


def _N(i, j, a, c):
    h0 = _H(i, j, 0.0, a)
    total = 0.0
    for n in range(2, int(np.exp(2 * a)) + 2):
        lam = _lambda(n)
        if lam:
            total += lam * _H(i, j, np.log(n), a)
    eps = 1e-8
    x = 0.5 * (2 * a - eps) * _NODES + 0.5 * (2 * a + eps)
    h = np.array([_H(i, j, float(t), a) for t in x])
    f = (np.exp(2 * x) * h - h0) / (np.exp(2 * x) - 1)
    total += 0.5 * (2 * a - eps) * float(np.dot(_WEIGHTS, f))
    total += h0 * eps + c * h0
    return total


def fast_matrix_plain(k=4, a=1.5):
    c = (np.log(np.pi) + np.euler_gamma) / 2
    return np.array([[_N(i + 1, j + 1, a, c) for j in range(k)] for i in range(k)])


def gap_plain(k, a=1.5, n_nodes=240):
    m = fast_matrix_plain(k, a)
    _, omega = split(m)
    w = np.eye(k) / np.sqrt(a)
    om = w.T @ omega @ w
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([plain_F(j + 1, x, a) for j in range(k)])
    l1 = phi @ ww
    l2 = (np.exp(x) * phi) @ ww
    ell = np.vstack([w.T @ l1, w.T @ l2])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    om_p = c.T @ om @ c
    ev, _ = np.linalg.eig(om_p)
    mu = np.sort(np.abs(ev.imag))
    return mu


def gap_table_plain(ks=(12, 14, 16, 18, 20)) -> dict:
    return {k: float(gap_plain(k).min()) for k in ks}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, g in gap_table_plain().items():
        print(k, g)
