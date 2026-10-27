"""Exact and high-precision companion to ``lean/Topic.lean``.

The Lean file is the canonical Euler–Maclaurin development.  This module is a
small, independent check of the same finite identity over ``Q`` and of the
shape of the explicit tail bound.  It is not a reimplementation of the Lean
proof: it is a computation layer that a reader can run.

Conventions
-----------
``bernoulli_exact(n)`` returns the even-index Bernoulli numbers with the
standard sign (``B_2 = 1/6``, ``B_4 = -1/30``).  ``periodic_bernoulli_polynomial``
uses the Bernoulli polynomial with ``B_1(x) = x - 1/2``, matching Mathlib's
``Polynomial.bernoulli`` and the Lean ``periodicBernoulli``.
"""
from __future__ import annotations

from fractions import Fraction
from typing import Callable

import mpmath as mp
import sympy as sp


def bernoulli_exact(n: int) -> sp.Rational:
    """Return the Bernoulli number ``B_n`` exactly, with ``B_1 = -1/2``.

    Sympy's ``bernoulli(n)`` uses the ``B_1^+ = +1/2`` convention, while its
    polynomial ``bernoulli(n, x)`` uses ``B_1(x) = x - 1/2``.  The Lean layer
    uses the latter, so ``B_1`` is normalised here.
    """
    if n < 0:
        raise ValueError("Bernoulli index must be non-negative")
    if n == 1:
        return sp.Rational(-1, 2)
    return sp.Rational(sp.bernoulli(n))


def periodic_bernoulli_polynomial(n: int, x: sp.Expr) -> sp.Expr:
    """The Bernoulli polynomial ``B_n(x)`` used by the Lean layer."""
    if n < 0:
        raise ValueError("Bernoulli index must be non-negative")
    return sp.expand(sp.bernoulli(n, x))


def _unit_integral(
    derivative: sp.Expr, n: int, k: int
) -> sp.Expr:
    """``∫_0^1 B_{2k+1}(u) f^{(2k+1)}(n+u) du`` exactly."""
    u = sp.symbols("u")
    B = periodic_bernoulli_polynomial(2 * k + 1, u)
    return sp.integrate(sp.expand(B * derivative.subs(sp.Symbol("x"), n + u)), (u, 0, 1))


def em_identity_polynomial(
    coefficients: list[sp.Rational] | tuple[sp.Rational, ...],
    M: int,
    N: int,
    K: int,
) -> sp.Expr:
    """Return ``LHS - RHS`` for the finite Euler–Maclaurin identity.

    ``f(x) = Σ coefficients[i] x^i`` on the integer interval ``[M, N]``.
    The right-hand side is

    ``∫_M^N f + (f(M)+f(N))/2
       + Σ_{j=1}^K B_{2j}/(2j)! (f^{(2j-1)}(N)-f^{(2j-1)}(M))
       + (1/(2K+1)!) ∫_M^N B̃_{2K+1}(x) f^{(2K+1)}(x) dx``.

    For a polynomial and ``K`` large enough the remainder vanishes; for small
    ``K`` it is evaluated exactly unit interval by unit interval.  The result
    is zero when the identity holds.
    """
    if N < M:
        raise ValueError("N must be at least M")
    if K < 0:
        raise ValueError("K must be non-negative")
    x = sp.symbols("x")
    f = sum(sp.Rational(c) * x**i for i, c in enumerate(coefficients))
    lhs = sum(f.subs(x, k) for k in range(M, N + 1))
    rhs = sp.integrate(f, (x, M, N))
    rhs += (f.subs(x, M) + f.subs(x, N)) / 2
    for j in range(1, K + 1):
        deriv = sp.diff(f, x, 2 * j - 1)
        rhs += (
            bernoulli_exact(2 * j)
            / sp.factorial(2 * j)
            * (deriv.subs(x, N) - deriv.subs(x, M))
        )
    deriv = sp.diff(f, x, 2 * K + 1)
    remainder = sum(_unit_integral(deriv, n, K) for n in range(M, N))
    rhs += remainder / sp.factorial(2 * K + 1)
    return sp.simplify(lhs - rhs)


def tail_radius(
    s_re: float,
    s_im: float,
    a: float,
    M: int,
    K: int,
    dps: int = 40,
) -> mp.mpf:
    """The explicit S2 tail radius

    ``|(s)_{2K+1}| · 2ζ(2K+1)/(2π)^(2K+1) · (a+M)^(-σ-2K)/(σ+2K)``.

    This is a floating-point *illustration* of the shape of the Lean bound, not
    a certified enclosure.  The Lean theorem bounds the norm of the remainder;
    the Python function evaluates the same expression at ``mp`` precision.
    """
    if a <= 0:
        raise ValueError("a must be positive")
    if M < 1:
        raise ValueError("M must be at least 1")
    if K < 1:
        raise ValueError("K must be at least 1 (the Lean S1/S2 theorem assumes K ≥ 1)")
    if s_re <= 0:
        raise ValueError("the tail shape requires σ > 0")
    mp.mp.dps = dps
    s = mp.mpc(s_re, s_im)
    rising = mp.mpf(1)
    for n in range(2 * K + 1):
        rising *= abs(s + n)
    zeta = mp.zeta(2 * K + 1)
    pi = mp.pi
    return (
        rising
        * (2 * zeta / (2 * pi) ** (2 * K + 1))
        * ((a + M) ** (-s_re - 2 * K) / (s_re + 2 * K))
    )
