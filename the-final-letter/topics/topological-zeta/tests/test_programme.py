"""Tests for the topological-zeta computation layer.

Every Computation row of the theorem ledger is covered here.  The checks
are exact except for the numerical test of the source's completed
function, which uses mpmath and states its tolerance.
"""

import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    completion_ratios,
    denominators_are_integral,
    egyptian_sum,
    ising_S,
    ising_dims,
    ising_psi,
    ising_psi_factored,
    is_unitary,
    is_symmetric,
    nonunit_egyptian_sum,
    psi,
    quantum_denominators,
    s_matrix_quantum_dimensions,
    su2_S,
    su2_dims,
)


def test_ising_egyptian_data():
    """C1: Ising denominators (4, 2, 4) and both Egyptian sums."""
    D2, ms = quantum_denominators(ising_dims())
    assert D2 == 4
    assert ms == (4, 2, 4)
    assert denominators_are_integral(ms)
    assert egyptian_sum(ms) == 1
    assert nonunit_egyptian_sum(ms) == sp.Rational(3, 4)


def test_su2_4_egyptian_data():
    """C2: SU(2)_4 denominators (12, 4, 3, 4, 12) and both sums."""
    D2, ms = quantum_denominators(su2_dims(4))
    assert D2 == 12
    assert ms == (12, 4, 3, 4, 12)
    assert denominators_are_integral(ms)
    assert egyptian_sum(ms) == 1
    assert nonunit_egyptian_sum(ms) == sp.Rational(11, 12)


def test_ising_s_matrix():
    """C3: the Ising S-matrix is symmetric, unitary, and S_{0i} = d_i/D."""
    S = ising_S()
    dims = ising_dims()
    assert is_symmetric(S)
    assert is_unitary(S)
    assert s_matrix_quantum_dimensions(S, dims)
    assert sp.simplify(S * S - sp.eye(3)) == sp.zeros(3)


def test_su2_s_matrix_levels():
    """C4: SU(2)_k modular data is unitary for k = 1, 2, 4 (edge k = 1)."""
    for k in (1, 2, 4):
        S = su2_S(k)
        dims = su2_dims(k)
        assert is_symmetric(S)
        assert is_unitary(S)
        assert s_matrix_quantum_dimensions(S, dims)


def test_ising_psi_factorisation_and_zero():
    """C5: Psi(s) = 2^{-s}(2^{1-s} - 1) and Psi(1) = 0."""
    s = sp.symbols("s")
    assert sp.simplify(ising_psi(s) - ising_psi_factored(s)) == 0
    assert ising_psi(1) == 0
    assert ising_psi(2) == sp.Rational(-1, 8)
    assert psi((4, 2, 4), (1, -1, 1), 1) == 0


def test_claimed_completion_functional_equation_fails():
    """C6: the source's completion has no constant root number.

    The archived paper asserts Lambda(s) = Lambda(1-s) for the Ising
    polynomial with q = 4, a = 0.  If a constant eps existed, every ratio
    Lambda(s)/Lambda(1-s) would coincide.  It does not; tolerance 1e-20
    on the spread, which is many orders below the observed spread.
    """
    old = mp.mp.dps
    mp.mp.dps = 30
    try:
        ratios = completion_ratios([0.7 + 2j, 1.5 + 3j, 2.0 + 1j])
        spread = max(abs(r - ratios[0]) for r in ratios)
        assert spread > mp.mpf("0.1")
        assert all(abs(r) > 0 for r in ratios)
    finally:
        mp.mp.dps = old


def test_edge_cases_reject_degenerate_data():
    """C7: edge cases: empty, non-positive, mismatched, or low-level data."""
    with pytest.raises(ValueError):
        quantum_denominators(())
    with pytest.raises(ValueError):
        quantum_denominators((sp.Integer(1), sp.Integer(0)))
    with pytest.raises(ValueError):
        quantum_denominators((sp.Integer(-2),))
    with pytest.raises(ValueError):
        su2_dims(0)
    with pytest.raises(ValueError):
        psi((4, 2), (1,), 1)
    with pytest.raises(ValueError):
        egyptian_sum(())
