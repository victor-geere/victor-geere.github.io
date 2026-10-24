"""Tests for the finite transfer-operator reconstruction.

Every ``Computation`` row of the dossier ledger has a test here.  The
tests cover exact sympy identities and one numerical (mpmath) check of
the classical xi functional equation; the latter is used only to fix the
analytic object, never to assert RH.
"""

import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    diagonal_energy,
    diagonal_form,
    fredholm_det,
    krein_form,
    prime_sieve,
    prime_weight,
    primes_up_to,
    truncated_euler_product,
    von_mangoldt,
    xi_numeric,
)


def test_von_mangoldt_values_and_edge_case():
    assert von_mangoldt(1) == 0
    assert von_mangoldt(2) == sp.log(2)
    assert von_mangoldt(4) == sp.log(2)
    assert von_mangoldt(8) == sp.log(2)
    assert von_mangoldt(9) == sp.log(3)
    assert von_mangoldt(6) == 0
    assert von_mangoldt(30) == 0
    with pytest.raises(ValueError):
        von_mangoldt(0)


def test_prime_sieve_does_not_isolate_primes():
    """The source's own correction: Ψ_P vanishes at composites too."""
    ps = primes_up_to(29)
    assert len(ps) == 10
    for n in range(2, 31):
        assert sp.simplify(prime_sieve(n, ps)) == 0
    # Composites are not distinguished from primes.
    assert sp.simplify(prime_sieve(4, ps)) == 0
    assert sp.simplify(prime_sieve(6, ps)) == 0
    assert sp.simplify(prime_sieve(9, ps)) == 0


def test_prime_sieve_nonzero_off_integers():
    ps = primes_up_to(29)
    value = sp.N(prime_sieve(sp.Rational(5, 2), ps), 30)
    assert abs(value) > sp.Float("1e-8")
    # Edge case: the empty truncation is the constant product 1.
    assert prime_sieve(sp.Rational(5, 2), []) == 1


def test_prime_weights_stay_in_unit_interval():
    for p in (2, 3, 5, 7, 11, 29):
        for s in (sp.Rational(1, 2), sp.Integer(1), sp.Integer(2), sp.Rational(7, 3)):
            w = prime_weight(p, s)
            assert sp.N(w, 40) > 0
            assert sp.N(w, 40) < 1
    with pytest.raises(ValueError):
        prime_weight(1, 2)


def test_fredholm_determinant_vanishes_iff_eigenvalue_one():
    assert sp.simplify(fredholm_det([sp.Rational(1, 2), sp.Rational(1, 3)])) == sp.Rational(1, 3)
    assert sp.simplify(fredholm_det([sp.Rational(1, 2), sp.Integer(1)])) == 0
    # Edge case: empty determinant is 1, so it never vanishes vacuously.
    assert fredholm_det([]) == 1
    assert truncated_euler_product(2, [2, 3, 5]) == sp.Rational(3, 4) * sp.Rational(8, 9) * sp.Rational(24, 25)


def test_diagonal_form_is_symmetric_and_positive():
    weights = [sp.Integer(2), sp.Integer(3), sp.Integer(5)]
    x = [sp.Integer(1), sp.Integer(-2), sp.Rational(1, 3)]
    y = [sp.Integer(4), sp.Rational(1, 2), sp.Integer(-1)]
    assert sp.simplify(diagonal_form(weights, x, y) - diagonal_form(weights, y, x)) == 0
    assert sp.simplify(diagonal_energy(weights, x)) > 0
    # Edge case: the zero vector has zero energy, and no negative weight is allowed.
    assert diagonal_energy(weights, [0, 0, 0]) == 0
    negative = [sp.Integer(2), sp.Integer(-1)]
    assert sp.simplify(diagonal_energy(negative, [0, 1])) < 0


def test_krein_form_is_symmetric_but_indefinite():
    signs = [sp.Integer(1), sp.Integer(-1)]
    x = [sp.Integer(3), sp.Integer(2)]
    y = [sp.Integer(1), sp.Integer(5)]
    assert sp.simplify(krein_form(signs, x, y) - krein_form(signs, y, x)) == 0
    # Positive and negative directions coexist: the form is not definite.
    assert sp.simplify(krein_form(signs, [1, 0], [1, 0])) > 0
    assert sp.simplify(krein_form(signs, [0, 1], [0, 1])) < 0
    # Edge case: the isotropic vector (1, 1) is neither positive nor negative.
    assert sp.simplify(krein_form(signs, [1, 1], [1, 1])) == 0


def test_xi_functional_equation_numeric():
    """Classical symmetry ξ(s) = ξ(1-s), checked at two points."""
    for s in (0.3 + 2.0j, 0.7 - 1.5j):
        lhs = xi_numeric(s, dps=30)
        rhs = xi_numeric(1 - s, dps=30)
        assert abs(lhs - rhs) <= 1e-14
    # A real point in the critical strip is finite and nonzero.
    assert abs(xi_numeric(0.5 + 3.0j, dps=30)) > 1e-6
