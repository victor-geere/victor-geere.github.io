"""Sign flip of the archimedean term in the smooth poly2 basis.

The sharp-basis sign flip favored subtracting the archimedean term at K=4,6.
This module repeats the test in the well-conditioned poly2 window.
"""

from __future__ import annotations

import numpy as np

from ccm_structure import split

__all__ = ["smooth_sign_eigs", "smooth_sign_table"]

_A = 1.5
_NODES, _WEIGHTS = np.polynomial.legendre.leggauss(160)


def _F(k, x, a=_A):
    return np.where(
        np.abs(x) <= a,
        np.sin(k * np.pi * (x + a) / (2 * a)) * (1 - (x / a) ** 2) ** 2,
        0.0,
    )


def _H(i, j, x, a):
    lo = max(-a, x - a)
    hi = min(a, x + a)
    if lo >= hi:
        return 0.0
    y = 0.5 * (hi - lo) * _NODES + 0.5 * (hi + lo)
    z = x - y
    return 0.5 * (hi - lo) * float(np.dot(_WEIGHTS, _F(i, y, a) * np.exp(-z) * _F(j, -z, a)))


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


def _components(k, a):
    c = (np.log(np.pi) + np.euler_gamma) / 2
    mp = np.zeros((k, k))
    ma = np.zeros((k, k))
    for i in range(k):
        for j in range(k):
            h0 = _H(i + 1, j + 1, 0.0, a)
            prime = 0.0
            for n in range(2, int(np.exp(2 * a)) + 2):
                lam = _lambda(n)
                if lam:
                    prime += lam * _H(i + 1, j + 1, np.log(n), a)
            eps = 1e-8
            x = 0.5 * (2 * a - eps) * _NODES + 0.5 * (2 * a + eps)
            h = np.array([_H(i + 1, j + 1, float(t), a) for t in x])
            f = (np.exp(2 * x) * h - h0) / (np.exp(2 * x) - 1)
            arch = 0.5 * (2 * a - eps) * float(np.dot(_WEIGHTS, f)) + h0 * eps + c * h0
            mp[i, j] = prime
            ma[i, j] = arch
    return mp, ma


def smooth_sign_eigs(k: int, sign: int = 1, a: float = _A, n_nodes: int = 200) -> np.ndarray:
    mp, ma = _components(k, a)
    m = mp + sign * ma
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([_F(j + 1, x, a) for j in range(k)])
    h = (phi * ww) @ phi.T
    h = (h + h.T) / 2
    ev, v = np.linalg.eigh(h)
    w = v @ np.diag(ev ** -0.5) @ v.T
    ell = np.vstack([w.T @ (phi @ ww), w.T @ ((np.exp(x) * phi) @ ww)])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    s, _ = split(m)
    s = c.T @ (w.T @ s @ w) @ c
    return np.linalg.eigvalsh((s + s.T) / 2)


def smooth_sign_table(ks=(4, 6, 8)) -> dict:
    return {k: {"plus": smooth_sign_eigs(k, 1), "minus": smooth_sign_eigs(k, -1)} for k in ks}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, d in smooth_sign_table().items():
        print(k, "plus", np.round(d["plus"], 6), "minus", np.round(d["minus"], 6))
