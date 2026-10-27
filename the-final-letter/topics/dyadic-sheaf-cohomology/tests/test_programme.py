"""Tests for the dyadic filtration and energy algebra of the source essay.

Each computation row in the programme README maps to one of these tests.
The cohomological claims of the source are *not* tested: they are open.
"""

import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    cohomology_dimensions,
    divisor_detection,
    dyadic_difference_matrix,
    dyadic_radius,
    dyadic_shell,
    dyadic_shell_index,
    energy,
    energy_zero,
)


def test_dyadic_radius_halving_and_positivity():
    assert dyadic_radius(0) == sp.Integer(1)
    assert dyadic_radius(10) == sp.Rational(1, 1024)
    for k in range(15):
        assert dyadic_radius(k) > 0
        assert dyadic_radius(k + 1) == dyadic_radius(k) / 2
    with pytest.raises(ValueError):
        dyadic_radius(-1)


def test_dyadic_shell_index_selects_the_unique_shell():
    samples = [
        sp.Rational(1, 1024),
        sp.Rational(1, 3),
        sp.Rational(3, 8),
        sp.Rational(1, 2),
        sp.Integer(1),
        sp.Integer(2),
        sp.Integer(3),
        sp.Rational(17, 2),
        sp.Integer(1000),
    ]
    for x in samples:
        k = dyadic_shell_index(x)
        lower, upper = dyadic_shell(k)
        assert lower <= x < upper
        # the shell length is exactly 2^{-k}
        assert upper - lower == sp.Rational(2) ** (-k)


def test_shell_index_boundary_is_closed_below_open_above():
    # Edge case: x = 2^{-k} sits on the closed lower boundary and must be
    # assigned index k, not k + 1.
    for k in range(0, 8):
        boundary = sp.Rational(1, 2) ** k
        assert dyadic_shell_index(boundary) == k
    # Just below the boundary 1/2 the point lies in the next shell, k = 2.
    assert dyadic_shell_index(sp.Rational(1, 2) - sp.Rational(1, 10**6)) == 2
    # Non-positive inputs are rejected rather than silently assigned.
    with pytest.raises(ValueError):
        dyadic_shell_index(0)
    with pytest.raises(ValueError):
        dyadic_shell_index(sp.Rational(-3, 2))


def test_shell_index_scales_by_one_under_doubling():
    for x in (sp.Rational(1, 7), sp.Rational(3, 5), sp.Integer(5), sp.Integer(64)):
        assert dyadic_shell_index(2 * x) == dyadic_shell_index(x) - 1
        assert dyadic_shell_index(x / 2) == dyadic_shell_index(x) + 1


def test_energy_is_nonnegative():
    tol = sp.Float("1e-40")
    for t in (sp.Rational(1, 7), sp.Integer(1), sp.Rational(5, 2), sp.Integer(11)):
        for x in (sp.Rational(1, 3), sp.Rational(1, 2), sp.Integer(1), sp.Integer(7)):
            value = sp.N(energy(t, x), 50)
            assert value >= -tol


def test_energy_vanishes_exactly_on_divisors():
    # The source's divisor-detection identity, forward and reverse, on a
    # finite grid of positive integers.
    for p in range(1, 17):
        for x in range(1, 9):
            assert divisor_detection(p, x) == (p % x == 0)
    with pytest.raises(ValueError):
        divisor_detection(6, 0)


def test_energy_zero_criterion_is_both_cosines_aligned():
    # E = 0 requires *both* cosine terms to equal 1.
    assert energy_zero(6, 3)
    assert sp.simplify(sp.cos(2 * PI * 6 / 3) - 1) == 0
    assert sp.simplify(sp.cos(2 * PI * 3) - 1) == 0
    # t = 1, x = 2: the second alignment is perfect but the first is not.
    assert sp.simplify(sp.cos(2 * PI * 2) - 1) == 0
    assert sp.simplify(sp.cos(2 * PI * sp.Rational(1, 2)) + 1) == 0
    assert not energy_zero(1, 2)


def test_energy_symmetry_under_x_maps_to_t_over_x():
    pairs = [
        (sp.Integer(6), sp.Integer(3)),
        (sp.Rational(5, 2), sp.Rational(1, 3)),
        (sp.Integer(11), sp.Integer(7)),
    ]
    for t, x in pairs:
        assert sp.simplify(energy(t, x) - energy(t, t / x)) == 0
    # Edge case: at x = 0 the expression is undefined (nan); it must not be
    # reported as a vanishing energy.
    assert sp.simplify(energy(sp.Integer(1), sp.Integer(0))) is sp.nan
    assert not energy_zero(sp.Integer(1), sp.Integer(0))


def test_toy_dyadic_complex_rank_bookkeeping():
    for n in range(8):
        dims = cohomology_dimensions(n)
        assert dims["rank"] == n
        assert dims["H0"] == 1          # constants only
        assert dims["H1"] == 0          # finite difference is surjective
        assert dims["H0"] - dims["H1"] == dims["C0"] - dims["C1"]
    # Edge case: the degenerate complex with one vertex and no edges.
    assert dyadic_difference_matrix(0).shape == (0, 1)
    assert cohomology_dimensions(0) == {
        "C0": 1, "C1": 0, "rank": 0, "H0": 1, "H1": 0, "euler": 1
    }
    with pytest.raises(ValueError):
        dyadic_difference_matrix(-1)
