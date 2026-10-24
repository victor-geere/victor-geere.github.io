import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    euler_truncation_residual,
    geometric_partial_sum,
    local_det,
    local_det_tail,
    quantum_dimension,
    rt_weight,
    s_matrix,
    s_matrix_squared_is_identity,
    total_quantum_dimension,
    total_quantum_dimension_sq_sum,
    verlinde_coefficient,
)

PRIMES = (3, 5, 7, 11, 13)


def test_quantum_dimension_normalisation():
    for p in PRIMES:
        assert sp.simplify(quantum_dimension(p, 1) - 1) == 0
        assert sp.simplify(quantum_dimension(p, p - 1) - 1) == 0
        for a in range(1, p):
            assert sp.N(quantum_dimension(p, a), 30) > 0
    with pytest.raises(ValueError):
        quantum_dimension(5, 0)
    with pytest.raises(ValueError):
        quantum_dimension(5, 5)
    with pytest.raises(ValueError):
        quantum_dimension(2, 1)


def test_s_matrix_squared_identity():
    for p in PRIMES:
        assert s_matrix_squared_is_identity(p)
        S = s_matrix(p)
        assert S == S.T
    for p in (3, 5):
        S = s_matrix(p)
        assert sp.simplify(S * S - sp.eye(p - 1)) == sp.zeros(p - 1)


def test_identity_row_quantum_dimensions():
    for p in (3, 5, 7, 11):
        S = s_matrix(p)
        for b in range(1, p):
            lhs = S[0, b - 1]
            rhs = S[0, 0] * quantum_dimension(p, b)
            assert sp.simplify(lhs - rhs) == 0


def test_total_quantum_dimension():
    for p in PRIMES:
        from_sum = total_quantum_dimension_sq_sum(p)
        closed = sp.Rational(p, 2) / sp.sin(PI / p) ** 2
        assert sp.simplify(from_sum - closed) == 0
        assert sp.simplify(total_quantum_dimension(p) ** 2 - from_sum) == 0


def test_euler_truncation_identity():
    x = sp.symbols("x")
    for n_terms in range(1, 13):
        assert euler_truncation_residual(x, n_terms) == 0
    # Edge case: the empty partial sum still satisfies the identity.
    assert euler_truncation_residual(x, 0) == 0
    with pytest.raises(ValueError):
        geometric_partial_sum(x, -1)


def test_local_det_tail_bound():
    for p in (2, 3, 5, 7, 11):
        x = sp.Rational(1, p)
        for n_terms in (0, 1, 4, 9):
            tail = sp.simplify(
                local_det(x) - geometric_partial_sum(x, n_terms)
            )
            assert sp.simplify(tail - local_det_tail(p, n_terms)) == 0
            assert sp.N(tail, 30) >= 0
        assert sp.N(local_det(x), 30) > 1
    # Edge case: x = 0 gives the trivial local factor; x = 1 is singular.
    assert local_det(0) == 1
    with pytest.raises(ValueError):
        local_det(1)


def test_local_weight_scaling():
    for p in (2, 3, 5, 7):
        for n in range(8):
            assert rt_weight(p, n) == sp.Rational(1, p) ** n
            assert rt_weight(p, n) > 0
        for n in range(7):
            assert rt_weight(p, n + 1) * p == rt_weight(p, n)
        for n in range(5):
            for m in range(5):
                assert rt_weight(p, n + m) == rt_weight(p, n) * rt_weight(p, m)
    assert all(rt_weight(5, n + 1) < rt_weight(5, n) for n in range(8))
    with pytest.raises(ValueError):
        rt_weight(0, 1)
    with pytest.raises(ValueError):
        rt_weight(3, -1)


def test_verlinde_coefficients_small():
    expected = {
        (3, 2, 2): {1: 1},
        (5, 1, 1): {1: 1},
        (5, 2, 2): {1: 1, 3: 1},
        (5, 2, 3): {2: 1, 4: 1},
    }
    for (p, a, b), support in expected.items():
        for c in range(1, p):
            N = verlinde_coefficient(p, a, b, c)
            assert sp.simplify(N - support.get(c, 0)) == 0
            assert sp.N(N, 25) >= 0
    with pytest.raises(ValueError):
        verlinde_coefficient(4, 1, 1, 1)
