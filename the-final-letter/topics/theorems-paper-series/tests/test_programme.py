"""Tests for the GDST paper-series finite computation layer.

Each Computation row of the programme ledger is covered here.  The tests
use exact sympy rational arithmetic; no floating-point tolerance is
needed anywhere.
"""

import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    alpha,
    complement_residual,
    digits,
    dirichlet_weight,
    invariant_residual,
    monotonicity_counterexample,
    next_index_lower_bound,
    pi_example,
    projected_next_index_ge_quadratic,
    rejected_sum,
    remainder_bound_holds,
    run,
    selected_sum,
    total_sum,
)


def test_alpha_values_and_invalid_indices():
    """C5 (edge cases): exact values, negative indices rejected."""
    assert alpha(0) == sp.Rational(1, 2)
    assert alpha(3) == sp.Rational(1, 5)
    assert alpha(1000) == sp.Rational(1, 1002)
    with pytest.raises(ValueError):
        alpha(-1)
    with pytest.raises(ValueError):
        digits(sp.Rational(1, 2), -1)
    with pytest.raises(ValueError):
        run(sp.Rational(1, 2), -1)
    with pytest.raises(ValueError):
        run(sp.pi / 4, 4)  # non-rational targets are outside the exact layer


def test_greedy_invariant_is_exact():
    """C1: the finite greedy invariant r_N = x - E_N."""
    for k in range(17):
        x = sp.Rational(k, 16)
        for N in (0, 1, 2, 5, 13, 40):
            assert invariant_residual(x, N) == 0


def test_selected_plus_rejected_equals_total():
    """C2: the finite selected/rejected split E_N + Omega_N = H_N."""
    s = sp.Symbol("s")
    weight = lambda n: dirichlet_weight(n, s)  # noqa: E731
    for k in range(9):
        x = sp.Rational(k, 8)
        for N in (0, 1, 2, 6, 12):
            assert complement_residual(x, N, weight) == 0
    # Also the plain harmonic weight (the invariant's own weight).
    assert complement_residual(sp.Rational(3, 7), 25) == 0


def test_pi_example_terminates_at_indices_0_1_4():
    """C3: the source's theta = pi example 1 = 1/2 + 1/3 + 1/6."""
    info = pi_example()
    assert info["word"][:6] == [1, 1, 0, 0, 1, 0]
    assert info["selected"] == [0, 1, 4]
    assert info["selected_sum"] == 1
    assert info["remainder"] == 0
    assert info["terminates"] is True
    assert info["word"] == [1, 1, 0, 0, 1, 0, 0, 0, 0]


def test_remainders_are_nonnegative_and_below_next_fraction():
    """C4: 0 <= r_N <= x and the repaired bound r_N <= 1/(N+1)."""
    for k in range(17):
        x = sp.Rational(k, 16)
        for N in (1, 2, 5, 13, 40):
            r = run(x, N)
            assert 0 <= r <= x
            assert remainder_bound_holds(x, N)
    # The source's stated Lemma 1.3 bound r_0 < 1/2 is false at x = 1.
    assert run(1, 1) == sp.Rational(1, 2)
    assert not (run(1, 1) < alpha(0))


def test_zero_and_threshold_targets_are_edge_cases():
    """C5: x = 0 rejects everything; x = 1/2 selects exactly index 0."""
    assert digits(0, 30) == [0] * 31
    assert selected_sum(0, 31) == 0
    assert rejected_sum(0, 31) == total_sum(31)
    assert run(0, 31) == 0

    assert digits(sp.Rational(1, 2), 5) == [1, 0, 0, 0, 0, 0]
    assert run(sp.Rational(1, 2), 1) == 0
    # Just below the first threshold: index 0 is rejected.
    assert digits(sp.Rational(499, 1000), 5)[0] == 0


def test_source_growth_arithmetic_step():
    """C6: the arithmetic conclusion of the source's Theorem 1.6."""
    for m in range(2, 200):
        assert projected_next_index_ge_quadratic(m)
        assert next_index_lower_bound(m) == (m + 1) * (m + 2) - 1
        assert next_index_lower_bound(m) >= m * (m - 1)
    with pytest.raises(ValueError):
        next_index_lower_bound(-1)


def test_digit_monotonicity_theorem_is_false():
    """C7: exact counterexample to the source's Theorem 1.7."""
    info = monotonicity_counterexample()
    assert info["lower"] < info["upper"]
    assert info["digits_lower"][info["index"]] == 1
    assert info["digits_upper"][info["index"]] == 0
    assert info["digits_lower"] == [0, 1, 0, 0]
    assert info["digits_upper"] == [1, 0, 0, 0]
