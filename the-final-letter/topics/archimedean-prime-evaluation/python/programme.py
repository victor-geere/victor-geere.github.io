"""Computation layer for the archimedean/prime evaluation programme.

The module records, at high precision, the quantities of the two evaluation
inputs:

* ``omega`` — the archimedean kernel ``Ω(t) = Re ψ(1/4+it/2) − log π``;
* ``density_term`` — ``σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt``;
* ``prime_term`` / ``prime_term_sym`` — the von Mangoldt Gaussian sum and its
  symmetrisation;
* ``critical_line_re`` / ``critical_line_im`` — the real and imaginary parts of
  the Gaussian test on the critical line (checked against the exact formula);
* ``arch_im_term`` — the ``Im ψ`` correction integral;
* ``arch_critical_line_real`` — the real part of the critical-line archimedean
  integral, written as ``2π·density − 2π·(Im ψ term)``, and
  ``arch_identity_residual`` its numerical residual against direct quadrature.

Numerical work uses ``mpmath``; no side effects on import.
"""

from __future__ import annotations

import math

import mpmath

PI = math.pi


def omega(t: float) -> float:
    """``Ω(t) = Re ψ(1/4 + it/2) − log π``."""
    return float(mpmath.re(mpmath.digamma(mpmath.mpf(1) / 4 + 1j * mpmath.mpf(t) / 2))
                 - mpmath.log(mpmath.pi))


def _gaussian_weight(t: float, sigma: float) -> float:
    return math.exp(-((sigma * t) ** 2))


def density_term(c: float, sigma: float) -> float:
    """``σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt``, by quadrature over ``ℝ``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    f = lambda t: _gaussian_weight(t, sigma) * math.cos(c * t) * omega(t)
    return float(sigma ** 2 * mpmath.quad(f, [-mpmath.inf, -60, -1, 0, 1, 60]))


def arch_im_term(c: float, sigma: float) -> float:
    """``σ² ∫ e^{−σ²t²} sin(ct) Im ψ(1/4+it/2) dt``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")

    def psi_im(t: float) -> float:
        z = mpmath.digamma(mpmath.mpf(1) / 4 + 1j * mpmath.mpf(t) / 2)
        return float(mpmath.im(z))

    f = lambda t: _gaussian_weight(t, sigma) * math.sin(c * t) * psi_im(t)
    return float(sigma ** 2 * mpmath.quad(f, [-mpmath.inf, -60, -1, 0, 1, 60]))


def critical_line_re(c: float, sigma: float, t: float) -> float:
    """``Re H_c(1/2+it) = 2πσ² e^{−σ²t²} cos(ct)``."""
    return 2 * PI * sigma ** 2 * math.exp(-((sigma * t) ** 2)) * math.cos(c * t)


def critical_line_im(c: float, sigma: float, t: float) -> float:
    """``Im H_c(1/2+it) = −2πσ² e^{−σ²t²} sin(ct)``."""
    return -2 * PI * sigma ** 2 * math.exp(-((sigma * t) ** 2)) * math.sin(c * t)


def arch_critical_line_real(c: float, sigma: float) -> float:
    """``Re ∫ (log π − ψ(1/4+it/2)) H_c(1/2+it) dt`` via the closed form.

    ``log π − ψ = −Ω − i·Im ψ``, so the real part is
    ``−2π·density_term − 2π·arch_im_term``.
    """
    return -2 * PI * density_term(c, sigma) - 2 * PI * arch_im_term(c, sigma)


def arch_identity_residual(c: float, sigma: float) -> float:
    """Residual of the closed form against direct quadrature of the integrand."""
    def integrand(t: float) -> float:
        z = mpmath.digamma(mpmath.mpf(1) / 4 + 1j * mpmath.mpf(t) / 2)
        w = mpmath.log(mpmath.pi) - z
        h = (2 * mpmath.pi * sigma ** 2
             * mpmath.exp(-((sigma * t) ** 2))
             * mpmath.exp(-1j * c * t))
        return float(mpmath.re(w * h))

    direct = mpmath.quad(integrand, [-mpmath.inf, -60, -1, 0, 1, 60])
    return float(abs(direct - arch_critical_line_real(c, sigma)))


def _von_mangoldt(n: int) -> float:
    if n < 2:
        return 0.0
    x = n
    found = None
    d = 2
    while d * d <= x:
        while x % d == 0:
            if found is None:
                found = d
            elif found != d:
                return 0.0
            x //= d
        d += 1
    if x > 1:
        if found is None:
            return math.log(x)
        if found != x:
            return 0.0
    return math.log(found) if found else 0.0


def prime_term(c: float, sigma: float, cutoff: int = 4000) -> float:
    """``−2 Σ_n Λ(n)/√n · √π σ exp(−(log n − c)²/(4σ²))``."""
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    total = 0.0
    for n in range(1, cutoff):
        lam = _von_mangoldt(n)
        if lam == 0.0:
            continue
        bump = math.sqrt(PI) * sigma * math.exp(-((math.log(n) - c) ** 2) / (4 * sigma ** 2))
        total += lam / math.sqrt(n) * bump
    return -2 * total


def prime_term_sym(c: float, sigma: float, cutoff: int = 4000) -> float:
    """``(primeTerm c σ + primeTerm (−c) σ)/2``."""
    return (prime_term(c, sigma, cutoff) + prime_term(-c, sigma, cutoff)) / 2


def prime_limit_re2(c: float, sigma: float, cutoff: int = 4000) -> float:
    """The prime vertical limit actually produced at ``Re s = 2``.

    This is the real value of
    ``Σ' Λ(n)/n² · termwiseIntegral c σ n``, which the Lean development
    proves converges.  It is **not** ``−2π·primeTermSym``: the critical-line
    prime term requires ``ζ'/ζ`` on the critical line (the functional
    equation), not just the Dirichlet series in its half-plane of
    convergence.
    """
    if sigma <= 0:
        raise ValueError("sigma must be positive")
    k = (2 * PI * sigma ** 2 * math.exp(9 * sigma ** 2 / 4 - 3 * c / 2)
         * math.sqrt(PI / sigma ** 2))
    total = 0.0
    for n in range(1, cutoff):
        lam = _von_mangoldt(n)
        if lam == 0.0:
            continue
        total += lam / (n * n) * math.exp(
            -((3 * sigma ** 2 - c - math.log(n)) ** 2) / (4 * sigma ** 2))
    return k * total


def prime_gap_ratio(c: float, sigma: float, cutoff: int = 4000) -> float:
    """``primeLimitRe2 / (−2π·primeTermSym)`` — numerically not ``1``."""
    return prime_limit_re2(c, sigma, cutoff) / (-2 * PI * prime_term_sym(c, sigma, cutoff))
