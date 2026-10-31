"""Split the CCM functional into prime and archimedean parts.

N(h) = sum_n Lambda(n) h(n) + integral_1^inf ... + c h(1).

On the plain sine basis, the antisymmetric spectra of the two parts and of
their sum show that the archimedean part has a robust gap while the prime
part is nearly degenerate.  The total gap's near-degeneracy at K=16 is driven
by the prime sum.
"""

from __future__ import annotations

import numpy as np

from ccm_structure import split
from plain_basis_gap import _H, _lambda, _NODES, _WEIGHTS, plain_F

__all__ = ["components_plain", "projected_spectra", "gap_table_split"]


def components_plain(k: int, a: float = 1.5) -> tuple[np.ndarray, np.ndarray]:
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


def projected_spectra(k: int, a: float = 1.5, n_nodes: int = 240) -> dict:
    mp, ma = components_plain(k, a)
    w = np.eye(k) / np.sqrt(a)
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([plain_F(j + 1, x, a) for j in range(k)])
    ell = np.vstack([w.T @ (phi @ ww), w.T @ ((np.exp(x) * phi) @ ww)])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    out = {}
    for name, m in (("prime", mp), ("arch", ma), ("total", mp + ma)):
        _, om = split(m)
        om_p = c.T @ (w.T @ om @ w) @ c
        ev, _ = np.linalg.eig(om_p)
        mu = np.sort(np.abs(ev.imag))
        out[name] = mu
    return out


def gap_table_split(ks=(12, 14, 16, 18, 20)) -> dict:
    return {k: {n: float(mu.min()) for n, mu in projected_spectra(k).items()} for k in ks}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, d in gap_table_split().items():
        print(k, {n: round(v, 6) for n, v in d.items()})
