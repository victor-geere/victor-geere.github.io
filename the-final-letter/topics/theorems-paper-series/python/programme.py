"""GDST paper series — exact finite computation layer.

The archived paper `archive/maths/theorems/paper.md` defines the greedy
harmonic expansion of a normalised target ``x = θ/π`` and the GDST
Dirichlet sub-series built from its digits.  This module implements the
*finite* part of that construction exactly with sympy:

* the harmonic fractions ``α_n = 1/(n+2)``;
* the greedy remainder recursion and the binary selection word;
* the truncated selected series ``E_N``, rejected series ``Ω_N`` and the
  full prefix ``H_N``;
* the finite invariant ``r_N = x - E_N`` and the split ``E_N + Ω_N = H_N``.

Everything is exact rational arithmetic.  The infinite series, the
transfer operator, the Fredholm determinant and the Riemann-hypothesis
claim of the paper are deliberately **not** implemented: they are source
claims recorded in the programme dossier, not computations certified here.
"""

from __future__ import annotations

from typing import Callable

import sympy as sp

Weight = Callable[[int], sp.Expr]


def _check_index(n: int) -> None:
    if n < 0:
        raise ValueError("index must be non-negative")


def _target(x) -> sp.Expr:
    """Coerce an exact target to a sympy rational."""
    x = sp.sympify(x)
    if not x.is_rational:
        raise ValueError("the greedy layer only accepts exact rational targets")
    return sp.Rational(x)


def alpha(n: int) -> sp.Rational:
    """The harmonic fraction ``α_n = 1/(n+2)``."""
    _check_index(n)
    return sp.Rational(1, n + 2)


def alpha_angle(n: int) -> sp.Expr:
    """The angle form ``π/(n+2)`` (for display alongside the paper)."""
    _check_index(n)
    return sp.pi / (n + 2)


def run(x, N: int) -> sp.Rational:
    """Greedy remainder after processing indices ``0 … N-1``.

    This is ``r_N`` in the source's notation: subtract ``α_k`` at step
    ``k`` exactly when it fits in the current remainder.
    """
    _check_index(N)
    r = _target(x)
    for n in range(N):
        if alpha(n) <= r:
            r -= alpha(n)
    return r


def digits(x, n_max: int) -> list[int]:
    """The greedy selection word ``δ_0 … δ_{n_max}``."""
    _check_index(n_max)
    r = _target(x)
    word: list[int] = []
    for n in range(n_max + 1):
        take = 1 if alpha(n) <= r else 0
        word.append(take)
        if take:
            r -= alpha(n)
    return word


def selected_sum(x, N: int, weight: Weight | None = None) -> sp.Expr:
    """Selected prefix ``E_N = Σ_{k<N, δ_k=1} weight(k)``."""
    _check_index(N)
    weight = alpha if weight is None else weight
    word = digits(x, N - 1) if N > 0 else []
    return sp.Add(*(weight(k) for k, d in enumerate(word) if d))


def rejected_sum(x, N: int, weight: Weight | None = None) -> sp.Expr:
    """Rejected prefix ``Ω_N = Σ_{k<N, δ_k=0} weight(k)``."""
    _check_index(N)
    weight = alpha if weight is None else weight
    word = digits(x, N - 1) if N > 0 else []
    return sp.Add(*(weight(k) for k, d in enumerate(word) if not d))


def total_sum(N: int, weight: Weight | None = None) -> sp.Expr:
    """Full prefix ``H_N = Σ_{k<N} weight(k)``."""
    _check_index(N)
    weight = alpha if weight is None else weight
    return sp.Add(*(weight(k) for k in range(N)))


def invariant_residual(x, N: int) -> sp.Expr:
    """Exact residual ``r_N - (x - E_N)``; zero by the finite invariant."""
    return sp.simplify(run(x, N) - (_target(x) - selected_sum(x, N)))


def complement_residual(x, N: int, weight: Weight | None = None) -> sp.Expr:
    """Exact residual ``E_N + Ω_N - H_N``; zero by the finite split."""
    return sp.expand(
        selected_sum(x, N, weight)
        + rejected_sum(x, N, weight)
        - total_sum(N, weight)
    )


def dirichlet_weight(n: int, s) -> sp.Expr:
    """The source's weight ``(n+2)^(-s)``."""
    _check_index(n)
    return sp.Pow(n + 2, -sp.sympify(s))


def pi_example() -> dict:
    """The source's ``θ = π`` example: ``1 = 1/2 + 1/3 + 1/6``.

    Returns the selected indices, the selection word, the selected sum,
    and the final remainder for the greedy pass over ``n = 0 … 8``.
    """
    word = digits(1, 8)
    r = run(1, 9)
    return {
        "word": word,
        "selected": [n for n, d in enumerate(word) if d],
        "selected_sum": selected_sum(1, 9),
        "remainder": r,
        "terminates": r == 0,
    }


def remainder_bound_holds(x, N: int) -> bool:
    """The repaired Lemma 1.3 bound ``r_N ≤ 1/(N+1)`` for ``N ≥ 1``.

    The source states ``r_n < 1/(n+2)``, which is false at ``x = 1``
    (there ``r_0 = 1/2 = 1/(0+2)``).  After processing index ``n`` the
    correct sharp bound is ``r_{n+1} ≤ 1/(n+1)``; this helper checks the
    ``N``-indexed form.
    """
    _check_index(N)
    if N == 0:
        raise ValueError("the bound needs at least one processed index")
    return bool(run(x, N) <= sp.Rational(1, N + 1))


def next_index_lower_bound(m: int) -> int:
    """The arithmetic conclusion of the source's Theorem 1.6.

    If ``m = n_k ≥ 2`` is selected and ``n_{k+1} ≥ (m+1)(m+2) - 1``,
    then in particular ``n_{k+1} ≥ m(m-1)``.
    """
    _check_index(m)
    return (m + 1) * (m + 2) - 1


def projected_next_index_ge_quadratic(m: int) -> bool:
    """Check ``(m+1)(m+2) - 1 ≥ m(m-1)`` for ``m ≥ 2``."""
    _check_index(m)
    return next_index_lower_bound(m) >= m * (m - 1)


def monotonicity_counterexample() -> dict:
    """Exact counterexample to the source's Theorem 1.7 (digit monotonicity).

    At ``n = 1`` the lower target ``999/2000`` selects index 1 while the
    larger target ``1/2`` does not, so ``δ_1`` is not non-decreasing.
    """
    lower = sp.Rational(999, 2000)
    upper = sp.Rational(1, 2)
    return {
        "lower": lower,
        "upper": upper,
        "index": 1,
        "digits_lower": digits(lower, 3),
        "digits_upper": digits(upper, 3),
    }
