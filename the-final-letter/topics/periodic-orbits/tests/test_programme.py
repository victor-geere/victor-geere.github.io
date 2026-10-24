"""Tests for the finite RT/braid bookkeeping of the periodic-orbits programme.

Covers every Computation row of the theorem ledger, plus edge and failure
cases (empty braid word, ``N = 0`` truncation, ``B_1``, invalid primes).
"""

import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    admissible_labels,
    euler_factor_closed_form,
    fixed_vertices,
    full_twist_writhe,
    gauss_mismatch,
    primitive_orbit_count,
    quantum_dim,
    rt_weight,
    s_entry,
    sin_sq_sum_mod_cyclotomic,
    total_quantum_dim_numeric_residual,
    truncated_euler_factor,
    verlinde_column_sum,
    writhe,
)


def test_quantum_dimensions_positive_and_symmetric():
    """C0: d_j > 0, d_0 = 1, and d_r = d_{p-r} for every admissible label."""
    for p in (3, 5, 7, 11):
        for j in admissible_labels(p):
            assert sp.N(quantum_dim(j, p), 30) > 0
        assert sp.simplify(quantum_dim(0, p) - 1) == 0
        for r in range(1, p):
            left = quantum_dim(sp.Rational(r - 1, 2), p)
            right = quantum_dim(sp.Rational(p - r - 1, 2), p)
            assert sp.simplify(sp.expand_trig(left - right)) == 0


def test_total_quantum_dim_identity():
    """C1/C2: Σ sin²(πr/p) = p/2 exactly; D_p² = p/(2 sin²(π/p))."""
    for p in (3, 5, 7, 11, 13):
        assert sin_sq_sum_mod_cyclotomic(p) == sp.Rational(p, 2)
    # Numerical residual at 50 digits; tolerance 1e-40.
    for p in (3, 5, 7):
        assert total_quantum_dim_numeric_residual(p, dps=50) < sp.Float("1e-40")


def test_verlinde_column_at_half_p_vanishes():
    """C3: the later section's column ℓ = (p-1)/2 is identically zero."""
    for p in (3, 5, 7):
        ell = sp.Rational(p - 1, 2)  # 2ℓ + 1 = p, so every S_{jℓ} = sin(πr) = 0
        for j in admissible_labels(p):
            assert sp.simplify(s_entry(j, ell, p)) == 0
        assert verlinde_column_sum(p, ell) == 0


def test_source_gauss_sum_mismatch():
    """C4: the source's own §3.2 retraction — G_p ≠ τ_p for p = 3, 5, 7.

    Numerical check at 40 digits; the mismatch is far above 1e-3.
    """
    for p in (3, 5, 7):
        assert gauss_mismatch(p) > 0.5


def test_rt_weight_and_truncated_euler_factor():
    """C5: p^{-n} exact, and Σ_{n<N} p^{-n} = (1 - p^{-N})/(1 - p^{-1})."""
    assert rt_weight(5, 3) == sp.Rational(1, 125)
    assert rt_weight(2, 0) == 1
    for p in (3, 5, 7):
        for terms in (0, 1, 2, 6, 9):
            assert truncated_euler_factor(p, terms) == euler_factor_closed_form(p, terms)
            assert truncated_euler_factor(p, terms) >= 0
    # Edge case: zero terms give the empty sum 0 = (1 - 1)/(1 - 1/p).
    assert truncated_euler_factor(7, 0) == 0
    with pytest.raises(ValueError):
        rt_weight(5, -1)


def test_writhe_bookkeeping():
    """C6: writhe is additive and the full twist has writhe n(n-1) > 0."""
    assert writhe([]) == 0  # B_1 / empty word
    assert writhe([1, 1, 1]) == 3
    assert writhe([-1, 1]) == 0
    assert writhe([1, -2, 3]) == 2
    assert full_twist_writhe(1) == 0
    for n in range(2, 8):
        assert full_twist_writhe(n) == n * (n - 1)
        assert full_twist_writhe(n) > 0
    with pytest.raises(ValueError):
        full_twist_writhe(0)


def test_primitive_orbit_counts():
    """C7: Möbius inversion of p^d + 1 gives primitive length-n orbits."""
    for p in (3, 5, 7):
        assert primitive_orbit_count(p, 1) == p + 1
        assert primitive_orbit_count(p, 2) == (p**2 - p) // 2
        for n in range(1, 7):
            reconstructed = sum(
                d * primitive_orbit_count(p, d) for d in sp.divisors(n)
            )
            assert reconstructed == fixed_vertices(p, n) == p**n + 1
    with pytest.raises(ValueError):
        primitive_orbit_count(4, 2)  # 4 is not prime
