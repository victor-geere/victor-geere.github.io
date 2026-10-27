"""Finance / trading ebooks — exact computation layer.

The archived source is an index of ebooks.  This module reconstructs the only
finite computation that the source states completely: the binomial-lattice
action sum of ``continuous-lattice.html`` §3–§4.

With node value ``S_{k,j} = S0 * u**j * d**(k-j)``, exposure
``a = 1 / (S * eps)`` and action ``f(S, a) = S * a``, the action is the
constant ``1 / eps``.  Hence the binomial-weighted action sum on level ``k``
is ``1 / eps`` and the total over ``n + 1`` levels is ``(n + 1) / eps``.

The module also exposes the exact two-point volatility-drag log growth,
``g(r) = log(1 - r**2) / 2``, for gross returns ``1 + r`` and ``1 - r``.
Everything is exact sympy arithmetic; no numerical approximation is used
except where a test explicitly states a tolerance.
"""

from __future__ import annotations

import sympy as sp


def _check_index(k: int, j: int) -> None:
    if k < 0:
        raise ValueError("k must be non-negative")
    if j < 0 or j > k:
        raise ValueError("j must satisfy 0 <= j <= k")


def binomial_weight(p: sp.Expr, k: int, j: int) -> sp.Expr:
    """Binomial lattice weight ``C(k, j) * p**j * (1 - p)**(k-j)``."""
    _check_index(k, j)
    p = sp.sympify(p)
    return sp.binomial(k, j) * p**j * (1 - p) ** (k - j)


def binomial_sum(p: sp.Expr, k: int) -> sp.Expr:
    """Sum of the level-``k`` binomial weights; exactly ``1`` for every ``p``."""
    if k < 0:
        raise ValueError("k must be non-negative")
    p = sp.sympify(p)
    return sp.simplify(sum(binomial_weight(p, k, j) for j in range(k + 1)))


def node_value(S0: sp.Expr, u: sp.Expr, d: sp.Expr, k: int, j: int) -> sp.Expr:
    """Lattice node value ``S0 * u**j * d**(k-j)``."""
    _check_index(k, j)
    return sp.sympify(S0) * sp.sympify(u) ** j * sp.sympify(d) ** (k - j)


def action(S: sp.Expr, eps: sp.Expr) -> sp.Expr:
    """The source's exposure action ``S * (1 / (S * eps))``.

    Raises ``ValueError`` for ``S = 0`` or ``eps = 0``; the source's
    simplification to ``1 / eps`` requires both to be non-zero.
    """
    S = sp.sympify(S)
    eps = sp.sympify(eps)
    if sp.simplify(S) == 0:
        raise ValueError("S must be non-zero")
    if sp.simplify(eps) == 0:
        raise ValueError("eps must be non-zero")
    return sp.simplify(S * (1 / (S * eps)))


def level_action_sum(
    p: sp.Expr,
    k: int,
    eps: sp.Expr,
    S0: sp.Expr = sp.Integer(1),
    u: sp.Expr = sp.Integer(2),
    d: sp.Rational = sp.Rational(1, 2),
) -> sp.Expr:
    """Probability-weighted action sum on lattice level ``k``."""
    if k < 0:
        raise ValueError("k must be non-negative")
    p = sp.sympify(p)
    total = sp.Integer(0)
    for j in range(k + 1):
        S = node_value(S0, u, d, k, j)
        total += binomial_weight(p, k, j) * action(S, eps)
    return sp.simplify(total)


def total_action_sum(n: int, eps: sp.Expr, p: sp.Expr = sp.Rational(1, 2)) -> sp.Expr:
    """Total action over levels ``0..n``; the source claims ``(n + 1) / eps``.

    The result is independent of ``p``; the argument is exposed so callers can
    check that independence rather than rely on a hidden default.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    eps = sp.sympify(eps)
    if sp.simplify(eps) == 0:
        raise ValueError("eps must be non-zero")
    return sp.simplify(
        sum(level_action_sum(p, k, eps) for k in range(n + 1))
    )


def two_point_log_growth(r: sp.Expr) -> sp.Expr:
    """Exact log growth of the two-point lattice ``1 + r`` / ``1 - r``."""
    r = sp.sympify(r)
    if r.is_positive is not True or (1 - r).is_positive is not True:
        raise ValueError("r must satisfy 0 < r < 1")
    return sp.log(1 - r**2) / 2


def two_point_drag_approx(r: sp.Expr) -> sp.Expr:
    """The volatility-drag approximation ``-sigma**2 / 2`` with ``sigma**2 = r**2``."""
    r = sp.sympify(r)
    return -(r**2) / 2
