"""Hermitian split of the CCM bilinear-form probe.

The probe matrix M is the finite evaluation of s(f_i,f_j)=N(f_i * f_j~).
Its symmetric part is the quadratic refinement (the Hodge-index form); its
antisymmetric part is the symplectic/intersection form.  The probe shows the
antisymmetric part dominates by about two orders of magnitude.
"""

from __future__ import annotations

import numpy as np

__all__ = ["PROBE_MATRIX", "split", "antisymmetric_dominated", "diagonal"]

PROBE_MATRIX = np.array([
    [0.00044081, 0.07959511, 0.17925334, 0.18075945],
    [-0.07802292, 0.00112864, 0.17658168, 0.25477669],
    [-0.17780529, -0.17469374, 0.00083405, 0.17726313],
    [-0.18043486, -0.25383145, -0.17563086, 0.00100229],
])


def split(m: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    sym = (m + m.T) / 2
    anti = (m - m.T) / 2
    return sym, anti


def antisymmetric_dominated(m: np.ndarray = PROBE_MATRIX, factor: float = 100.0) -> bool:
    sym, anti = split(m)
    return float(np.linalg.norm(anti)) > factor * float(np.linalg.norm(sym))


def diagonal(m: np.ndarray = PROBE_MATRIX) -> np.ndarray:
    return np.diag(m)


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    sym, anti = split(PROBE_MATRIX)
    print("||sym|| =", np.linalg.norm(sym))
    print("||anti|| =", np.linalg.norm(anti))
    print("dominated:", antisymmetric_dominated())
    print("diag:", diagonal())
