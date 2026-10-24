"""Sinc, sine kernel, moments — exact computation layer.

This module implements the finite, exact bookkeeping that the archived
sinc/zeta essays actually define:

* the normalised sinc function ``sin(pi x)/(pi x)`` with the value one at
  the origin;
* the sine kernel ``K(x, y) = sinc(x - y)``;
* Montgomery's pair-correlation factor ``F(alpha) = 1 - sinc(alpha)**2``;
* the phase-times-sinc factor of Kösters' shifted-moment kernel;
* a finite shifted-moment matrix and its Hermitian bookkeeping;
* the even Taylor moments of the sinc function.

No asymptotic zeta or random-matrix statement is evaluated here.  Those
are recorded as source claims / open items in the programme dossier.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi


def _as_expr(x: sp.Expr | int | float) -> sp.Expr:
    """Coerce to a sympy expression without introducing floats silently."""
    return sp.sympify(x)


def sinc(x: sp.Expr | int | float) -> sp.Expr:
    """Normalised sinc: ``sin(pi x)/(pi x)`` for ``x != 0``, and ``1`` at zero."""
    x = _as_expr(x)
    if x == 0:
        return sp.Integer(1)
    return sp.sin(PI * x) / (PI * x)


def sine_kernel(x: sp.Expr | int | float, y: sp.Expr | int | float) -> sp.Expr:
    """The sine kernel ``K(x, y) = sinc(x - y)``."""
    return sinc(_as_expr(x) - _as_expr(y))


def montgomery_F(alpha: sp.Expr | int | float) -> sp.Expr:
    """Montgomery's pair-correlation factor ``1 - sinc(alpha)**2``."""
    alpha = _as_expr(alpha)
    return 1 - sinc(alpha) ** 2


def kosters_kernel(mu: sp.Expr | int | float, nu: sp.Expr | int | float) -> sp.Expr:
    """Kösters' phase-times-sinc factor ``exp(-i pi (mu - nu)) sinc(mu - nu)``."""
    d = _as_expr(mu) - _as_expr(nu)
    return sp.exp(-sp.I * PI * d) * sinc(d)


def shifted_moment_matrix(shifts: Sequence[sp.Expr | int | float]) -> sp.Matrix:
    """Finite shifted-moment matrix ``M[j, k] = kosters_kernel(mu_j, mu_k)``.

    This is bookkeeping for a finite truncation of a shifted moment: it
    records the kernel values at the chosen shifts, not an asymptotic
    zeta moment.
    """
    shifts = [_as_expr(mu) for mu in shifts]
    return sp.Matrix(
        len(shifts),
        len(shifts),
        lambda j, k: kosters_kernel(shifts[j], shifts[k]),
    )


def sinc_taylor_coeff(k: int) -> sp.Expr:
    """The ``k``-th even Taylor coefficient of the normalised sinc function.

    ``sinc(x) = sum_k (-1)^k pi^(2k) x^(2k) / (2k + 1)!``.
    """
    if k < 0:
        raise ValueError("k must be non-negative")
    return sp.Rational((-1) ** k, 1) * PI ** (2 * k) / sp.factorial(2 * k + 1)


def sinc_taylor_polynomial(x: sp.Expr | int | float, n: int) -> sp.Expr:
    """Truncated even Taylor polynomial of ``sinc`` through order ``2n``."""
    if n < 0:
        raise ValueError("n must be non-negative")
    x = _as_expr(x)
    return sp.expand(sum(sinc_taylor_coeff(k) * x ** (2 * k) for k in range(n + 1)))


def sinc_series(x: sp.Expr | int | float, n: int) -> sp.Expr:
    """The Taylor series of ``sin(pi x)/(pi x)`` about zero, truncated at ``2n``.

    This is the same object as :func:`sinc_taylor_polynomial`, obtained
    independently through sympy's series engine, and is used as a check.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    x = _as_expr(x)
    return sp.series(sp.sin(PI * x) / (PI * x), x, 0, 2 * n + 2).removeO()


def moment_ledger(shifts: Sequence[sp.Expr | int | float]) -> dict[str, object]:
    """Small finite ledger for the shifted-moment matrix.

    Returns the matrix together with its diagonal, Hermitian residual and
    modulus residual.  All entries are exact sympy expressions.
    """
    shifts = [_as_expr(mu) for mu in shifts]
    matrix = shifted_moment_matrix(shifts)
    diagonal = [sp.simplify(matrix[j, j]) for j in range(matrix.rows)]
    hermitian_residual = sp.simplify(matrix - matrix.H)
    modulus_residual = sp.simplify(
        sp.Matrix(
            matrix.rows,
            matrix.cols,
            lambda j, k: sp.Abs(matrix[j, k]) - sp.Abs(sinc(shifts[j] - shifts[k])),
        )
    )
    return {
        "matrix": matrix,
        "diagonal": diagonal,
        "hermitian_residual": hermitian_residual,
        "modulus_residual": modulus_residual,
    }
