"""Exact tests for the HST reconstruction.

Every ``Computation`` row of the programme ledger has a test here.  The
tests use only exact rational arithmetic and sympy; no numerical tolerance
is needed except where explicitly stated.  The edge cases are the endpoints
``θ = 0`` and the invalid inputs rejected by the module.
"""

from __future__ import annotations

import sys
from fractions import Fraction
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from python.programme import (  # noqa: E402
    alpha,
    alpha_scaled,
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

    Coefficients ``1/√|child|`` give squared norm 2 and mean ``√b − √a``.
    Only the equal-child edge case ``a = b`` has zero mean.
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
