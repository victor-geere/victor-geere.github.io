"""Partial-sum + tail identities harvested from ~/workspace/rh.

Model: the summable geometric sequence `f(n) = q^n`. The total is `1/(1-q)`;
the finite partial sum plus the shifted tail is the total, and the truncation
residual equals the tail.
"""

from __future__ import annotations

import sympy as sp


def geometric_total(q: sp.Expr) -> sp.Expr:
    return sp.simplify(1 / (1 - sp.sympify(q)))


def geometric_partial(q: sp.Expr, K: int) -> sp.Expr:
    q = sp.sympify(q)
    return sp.simplify(sum(q**n for n in range(K)))


def geometric_tail(q: sp.Expr, K: int) -> sp.Expr:
    q = sp.sympify(q)
    return sp.simplify(q**K / (1 - q))


def partial_plus_tail(q: sp.Expr, K: int) -> sp.Expr:
    return sp.simplify(geometric_partial(q, K) + geometric_tail(q, K))


def residual_bound_holds(q: sp.Expr, K: int) -> bool:
    q = sp.sympify(q)
    residual = sp.simplify(geometric_total(q) - geometric_partial(q, K))
    return bool(sp.simplify(sp.Abs(residual) - sp.Abs(geometric_tail(q, K))) <= 0)


def three_tail_bound_holds(lhs, rhs_computed, zero_tail, prime_tail, arch_tail) -> bool:
    lhs, rhs_computed, z, p, a = map(sp.sympify, (lhs, rhs_computed, zero_tail, prime_tail, arch_tail))
    rhs_true = rhs_computed + (z + p + a)
    residual = sp.simplify(lhs - rhs_computed)
    return bool(sp.simplify(sp.Abs(residual) - (sp.Abs(z) + sp.Abs(p) + sp.Abs(a))) <= 0) and sp.simplify(lhs - rhs_true) == 0
