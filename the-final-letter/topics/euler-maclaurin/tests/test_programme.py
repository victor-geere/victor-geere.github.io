"""Tests for the euler-maclaurin dossier.

Every Computation row in ``README.md`` has a test here, plus edge cases.
"""
from __future__ import annotations

import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

TOPIC = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(TOPIC / "python"))

from programme import (  # noqa: E402
    bernoulli_exact,
    em_identity_polynomial,
    periodic_bernoulli_polynomial,
    tail_radius,
)

CANONICAL = TOPIC.parent / "partial-sum-plus-tail" / "lean" / "EulerMaclaurin.lean"


def test_bernoulli_numbers_are_exact():
    # Computation E1: B_0, B_1, B_2, B_4, B_6, B_8, B_10.
    expected = {
        0: sp.Rational(1),
        1: sp.Rational(-1, 2),
        2: sp.Rational(1, 6),
        4: sp.Rational(-1, 30),
        6: sp.Rational(1, 42),
        8: sp.Rational(-1, 30),
        10: sp.Rational(5, 66),
    }
    for n, value in expected.items():
        assert bernoulli_exact(n) == value


def test_bernoulli_edge_cases():
    with pytest.raises(ValueError):
        bernoulli_exact(-1)
    with pytest.raises(ValueError):
        periodic_bernoulli_polynomial(-1, sp.Symbol("x"))
    # Odd Bernoulli numbers above 1 vanish exactly.
    for n in (3, 5, 7, 9):
        assert bernoulli_exact(n) == 0


def test_periodic_bernoulli_polynomial_low_degrees():
    x = sp.Symbol("x")
    assert sp.expand(periodic_bernoulli_polynomial(0, x)) == 1
    assert sp.expand(periodic_bernoulli_polynomial(1, x)) == x - sp.Rational(1, 2)
    assert sp.expand(periodic_bernoulli_polynomial(2, x)) == x**2 - x + sp.Rational(1, 6)


# Computation E2: the finite Euler–Maclaurin identity for polynomials, exact
# over Q.  K = 0, 1, 2 and several polynomial degrees / intervals.
@pytest.mark.parametrize(
    "coefficients,M,N,K",
    [
        ([0, 1], 1, 3, 0),
        ([0, 1], 1, 3, 1),
        ([0, 0, 1], 1, 3, 0),
        ([0, 0, 1], 1, 3, 1),
        ([0, 0, 1], 2, 7, 2),
        ([1, 2, 3, 4], 0, 5, 1),
        ([1, 2, 3, 4], 1, 6, 2),
        ([0, 0, 0, 0, 1], -2, 4, 3),
        ([3, -1, 0, 5, 0, 2], 2, 9, 4),
    ],
)
def test_finite_euler_maclaurin_identity(coefficients, M, N, K):
    assert em_identity_polynomial(coefficients, M, N, K) == 0


def test_em_invalid_intervals_are_rejected():
    with pytest.raises(ValueError):
        em_identity_polynomial([0, 1], 4, 3, 0)
    with pytest.raises(ValueError):
        em_identity_polynomial([0, 1], 1, 3, -1)


# Computation E3: the S2 tail radius shape is positive and decreases with K.
def test_tail_radius_positive_and_decreasing():
    values = [tail_radius(2.0, 3.0, 1.0, 10, K) for K in range(1, 8)]
    assert all(v > 0 for v in values)
    # The explicit S2 factor should shrink as K grows on this range.
    assert all(values[i + 1] < values[i] for i in range(len(values) - 1))


def test_tail_radius_even_case_matches_zeta_bound():
    # For large K the zeta factor tends to 1 and the power factor dominates.
    r5 = tail_radius(2.0, 0.0, 1.0, 50, 5)
    r6 = tail_radius(2.0, 0.0, 1.0, 50, 6)
    assert r6 < r5


def test_tail_radius_rejects_bad_inputs():
    with pytest.raises(ValueError):
        tail_radius(2.0, 0.0, 0.0, 10, 1)
    with pytest.raises(ValueError):
        tail_radius(2.0, 0.0, 1.0, 0, 1)
    with pytest.raises(ValueError):
        tail_radius(2.0, 0.0, 1.0, 10, 0)
    with pytest.raises(ValueError):
        tail_radius(0.0, 0.0, 1.0, 10, 1)


# Computation E4: the dossier cannot drift from the canonical Lean file.
def test_lean_mirror_matches_canonical_file():
    assert CANONICAL.exists(), f"canonical file missing: {CANONICAL}"
    assert (TOPIC / "lean" / "Topic.lean").read_bytes() == CANONICAL.read_bytes()


def test_tail_radius_uses_high_precision():
    # A 50-digit evaluation must not collapse to a merely double-precision value:
    # two nearby K values differ by more than 1e-30 relative difference.
    r3 = tail_radius(1.5, 14.0, 0.5, 20, 3, dps=50)
    r4 = tail_radius(1.5, 14.0, 0.5, 20, 4, dps=50)
    assert r3 > 0 and r4 > 0
    assert abs(r3 - r4) / r3 > mp.mpf(10) ** -30
