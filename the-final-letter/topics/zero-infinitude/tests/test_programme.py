"""Tests for the zero-count and zero-tail computations (C1–C3)."""

import math
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    ZERO_ORDINATES,
    first_zero_gap,
    gaussian_weight,
    n_log_n_model,
    partial_tail,
    zero_count_up_to,
)


def test_zero_table_is_strictly_increasing():
    assert all(a < b for a, b in zip(ZERO_ORDINATES, ZERO_ORDINATES[1:]))
    assert first_zero_gap() > 0
    assert len(ZERO_ORDINATES) == 10


def test_zero_count_is_monotone_and_correct_on_the_table():
    assert zero_count_up_to(0) == 0
    assert zero_count_up_to(ZERO_ORDINATES[0]) == 1
    assert zero_count_up_to(ZERO_ORDINATES[-1]) == 10
    assert zero_count_up_to(1e6) == 10
    for a, b in zip(ZERO_ORDINATES, ZERO_ORDINATES[1:]):
        assert zero_count_up_to(a) <= zero_count_up_to(b)
    with pytest.raises(ValueError):
        zero_count_up_to(-1)


def test_gaussian_weights_are_positive_and_decreasing():
    sigma = 0.05
    weights = [gaussian_weight(sigma, g) for g in ZERO_ORDINATES]
    assert all(w > 0 for w in weights)
    assert all(a > b for a, b in zip(weights, weights[1:]))
    with pytest.raises(ValueError):
        gaussian_weight(0, 1)


def test_n_log_n_model_is_positive_and_summable_in_partial_sums():
    sigma = 0.05
    values = [n_log_n_model(sigma, n) for n in range(2, 200)]
    assert all(v > 0 for v in values)
    # the model decays, and the partial sums are bounded
    assert values[0] > values[-1]
    sums = [partial_tail(sigma, n) for n in (10, 50, 100, 199)]
    assert all(a <= b + 1e-15 for a, b in zip(sums, sums[1:]))
    assert sums[-1] < 100.0
    with pytest.raises(ValueError):
        n_log_n_model(sigma, 1)


def test_inverse_square_weights_are_positive_and_decreasing():
    from programme import inverse_square_weight

    weights = [inverse_square_weight(g) for g in ZERO_ORDINATES]
    assert all(w > 0 for w in weights)
    assert all(a > b for a, b in zip(weights, weights[1:]))
    # the tail of the sum is dominated by the first few terms
    assert sum(weights) < 0.1


def test_inverse_square_weight_implies_ordinate_growth():
    from programme import growth_threshold, index_where_growth_starts, inverse_square_weight

    for epsilon in (1e-1, 1e-2, 1e-3):
        threshold = growth_threshold(epsilon)
        assert threshold == pytest.approx(1.0 / math.sqrt(epsilon) - 1.0)
        # every tabulated ordinate whose weight is below epsilon exceeds the threshold
        for gamma in ZERO_ORDINATES:
            if inverse_square_weight(gamma) < epsilon:
                assert abs(gamma) > threshold
        assert index_where_growth_starts(threshold) is not None
    with pytest.raises(ValueError):
        growth_threshold(0.0)
