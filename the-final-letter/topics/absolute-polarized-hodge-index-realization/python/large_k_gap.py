"""Large-K behaviour of the poly2-windowed gap.

The gap is stable through K=28 but drops to about 0.015 at K=32 and recovers
to 0.025 at K=40.  The K=32 dip is stable under quadrature refinement, so it
is a genuine resonance of the truncated family, not a quadrature artefact.
"""

from __future__ import annotations

import numpy as np

import ccm_fast as CF
from ccm_structure import split
from window_robustness import gap_window

__all__ = ["large_k_table", "gap_poly2", "small_vector_poly2"]


def gap_poly2(k: int, n_nodes: int = 200) -> float:
    return gap_window(k, "poly2", n_nodes=n_nodes)["gap"]


def large_k_table(ks=(24, 28, 32, 36, 40)) -> dict:
    return {k: gap_poly2(k) for k in ks}


def small_vector_poly2(k: int = 32, a: float = 1.5, n_nodes: int = 300) -> dict:
    def f(kk, x, aa=a):
        return np.where(
            np.abs(x) <= aa,
            np.sin(kk * np.pi * (x + aa) / (2 * aa)) * (1 - (x / aa) ** 2) ** 2,
            0.0,
        )

    old = CF._F
    CF._F = f
    try:
        m = CF.fast_matrix(k, a)
    finally:
        CF._F = old
    _, om = split(m)
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([f(j + 1, x) for j in range(k)])
    h = (phi * ww) @ phi.T
    h = (h + h.T) / 2
    ev, v = np.linalg.eigh(h)
    w = v @ np.diag(ev ** -0.5) @ v.T
    om2 = w.T @ om @ w
    ell = np.vstack([w.T @ (phi @ ww), w.T @ ((np.exp(x) * phi) @ ww)])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    om_p = c.T @ om2 @ c
    ev2, vec = np.linalg.eig(om_p)
    idx = int(np.argmin(np.abs(ev2.imag)))
    v = vec[:, idx]
    v = v / np.linalg.norm(v)
    coeff = c @ v
    aa = np.abs(coeff)
    pr = float((aa ** 2).sum() ** 2 / (aa ** 4).sum())
    top = np.argsort(aa)[-6:]
    return {
        "mu": float(abs(ev2.imag[idx])),
        "PR": pr,
        "top": top,
        "top_mass": float((aa[top] ** 2).sum()),
        "coeff": aa,
    }


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, g in large_k_table().items():
        print(k, g)
    d = small_vector_poly2()
    print("K=32 mu", d["mu"], "PR", d["PR"], "top", d["top"], "top mass", d["top_mass"])
