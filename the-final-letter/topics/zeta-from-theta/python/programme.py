"""Computation layer for the theta-first development of ``ζ``.

The point of these routines is to exhibit, numerically and independently of the
Hurwitz-zeta route, that

* the Dirichlet series reproduces ``ζ`` on ``Re s > 1``;
* the *theta-side* completed function

  ``Λ_θ(s) = ∫_1^∞ ψ(t)(t^{s/2−1} + t^{(1−s)/2−1}) dt + 1/(s−1) − 1/s``,
  ``ψ(t) = (θ(t) − 1)/2 = Σ_{n≥1} e^{−π n² t}``,

  agrees with ``Λ(s) = π^{−s/2} Γ(s/2) ζ(s)`` on ``Re s > 1``, and is invariant
  under ``s ↦ 1 − s`` — the functional equation, seen from the theta side.

Numerical work uses ``mpmath``; no side effects on import.
"""

from __future__ import annotations

import mpmath


def dirichlet_zeta(s: complex, n_max: int = 20000) -> complex:
    """Partial sum ``Σ_{n=1}^{n_max} n^{−s}`` of the Dirichlet series."""
    z = mpmath.mpc(s)
    return mpmath.fsum(mpmath.power(n, -z) for n in range(1, n_max + 1))


def gamma_R(s: complex) -> complex:
    """``Γℝ(s) = π^{−s/2} Γ(s/2)``."""
    z = mpmath.mpc(s)
    return mpmath.power(mpmath.pi, -z / 2) * mpmath.gamma(z / 2)


def completed_zeta(s: complex) -> complex:
    """``Λ(s) = π^{−s/2} Γ(s/2) ζ(s)``."""
    return gamma_R(s) * mpmath.zeta(mpmath.mpc(s))


def theta_kernel(t: float, n_max: int = 24) -> float:
    """``ψ(t) = (θ(t) − 1)/2 = Σ_{n≥1} e^{−π n² t}`` (fast for ``t ≥ 1``)."""
    return float(mpmath.fsum(mpmath.exp(-mpmath.pi * n * n * t) for n in range(1, n_max + 1)))


def completed_zeta_theta(s: complex) -> complex:
    """The theta-side ``Λ_θ`` from the split representation.

    ``Λ_θ(s) = ∫_1^∞ ψ(t)(t^{s/2−1} + t^{(1−s)/2−1}) dt + 1/(s−1) − 1/s``,
    valid for ``Re s > 1`` (and, by the symmetry, on a larger domain).
    """
    z = mpmath.mpc(s)
    a = z / 2 - 1
    b = (1 - z) / 2 - 1

    def integrand(t: float) -> complex:
        psi = theta_kernel(t)
        return psi * (mpmath.power(t, a) + mpmath.power(t, b))

    integral = mpmath.quad(integrand, [1, mpmath.inf])
    return integral + 1 / (z - 1) - 1 / z


def functional_equation_residual_theta(s: complex) -> float:
    """``|Λ_θ(1 − s) − Λ_θ(s)|`` — zero if the theta-side symmetry holds."""
    return float(abs(completed_zeta_theta(1 - s) - completed_zeta_theta(s)))


def bridge_residual(s: complex, n_max: int = 20000) -> float:
    """``|Σ_{n≤N} n^{−s} − ζ(s)|`` for ``Re s > 1``."""
    return float(abs(dirichlet_zeta(s, n_max) - mpmath.zeta(mpmath.mpc(s))))
