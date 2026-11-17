"""Computation layer for the zeta functional equation / ζ′/ζ continuation.

* ``completed_zeta`` — ``Λ(s) = π^{−s/2} Γ(s/2) ζ(s)``;
* ``functional_equation_residual`` — ``|Λ(1 − s) − Λ(s)|``;
* ``log_deriv_zeta`` — ``ζ′(s)/ζ(s)``;
* ``critical_line_zero`` — the ``n``-th zero ``1/2 + iγ_n`` (imaginary part);
* ``trivial_zero_value`` — ``ζ(−2n)``.

Numerical work uses ``mpmath``; no side effects on import.
"""

from __future__ import annotations

import mpmath


def completed_zeta(s: complex) -> complex:
    """``Λ(s) = π^{−s/2} Γ(s/2) ζ(s)``."""
    z = mpmath.mpc(s)
    return mpmath.power(mpmath.pi, -z / 2) * mpmath.gamma(z / 2) * mpmath.zeta(z)


def functional_equation_residual(s: complex) -> float:
    """``|Λ(1 − s) − Λ(s)|`` — zero if the functional equation holds."""
    return float(abs(completed_zeta(1 - s) - completed_zeta(s)))


def log_deriv_zeta(s: complex) -> complex:
    """``ζ′(s)/ζ(s)``."""
    z = mpmath.mpc(s)
    return mpmath.zeta(z, derivative=1) / mpmath.zeta(z)


def critical_line_zero(n: int) -> float:
    """The imaginary part of the ``n``-th nontrivial zero (``n`` from 1)."""
    if n < 1:
        raise ValueError("n must be at least 1")
    return float(mpmath.im(mpmath.zetazero(n)))


def trivial_zero_value(n: int) -> complex:
    """``ζ(−2n)``, numerically."""
    return mpmath.zeta(-2 * n)
