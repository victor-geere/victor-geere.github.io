import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    atomic_mass,
    atomic_mass_bound_holds,
    atomic_weight,
    complete_block_sum,
    filter_coefficient,
    filter_coefficients,
    quadratic_link,
    tempered_weight,
    two_sum_coefficients,
    two_sum_identity_holds,
)


def test_filter_coefficient_cases():
    """C1: the two coefficient cases of Lemma 2.2, exactly."""
    for N in (2, 3, 4, 5, 7, 12):
        for m in range(1, 4 * N + 1):
            expected = sp.Integer(1 - N) if m % N == 0 else sp.Integer(1)
            assert filter_coefficient(N, m) == expected


def test_complete_block_mean_zero():
    """C2: the filter has mean zero over every complete block (Lemma 3.2)."""
    for N in range(2, 61):
        assert complete_block_sum(N) == 0
        assert sp.Integer(sum(filter_coefficients(N, N))) == 0


def test_quadratic_link_inner_length():
    """C3: at M = N^2 the inner length is exactly N (Definition 3.1)."""
    for N in range(2, 301):
        assert quadratic_link(N) == N


def test_two_sum_filter_identity():
    """C4: the depth-one pair and the filter form agree coefficientwise."""
    for N in range(2, 16):
        for M in (1, N - 1, N, N + 1, N * N, 2 * N * N + 3):
            if M < 1:
                continue
            assert two_sum_identity_holds(N, M)
            coeffs = two_sum_coefficients(N, M)
            assert len(coeffs) == M
            if M >= N:
                assert coeffs[N] == 1 - N
            if M >= N * N:
                assert coeffs[N * N] == 1 - N


def test_tempered_weight_bounds():
    """C5: exact positivity and the unit upper bound of Definition 2.4."""
    for t in (0, sp.Rational(1, 2), 1, sp.Rational(3, 2), 3, -5):
        w = tempered_weight(t)
        assert w > 0
        assert w <= 1
        assert sp.simplify(sp.Integer(1) - w) >= 0


def test_atomic_mass_bound():
    """C6: finite atomic mass is non-negative and at most the atom count."""
    points = [
        sp.Integer(0),
        sp.Integer(1),
        sp.Integer(-1),
        sp.I,
        sp.Integer(3) + 4 * sp.I,
        sp.Rational(1, 2) + sp.Rational(3, 2) * sp.I,
    ]
    assert atomic_weight(sp.Integer(3) + 4 * sp.I) == sp.Rational(1, 26)
    mass = atomic_mass(points)
    assert mass >= 0
    assert sp.simplify(mass - len(points)) <= 0
    assert atomic_mass_bound_holds(points)


def test_edge_cases():
    """C7: domain edges are explicit and the empty measure has mass zero."""
    with pytest.raises(ValueError):
        filter_coefficient(1, 1)
    with pytest.raises(ValueError):
        filter_coefficients(2, 0)
    with pytest.raises(ValueError):
        quadratic_link(0)
    with pytest.raises(TypeError):
        filter_coefficient(2.0, 1)  # type: ignore[arg-type]
    assert atomic_mass([]) == 0
    assert atomic_mass_bound_holds([])
    assert filter_coefficient(2, 3) == 1
    assert filter_coefficient(2, 4) == -1
