"""Greedy harmonic decomposition computation package."""
from .programme import (
    alpha,
    alpha_scaled,
    greedy_digits,
    greedy_accumulated,
    thresholds,
    Kdiag,
    Koff,
    kernel_integral,
    residual_bound_holds,
    selection_density,
)

__all__ = [
    "alpha",
    "alpha_scaled",
    "greedy_digits",
    "greedy_accumulated",
    "thresholds",
    "Kdiag",
    "Koff",
    "kernel_integral",
    "residual_bound_holds",
    "selection_density",
]
