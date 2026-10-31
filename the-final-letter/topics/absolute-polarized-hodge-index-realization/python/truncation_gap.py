"""Spectral-gap behaviour of the finite Hodge-index form under truncation.

For basis size K, build the fast CCM matrix, orthonormalize the L2 Gram,
project onto the two degree-zero constraints, and compute the antisymmetric
spectrum mu and the Hodge-index eigenvalues of R = Omega U.

Even K: Omega_p is invertible, R is negative definite.  The gap decreases
with K but the decay slows; a positive limit is not excluded.
Odd K: Omega_p has a zero mode; the theorem's hypothesis fails and the
construction is not defined on the kernel.

For K >= 12 the L2 Gram becomes numerically singular in double precision,
so the truncation is not accessible without a better-conditioned basis.
"""

from __future__ import annotations

import numpy as np

from ccm_fast import fast_matrix
from ccm_structure import split
from polarization import _constraints, l2_gram, orthonormalize

__all__ = ["gap_for", "gap_table"]


def gap_for(k: int, a: float = 1.5) -> dict:
    m = fast_matrix(k, a)
    _, omega = split(m)
    h = l2_gram(a, k)
    w = orthonormalize(h)
    om = w.T @ omega @ w
    l1, l2 = _constraints(a, k)
    ell = np.vstack([w.T @ l1, w.T @ l2])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    om_p = c.T @ om @ c
    ev, v = np.linalg.eig(om_p)
    mu_raw = np.abs(ev.imag)
    mu = np.sort(mu_raw)
    degenerate = bool(mu_raw.min() < 1e-8)
    if degenerate:
        r_eig = None
    else:
        p = np.real(v @ np.diag(mu_raw) @ np.linalg.inv(v))
        u = om_p @ np.linalg.inv(p)
        r = om_p @ u
        r_eig = np.linalg.eigvalsh((r + r.T) / 2)
    return {
        "K": k,
        "dim": k - 2,
        "mu": mu,
        "degenerate": degenerate,
        "R_eig": r_eig,
        "min_gap": None if r_eig is None else float(np.min(np.abs(r_eig))),
    }


def gap_table(ks=(4, 5, 6, 7, 8, 10)) -> dict:
    return {k: gap_for(k) for k in ks}


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for k, d in gap_table().items():
        print(k, "dim", d["dim"], "mu", np.round(d["mu"], 6),
              "degenerate", d["degenerate"],
              "min_gap", d["min_gap"], "R_eig", d["R_eig"])
