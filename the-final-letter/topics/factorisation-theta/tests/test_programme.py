import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    detector_sign_on_integers,
    divisor_detector,
    divisor_theta,
    divisor_theta_positive_side,
    double_zero_certificate,
    expected_second_derivative,
    finite_theta,
    functional_equation_residual,
    integer_divisors,
    positive_divisors,
)


@pytest.mark.parametrize("k", [1, 2, 6, 12])
def test_divisor_detector_roots_at_all_integer_divisors(k):
    """Every signed integer divisor is an exact root (source section 2)."""
    divisors = integer_divisors(k)
    assert divisors == sorted(divisors)
    assert 0 not in divisors
    for d in divisors:
        assert sp.simplify(divisor_detector(k, d)) == 0


def test_divisor_detector_is_negative_off_divisors():
    """Non-divisors are not roots; the detector is strictly negative there."""
    # Exact values: f_6(4) = -2 and f_6(9) = -3/2.
    assert sp.simplify(divisor_detector(6, 4)) == -2
    assert sp.simplify(divisor_detector(6, 9)) == sp.Rational(-3, 2)
    assert sp.simplify(divisor_detector(1, 2)) == -2
    # Numerical grid check with tolerance 1e-30.
    for x in (5, 7, 8, 10, 11):
        assert float(sp.N(divisor_detector(12, x), 40)) < -1e-30


@pytest.mark.parametrize("d", [1, 2, 3, 4, 6, 12])
def test_divisors_are_double_zeros(d):
    """f(d) = f'(d) = 0 and f''(d) = -4π²((k/d)²/d² + 1) ≠ 0."""
    f, fp, fpp = double_zero_certificate(12, d)
    assert f == 0
    assert fp == 0
    assert sp.simplify(fpp - expected_second_derivative(12, d)) == 0
    assert fpp != 0


@pytest.mark.parametrize("k", [1, 6, 12, 36])
def test_divisor_theta_is_twice_the_positive_side(k):
    """The signed divisor theta sum equals the essay's simplified 2·Σ_{d>0}."""
    t = sp.Rational(1, 3)
    signed = divisor_theta(k, t)
    positive = divisor_theta_positive_side(k, t)
    assert sp.simplify(signed - positive) == 0
    # Positivity with tolerance 1e-30.
    assert float(sp.N(signed, 40)) > 1e-30


def test_finite_theta_positive_and_antitone():
    """Θ_N(t) > 0 and Θ_N is decreasing in t (grid check, tolerance 1e-30)."""
    N = 3
    values = [float(sp.N(finite_theta(N, t), 40)) for t in (sp.Rational(1, 2), 1, 2)]
    assert all(v > 0 for v in values)
    assert values[0] > values[1] > values[2]
    # Edge case N = 0: the sum has the single term n = 0.
    assert sp.simplify(finite_theta(0, 1) - 1) == 0


@pytest.mark.parametrize("t", [sp.Rational(7, 10), 1, 2])
def test_theta_functional_equation_numerically(t):
    """Truncated θ(1/t) = √t θ(t) to tolerance 1e-40 at 50 digits.

    This is numerical evidence for a classical source claim, not a proof.
    """
    residual = functional_equation_residual(t, 12, dps=50)
    assert abs(float(residual)) < 1e-40


def test_invalid_inputs_and_edge_cases():
    with pytest.raises(ValueError):
        divisor_detector(6, 0)
    with pytest.raises(ValueError):
        positive_divisors(0)
    with pytest.raises(ValueError):
        finite_theta(-1, 1)
    with pytest.raises(TypeError):
        finite_theta(1.5, 1)
    with pytest.raises(ValueError):
        double_zero_certificate(12, 5)
    with pytest.raises(ValueError):
        functional_equation_residual(0, 5)
    with pytest.raises(ValueError):
        detector_sign_on_integers(6, 0)
    assert detector_sign_on_integers(6, 6) == {
        1: True,
        2: True,
        3: True,
        4: False,
        5: False,
        6: True,
    }
