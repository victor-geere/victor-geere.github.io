import sys
from pathlib import Path

import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from partial_sum_tail import (  # noqa: E402
    geometric_partial,
    geometric_tail,
    geometric_total,
    partial_plus_tail,
    residual_bound_holds,
    three_tail_bound_holds,
)


def test_partial_plus_tail_is_total():
    q = sp.Rational(1, 2)
    for K in (0, 1, 5, 20):
        assert sp.simplify(partial_plus_tail(q, K) - geometric_total(q)) == 0


def test_residual_equals_tail():
    q = sp.Rational(1, 3)
    for K in (1, 4, 10):
        residual = sp.simplify(geometric_total(q) - geometric_partial(q, K))
        assert sp.simplify(residual - geometric_tail(q, K)) == 0


def test_residual_bound():
    for q in (sp.Rational(1, 2), sp.Rational(2, 3), sp.Rational(-1, 2)):
        for K in (0, 3, 9):
            assert residual_bound_holds(q, K)


def test_three_tail_bound():
    assert three_tail_bound_holds(
        lhs=sp.Integer(10),
        rhs_computed=sp.Integer(6),
        zero_tail=sp.Integer(1),
        prime_tail=sp.Integer(2),
        arch_tail=sp.Integer(1),
    )
    assert three_tail_bound_holds(
        lhs=sp.Integer(5) + sp.I,
        rhs_computed=sp.Integer(3),
        zero_tail=sp.Integer(1),
        prime_tail=sp.I,
        arch_tail=sp.Integer(1),
    )
