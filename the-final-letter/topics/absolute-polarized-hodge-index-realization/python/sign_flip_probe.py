"""Sign flip of the archimedean term on the degree-zero subspace.

Compare M = M_prime + M_arch (plus) with M = M_prime - M_arch (minus).
At K=4,6 the minus convention is negative definite on the degree-zero
subspace; the plus convention is positive/mixed.  At K=8,10 the minus
convention develops positive directions, attributed to truncation.
"""

from __future__ import annotations

import numpy as np

from ccm_structure import split
from plain_basis_gap import plain_F
from prime_arch_split import components_plain

__all__ = ["sign_eigs", "sign_table"]


def sign_eigs(k: int, sign: int = 1, a: float = 1.5, n_nodes: int = 240) -> np.ndarray:
    mp, ma = components_plain(k, a)
    m = mp + sign * ma
    w = np.eye(k) / np.sqrt(a)
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([plain_F(j + 1, x, a) for j in range(k)])
    ell = np.vstack([w.T @ (phi @ ww), w.T @ ((np.exp(x) * phi) @ ww)])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    s, _ = split(m)
    s = c.T @ (w.T @ s @ w) @ c
    return np.linalg.eigvalsh((s + s.T) / 2)


def sign_table(ks=(4, 6, 8, 10)) -> dict:
    return {k: {"plus": sign_eigs(k, 1), "minus": sign_eigs(k, -1)} for k in ks}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, d in sign_table().items():
        print(k, "plus", np.round(d["plus"], 6), "minus", np.round(d["minus"], 6))
