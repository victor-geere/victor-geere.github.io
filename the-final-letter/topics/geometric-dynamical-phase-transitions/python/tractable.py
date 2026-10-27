"""Tractable O3/O4 checks."""

from __future__ import annotations

import sympy as sp

BOURGAIN_THRESHOLD = sp.Rational(13, 194)


def bourgain_exponent(eps: sp.Expr) -> sp.Expr:
    """The exponent `(1/2 - eps) * 13/84` from Corollary F.9."""
    e = sp.sympify(eps)
    return (sp.Rational(1, 2) - e) * sp.Rational(13, 84)


def bourgain_threshold_holds(eps: sp.Expr) -> bool:
    """Whether the Bourgain exponent is below `eps`."""
    e = sp.sympify(eps)
    return bool(sp.simplify(bourgain_exponent(e) - e) < 0)


def threshold_equivalence(eps: sp.Expr) -> bool:
    """Check `(1/2-eps)*13/84 < eps` iff `13/194 < eps` exactly."""
    e = sp.sympify(eps)
    return bourgain_threshold_holds(e) == bool(BOURGAIN_THRESHOLD < e)
