"""Harmonic Sine Transform programme — finite exact computation layer.

The HST landing page is a duplicate programme hub; its mathematical seed is the
greedy harmonic expansion of a normalised angle ``x = θ/π`` with respect to the
harmonic fractions ``1/(n+2)``.  This module implements the *finite* part of
that recursion exactly with sympy:

* the greedy binary digits and residual;
* the exact finite identity ``x = Σ_{k<n} δ_k/(k+2) + r_n``;
* terminating expansions (including the endpoint ``x = 1``);
* the sine reconstruction ``sin(π · Σ δ_k/(k+2))`` for terminating angles;
* the alternative floor recursion printed in the archived research guide,
  which is *not* binary and is recorded here to document the discrepancy.

No floating point is used.  ``mpmath`` is not required.
"""

from __future__ import annotations

from typing import NamedTuple

import sympy as sp

PI = sp.pi


class Expansion(NamedTuple):
    """A finite greedy expansion.

    ``digits`` is the selected word, ``value`` the exact partial sum and
    ``residual`` the exact remainder ``x - value``.  ``terminated`` is true
    when the residual reached zero inside ``max_terms``.
    """

    digits: tuple[int, ...]
    value: sp.Expr
    residual: sp.Expr
    terminated: bool


def harmonic_fraction(n: int) -> sp.Rational:
    """The normalised harmonic fraction ``d n = 1/(n+2)``."""
    if not isinstance(n, int):
        raise TypeError("n must be an int")
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.Rational(1, n + 2)


def _normalised(x) -> sp.Rational:
    """Convert an exact input to a rational in ``[0, 1]``."""
    if isinstance(x, float):
        raise TypeError("floating-point input is not exact; pass a Rational")
    q = sp.Rational(x)
    if not q.is_Rational:
        raise TypeError("x must be an exact rational in [0, 1]")
    if q < 0 or q > 1:
        raise ValueError("x must lie in [0, 1]")
    return q


def greedy_digits(x, n_terms: int) -> list[int]:
    """The first ``n_terms`` greedy binary digits of ``x``.

    Digit ``n`` is ``1`` exactly when ``1/(n+2)`` fits in the current
    residual.  This is the rule of Programme I and of the landing page.
    """
    if not isinstance(n_terms, int):
        raise TypeError("n_terms must be an int")
    if n_terms < 0:
        raise ValueError("n_terms must be non-negative")
    q = _normalised(x)
    residual = q
    digits: list[int] = []
    for n in range(n_terms):
        d = harmonic_fraction(n)
        if d <= residual:
            digits.append(1)
            residual -= d
        else:
            digits.append(0)
    return digits


def residual(x, n_terms: int) -> sp.Expr:
    """The exact residual ``x - Σ_{k<n} δ_k/(k+2)``."""
    q = _normalised(x)
    return sp.simplify(q - partial_sum(x, n_terms))


def partial_sum(x, n_terms: int) -> sp.Expr:
    """The exact finite greedy partial sum ``Σ_{k<n} δ_k/(k+2)``."""
    total = sp.Integer(0)
    for k, digit in enumerate(greedy_digits(x, n_terms)):
        if digit:
            total += harmonic_fraction(k)
    return sp.simplify(total)


def expansion(x, max_terms: int = 512) -> Expansion:
    """Run the greedy recursion until the residual vanishes or ``max_terms``.

    The residual is exact, so termination is decided exactly.  For example
    ``x = 1`` terminates only after the five digits ``1, 1, 0, 0, 1``
    (``1 = 1/2 + 1/3 + 1/6``).
    """
    if max_terms < 0:
        raise ValueError("max_terms must be non-negative")
    q = _normalised(x)
    residual_value = q
    digits: list[int] = []
    while residual_value != 0 and len(digits) < max_terms:
        n = len(digits)
        d = harmonic_fraction(n)
        if d <= residual_value:
            digits.append(1)
            residual_value -= d
        else:
            digits.append(0)
    total = sum((harmonic_fraction(k) for k, digit in enumerate(digits) if digit),
                sp.Integer(0))
    return Expansion(tuple(digits), sp.simplify(total), sp.simplify(residual_value),
                     residual_value == 0)


def sine_reconstruction(x, n_terms: int) -> sp.Expr:
    """``sin(π · s_n)`` for the greedy partial sum ``s_n`` of ``x``.

    When the expansion terminates exactly, this is ``sin(π x)``; the
    function is used to check the sine-reconstruction examples exactly.
    """
    return sp.sin(PI * partial_sum(x, n_terms))


def guide_floor_digits(x, n_terms: int) -> list[int]:
    """The *other* recursion printed in the archived research guide.

    The guide defines ``r₀ = x``, ``δₙ = ⌊(n+2) rₙ⌋`` and
    ``rₙ₊₁ = (n+2) rₙ − δₙ`` while calling ``δₙ`` binary.  This recursion
    can return digits greater than one; it is included so the discrepancy
    with Programme I is testable rather than silently smoothed over.
    """
    if n_terms < 0:
        raise ValueError("n_terms must be non-negative")
    residual_value = _normalised(x)
    digits: list[int] = []
    for n in range(n_terms):
        scaled = (n + 2) * residual_value
        digit = int(sp.floor(scaled))
        digits.append(digit)
        residual_value = scaled - digit
    return digits
