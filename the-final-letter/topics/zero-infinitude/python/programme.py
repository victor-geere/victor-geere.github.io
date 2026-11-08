"""Zero-count and zero-tail numerics for the infinitude programme.

The first ten ordinates are the standard tabulated values (Odlyzko).  They
are used only as a finite sanity check of the counting and tail formulas;
they are not a proof of infinitude.
"""

from __future__ import annotations

import math

# First ten positive imaginary parts of the nontrivial zeros.
ZERO_ORDINATES = (
    14.134725141734693,
    21.022039638771555,
    25.010857580145688,
    30.424876125859513,
    32.935061587739189,
    37.586178158825671,
    40.918719012147495,
    43.327073280914999,
    48.005150881167159,
    49.773832477672302,
)


def zero_count_up_to(t: float) -> int:
    """Number of tabulated zeros with ordinate <= t."""
    if t < 0:
        raise ValueError("height must be non-negative")
    return sum(1 for gamma in ZERO_ORDINATES if gamma <= t)


def gaussian_weight(sigma: float, gamma: float) -> float:
    """The zero-side weight exp(-sigma^2 * gamma^2)."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    return math.exp(-(sigma ** 2) * gamma ** 2)


def n_log_n_model(sigma: float, n: int) -> float:
    """The sublinear model weight exp(-sigma^2 (n/log n)^2), n >= 2."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    if n < 2:
        raise ValueError("n must be at least 2")
    x = n / math.log(n)
    return math.exp(-(sigma ** 2) * x * x)


def partial_tail(sigma: float, n_max: int) -> float:
    """Partial sum of the n/log n model from n = 2 to n_max."""
    if n_max < 2:
        return 0.0
    return sum(n_log_n_model(sigma, n) for n in range(2, n_max + 1))


def first_zero_gap() -> float:
    """Gap between the first two tabulated ordinates."""
    return ZERO_ORDINATES[1] - ZERO_ORDINATES[0]


def inverse_square_weight(gamma: float) -> float:
    """The inverse-square zero weight 1/(|gamma|+1)^2.

    Summability of this weight is the hypothesis from which the formal core
    derives ordinate growth (`tendsto_abs_atTop_of_summable_inv_sq`).
    """
    return 1.0 / (abs(gamma) + 1.0) ** 2


def growth_threshold(epsilon: float) -> float:
    """The ordinate threshold implied by weight < epsilon.

    1/(|gamma|+1)^2 < epsilon  <=>  |gamma| > 1/sqrt(epsilon) - 1.
    """
    if epsilon <= 0:
        raise ValueError("epsilon must be positive")
    return 1.0 / math.sqrt(epsilon) - 1.0


def index_where_growth_starts(threshold: float) -> int | None:
    """First table index after which every tabulated ordinate exceeds threshold."""
    for i, gamma in enumerate(ZERO_ORDINATES):
        if all(g > threshold for g in ZERO_ORDINATES[i:]):
            return i
    return None
