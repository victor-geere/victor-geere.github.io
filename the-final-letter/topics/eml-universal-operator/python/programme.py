"""EML universal operator — exact computation layer.

The archived source defines the binary operator

    eml(x, y) = exp(x) - log(y),      y > 0,

and states the three base identities

    exp(z) = eml(z, 1),
    log(z) = eml(1, eml(eml(1, z), 1)),
    sqrt(u) = eml(log(u) / 2, 1).

The module checks those identities with sympy.  It also implements the
source's one-step harmonic fusion rule and the greedy harmonic sine
reconstruction, so that the dossier can record exactly where the source's
recurrence departs from the sine-addition identity.
"""

from __future__ import annotations

import math

import sympy as sp

PI = sp.pi


def _check_second_argument(y: sp.Expr) -> None:
    """Raise when a numeric second argument is outside the domain ``y > 0``."""
    if y.is_real is False:
        raise ValueError("eml requires a real second argument y > 0")
    if y.is_number and sp.N(y) <= 0:
        raise ValueError("eml requires y > 0")


def eml(x: sp.Expr, y: sp.Expr) -> sp.Expr:
    """The source operator ``eml(x, y) = exp(x) - log(y)``."""
    x = sp.sympify(x)
    y = sp.sympify(y)
    _check_second_argument(y)
    return sp.exp(x) - sp.log(y)


def exp_via_eml(z: sp.Expr) -> sp.Expr:
    """Source identity: ``exp(z) = eml(z, 1)``."""
    return eml(z, 1)


def log_via_eml(z: sp.Expr) -> sp.Expr:
    """Source identity: the three-gate expression for ``log(z)``."""
    return eml(1, eml(eml(1, z), 1))


def sqrt_via_eml(u: sp.Expr) -> sp.Expr:
    """Source identity: ``sqrt(u) = eml(log(u) / 2, 1)``."""
    return eml(sp.log(u) / 2, 1)


def source_fusion_step(s: sp.Expr, h: sp.Expr, delta: int) -> sp.Expr:
    """The fusion rule exactly as printed in the source.

    ``s_{n+1} = s_n sqrt(1-h_n^2)
       + delta_n (h_n sqrt(1-s_n^2) + s_n sqrt(1-h_n^2))``

    The base term is present even when ``delta_n = 0``, which is one of the
    reasons the printed recurrence does not preserve a sine value.
    """
    if delta not in (0, 1):
        raise ValueError("delta must be 0 or 1")
    return s * sp.sqrt(1 - h**2) + delta * (
        h * sp.sqrt(1 - s**2) + s * sp.sqrt(1 - h**2)
    )


def source_python_step(s: float, h: float, delta: int) -> float:
    """The update used by the source's Python listing.

    The listing does ``s += h sqrt(1-s^2) + s sqrt(1-h^2)`` on a selection
    and leaves ``s`` unchanged otherwise.  This is different from the
    printed recurrence above; both readings are recorded for comparison.
    """
    if delta not in (0, 1):
        raise ValueError("delta must be 0 or 1")
    if not delta:
        return s
    return s + h * math.sqrt(max(0.0, 1.0 - s * s)) + s * math.sqrt(
        max(0.0, 1.0 - h * h)
    )


def _greedy_angles(theta: float, n_max: int):
    """Yield ``(alpha_n, delta_n)`` for the greedy harmonic selector."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    accumulated = 0.0
    for n in range(n_max + 1):
        alpha = math.pi / (n + 2)
        delta = 1 if theta - accumulated >= alpha else 0
        yield alpha, delta
        if delta:
            accumulated += alpha


def source_harmonic_sine(theta: float, n_max: int = 1000) -> float:
    """The source's printed recurrence, evaluated in floating point."""
    s = 0.0
    for alpha, delta in _greedy_angles(theta, n_max):
        h = math.sin(alpha)
        s = s * math.sqrt(max(0.0, 1.0 - h * h)) + delta * (
            h * math.sqrt(max(0.0, 1.0 - s * s))
            + s * math.sqrt(max(0.0, 1.0 - h * h))
        )
    return s


def source_python_sine(theta: float, n_max: int = 1000) -> float:
    """The source's Python listing, evaluated in floating point."""
    s = 0.0
    for alpha, delta in _greedy_angles(theta, n_max):
        s = source_python_step(s, math.sin(alpha), delta)
    return s


def harmonic_sine(theta: float, n_max: int = 1000) -> float:
    """Corrected greedy harmonic reconstruction of ``sin(theta)``.

    The corrected step is ordinary sine addition,

        sin(A + alpha) = sin(A) cos(alpha) + cos(A) sin(alpha),

    applied only when the greedy selector takes ``alpha``.  It keeps the
    accumulated angle, so it is valid on the whole interval ``[0, pi]``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    s = 0.0
    accumulated = 0.0
    for n in range(n_max + 1):
        alpha = math.pi / (n + 2)
        if theta - accumulated >= alpha:
            s = s * math.cos(alpha) + math.sin(alpha) * math.cos(accumulated)
            accumulated += alpha
    return s


def selection_count(theta: float, n_max: int = 1000) -> int:
    """Number of selected angles among ``n = 0, ..., n_max``."""
    return sum(delta for _, delta in _greedy_angles(theta, n_max))
