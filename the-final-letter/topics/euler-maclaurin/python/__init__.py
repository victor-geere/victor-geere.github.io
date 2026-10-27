"""Exact companion to the Euler–Maclaurin Lean layer."""

from .programme import (
    bernoulli_exact,
    periodic_bernoulli_polynomial,
    em_identity_polynomial,
    tail_radius,
)

__all__ = [
    "bernoulli_exact",
    "periodic_bernoulli_polynomial",
    "em_identity_polynomial",
    "tail_radius",
]
