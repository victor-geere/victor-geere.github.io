import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    digit_strings,
    encode_bound_holds,
    encode_digits,
    eta_at_two,
    euler_factor,
    euler_telescope,
    kl_factor,
    kl_value,
    padic_norm,
    padic_norm_rational,
    padic_valuation,
    ultrametric_holds,
    zeta_at_negative_integer,
)


def test_padic_valuation_and_norm():
    assert padic_valuation(2, 12) == 2
    assert padic_valuation(3, 12) == 1
    assert padic_valuation(5, 1) == 0
    assert padic_norm(2, 12) == sp.Rational(1, 4)
    assert padic_norm(3, 12) == sp.Rational(1, 3)
    assert padic_norm(5, 5) == sp.Rational(1, 5)
    assert padic_norm(2, 1) == sp.Rational(1)
    assert padic_norm(2, 0) == sp.Rational(0)
    with pytest.raises(ValueError):
        padic_valuation(2, 0)
    with pytest.raises(ValueError):
        padic_norm(1, 5)


def test_padic_norm_is_ultrametric_on_grid():
    values = [
        sp.Rational(0),
        sp.Rational(1, 3),
        sp.Rational(-7, 2),
        sp.Rational(3, 4),
        sp.Rational(5, 8),
        sp.Rational(12),
        sp.Rational(-12),
        sp.Rational(25, 3),
    ]
    for p in (2, 3, 5):
        for q in values:
            for r in values:
                assert ultrametric_holds(p, q, r)
    # Exact edge values for one pair.
    assert padic_norm_rational(2, sp.Rational(1, 2)) == sp.Rational(2)
    # v_2(3/8) = 0 - 3 = -3, so |3/8|_2 = 2^3 = 8.
    assert padic_norm_rational(2, sp.Rational(3, 8)) == sp.Rational(8)
    assert padic_norm_rational(2, sp.Rational(3, 4)) == sp.Rational(4)


def test_encode_source_example():
    # Source §2: p = 3, sequence [2, 1, 0] gives 2 + 3 + 0 = 5.
    assert encode_digits(3, [2, 1, 0]) == 5
    assert encode_digits(2, []) == 0
    assert encode_digits(2, [1, 1, 1, 1]) == 15
    with pytest.raises(ValueError):
        encode_digits(3, [2, 3, 0])
    with pytest.raises(ValueError):
        encode_digits(1, [0])


def test_encode_bound_on_all_small_digit_strings():
    for p in (2, 3, 5):
        for length in range(5):
            for digits in digit_strings(p, length):
                assert encode_bound_holds(p, digits)
                assert encode_digits(p, digits) < p**length


def test_euler_factor_and_telescope():
    assert euler_factor(2) == sp.Rational(1, 2)
    assert euler_factor(3) == sp.Rational(2, 3)
    for p in (2, 3, 5):
        for n in (0, 1, 7):
            lhs, rhs = euler_telescope(p, n)
            assert sp.simplify(lhs - rhs) == 0
    with pytest.raises(ValueError):
        euler_telescope(2, -1)


def test_kubota_leopoldt_rational_values():
    assert zeta_at_negative_integer(2) == sp.Rational(-1, 12)
    assert zeta_at_negative_integer(4) == sp.Rational(1, 120)
    assert kl_factor(2, 2) == -1
    assert kl_factor(3, 2) == -2
    assert kl_value(2, 2) == sp.Rational(1, 12)
    assert kl_value(3, 2) == sp.Rational(1, 6)
    assert kl_value(5, 2) == sp.Rational(1, 3)
    for p in (2, 3, 5, 7):
        assert kl_value(p, 2) == sp.Rational(p - 1, 12)
        assert kl_value(p, 4) == sp.Rational((1 - p**3), 120)
    with pytest.raises(ValueError):
        zeta_at_negative_integer(1)
    with pytest.raises(ValueError):
        kl_value(2, 1)


def test_eta_two_archimedean_context():
    # η(2) = (1 - 2^(1-2)) ζ(2) = (1/2)(π²/6) = π²/12.
    assert sp.simplify(eta_at_two() - sp.pi**2 / 12) == 0
