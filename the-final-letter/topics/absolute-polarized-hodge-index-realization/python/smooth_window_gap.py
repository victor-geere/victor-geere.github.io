"""Gap in a smooth C^1 sin^2-windowed sine basis.

The sharp sine basis has a UV artefact at K=16.  Multiplying by the smooth
window sin^2(pi(x+A)/(2A)) removes the boundary derivative jump while keeping
the L2 Gram moderately conditioned.  The gap then stabilises around 0.04-0.05
for K=16..26 instead of collapsing.
"""

from __future__ import annotations

import numpy as np

import ccm_fast as CF
from ccm_structure import split

__all__ = ["F_smooth", "gap_smooth", "gap_table_smooth"]


def F_smooth(k, x, a=1.5):
    s = np.sin(k * np.pi * (x + a) / (2 * a))
    win = np.sin(np.pi * (x + a) / (2 * a)) ** 2
    return np.where(np.abs(x) <= a, s * win, 0.0)


def gap_smooth(k: int, a: float = 1.5, n_nodes: int = 200) -> dict:
    old = CF._F
    CF._F = F_smooth
    try:
        m = CF.fast_matrix(k, a)
    finally:
        CF._F = old
    _, omega = split(m)
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([F_smooth(j + 1, x, a) for j in range(k)])
    h = (phi * ww) @ phi.T
    h = (h + h.T) / 2
    ev, v = np.linalg.eigh(h)
    w = v @ np.diag(ev ** -0.5) @ v.T
    om = w.T @ omega @ w
    ell = np.vstack([w.T @ (phi @ ww), w.T @ ((np.exp(x) * phi) @ ww)])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    om_p = c.T @ om @ c
    ev2, _ = np.linalg.eig(om_p)
    mu = np.sort(np.abs(ev2.imag))
    return {"cond_H": float(ev.max() / ev.min()), "mu": mu, "gap": float(mu.min())}


def gap_table_smooth(ks=(12, 14, 16, 18, 20, 22, 24, 26)) -> dict:
    return {k: gap_smooth(k)["gap"] for k in ks}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, d in ((k, gap_smooth(k)) for k in (12, 16, 20, 24)):
        print(k, "cond", d["cond_H"], "gap", d["gap"])
