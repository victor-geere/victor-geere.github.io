"""Harmonic–categorical Hilbert–Pólya computation package."""

from .programme import (
    charpoly_2x2,
    det_A,
    det_one_minus_A,
    diag_constant,
    discriminant_2x2,
    eigenvalues_2x2,
    entry,
    is_upper_triangular,
    matrix_A,
    realise_symmetric_2x2,
    weight,
)

__all__ = [
    "weight",
    "entry",
    "matrix_A",
    "is_upper_triangular",
    "diag_constant",
    "det_A",
    "det_one_minus_A",
    "discriminant_2x2",
    "charpoly_2x2",
    "eigenvalues_2x2",
    "realise_symmetric_2x2",
]
