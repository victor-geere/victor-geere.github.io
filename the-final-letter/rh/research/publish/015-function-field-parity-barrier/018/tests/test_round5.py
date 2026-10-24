"""018 round 5 — tests for the Frobenius-trace reading of T(3)."""
import os
import sys
from fractions import Fraction

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
import fast_twin as F


def primes_upto(N):
    return [p for p in range(3, N + 1) if all(p % d for d in range(2, int(p ** 0.5) + 1))]


def chi(a, q):
    a %= q
    if a == 0:
        return 0
    return 1 if pow(a, (q - 1) // 2, q) == 1 else -1


def E_char_count(q):
    return q + 1 + sum(chi(1 + 4 * pow(X, 3, q), q) for X in range(q))


def E_brute_count(q):
    n = 1
    for X in range(q):
        rhs = pow(X, 3, q)
        for Y in range(q):
            if (Y * Y - Y - rhs) % q == 0:
                n += 1
    return n


@pytest.mark.parametrize("q", [5, 7, 11, 13, 17, 19])
def test_E_char_equals_brute(q):
    assert E_char_count(q) == E_brute_count(q)


@pytest.mark.parametrize("q", [5, 7, 11, 13, 17, 19, 23, 29])
def test_E_count_sympy(q):
    sp = pytest.importorskip("sympy")
    # independent count via a sympy sum over the curve equation
    n = 1
    for X in range(q):
        for Y in range(q):
            if sp.Mod(Y ** 2 - Y - X ** 3, q) == 0:
                n += 1
    assert n == E_char_count(q)


def test_clean_formula_on_supersingular_class():
    for q in [p for p in primes_upto(120) if p % 3 == 2]:
        assert F.twin_count_fast(q, 3) == q * (q - 2) * (q + 1) // 9
        assert E_char_count(q) == q + 1  # c_q = 0


def test_deviation_vanishes_iff_supersingular():
    for q in primes_upto(120):
        if q < 5:
            continue
        clean = Fraction(q * (q - 2) * (q + 1), 9)
        dev = F.twin_count_fast(q, 3) - clean
        c = q + 1 - E_char_count(q)
        assert (dev == 0) == (c == 0)


def test_supersingular_criterion():
    for q in primes_upto(200):
        if q == 3:
            continue
        assert ((q + 1 - E_char_count(q)) == 0) == (q % 3 == 2)
