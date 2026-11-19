"""Exact tests for the HST reconstruction.

Every ``Computation`` row of the programme ledger has a test here.  The
tests use only exact rational arithmetic and sympy; no numerical tolerance
is needed except where explicitly stated.  The edge cases are the endpoints
``θ = 0`` and the invalid inputs rejected by the module.
"""

from __future__ import annotations

import sys
from fractions import Fraction
from math import factorial, isqrt
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from python.programme import (  # noqa: E402
    alpha,
    alpha_scaled,
    cylinder_mesh,
    digit_one_intervals,
    digit_set_components,
    guide_factorial_partial,
    guide_floor_digits,
    guide_floor_remainder,
    guide_harmonic_partial,
    split_lengths,
    greedy_accumulated,
    greedy_digits,
    haar_mean,
    haar_norm_sq,
    inner_product,
    reconstructed_wavelet,
    residual,
    source_wavelet,
    thresholds_exact,
    tree_intervals,
    tree_wavelets,
)


def test_alpha_sequence_is_exact_and_strictly_decreasing() -> None:
    """The harmonic angles π/(n+2) are positive and strictly decreasing."""
    assert sp.simplify(alpha(0) - sp.pi / 2) == 0
    assert sp.simplify(alpha(3) - sp.pi / 5) == 0
    for n in range(25):
        assert alpha_scaled(n) > 0
        assert alpha_scaled(n + 1) < alpha_scaled(n)


def test_greedy_digits_exact_and_edge_cases() -> None:
    """Digits are exact; θ = 0 is the all-zero edge case."""
    assert greedy_digits(Fraction(0), 8) == [0] * 9
    assert greedy_digits(Fraction(1, 5), 3) == [0, 0, 0, 1]
    assert residual(Fraction(1, 5), 3) == 0
    assert greedy_accumulated(Fraction(1, 3), 1) == Fraction(1, 3)

    with pytest.raises(ValueError):
        greedy_digits(Fraction(-1, 10), 3)
    with pytest.raises(ValueError):
        greedy_digits(Fraction(11, 10), 3)
    with pytest.raises(ValueError):
        greedy_digits(Fraction(1, 2), -1)


def test_threshold_scan_equals_harmonic_angles() -> None:
    """C1: the exact tree scan gives θ_n*/π = 1/(n+2) for n < 40."""
    thresholds = thresholds_exact(40)
    assert thresholds == [Fraction(1, n + 2) for n in range(40)]
    # Edge: the first level.
    assert thresholds[0] == Fraction(1, 2)


def test_third_threshold_and_source_error() -> None:
    """C2: θ_3* = π/5, and the source's claimed 5π/12 is not a threshold."""
    thresholds = thresholds_exact(6)
    assert thresholds[3] == Fraction(1, 5)
    assert greedy_digits(Fraction(5, 12), 3)[3] == 0
    assert Fraction(5, 12) != Fraction(1, 5)


def test_digit_is_not_monotone() -> None:
    """C3: the source's step-function claim for δ_n fails.

    At t = 2/5 the first digit is 0, so δ_1 = 1; at the larger t = 11/20 the
    first digit is 1 and δ_1 = 0.  Hence t ↦ δ_1(t) is not non-decreasing.
    """
    left = greedy_digits(Fraction(2, 5), 1)
    right = greedy_digits(Fraction(11, 20), 1)
    assert left[1] == 1
    assert right[1] == 0
    assert Fraction(2, 5) < Fraction(11, 20)


def test_tree_wavelets_are_orthonormal_and_mean_zero() -> None:
    """C4: the reconstructed Haar wavelets of the tree are orthonormal."""
    wavelets = tree_wavelets(6)
    assert len(wavelets) >= 8
    for w in wavelets:
        assert sp.simplify(haar_norm_sq(w) - 1) == 0
        assert sp.simplify(haar_mean(w)) == 0
    for i, w1 in enumerate(wavelets):
        for j, w2 in enumerate(wavelets):
            expected = 1 if i == j else 0
            assert sp.simplify(inner_product(w1, w2) - expected) == 0


def test_source_normalisation_defect_and_equal_child_edge_case() -> None:
    """C5: the source's displayed wavelet is not normalised and not mean-zero.

    Under the source's *prose* convention (right child length ``b = α_n``),
    coefficients ``1/√|child|`` give squared norm 2 and mean ``√b − √a``.
    Only the equal-child edge case ``a = b`` has zero mean.  C10 checks the
    different defect on the actual tree, where the left child has length α_n.
    """
    a, b = Fraction(1, 3), Fraction(1, 4)
    src = source_wavelet(a, b)
    assert sp.simplify(haar_norm_sq(src) - 2) == 0
    assert sp.simplify(haar_mean(src) - (sp.sqrt(sp.Rational(b)) - sp.sqrt(sp.Rational(a)))) == 0
    assert sp.simplify(haar_mean(source_wavelet(Fraction(1, 2), Fraction(1, 2)))) == 0

    fixed = reconstructed_wavelet(a, b)
    assert sp.simplify(haar_norm_sq(fixed) - 1) == 0
    assert sp.simplify(haar_mean(fixed)) == 0


def test_cylinder_mass_and_residual_bounds() -> None:
    """C6: selected mass stays below θ and the residual is non-negative.

    The refined bound ``residual(t, N) ≤ 1/(N+1)`` is also checked on a grid.
    """
    for n in range(25):
        for lo, hi, s in tree_intervals(n):
            assert lo < hi
            assert sp.Rational(0) <= sp.Rational(s)
    for k in range(0, 41):
        t = Fraction(k, 40)
        for n in range(0, 30):
            assert greedy_accumulated(t, n) <= t
            r = residual(t, n)
            assert r >= 0
            assert r <= Fraction(1, n + 1)

    # The sparse selection pattern that contradicts the source's logarithmic
    # density claim: at t = 99/100 the selected indices through depth 200 are
    # 0, 1, 5, 71 (the next one is 9016, far beyond this truncation).
    selected = [n for n, d in enumerate(greedy_digits(Fraction(99, 100), 200)) if d]
    assert selected[:4] == [0, 1, 5, 71]


