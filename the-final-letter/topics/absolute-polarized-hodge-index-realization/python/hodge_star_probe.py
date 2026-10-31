"""Hodge-star extraction from the CCM probe matrix.

Given M = S + Omega (symmetric + antisymmetric), the naive Hodge star is
T = S^{-1} Omega.  On the probe matrix S is indefinite and ill-conditioned,
and T^2 is not a scalar multiple of the identity, so no normalization of T is
a complex structure or an involution.  This is a compatibility obstruction,
not a certificate.
"""

from __future__ import annotations

import numpy as np

from ccm_structure import PROBE_MATRIX, split

__all__ = ["star_candidate", "t2_scalar_defect", "star_diagnostics"]


def star_candidate(m: np.ndarray = PROBE_MATRIX) -> np.ndarray:
    s, omega = split(m)
    return np.linalg.solve(s, omega)


def t2_scalar_defect(t: np.ndarray) -> tuple[float, float]:
    t2 = t @ t
    n = t.shape[0]
    c = float(np.trace(t2) / n)
    defect = float(np.linalg.norm(t2 - c * np.eye(n)))
    return defect, c


def star_diagnostics(m: np.ndarray = PROBE_MATRIX) -> dict:
    s, omega = split(m)
    t = star_candidate(m)
    defect, c = t2_scalar_defect(t)
    return {
        "cond_S": float(np.linalg.cond(s)),
        "eig_S": np.linalg.eigvalsh(s),
        "eig_T": np.linalg.eigvals(t),
        "t2_defect": defect,
        "t2_scalar": c,
    }


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    d = star_diagnostics()
    print("cond S:", d["cond_S"])
    print("eig S:", np.round(d["eig_S"], 8))
    print("eig T:", np.round(d["eig_T"], 4))
    print("T^2 scalar defect:", d["t2_defect"], "scalar:", d["t2_scalar"])
