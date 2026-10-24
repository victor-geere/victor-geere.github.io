import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    egyptian_denominator,
    egyptian_denominator_from_ratio,
    level_size,
    midpoint_denominator,
    normalised_psi,
    object_indices,
    psi,
    quantum_dimension,
    scaled_leading_term,
    total_quantum_dimension_squared,
    trivial_bound,
)


def test_quantum_dimension_symmetry_exact():
    """C1: d_n = d_{N-n}, the reflection symmetry of the simple objects."""
    for k in range(1, 11):
        N = level_size(k)
        for n in object_indices(k):
            assert sp.simplify(quantum_dimension(k, n) - quantum_dimension(k, N - n)) == 0


def test_egyptian_denominator_is_dimension_ratio_exact():
    """C2: the defining ratio D^2/d_n^2 equals N/(4 sin^2(pi n/N))."""
    for k in range(1, 9):
        for n in object_indices(k):
            lhs = egyptian_denominator_from_ratio(k, n)
            rhs = egyptian_denominator(k, n)
            assert sp.simplify(lhs - rhs) == 0


def test_midpoint_denominator_is_exact_rational():
    """C3: at the reflection fixed point n = N/2, m_n = N/4 exactly."""
    for k in (2, 4, 6, 8, 10, 12):
        N = level_size(k)
        assert sp.simplify(midpoint_denominator(k) - sp.Rational(N, 4)) == 0


def test_literal_integrality_claim_fails_at_k3():
    """C4: the source's 'all m_{j,k} are integers' claim fails literally.

    With the proposal's normalisation D^2 = N/(4 sin^2(pi/N)), the level
    k = 3 value m_{0,3} is (5 + sqrt(5))/2, not an integer.
    """
    value = egyptian_denominator(3, 1)
    assert sp.simplify(value - (5 + sp.sqrt(5)) / 2) == 0
    assert not value.is_rational
    # The reflection fixed point does not exist for odd N.
    with pytest.raises(ValueError):
        midpoint_denominator(3)


def test_psi_obeys_trivial_triangle_bound():
    """C5: |Psi_k(s)| <= sum_n m_n^{-Re s}, exactly for real s."""
    k = 4
    signs = [1, -1, 1, 1, -1]
    s = sp.Integer(2)
    lhs = abs(psi(k, s, signs))
    rhs = trivial_bound(k, s)
    assert sp.simplify(rhs - lhs).is_positive


def test_normalisation_fixes_value_at_half():
    """C6: Psi_k(s)/Psi_k(1/2) equals 1 at s = 1/2."""
    k = 5
    signs = [1, -1, 1, 1, -1, 1]
    value = normalised_psi(k, sp.Rational(1, 2), signs)
    assert sp.simplify(value - 1) == 0


def test_validation_and_zero_denominator_edge_cases():
    """Edge cases: bad levels/labels/signs and a vanishing normaliser."""
    with pytest.raises(ValueError):
        level_size(0)
    with pytest.raises(ValueError):
        quantum_dimension(2, 0)
    with pytest.raises(ValueError):
        quantum_dimension(2, 4)
    with pytest.raises(ValueError):
        psi(3, 2, [1, 1])
    with pytest.raises(ValueError):
        psi(3, 2, [1, 0, 1, 1])
    # Alternating signs on reflection-symmetric denominators cancel exactly.
    assert sp.simplify(psi(3, 2, [1, -1, 1, -1])) == 0
    with pytest.raises(ZeroDivisionError):
        normalised_psi(3, 2, [1, -1, 1, -1])


def test_literal_leading_constant_is_one_over_four_pi_squared():
    """C7: m_n * n^2 / N^3 -> 1/(4 pi^2), not the source's 1/(3 pi^2).

    High-precision check, tolerance 1e-8 at N = 4002.
    """
    approx = sp.N(scaled_leading_term(4000, 1), 30)
    target = 1 / (4 * PI ** 2)
    assert abs(float(approx - sp.N(target, 30))) < 1e-8
    assert abs(float(approx) - 1 / (3 * float(PI) ** 2)) > 1e-3
