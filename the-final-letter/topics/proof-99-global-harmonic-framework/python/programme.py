"""Global Harmonic Framework — exact finite spectral bookkeeping.

The archived source (`archive/maths/proof-99/paper.md`) builds the GHD
correlation kernel from the two coefficient sequences

    a_n = 1 / sqrt(n (n + 1)),      b_n = 1 / (n + 1),      n >= 1,

as the rank-one perturbation ``K = I + |a><b|`` of the identity, then forms
the weighted Gram operator ``M(s) = D(s) K D(s)`` with diagonal weight
``D(s)_nn = (n + 2)^(-(s + 1/2))``.

This module implements the finite, exact part of that construction:

* the coefficient sequences and their squared sums (including the
  telescoping identity ``sum a_n^2 = N/(N+1)``);
* the finite rank-one kernel and the matrix determinant lemma
  ``det(I + |a><b|) = 1 + <b, a>``;
* the finite weighted Gram determinant in closed form;
* the modulus of the critical-line weight;
* the symmetry defect of the canonical kernel, which records a genuine
  internal inconsistency in the source (see the programme README).

Nothing here evaluates zeta, its zeros, or any Fredholm determinant of an
infinite-dimensional operator.  The module is import-safe and uses sympy
for exact arithmetic; mpmath is only used for the high-precision modulus
check.
"""

from __future__ import annotations

from typing import Iterable

import mpmath as mp
import sympy as sp

__all__ = [
    "a",
    "b",
    "a_squared",
    "b_squared",
    "telescoping_partial",
    "b_squared_partial",
    "rank_one_kernel",
    "rank_one_det",
    "rank_one_det_formula",
    "weighted_gram",
    "weighted_diagonal",
    "weighted_gram_det",
    "weighted_gram_det_formula",
    "critical_line_modulus",
    "symmetry_defect",
]


def a(n: int) -> sp.Expr:
    """First GHD coefficient ``a_n = 1/sqrt(n(n+1))`` for ``n >= 1``."""
    if n < 1:
        raise ValueError("the source indexes a_n from n >= 1")
    return 1 / sp.sqrt(sp.Integer(n) * (n + 1))


def b(n: int) -> sp.Expr:
    """Second GHD coefficient ``b_n = 1/(n+1)`` for ``n >= 1``."""
    if n < 1:
        raise ValueError("the source indexes b_n from n >= 1")
    return sp.Rational(1, n + 1)


def a_squared(n: int) -> sp.Rational:
    """``a_n^2 = 1/(n(n+1))`` as an exact rational."""
    if n < 1:
        raise ValueError("the source indexes a_n from n >= 1")
    return sp.Rational(1, n * (n + 1))


def b_squared(n: int) -> sp.Rational:
    """``b_n^2 = 1/(n+1)^2`` as an exact rational."""
    if n < 1:
        raise ValueError("the source indexes b_n from n >= 1")
    return sp.Rational(1, (n + 1) ** 2)


def telescoping_partial(n_max: int) -> sp.Rational:
    """Exact ``sum_{n=1}^{N} a_n^2 = N/(N+1)``.

    This is the finite form of the source's telescoping claim
    ``sum_n 1/(n(n+1)) = 1``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return sp.Rational(n_max, n_max + 1)


def b_squared_partial(n_max: int) -> sp.Expr:
    """Exact ``sum_{n=1}^{N} b_n^2`` in terms of a generalised harmonic number.

    ``sum_{n=1}^{N} 1/(n+1)^2 = H_{N+1}^{(2)} - 1``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return sp.harmonic(n_max + 1, 2) - 1


def rank_one_kernel(n_max: int) -> sp.Matrix:
    """Finite truncation of ``K = I + |a><b|`` on indices ``1..N``.

    The matrix entries are ``K_ij = delta_ij + a_i b_j``.  No symmetry is
    assumed; in fact this kernel is *not* symmetric when ``a != b``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    if n_max == 0:
        return sp.zeros(0, 0)
    return sp.Matrix(
        n_max,
        n_max,
        lambda i, j: (sp.Integer(1) if i == j else 0) + a(i + 1) * b(j + 1),
    )


def rank_one_det(n_max: int) -> sp.Expr:
    """Exact determinant of the finite rank-one kernel."""
    return sp.simplify(rank_one_kernel(n_max).det())


def rank_one_det_formula(n_max: int) -> sp.Expr:
    """Closed form ``1 + sum_i b_i a_i`` from the determinant lemma."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return 1 + sum(b(i) * a(i) for i in range(1, n_max + 1))


def weighted_diagonal(n_max: int, s: sp.Expr) -> list[sp.Expr]:
    """The diagonal weights ``d_n = (n+2)^(-(s+1/2))`` for ``n = 1..N``."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return [(sp.Integer(n + 2)) ** (-(s + sp.Rational(1, 2))) for n in range(1, n_max + 1)]


def weighted_gram(n_max: int, s: sp.Expr) -> sp.Matrix:
    """Finite weighted Gram operator ``M(s) = D(s) K D(s)``."""
    d = weighted_diagonal(n_max, s)
    diag = sp.diag(*d) if d else sp.zeros(0, 0)
    return sp.simplify(diag * rank_one_kernel(n_max) * diag)


def weighted_gram_det(n_max: int, s: sp.Expr) -> sp.Expr:
    """Exact determinant of the finite weighted Gram operator."""
    return sp.simplify(weighted_gram(n_max, s).det())


def weighted_gram_det_formula(n_max: int, s: sp.Expr) -> sp.Expr:
    """Closed form ``prod_n d_n^2 * (1 + sum_n a_n b_n)``.

    This is the matrix determinant lemma applied to
    ``M(s) = D(s)^2 + (D(s)a)(b^T D(s))`` with ``D(s)^2`` invertible.
    The correction term is independent of ``s``: the weights cancel in
    ``b^T D(s)^{-2} D(s) a = sum_n a_n b_n``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    d = weighted_diagonal(n_max, s)
    det_d_sq = sp.prod([di * di for di in d])
    correction = 1 + sum(a(n) * b(n) for n in range(1, n_max + 1))
    return sp.simplify(det_d_sq * correction)


def critical_line_modulus(n: int, t: float, dps: int = 40) -> tuple[mp.mpf, mp.mpf]:
    """Compare ``|(n+2)^(-(1+it))|`` with ``1/(n+2)`` at high precision.

    Returns ``(modulus, expected)``.  On the critical line the source
    claims the modulus is exactly ``1/(n+2)`` (Section 4.3).
    """
    if n < 1:
        raise ValueError("n must be at least 1")
    mp.mp.dps = dps
    z = mp.mpc(n + 2) ** (-(mp.mpc(1, t)))
    return abs(z), mp.mpf(1) / (n + 2)


def symmetry_defect(n_max: int) -> sp.Expr:
    """Largest ``|K_ij - K_ji|`` of the canonical rank-one kernel.

    The archived source asserts that ``K`` is symmetric (Section 8.2).
    For the sequences it actually defines this is false: the defect is
    positive as soon as ``N >= 2``.
    """
    if n_max < 1:
        raise ValueError("need at least two indices to test symmetry")
    K = rank_one_kernel(n_max)
    return max(abs(K[i, j] - K[j, i]) for i in range(n_max) for j in range(n_max))
