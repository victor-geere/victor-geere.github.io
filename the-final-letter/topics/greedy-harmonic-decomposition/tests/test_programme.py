import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    Kdiag,
    Koff,
    alpha,
    alpha_scaled,
    greedy_accumulated,
    greedy_digits,
    kernel_integral,
    residual_bound_holds,
    thresholds,
)


def test_alpha_values():
    assert sp.simplify(alpha(0) - PI / 2) == 0
    assert sp.simplify(alpha(3) - PI / 5) == 0
    with pytest.raises(ValueError):
        alpha(-1)


def test_threshold_identity_exact():
    ts = thresholds(40)
    for n, t in enumerate(ts):
        assert sp.simplify(t - alpha(n)) == 0


def test_threshold_at_own_angle_selects():
    for n in range(12):
        digits = greedy_digits(alpha(n), n)
        assert digits[n] == 1
        assert sum(digits[:n]) == 0


def test_below_threshold_does_not_select():
    for n in range(1, 12):
        theta = sp.simplify(alpha(n) * sp.Rational(999, 1000))
        digits = greedy_digits(theta, n)
        assert digits[n] == 0


def test_residual_bound():
    for k in range(18):
        theta = sp.Rational(k, 17) * PI
        for n_max in (0, 1, 2, 5, 20, 100):
            assert residual_bound_holds(theta, n_max)


def test_accumulated_angle_is_bounded_by_target():
    for k in range(18):
        theta = sp.Rational(k, 17) * PI
        acc = greedy_accumulated(theta, 200)
        assert sp.N(acc, 40) <= sp.N(theta, 40) + sp.Float("1e-12")


def test_diagonal_kernel_matches_integral():
    for t in (sp.Rational(1, 7) * PI, sp.Rational(1, 2) * PI, sp.Rational(5, 7) * PI):
        assert sp.simplify(Kdiag(t) - kernel_integral(t, t)) == 0


def test_off_diagonal_kernel_matches_integral():
    pairs = [
        (sp.Rational(1, 7) * PI, sp.Rational(2, 7) * PI),
        (sp.Rational(1, 3) * PI, sp.Rational(2, 3) * PI),
        (sp.Rational(1, 10) * PI, sp.Rational(9, 10) * PI),
    ]
    for tn, tm in pairs:
        assert sp.simplify(Koff(tn, tm) - kernel_integral(tn, tm)) == 0


def test_diagonal_kernel_symmetry_and_half_value():
    t = sp.Rational(3, 11) * PI
    assert sp.simplify(Kdiag(t) - Kdiag(PI - t)) == 0
    assert sp.simplify(Kdiag(PI / 2) - PI / 12) == 0


def test_diagonal_kernel_positive():
    for k in range(1, 10):
        assert sp.N(Kdiag(sp.Rational(k, 10) * PI), 30) > 0