def test_cylinder_mesh_is_exact_and_shrinks() -> None:
    """C7: the depth-n cylinder mesh is exactly 1/(n+1) for n ≤ 40.

    This is the finite, exact shadow of the Lean theorem
    ``HST.cylinder_diameter``; it is the mesh-to-zero hypothesis behind the
    completeness argument for the Haar system.
    """
    for n in range(1, 41):
        assert cylinder_mesh(n) == Fraction(1, n + 1)


def test_digit_sets_are_finite_unions_not_intervals() -> None:
    """C8: the digit-one set is a finite union of intervals, not an interval.

    In the computed range 1 ≤ n ≤ 40, components start
    1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 6, …; the sequence grows slowly and has no
    single-threshold description, which is the precise content of open item O4.
    """
    counts = [digit_set_components(n) for n in range(12)]
    assert counts == [1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 6]
    for n in range(1, 41):
        pieces = digit_one_intervals(n)
        assert len(pieces) > 1
        assert sum(hi - lo for lo, hi in pieces) > 0
        if n < 12:
            assert len(pieces) == counts[n]
    assert digit_set_components(41) == 14


def test_cylinders_separate_points() -> None:
    """C9: points in the same depth-n cylinder agree on the first n digits and
    differ by at most 1/(n+1).

    This is the exact separation statement proved in Lean as
    ``HST.digits_eq_imp_eq`` plus ``HST.cylinder_diameter``.
    """
    for n in range(1, 26):
        for lo, hi, _s in tree_intervals(n):
            first = lo + (hi - lo) / 3
            second = lo + 2 * (hi - lo) / 3
            assert greedy_digits(first, n - 1) == greedy_digits(second, n - 1)
            assert abs(second - first) <= Fraction(1, n + 1)


def test_source_child_lengths_are_swapped() -> None:
    """C10: the actual greedy split puts length α_n on the *left* child.

    The source prose says the right child has length α_n.  At every split node
    the exact scan gives left = α_n and right = ℓ − α_n; at depth 1 the node
    [0, 1/2] has children (1/3, 1/6), so the source's displayed wavelet has
    squared norm 1/3 ÷ 1/6 + 1/6 ÷ 1/3 = 5/2, not 2.
    """
    assert split_lengths(1) == [
        (Fraction(1, 3), Fraction(1, 6), Fraction(1, 3)),
        (Fraction(1, 3), Fraction(1, 6), Fraction(1, 3)),
    ]
    for n in range(1, 20):
        for left, right, a in split_lengths(n):
            assert left == a
            assert left + right <= 1
            assert right == left + right - a
    a, b = Fraction(1, 3), Fraction(1, 6)
    assert a / b + b / a == Fraction(5, 2)


def test_guide_floor_recursion_is_factorial_not_harmonic() -> None:
    """C11: the guide's floor recursion is neither binary nor harmonic.

    At t = 9/10 the digits begin [1, 2, 1, 3, 0, 0]; the harmonic-denominator
    partial sum is 121/60 > 9/10, while the factorial-denominator partial sum
    reconstructs 9/10 exactly.
    """
    assert guide_floor_digits(Fraction(9, 10), 5) == [1, 2, 1, 3, 0, 0]
    assert guide_harmonic_partial(Fraction(9, 10), 4) == Fraction(121, 60)
    assert Fraction(9, 10) < guide_harmonic_partial(Fraction(9, 10), 4)
    assert guide_factorial_partial(Fraction(9, 10), 5) == Fraction(9, 10)

    for t in (Fraction(1, 3), Fraction(9, 10), Fraction(3, 7)):
        for n in (1, 2, 5, 10):
            remainder = guide_floor_remainder(t, n - 1)
            assert (
                guide_factorial_partial(t, n)
                + remainder / factorial(n + 1)
                == t
            )



def test_component_count_jump_table() -> None:
    """C12: exact component-count jump points through n = 155."""
    jumps = {
        1: 2, 5: 4, 11: 6, 19: 8, 29: 10, 41: 14,
        55: 18, 71: 22, 89: 26, 109: 30, 131: 34, 155: 40,
    }
    for n, expected in jumps.items():
        assert digit_set_components(n) == expected


def test_digit_one_measure_small_depths() -> None:
    """C13: exact measure of {t : δ_n(t) = 1} for n = 1..15."""
    expected = {
        1: Fraction(1, 3), 2: Fraction(1, 6), 3: Fraction(1, 10),
        4: Fraction(1, 15), 5: Fraction(2, 21), 6: Fraction(1, 14),
        7: Fraction(1, 18), 8: Fraction(2, 45), 9: Fraction(2, 55),
        10: Fraction(1, 33), 11: Fraction(1, 26), 12: Fraction(3, 91),
        13: Fraction(1, 35), 14: Fraction(1, 40), 15: Fraction(3, 136),
    }
    for n, value in expected.items():
        total = sum((b - a for a, b in digit_one_intervals(n)), Fraction(0))
        assert total == value


def test_sample_digit_frequencies() -> None:
    """C14: selected-digit counts up to n = 200 at four sample targets."""
    for t, expected in (
        (Fraction(0), 0),
        (Fraction(1, 3), 1),
        (Fraction(9, 10), 3),
        (Fraction(99, 100), 4),
    ):
        assert sum(greedy_digits(t, 200)) == expected
