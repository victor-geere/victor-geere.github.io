import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))

from programme import (  # noqa: E402
    PI,
    expansion,
    greedy_digits,
    guide_floor_digits,
    harmonic_fraction,
    partial_sum,
    residual,
    sine_reconstruction,
)


def test_harmonic_fractions_exact():
    assert harmonic_fraction(0) == sp.Rational(1, 2)
    assert harmonic_fraction(3) == sp.Rational(1, 5)
    assert all(harmonic_fraction(n) > harmonic_fraction(n + 1) for n in range(20))
    with pytest.raises(ValueError):
        harmonic_fraction(-1)
    with pytest.raises(TypeError):
        harmonic_fraction(2.0)  # type: ignore[arg-type]


def test_digits_binary_and_exact_telescoping():
    for k in range(13):
        x = sp.Rational(k, 12)
        for n in (0, 1, 2, 3, 7, 20, 60):
            digits = greedy_digits(x, n)
            assert all(d in (0, 1) for d in digits)
            assert len(digits) == n
            s = partial_sum(x, n)
            r = residual(x, n)
            assert sp.simplify(s + r - x) == 0
            assert r >= 0
            if x < 1:
                # The source estimate θ - θ_n ≤ π/(n+1), normalised.
                assert r < sp.Rational(1, n + 1)


def test_terminating_expansions_exact():
    cases = {
        sp.Rational(0): (),
        sp.Rational(1, 2): (1,),
        sp.Rational(1, 3): (0, 1),
        sp.Rational(2, 3): (1, 0, 0, 0, 1),
        sp.Rational(9, 10): (1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
        sp.Rational(1): (1, 1, 0, 0, 1),
    }
    for x, expected in cases.items():
        e = expansion(x)
        assert e.digits == expected, (x, e)
        assert e.terminated is True
        assert e.residual == 0
        assert sp.simplify(e.value - x) == 0

    # A rational with a long but finite expansion: 3/7 needs 230 digits.
    slow = expansion(sp.Rational(3, 7), max_terms=300)
    assert slow.terminated is True
    assert len(slow.digits) == 230
    assert sp.simplify(slow.value - sp.Rational(3, 7)) == 0


def test_partial_sums_monotone_and_bounded_by_target():
    for k in range(1, 12):
        x = sp.Rational(k, 12)
        previous = sp.Integer(0)
        for n in range(1, 41):
            s = partial_sum(x, n)
            assert s >= previous
            assert s <= x
            previous = s


def test_sine_reconstruction_exact():
    # 1/2 = 1/2, so the reconstructed angle is π/2.
    assert sp.simplify(sine_reconstruction(sp.Rational(1, 2), 1) - 1) == 0
    # 1/3 = 1/3, so the reconstructed angle is π/3.
    assert sp.simplify(
        sine_reconstruction(sp.Rational(1, 3), 2) - sp.sqrt(3) / 2
    ) == 0
    # 1 = 1/2 + 1/3 + 1/6, so sin(π · 1) = 0.
    assert sp.simplify(sine_reconstruction(sp.Rational(1), 5)) == 0
    # The word for 1/2 is [1]; all later digits vanish.
    assert greedy_digits(sp.Rational(1, 2), 8) == [1, 0, 0, 0, 0, 0, 0, 0]


def test_guide_floor_recursion_is_not_binary():
    # The research guide prints δ_n = floor((n+2) r_n), which is not the
    # binary rule of Programme I.  For x = 9/10 it produces a digit 2.
    guide = guide_floor_digits(sp.Rational(9, 10), 6)
    assert guide == [1, 2, 1, 3, 0, 0]
    assert any(d > 1 for d in guide)
    assert greedy_digits(sp.Rational(9, 10), 6) == [1, 1, 0, 0, 0, 0]


def test_edge_cases_and_invalid_input():
    assert expansion(sp.Rational(0)).digits == ()
    assert expansion(sp.Rational(1)).terminated is True
    with pytest.raises(ValueError):
        greedy_digits(sp.Rational(-1, 2), 3)
    with pytest.raises(ValueError):
        greedy_digits(sp.Rational(3, 2), 3)
    with pytest.raises(ValueError):
        greedy_digits(sp.Rational(1, 2), -1)
    with pytest.raises(TypeError):
        greedy_digits(sp.Rational(1, 2), 3.0)  # type: ignore[arg-type]
    with pytest.raises(TypeError):
        greedy_digits(0.5, 3)  # type: ignore[arg-type]
