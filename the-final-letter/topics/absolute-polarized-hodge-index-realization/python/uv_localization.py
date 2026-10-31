"""Localization of the small eigenvectors of the CCM form.

At K=16 the total small eigenvector is concentrated in the highest sine modes
(participation ratio ~4.7; the last four coefficients dominate), while the
prime and archimedean small eigenvectors are broad.  This indicates that the
K=16 near-degeneracy is a high-frequency (UV) truncation effect of the sharp
sine basis.
"""

from __future__ import annotations

import numpy as np

from ccm_structure import split
from plain_basis_gap import plain_F
from prime_arch_split import components_plain

__all__ = ["small_vectors", "participation_ratio"]


def participation_ratio(v: np.ndarray) -> float:
    """Effective number of modes: (sum |v|^2)^2 / sum |v|^4."""
    a = np.abs(v)
    return float(((a ** 2).sum() ** 2) / (a ** 4).sum())


def small_vectors(k: int = 16, a: float = 1.5, n_nodes: int = 240) -> dict:
    mp, ma = components_plain(k, a)
    w = np.eye(k) / np.sqrt(a)
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([plain_F(j + 1, x, a) for j in range(k)])
    ell = np.vstack([w.T @ (phi @ ww), w.T @ ((np.exp(x) * phi) @ ww)])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T

    def proj(m):
        _, om = split(m)
        return c.T @ (w.T @ om @ w) @ c

    out = {}
    for name, m in (("prime", mp), ("arch", ma), ("total", mp + ma)):
        ev, vec = np.linalg.eig(proj(m))
        idx = int(np.argmin(np.abs(ev.imag)))
        v = vec[:, idx]
        v = v / np.linalg.norm(v)
        coeff = c @ v
        a_coeff = np.abs(coeff)
        out[name] = {
            "mu": float(abs(ev.imag[idx])),
            "participation": participation_ratio(coeff),
            "top": np.argsort(a_coeff)[-4:],
            "top_mass": float((a_coeff[np.argsort(a_coeff)[-4:]] ** 2).sum()),
            "coeff": a_coeff,
        }
    return out


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    d = small_vectors()
    for n, v in d.items():
        print(n, "mu", v["mu"], "PR", v["participation"],
              "top", v["top"], "top mass", v["top_mass"])
