"""Exact finite arithmetic for the geometric DQPT programme.

This module implements only the elementary finite layer of

    the-final-letter/geometric-dynamical-phase-transitions/publication.html

namely the integer mean-zero filter of Lemma 2.2, the depth-one pair of
Definition 3.1 at the quadratic link, the tempering weight of Definition 2.4,
and the atomic weights of Definition 8.1.  The analytic remainder estimates,
tightness, the spectral conversion theorem and the Riemann hypothesis are not
implemented here; see the programme README.

All arithmetic is exact sympy arithmetic.  No numerical tolerance is used.
"""

from __future__ import annotations

from typing import Iterable, Mapping

import sympy as sp

__all__ = [
    "filter_coefficient",
    "filter_coefficients",
    "complete_block_sum",
    "quadratic_link",
    "two_sum_coefficients",
    "filter_coefficients_dict",
    "two_sum_identity_holds",
    "tempered_weight",
    "atomic_weight",
    "atomic_mass",
    "atomic_mass_bound_holds",
]


def _check_period(N: int) -> None:
    """The source uses integer periods ``N >= 2``."""
    if not isinstance(N, int) or isinstance(N, bool):
        raise TypeError("period N must be an integer")
    if N < 2:
        raise ValueError("period N must satisfy N >= 2")


def _check_length(M: int) -> None:
    if not isinstance(M, int) or isinstance(M, bool):
        raise TypeError("outer length M must be an integer")
    if M < 1:
        raise ValueError("outer length M must satisfy M >= 1")


def filter_coefficient(N: int, m: int) -> sp.Integer:
    """Return the integer filter coefficient ``c_m^(N)`` of Lemma 2.2.

    ``c_m^(N) = 1`` when ``N`` does not divide ``m`` and ``1 - N`` when it
    does.
    """
    _check_period(N)
    if not isinstance(m, int) or isinstance(m, bool):
        raise TypeError("index m must be an integer")
    if m < 1:
        raise ValueError("index m must satisfy m >= 1")
    return sp.Integer(1 - N) if m % N == 0 else sp.Integer(1)


def filter_coefficients(N: int, M: int) -> list[sp.Integer]:
    """Return ``[c_1^(N), ..., c_M^(N)]`` exactly."""
    _check_period(N)
    _check_length(M)
    return [filter_coefficient(N, m) for m in range(1, M + 1)]


def complete_block_sum(N: int) -> sp.Integer:
    """Sum of the filter over one complete block ``1, ..., N``.

    Lemma 3.2 states that the coefficients have mean zero over every complete
    block of ``N`` consecutive integers.  This function returns the exact sum,
    which is zero for every admissible period.
    """
    _check_period(N)
    return sp.Integer(sum(filter_coefficients(N, N)))


def quadratic_link(N: int) -> int:
    """The inner length at ``M = N^2``: ``floor(N^2 / N)``.

    Definition 3.1 notes that the quadratic link makes the inner length equal
    to the filter period.
    """
    _check_period(N)
    return (N * N) // N


def two_sum_coefficients(N: int, M: int) -> dict[int, sp.Integer]:
    """Coefficients of the depth-one pair of Definition 3.1.

    The pair is

        ``eta_N^(M)(s) = H_M^(s) - N^(1-s) H_floor(M/N)^(s)``

    and therefore has coefficient ``1`` at every ``m <= M`` and an additional
    ``-N`` at every multiple of ``N``.  The entry ``N^(1-s)`` is exactly
    ``N * (N j)^(-s)`` at ``m = N j``, which is why the coefficient is ``1 - N``.
    """
    _check_period(N)
    _check_length(M)
    inner = M // N
    coefficients: dict[int, sp.Integer] = {m: sp.Integer(1) for m in range(1, M + 1)}
    for j in range(1, inner + 1):
        m = N * j
        coefficients[m] = coefficients[m] - sp.Integer(N)
    return coefficients


def filter_coefficients_dict(N: int, M: int) -> dict[int, sp.Integer]:
    """The filter-form coefficients of Lemma 3.2, indexed by ``m``."""
    return {m: c for m, c in enumerate(filter_coefficients(N, M), start=1)}


def two_sum_identity_holds(N: int, M: int) -> bool:
    """Exact check of Lemma 3.2 at a finite outer length.

    The depth-one pair and the filter sum have the same coefficient at every
    ``m <= M``.  Returns ``True`` exactly when the two dictionaries agree.
    """
    return two_sum_coefficients(N, M) == filter_coefficients_dict(N, M)


def tempered_weight(t: sp.Expr | int | sp.Rational) -> sp.Expr:
    """The tempering weight ``(1 + t^2)^(-1)`` of Definition 2.4."""
    tt = sp.sympify(t)
    return sp.simplify(sp.Integer(1) / (1 + tt**2))


def _real_imag(z: sp.Expr) -> tuple[sp.Expr, sp.Expr]:
    """Return the exact real and imaginary parts of a complex expression."""
    expanded = sp.expand_complex(sp.sympify(z))
    return sp.simplify(sp.re(expanded)), sp.simplify(sp.im(expanded))


def atomic_weight(z: sp.Expr) -> sp.Expr:
    """The atomic weight ``(1 + |z|^2)^(-1)`` of Definition 8.1."""
    x, y = _real_imag(z)
    return sp.simplify(sp.Integer(1) / (1 + x**2 + y**2))


def atomic_mass(points: Iterable[sp.Expr]) -> sp.Expr:
    """Total mass of a finite atomic measure with one atom per point."""
    return sp.simplify(sum((atomic_weight(z) for z in points), sp.Integer(0)))


def atomic_mass_bound_holds(points: Iterable[sp.Expr]) -> bool:
    """Exact check that a finite atomic mass is non-negative and at most its
    atom count, mirroring the finite-measure clause of Theorem 9.1."""
    pts = list(points)
    mass = atomic_mass(pts)
    return bool(mass >= 0) and bool(sp.simplify(mass - len(pts)) <= 0)
