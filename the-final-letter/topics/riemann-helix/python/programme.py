"""Riemann helix — exact computation layer.

The archived source constructs the constant-radius helix

    C(t) = (R cos t, R sin t, c t)

and the varying-radius helix ``(r(t) cos φ(t), r(t) sin φ(t), t)``.
This module implements the exact Frenet invariants of the constant-radius
family, the closed forms

    κ(R, c) = R / (R² + c²),      τ(R, c) = c / (R² + c²),

and the algebraic relations the programme uses.  Everything is symbolic
(sympy), so the tests check identities exactly rather than numerically.

The source's displayed torsion formula for the unit-radius helix with
phase ``φ`` is also implemented, so that it can be compared exactly with
the direct Frenet computation.  It does not agree; see
``source_torsion_formula``.
"""

from __future__ import annotations

import sympy as sp

t = sp.symbols("t", real=True)


def helix(radius: sp.Expr, pitch: sp.Expr, parameter: sp.Expr = t) -> sp.Matrix:
    """The point ``(R cos t, R sin t, c t)`` of the circular helix."""
    return sp.Matrix(
        [
            sp.sympify(radius) * sp.cos(parameter),
            sp.sympify(radius) * sp.sin(parameter),
            sp.sympify(pitch) * parameter,
        ]
    )


def _derivatives(curve: sp.Matrix, parameter: sp.Expr) -> tuple[sp.Matrix, ...]:
    """First three derivatives of a parametrised space curve."""
    return tuple(sp.diff(curve, parameter, order) for order in (1, 2, 3))


def frenet_curvature(curve: sp.Matrix, parameter: sp.Expr = t) -> sp.Expr:
    """Frenet curvature ``κ = |C' × C''| / |C'|³``.

    Returns ``nan`` for a degenerate parametrisation (for example a
    straight line, where the Frenet frame is undefined).
    """
    d1, d2, _ = _derivatives(curve, parameter)
    cross = d1.cross(d2)
    return sp.simplify(cross.norm() / d1.norm() ** 3)


def frenet_torsion(curve: sp.Matrix, parameter: sp.Expr = t) -> sp.Expr:
    """Frenet torsion ``τ = (C' × C'') · C''' / |C' × C''|²``.

    Returns ``nan`` for a degenerate parametrisation (zero curvature).
    """
    d1, d2, d3 = _derivatives(curve, parameter)
    cross = d1.cross(d2)
    return sp.simplify(cross.dot(d3) / cross.dot(cross))


def helix_curvature(radius: sp.Expr, pitch: sp.Expr) -> sp.Expr:
    """Closed form ``κ = R / (R² + c²)`` for the circular helix."""
    R, c = sp.sympify(radius), sp.sympify(pitch)
    return R / (R**2 + c**2)


def helix_torsion(radius: sp.Expr, pitch: sp.Expr) -> sp.Expr:
    """Closed form ``τ = c / (R² + c²)`` for the circular helix.

    The formula requires a non-degenerate helix (``R > 0``, and not both
    ``R`` and ``c`` zero).  It is *not* the Frenet torsion at ``R = 0``:
    there the curve is a straight line and torsion is undefined.
    """
    R, c = sp.sympify(radius), sp.sympify(pitch)
    return c / (R**2 + c**2)


def source_torsion_formula(
    phi1: sp.Expr, phi2: sp.Expr, phi3: sp.Expr
) -> sp.Expr:
    """The torsion formula displayed in the archived source paper.

    With ``phi1 = φ'``, ``phi2 = φ''`` and ``phi3 = φ'''`` the source
    states

        τ = φ' (φ'⁴ − φ' φ''' + 3 φ''²)
            / ((φ'² + 1)(φ'⁴ + φ''² + φ'⁶)).

    A direct Frenet computation gives the denominator
    ``φ'⁶ + φ'⁴ + φ''²`` instead.  The function is kept so that the
    discrepancy can be checked exactly in the tests.
    """
    p1, p2, p3 = sp.sympify(phi1), sp.sympify(phi2), sp.sympify(phi3)
    return p1 * (p1**4 - p1 * p3 + 3 * p2**2) / (
        (p1**2 + 1) * (p1**4 + p2**2 + p1**6)
    )


def torsion_scale_law(
    scale: sp.Expr, radius: sp.Expr, pitch: sp.Expr
) -> sp.Expr:
    """Exact difference ``τ(λR, λc) − τ(R, c)/λ`` (zero identically)."""
    lam = sp.sympify(scale)
    return sp.simplify(
        helix_torsion(lam * radius, lam * pitch) - helix_torsion(radius, pitch) / lam
    )


def curvature_torsion_inversion(
    radius: sp.Expr, pitch: sp.Expr
) -> tuple[sp.Expr, sp.Expr, sp.Expr]:
    """Exact algebraic criterion for the circular helix.

    Returns ``(κ² + τ², κ/(κ² + τ²), τ/(κ² + τ²))``, which equals
    ``(1/(R² + c²), R, c)`` whenever ``R² + c² ≠ 0``.
    """
    R, c = sp.sympify(radius), sp.sympify(pitch)
    kappa = helix_curvature(R, c)
    tau = helix_torsion(R, c)
    s = sp.simplify(kappa**2 + tau**2)
    return (
        s,
        sp.simplify(kappa / s),
        sp.simplify(tau / s),
    )


def amgm_slack(radius: sp.Expr, pitch: sp.Expr) -> sp.Expr:
    """Exact slack ``1/(2R) − τ`` in the AM–GM bound.

    The identity ``1/(2R) − c/(R² + c²) = (R − c)² / (2R(R² + c²))``
    shows ``τ ≤ 1/(2R)`` for ``R, c > 0``.
    """
    R, c = sp.sympify(radius), sp.sympify(pitch)
    return sp.simplify(1 / (2 * R) - helix_torsion(R, c))


def amgm_bound_holds(radius: sp.Expr, pitch: sp.Expr) -> bool:
    """Return whether the exact slack is non-negative.

    Raises ``ValueError`` if either parameter is not positive: the bound
    is stated for non-degenerate helices only.
    """
    R, c = sp.sympify(radius), sp.sympify(pitch)
    if not (R.is_positive and c.is_positive):
        raise ValueError("the AM-GM bound requires R > 0 and c > 0")
    return bool(amgm_slack(R, c).is_nonnegative)
