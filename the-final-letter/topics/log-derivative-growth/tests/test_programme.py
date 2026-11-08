"""Tests for the Z'/Z growth probes (C1–C2)."""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import linear_ratio, max_ratio, sample_heights, zeta_log_derivative  # noqa: E402


def test_log_derivative_is_finite_away_from_the_pole():
    for sigma, t in ((2.0, 10.0), (1.5, 20.0), (0.6, 15.0), (0.5, 60.0)):
        value = zeta_log_derivative(complex(sigma, t))
        assert abs(value) < 1e6


def test_linear_ratio_is_small_on_the_sampled_grid():
    heights = sample_heights(10.0, 60.0, 5.0)
    assert heights
    assert max_ratio(2.0, heights) < 2.0
    assert max_ratio(1.5, heights) < 5.0
    # every ratio is finite and non-negative
    for t in heights:
        r = linear_ratio(0.7, t)
        assert 0.0 <= r < 1e6


def test_linear_ratio_requires_positive_sigma():
    with pytest.raises(ValueError):
        linear_ratio(0.0, 10.0)
    with pytest.raises(ValueError):
        max_ratio(1.0, [])


def test_polynomial_majorant_ratio_is_bounded_by_one():
    from programme import polynomial_majorant_ratio

    for k in range(0, 8):
        for y in (0.0, 0.25, 1.0, 2.0, 10.0, 1e3):
            assert 0.0 < polynomial_majorant_ratio(k, y) <= 1.0 + 1e-12


def test_gaussian_polynomial_moments_are_finite_and_decreasing_in_sigma():
    from programme import gaussian_polynomial_moment

    for sigma in (0.5, 1.0):
        moments = [gaussian_polynomial_moment(k, sigma) for k in range(0, 7)]
        assert all(m > 0 for m in moments)
        # the k = 0 moment is the Gaussian integral sqrt(2π)/sigma
        assert float(moments[0]) == pytest.approx((2 * 3.141592653589793) ** 0.5 / sigma, rel=1e-8)
        # the Gaussian recurrence M_{k+2} = (k+1)/(2b) M_k with b = sigma^2/2
        b = sigma ** 2 / 2
        for k in range(0, 5):
            assert float(moments[k + 2]) == pytest.approx((k + 1) / (2 * b) * float(moments[k]), rel=1e-7)
    with pytest.raises(ValueError):
        gaussian_polynomial_moment(1, 0.0)


def test_polynomial_bound_holds_on_the_sampled_grid():
    from programme import polynomial_bound_holding

    heights = sample_heights(10.0, 60.0, 5.0)
    for k in (1, 2, 3):
        assert all(polynomial_bound_holding(2.0, t, k, 10.0) for t in heights)
    with pytest.raises(ValueError):
        polynomial_bound_holding(2.0, 10.0, 1, -1.0)
