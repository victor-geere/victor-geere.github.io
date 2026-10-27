"""GDST finite computation layer (see :mod:`programme`)."""

from .programme import (  # noqa: F401
    PI,
    K00_integral,
    alpha,
    ax5_diagonal,
    digit_word,
    dirichlet_prefix,
    finite_identity_residual,
    greedy_digits,
    greedy_remainders,
    greedy_trajectory,
    non_monotone_counterexample,
    partial_sum,
    post_selection_bound_holds,
    rejected_weight,
    remainder_bound_holds,
    selected_weight,
)

__all__ = [
    "PI",
    "K00_integral",
    "alpha",
    "ax5_diagonal",
    "digit_word",
    "dirichlet_prefix",
    "finite_identity_residual",
    "greedy_digits",
    "greedy_remainders",
    "greedy_trajectory",
    "non_monotone_counterexample",
    "partial_sum",
    "post_selection_bound_holds",
    "rejected_weight",
    "remainder_bound_holds",
    "selected_weight",
]
