"""Gap robustness across smooth windows.

Well-conditioned windows (sin^2, (1-(x/A)^2)^2) give a stable gap around
0.04-0.05 for K=16,20,24.  Poorly conditioned windows (sin^4,
(1-(x/A)^2)^4) show a decreasing gap, indicating that the decrease is a
conditioning artefact rather than an arithmetic collapse.
"""

from __future__ import annotations

import numpy as np

import ccm_fast as CF
from ccm_structure import split

__all__ = ["WINDOWS", "gap_window"]


def _sin2(u, a):
    return np.sin(np.pi * (u + a) / (2 * a)) ** 2


def _sin4(u, a):
    return np.sin(np.pi * (u + a) / (2 * a)) ** 4


def _poly2(u, a):
    return (1 - (u / a) ** 2) ** 2


def _poly4(u, a):
    return (1 - (u / a) ** 2) ** 4


WINDOWS = {"sin2": _sin2, "sin4": _sin4, "poly2": _poly2, "poly4": _poly4}


def gap_window(k: int, name: str, a: float = 1.5, n_nodes: int = 200) -> dict:
    if name not in WINDOWS:
        raise ValueError(name)
    win = WINDOWS[name]

    def f(kk, x, aa=a):
        return np.where(np.abs(x) <= aa, np.sin(kk * np.pi * (x + aa) / (2 * aa)) * win(x, aa), 0.0)

    old = CF._F
    CF._F = f
    try:
        m = CF.fast_matrix(k, a)
    finally:
        CF._F = old
    _, omega = split(m)
    nodes, weights = np.polynomial.legendre.leggauss(n_nodes)
    x = a * nodes
    ww = a * weights
    phi = np.array([f(j + 1, x) for j in range(k)])
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
    return {"cond": float(ev.max() / ev.min()), "gap": float(mu.min())}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for name in WINDOWS:
        print(name, {k: round(gap_window(k, name)["gap"], 5) for k in (16, 20, 24)})
