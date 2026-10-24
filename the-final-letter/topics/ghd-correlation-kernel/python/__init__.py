"""GHD correlation kernel — exact computation layer.

Import from ``python/programme.py``; the package is intentionally free of
side effects.
"""

from .programme import (  # noqa: F401
    K_diag,
    K_diag_n,
    K_off,
    K_off_source,
    PI,
    alpha,
    alpha_scaled,
    diagonal_trace,
    greedy_accumulated,
    greedy_digits,
    is_positive_semidefinite,
    kernel_integral,
    leading_principal_minors,
    model_phi,
    scaled_kernel_matrix,
    selection_word_report,
    step_indicator,
    true_kernel_matrix,
)

__all__ = [
    "PI",
    "alpha",
    "alpha_scaled",
    "step_indicator",
    "model_phi",
    "greedy_digits",
    "greedy_accumulated",
    "K_diag",
    "K_diag_n",
    "K_off",
    "K_off_source",
    "kernel_integral",
    "scaled_kernel_matrix",
    "leading_principal_minors",
    "is_positive_semidefinite",
    "diagonal_trace",
    "selection_word_report",
]
