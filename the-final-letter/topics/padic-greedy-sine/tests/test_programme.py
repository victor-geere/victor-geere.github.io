import sys
from fractions import Fraction
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    approximate_zeros,
    base_digits,
    factorial_valuation,
    first_root_valuation,
    first_slope,
    newton_slopes,
    padic_norm_int,
    padic_norm_p_neg_pow,
    padic_norm_p_pow,
    padic_reduction,
    padic_valuation,
    partial_sum,
    p_adic_sine_mod,
    p_adic_sine_partial,
    residual_high,
)


def test_base_digits_and_truncation():
    assert base_digits(5, 3) == [2, 1]
    assert base_digits(13, 2) == [1, 0, 1, 1]
    assert base_digits(0, 7) == [0]
    assert partial_sum(5, 3, 0) == 0
    assert partial_sum(5, 3, 1) == 2
    assert partial_sum(5, 3, 2) == 5
    assert partial_sum(13, 2, 3) == 5
    assert residual_high(13, 2, 3) == 1
    for p in (2, 3, 5, 7):
        for x in (0, 1, 2, 5, 13, 100):
            for n in range(0, 8):
                assert partial_sum(x, p, n) == x % p**n
                assert partial_sum(x, p, n) + p**n * residual_high(x, p, n) == x


def test_padic_norm_correction():
    for p in (2, 3, 5, 7):
        for n in range(0, 6):
            assert padic_norm_p_pow(p, n) == Fraction(1, p**n)
            assert padic_norm_p_neg_pow(p, n) == Fraction(p**n)
        # p^{-n} grows in the p-adic norm; it is not a null sequence.
        norms = [padic_norm_p_neg_pow(p, n) for n in range(6)]
        assert norms == sorted(norms)
        assert norms[0] < norms[-1]
        # p^n shrinks.
        shrinking = [padic_norm_p_pow(p, n) for n in range(6)]
        assert shrinking == sorted(shrinking, reverse=True)
    assert padic_valuation(9, 3) == 2
    assert padic_norm_int(9, 3) == Fraction(1, 9)
    assert padic_norm_int(0, 3) == 0
    assert factorial_valuation(6, 3) == 2
    assert factorial_valuation(10, 2) == 8


def test_newton_polygon_first_slope_odd_primes():
    for p in (3, 5, 7, 11):
        slope = first_slope(p, terms=80)
        assert slope == Fraction(-1, p - 1)
        root_val = first_root_valuation(p, terms=80)
        assert root_val == Fraction(1, p - 1)
        # A nonzero root of the p-adic sine would have fractional
        # valuation, hence cannot lie in Q_p.  Check every nonzero slope,
        # not only the first: an integer slope deeper in the polygon
        # would also give a Q_p root.
        assert root_val.denominator != 1
        for slope in newton_slopes(p, terms=300):
            if slope != 0:
                assert slope.denominator != 1


def test_p_adic_sine_values_and_reduction():
    assert p_adic_sine_partial(0, 3, 10) == 0
    for p, expected in ((3, 39), (5, 505), (7, 350)):
        x = p
        q = p_adic_sine_partial(x, p, 40)
        assert q != 0
        assert p_adic_sine_mod(x, p, 40, 4) == expected
    # The reduction is exact modulo p^m.
    for p in (3, 5):
        q = p_adic_sine_partial(p, p, 30)
        for m in range(0, 5):
            r = padic_reduction(q, p, m)
            assert (q - r).numerator % (p**m) == 0 or m == 0


def test_approximate_zero_search():
    # For odd p, the only approximate zero in p Z_p up to p^4 is 0.
    for p in (3, 5, 7):
        assert approximate_zeros(p, 4) == [0]


def test_argument_errors():
    with pytest.raises(ValueError):
        padic_valuation(0, 3)
    with pytest.raises(ValueError):
        base_digits(-1, 3)
    with pytest.raises(ValueError):
        partial_sum(-1, 3, 2)
    with pytest.raises(ValueError):
        padic_norm_p_pow(1, 2)
    with pytest.raises(ValueError):
        factorial_valuation(-1, 3)
    with pytest.raises(ValueError):
        approximate_zeros(3, 0)
