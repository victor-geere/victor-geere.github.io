"""Greedy harmonic decomposition — exact computation layer.

The module implements the finite greedy algorithm, the threshold
recursion of the archived threshold paper, and the closed forms for the
diagonal and off-diagonal correlation kernels.  It uses sympy so that
the threshold identity can be checked exactly rather than numerically.
"""

from __future__ import annotations

from typing import Iterable

import sympy as sp

PI = sp.pi


def alpha(n: int) -> sp.Expr:
    """Harmonic angle α_n = π / (n + 2)."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return PI / (n + 2)


def alpha_scaled(n: int) -> sp.Rational:
    """The angle divided by π: 1 / (n + 2)."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.Rational(1, n + 2)


def greedy_digits(theta: sp.Expr, n_max: int) -> list[int]:
    """Run the greedy selection rule for indices 0..n_max.

    Returns the binary selection word δ_0 … δ_{n_max}.  The comparison is
    exact when sympy can decide the sign of the residual; otherwise it
    falls back to a 60-digit numerical evaluation.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    acc = sp.Integer(0)
    digits: list[int] = []
    for n in range(n_max + 1):
        residual = sp.simplify(theta - acc - alpha(n))
        take = residual.is_nonnegative
        if take is None:
            take = bool(sp.N(residual, 60) >= 0)
        digits.append(1 if take else 0)
        if take:
            acc += alpha(n)
    return digits


def greedy_accumulated(theta: sp.Expr, n_max: int) -> sp.Expr:
    """Total angle selected after processing indices 0..n_max."""
    return sp.simplify(sum(alpha(n) for n, d in enumerate(greedy_digits(theta, n_max)) if d))


def thresholds(n_max: int) -> list[sp.Expr]:
    """Thresholds θ_n* for n = 0..n_max, computed by the exact recursion.

    The recursion is Algorithm 3.5 of the archived threshold paper:
    start at α_n, then add the prior angles whose thresholds are at most
    the running total, in increasing threshold order.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    out: list[sp.Expr] = []
    for n in range(n_max + 1):
        A = alpha_scaled(n)
        for k in sorted(range(n), key=lambda j: out[j]):
            if out[k] <= A:
                A += alpha_scaled(k)
            else:
                break
        out.append(A)
    return [sp.simplify(t * PI) for t in out]


def Kdiag(t: sp.Expr) -> sp.Expr:
    """Diagonal correlation kernel K(n,n) at threshold θ_n* = t."""
    return (t**3 + (PI - t) ** 3) / (3 * PI**2)


def Koff(tn: sp.Expr, tm: sp.Expr) -> sp.Expr:
    """Off-diagonal correlation kernel for thresholds tn <= tm."""
    if sp.simplify(tm - tn).is_nonnegative is False:
        tn, tm = tm, tn
    return (
        tn**3 / (3 * PI**2)
        + (-(PI / 2) * (tm**2 - tn**2) + (tm**3 - tn**3) / 3) / PI**2
        + (PI - tm) ** 3 / (3 * PI**2)
    )


def kernel_integral(tn: sp.Expr, tm: sp.Expr) -> sp.Expr:
    """Evaluate the defining integral of K(n,m) by splitting at the thresholds."""
    x = sp.symbols("x", real=True)
    if sp.simplify(tm - tn).is_nonnegative is False:
        tn, tm = tm, tn
    left = sp.integrate((x / PI) ** 2, (x, 0, tn))
    middle = sp.integrate((1 - x / PI) * (-x / PI), (x, tn, tm))
    right = sp.integrate((1 - x / PI) ** 2, (x, tm, PI))
    return sp.simplify(left + middle + right)


def residual_bound_holds(theta: sp.Expr, n_max: int, tol: float = 1e-12) -> bool:
    """Check the source's residual bound 0 <= θ - θ_N <= π/(N+2)."""
    acc = greedy_accumulated(theta, n_max)
    residual = sp.N(theta - acc, 40)
    bound = sp.N(PI / (n_max + 2), 40)
    return bool(-tol <= residual <= bound + tol)


def selection_density(theta: sp.Expr, n_max: int) -> float:
    """Fraction of selected indices among 0..n_max."""
    digits = greedy_digits(theta, n_max)
    return sum(digits) / (n_max + 1)
