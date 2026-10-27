"""Harmonic sine — exact computation layer.

The archived source proposes a greedy reconstruction of ``sin(pi*x)``
from harmonic angle steps ``eps_n = pi/(n+2)``, fused with the
angle-addition (Pythagorean rotation) rule.  This module implements the
finite, exact part of that construction:

* the harmonic angle and the source's half-angle expression for ``h_n``;
* the rotation step, checked symbolically against the angle-addition
  formula;
* the greedy selection word on ``[0, 1]``, computed in exact rational
  multiples of ``pi`` (so comparisons never round);
* the source's residual invariant ``0 <= r_n <= pi/(n+1)``; and
* a high-precision reconstruction using mpmath.

The source's Riemann-hypothesis claims are not implemented and are not
verified here.
"""

from __future__ import annotations

from typing import Sequence

import mpmath as mp
import sympy as sp

PI = sp.pi

__all__ = [
    "PI",
    "harmonic_angle",
    "half_angle_sine",
    "step_sine",
    "rotation_step",
    "greedy_word",
    "greedy_residuals",
    "residual_bound_holds",
    "reconstruct_sine",
]


def harmonic_angle(n: int) -> sp.Expr:
    """The harmonic angle ``eps_n = pi / (n + 2)``."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return PI / (n + 2)


def half_angle_sine(n: int) -> sp.Expr:
    """The source's stated ``h_n = sqrt((1 - cos(pi/(n+2))) / 2)``.

    This is the half-angle expression.  It simplifies to
    ``sin(pi / (2 (n+2)))``, not to ``sin(pi/(n+2))``; see
    :func:`step_sine` and the errata entry in the README.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.sqrt((1 - sp.cos(harmonic_angle(n))) / 2)


def step_sine(n: int) -> sp.Expr:
    """The sine actually required by the rotation: ``sin(pi/(n+2))``."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.sin(harmonic_angle(n))


def rotation_step(
    s: sp.Expr, c: sp.Expr, eps: sp.Expr
) -> tuple[sp.Expr, sp.Expr]:
    """Rotate ``(s, c) = (sin θ, cos θ)`` by the angle ``eps``."""
    return (
        s * sp.cos(eps) + c * sp.sin(eps),
        c * sp.cos(eps) - s * sp.sin(eps),
    )


def greedy_word(y: sp.Expr, n_max: int) -> list[int]:
    """Greedy selection word for the target angle ``pi * y``.

    ``y`` is measured in units of ``pi`` and must be a non-negative exact
    rational.  Working in those units makes every comparison exact: the
    residual is a rational number and the step is ``1/(n+2)``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    target = sp.Rational(y)
    if target < 0:
        raise ValueError("y must be non-negative")
    residual = target
    word: list[int] = []
    for n in range(n_max + 1):
        step = sp.Rational(1, n + 2)
        take = bool(step <= residual)
        word.append(1 if take else 0)
        if take:
            residual -= step
    return word


def greedy_residuals(y: sp.Expr, n_max: int) -> list[sp.Rational]:
    """Residuals ``r_n = pi*y - theta_n`` in units of ``pi``, for n = 0..n_max."""
    target = sp.Rational(y)
    residual = target
    out: list[sp.Rational] = [residual]
    for n in range(n_max + 1):
        step = sp.Rational(1, n + 2)
        if step <= residual:
            residual -= step
        out.append(residual)
    return out


def residual_bound_holds(y: sp.Expr, n_max: int) -> bool:
    """Check the source's invariant ``0 <= r_n <= pi/(n+1)`` for ``n >= 1``."""
    rs = greedy_residuals(y, n_max)
    for n in range(1, n_max + 2):
        if not (0 <= rs[n] <= sp.Rational(1, n + 1)):
            return False
    return True


def reconstruct_sine(y: sp.Expr, n_max: int, dps: int = 50) -> mp.mpf:
    """Reconstruct ``sin(pi*y)`` by greedy rotation at ``dps`` decimal digits.

    Only the rotation update is used: no trigonometric identity for the
    target is consulted beyond ``sin``/``cos`` of the individual steps.
    """
    mp.mp.dps = dps
    word = greedy_word(y, n_max)
    s = mp.mpf(0)
    c = mp.mpf(1)
    for n, delta in enumerate(word):
        if delta:
            eps = mp.pi / (n + 2)
            s, c = (
                s * mp.cos(eps) + c * mp.sin(eps),
                c * mp.cos(eps) - s * mp.sin(eps),
            )
    return +s
