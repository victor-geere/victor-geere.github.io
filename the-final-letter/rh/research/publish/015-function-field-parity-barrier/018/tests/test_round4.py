"""018 round 4 — unit tests for the shift / curve-lift computations."""
import os
import sys

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
import qrime as Q


@pytest.mark.parametrize("q,n", [(3, 3), (3, 5), (5, 3), (7, 2), (7, 3)])
def test_shift_two_matches_twin(q, n):
    assert Q.twin_qrimes_shift(q, n, 2) == Q.twin_qrimes(q, n)


@pytest.mark.parametrize("q,n", [(5, 2), (7, 2), (7, 3), (11, 2)])
def test_shift_symmetry(q, n):
    # f ↦ -f is a bijection on degree-n polynomials and preserves
    # irreducibility (up to units), so the counts for δ and -δ agree.
    for d in range(q):
        assert len(Q.twin_qrimes_shift(q, n, d)) == len(Q.twin_qrimes_shift(q, n, (-d) % q))


def test_F5_degree2_shifts():
    # the curve-lift witness
    assert len(Q.twin_qrimes_shift(5, 2, 1)) == 5
    assert len(Q.twin_qrimes_shift(5, 2, 2)) == 0


def test_F5_degree2_map_counts():
    # maps pi_a(x) = a x induce delta = 2/a; the counts are {0, 5}
    counts = {a: len(Q.twin_qrimes_shift(5, 2, (2 * pow(a, -1, 5)) % 5)) for a in range(1, 5)}
    assert counts == {1: 0, 2: 5, 3: 5, 4: 0}


def test_zigma_datum_deg2():
    assert Q.qrime_count_mobius(5, 2) == 10


def test_sympy_cross_check_f5_degree2():
    sp = pytest.importorskip("sympy")
    x = sp.symbols('x')

    def irr(b, c):
        return sp.Poly(x ** 2 + b * x + c, x, modulus=5).is_irreducible

    for d in range(5):
        sy = sum(1 for b in range(5) for c in range(5) if irr(b, c) and irr(b, c + d))
        assert sy == len(Q.twin_qrimes_shift(5, 2, d))
