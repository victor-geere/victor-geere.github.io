"""Quaternion–cosine framework — exact computation layer.

The archived essay proposes a quaternion-valued cosine phase

    φ(x) = cos(2πx) i + cos(2π p/x) j

as a divisor detector, together with an alignment energy

    E(x) = (1 - cos(2πx))² + (1 - cos(2π p/x))².

This module implements those objects with sympy.  Everything is exact:
trigonometric values at integer multiples of π are reduced by sympy, and
the divisor test uses integer predicates rather than floating point.  The
module has no import-time side effects.
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi

Quaternion = tuple[sp.Expr, sp.Expr, sp.Expr, sp.Expr]


def _check_positive(name: str, value) -> sp.Expr:
    """Return ``value`` as a sympy expression, requiring positivity."""
    expr = sp.sympify(value)
    if expr.is_positive is False or expr.is_nonpositive is True:
        raise ValueError(f"{name} must be positive")
    return expr


def quaternion_mul(q: Quaternion, r: Quaternion) -> Quaternion:
    """Hamilton product of two quaternions ``(a, b, c, d)``.

    The tuple represents ``a + b i + c j + d k``.  The multiplication is
    the one used by the source: ``i² = j² = k² = -1`` and ``ij = -ji = k``.
    """
    a1, b1, c1, d1 = q
    a2, b2, c2, d2 = r
    return (
        a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
        a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
        a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
        a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2,
    )


def quaternion_norm_sq(q: Quaternion) -> sp.Expr:
    """Squared norm ``a² + b² + c² + d²`` of a quaternion."""
    return sp.expand(sum(component**2 for component in q))


def phase(x, p) -> Quaternion:
    """The lifted phase ``cos(2πx) i + cos(2π p/x) j``.

    The real and ``k`` components are zero, so the quaternion norm is the
    squared distance of the two cosine coordinates from the origin.
    """
    x = _check_positive("x", x)
    p = _check_positive("p", p)
    return (
        sp.Integer(0),
        sp.cos(2 * PI * x),
        sp.cos(2 * PI * p / x),
        sp.Integer(0),
    )


def detector(x, p) -> sp.Expr:
    """The scalar cosine divisor detector ``cos(2π p/x) + cos(2π x) - 2``.

    It equals zero exactly when both ``x`` and ``p/x`` are integers, which
    for integer ``p`` means that ``x`` is a positive divisor of ``p``.
    """
    x = _check_positive("x", x)
    p = _check_positive("p", p)
    return sp.cos(2 * PI * p / x) + sp.cos(2 * PI * x) - 2


def alignment_energy(x, p) -> sp.Expr:
    """The source's alignment energy ``(1 - c₁)² + (1 - c₂)²``."""
    _, c1, c2, _ = phase(x, p)
    return sp.expand((1 - c1) ** 2 + (1 - c2) ** 2)


def displacement_quaternion(x, p) -> Quaternion:
    """The quaternion from ``(1, 1)`` to the cosine phase, lifted to ``ℍ``.

    Its squared norm equals :func:`alignment_energy`; this is the exact
    quaternion form of the energy functional in the source.
    """
    _, c1, c2, _ = phase(x, p)
    return (sp.Integer(0), 1 - c1, 1 - c2, sp.Integer(0))


def is_divisor(p: int, x) -> bool:
    """Exact test whether positive ``x`` divides positive integer ``p``."""
    if not isinstance(p, (int, sp.Integer)) or int(p) <= 0:
        raise ValueError("p must be a positive integer")
    x = _check_positive("x", x)
    return bool(x.is_integer and (sp.Integer(p) / x).is_integer)


def divisors_exact(p: int) -> list[int]:
    """Positive divisors of ``p``, returned by sympy's exact divisor list."""
    if not isinstance(p, (int, sp.Integer)) or int(p) <= 0:
        raise ValueError("p must be a positive integer")
    return [int(d) for d in sp.divisors(int(p))]


def detector_on_divisors(p: int) -> list[sp.Expr]:
    """The detector evaluated exactly at every divisor of ``p``."""
    return [sp.simplify(detector(d, p)) for d in divisors_exact(p)]


def warp_factor(sigma) -> sp.Expr:
    """The functional-equation warping factor ``2σ - 1``.

    The source's prose uses ``t' ~ t / (2σ - 1)`` while its sample Python
    code uses ``t / abs(σ - 1/2)``.  This function records the prose factor
    exactly; the discrepancy is discussed in the programme dossier.
    """
    return sp.sympify(2 * sigma - 1)


def warped_height(t, sigma) -> sp.Expr:
    """The warped height ``t / (2σ - 1)``.

    The critical line ``σ = 1/2`` is a pole of this formal expression, so
    it raises ``ValueError`` there rather than silently substituting a
    finite value.
    """
    factor = warp_factor(sigma)
    if sp.simplify(factor) == 0:
        raise ValueError("warped_height is undefined on the critical line")
    return sp.sympify(t) / factor


def is_aligned(x, p, tol: float | None = None) -> bool:
    """Whether the cosine phase is exactly aligned with ``i + j``.

    With ``tol=None`` the decision is exact; a numeric tolerance may be
    supplied for illustrative floating-point checks only.
    """
    if tol is None:
        return bool(sp.simplify(detector(x, p)) == 0)
    return bool(abs(complex(sp.N(detector(x, p), 30))) <= tol)
