import sys
from fractions import Fraction
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    archived_gauss_sum_residual,
    is_source_prime,
    local_determinant_limit,
    local_factor,
    local_partial_sum,
    local_partial_sum_closed,
    quantum_dimension,
    rt_weight,
    simple_object_count,
    simple_spins,
    sine_square_sum_exact,
    total_quantum_dimension_sq,
    verlinde_s,
    verlinde_s_squared_error,
)

PRIMES = (3, 5, 7, 11, 13, 17, 19, 23)


def test_rt_weight_is_exact_multiplicative_and_positive():
    for p in PRIMES:
        assert rt_weight(p, 0) == 1
        for n in range(7):
            assert rt_weight(p, n) > 0
            assert rt_weight(p, n) == Fraction(1, p**n)
        for n in range(5):
            for m in range(5):
                assert rt_weight(p, n + m) == rt_weight(p, n) * rt_weight(p, m)
        for n in range(9):
            assert rt_weight(p, n + 1) < rt_weight(p, n)


def test_local_determinant_bookkeeping_is_exact():
    for p in PRIMES:
        assert local_factor(p) == Fraction(p - 1, p)
        assert local_determinant_limit(p) == Fraction(p, p - 1)
        assert local_factor(p) * local_determinant_limit(p) == 1
        for n_terms in range(13):
            assert local_partial_sum(p, n_terms) == local_partial_sum_closed(p, n_terms)
        # The infinite local determinant is the limit of the finite Euler product.
        assert local_determinant_limit(p) == 1 / local_factor(p)


def test_total_quantum_dimension_identity_exactly_and_numerically():
    for p in PRIMES:
        assert sine_square_sum_exact(p) == sp.Rational(p, 2)
        d_sq = total_quantum_dimension_sq(p)
        target = sp.Rational(p, 2) / sp.sin(sp.pi / p) ** 2
        assert abs(sp.N(d_sq - target, 50)) < sp.Float("1e-40")


def test_simple_object_count_and_quantum_dimension_edge_values():
    for p in PRIMES:
        assert simple_object_count(p) == p - 1
        assert simple_spins(p)[0] == Fraction(0)
        assert simple_spins(p)[-1] == Fraction(p - 2, 2)
        assert sp.simplify(quantum_dimension(p, 0) - 1) == 0
        # The top spin has the largest quantum dimension and d_j = d_{top-j}.
        assert sp.simplify(
            quantum_dimension(p, 0) - quantum_dimension(p, Fraction(p - 2, 2))
        ) == 0


def test_verlinde_s_matrix_is_a_symmetric_involution():
    for p in (3, 5, 7, 11, 13):
        spins = simple_spins(p)
        for j in spins:
            for jp in spins:
                assert sp.simplify(verlinde_s(p, j, jp) - verlinde_s(p, jp, j)) == 0
        assert verlinde_s_squared_error(p) < 1e-30


def test_archived_gauss_sum_identity_fails():
    # The archived appendix claims sum_j d_j theta_j S_{jj'} = tau_p S_{0j'}.
    # The obstruction notes concede G_p != tau_p; this test records the failure.
    for p in (3, 5, 7, 11):
        assert archived_gauss_sum_residual(p) > 0.1


def test_out_of_domain_primes_and_spins_are_rejected():
    for p in (2, 4, 9, 15):
        with pytest.raises(ValueError):
            simple_spins(p)
    with pytest.raises(ValueError):
        rt_weight(3, -1)
    with pytest.raises(ValueError):
        quantum_dimension(5, Fraction(3, 2) + 1)
    with pytest.raises(ValueError):
        quantum_dimension(5, Fraction(-1, 2))
    assert is_source_prime(3)
    assert not is_source_prime(2)
    assert not is_source_prime(4)
