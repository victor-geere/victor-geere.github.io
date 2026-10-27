"""Nested spheres and the continuous cone — exact computation layer.

The archived notes in ``maths/`` define a mean-zero filter, nest polygonal
paths on Hopf fibres whose radii scale by ``N⁻¹``, and replace the integer
scale by a continuous radius ``R``.  The audit in ``summary/13-working-notes``
accepts the filter identity, the nested-fibre geometry and the sampling
estimate, but rejects the local quadratic form with constant ``1/2`` and the
resulting RH conclusion.

This module implements the surviving exact core with sympy:

* nested fibre radii and the mean-zero coefficient filter;
* the purification factor ``1 - N^{1-s}``;
* the regular ``N``-gon chord and arc lengths;
* the corrected continuous-cone local diagonal ``-∫φ + R∫φ²``.

Everything is exact; no floating-point decision is used except in the
sampling test, where the sign of ``sin x - x`` is checked at finite
precision with a stated tolerance.
"""

from __future__ import annotations

from typing import Callable

import sympy as sp

PI = sp.pi

Phi = Callable[[sp.Expr], sp.Expr]


def _check_scale(N: int) -> None:
    if not isinstance(N, int) or N < 1:
        raise ValueError("N must be a positive integer")


def fibre_radius(N: int) -> sp.Rational:
    """Radius of the ``N``-th nested fibre: ``1 / N``."""
    _check_scale(N)
    return sp.Rational(1, N)


def fibre_radii(N_max: int) -> list[sp.Rational]:
    """The nested radii ``r_1, …, r_{N_max}``, in nesting order."""
    _check_scale(N_max)
    return [fibre_radius(N) for N in range(1, N_max + 1)]


def mean_zero_coeff(N: int, m: int) -> sp.Integer:
    """The mean-zero coefficient ``c_m(N) = 1 - N`` if ``N ∣ m``, else ``1``."""
    _check_scale(N)
    if not isinstance(m, int) or m < 1:
        raise ValueError("m must be a positive integer")
    return sp.Integer(1 - N) if m % N == 0 else sp.Integer(1)


def period_coeff_sum(N: int) -> sp.Integer:
    """Exact sum ``∑_{m=1}^{N} c_m(N)``; this is the mean-zero identity."""
    _check_scale(N)
    return sp.Integer(sum(mean_zero_coeff(N, m) for m in range(1, N + 1)))


def purification_factor(N: int, s: sp.Expr) -> sp.Expr:
    """The exact factor ``1 - N^{1-s}`` multiplying ``ζ(s)``."""
    _check_scale(N)
    return sp.simplify(1 - sp.Integer(N) ** (1 - s))


def sampling_chord(N: int) -> sp.Expr:
    """Chord length of one edge of the regular ``N``-gon on the unit circle."""
    _check_scale(N)
    return 2 * sp.sin(PI / N)


def sampling_arc(N: int) -> sp.Expr:
    """Arc length subtended by one edge: ``2π / N``."""
    _check_scale(N)
    return 2 * PI / N


def sampling_ratio(N: int) -> sp.Expr:
    """Chord-to-arc ratio ``sin(π/N) / (π/N)``, which tends to ``1``."""
    _check_scale(N)
    return sp.simplify(sp.sin(PI / N) / (PI / N))


def phi_mean(phi: Phi) -> sp.Expr:
    """The normalisation ``∫_{-1}^{1} φ(u) du``."""
    u = sp.symbols("u", real=True)
    return sp.integrate(phi(u), (u, -1, 1))


def phi_energy(phi: Phi) -> sp.Expr:
    """The energy ``∫_{-1}^{1} φ(u)^2 du``."""
    u = sp.symbols("u", real=True)
    return sp.integrate(phi(u) ** 2, (u, -1, 1))


def local_diagonal(R: sp.Expr, mean: sp.Expr, energy: sp.Expr) -> sp.Expr:
    """Corrected local diagonal ``-∫φ + R ∫φ²``, written from its moments."""
    return -mean + R * energy


def local_diagonal_integral(phi: Phi, R: sp.Expr) -> sp.Expr:
    """Evaluate ``∫_{-1}^{1} (1 - R φ(u)) (-φ(u)) du`` exactly.

    This is the integral that the continuous-cone note replaced by ``-1/2``.
    The exact value is ``-∫φ + R ∫φ²``.
    """
    u = sp.symbols("u", real=True)
    integrand = sp.expand((1 - R * phi(u)) * (-phi(u)))
    return sp.integrate(integrand, (u, -1, 1))
