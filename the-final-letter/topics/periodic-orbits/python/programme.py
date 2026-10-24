"""Periodic orbits on Bruhat–Tits trees — exact finite bookkeeping.

The archived programme attaches a framed braid to every periodic orbit of
the shift ``σ_p(z) = p z`` on the Bruhat–Tits tree ``T_p`` and claims that
the Reshetikhin–Turaev invariant of the closure is ``p^{-n}``.  The
source's own detailed section retracts that claim, and the later repair
sections are circular.  This module therefore implements only the finite,
checkable layer:

* the modular data ``d_j``, ``S_{jj'}``, ``θ_j`` and ``D_p^2`` of
  ``SU(2)_{p-2}``;
* exact verification of ``Σ_r sin²(πr/p) = p/2`` by reduction modulo the
  cyclotomic polynomial ``Φ_p`` (hence the ``D_p^2`` identity);
* the reduced Verlinde column sums, including the later section's
  "surviving" column ``ℓ = (p-1)/2``, which is identically zero;
* the numerical mismatch ``G_p ≠ τ_p`` recorded by the source;
* the local RT weight ``p^{-n}``, its truncated Euler factor, and the
  writhe bookkeeping for braid words;
* primitive periodic-orbit counts from the fixed-vertex count
  ``p^n + 1`` by Möbius inversion.

Everything is exact except ``gauss_mismatch`` and
``total_quantum_dim_numeric_residual``, which are explicitly numerical
and return the requested tolerance domain.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi
_I = sp.I


def _check_prime(p: int) -> None:
    """Reject non-primes below 3 with a clear error."""
    if not isinstance(p, int) or p < 3 or not sp.isprime(p):
        raise ValueError(f"p must be a prime >= 3, got {p!r}")


# ---------------------------------------------------------------------------
# Modular data of SU(2)_{p-2}
# ---------------------------------------------------------------------------

def admissible_labels(p: int) -> list[sp.Rational]:
    """Labels ``j = 0, 1/2, …, (p-2)/2``, i.e. ``r = 2j+1 = 1, …, p-1``."""
    _check_prime(p)
    return [sp.Rational(k, 2) for k in range(p - 1)]


def quantum_dim(j: sp.Expr, p: int) -> sp.Expr:
    """Quantum dimension ``d_j = sin(π(2j+1)/p) / sin(π/p)``."""
    _check_prime(p)
    return sp.sin(PI * (2 * j + 1) / p) / sp.sin(PI / p)


def s_entry(j: sp.Expr, jp: sp.Expr, p: int) -> sp.Expr:
    """Modular ``S``-matrix entry ``S_{jj'} = sqrt(2/p) sin(π(2j+1)(2j'+1)/p)``."""
    _check_prime(p)
    return sp.sqrt(sp.Rational(2, p)) * sp.sin(
        PI * (2 * j + 1) * (2 * jp + 1) / p
    )


def theta(j: sp.Expr, p: int) -> sp.Expr:
    """Ribbon twist ``θ_j = exp((iπ/p)(j(j+1) - 1/4))``."""
    _check_prime(p)
    return sp.exp(_I * PI / p * (j * (j + 1) - sp.Rational(1, 4)))


def total_quantum_dim_sq(p: int) -> sp.Expr:
    """The state-sum square ``Σ_j d_j^2``."""
    return sp.Add(*(quantum_dim(j, p) ** 2 for j in admissible_labels(p)))


def sin_sq_sum_mod_cyclotomic(p: int) -> sp.Expr:
    """Exact value of ``Σ_{r=1}^{p-1} sin²(πr/p)`` modulo ``Φ_p``.

    With ``ζ = exp(2πi/p)`` one has
    ``sin²(πr/p) = (2 - ζ^r - ζ^{-r}) / 4``.  The two power sums are
    reduced modulo the ``p``-th cyclotomic polynomial, which is exact
    rational arithmetic in ``ℚ[z]/(Φ_p)``.
    """
    _check_prime(p)
    z = sp.symbols("z")
    phi = sp.Poly(sp.cyclotomic_poly(p, z), z)
    power_sum = sp.Poly(sp.Add(*(z**r for r in range(1, p))), z).rem(phi)
    inverse_sum = sp.Poly(sp.Add(*(z ** (p - r) for r in range(1, p))), z).rem(phi)
    return sp.Rational(1, 4) * (
        2 * (p - 1) - power_sum.as_expr() - inverse_sum.as_expr()
    )


def total_quantum_dim_numeric_residual(p: int, dps: int = 50) -> sp.Float:
    """Numerical residual of ``Σ_j d_j^2 = p / (2 sin²(π/p))``.

    Returned as an absolute ``dps``-digit value; the accompanying test
    uses the tolerance ``1e-40`` at ``dps = 50``.
    """
    _check_prime(p)
    closed = sp.Rational(p, 2) / sp.sin(PI / p) ** 2
    return abs(sp.N(total_quantum_dim_sq(p) - closed, dps))


# ---------------------------------------------------------------------------
# Verlinde column sums and the Gauss-sum comparison
# ---------------------------------------------------------------------------

def verlinde_column_sum(p: int, ell: sp.Expr) -> sp.Expr:
    """Reduced column sum ``Σ_j d_j θ_j S_{jℓ}``.

    The source's first reduction uses ``ℓ = 0`` (the ``G_p`` of §3.2);
    the later "repair" uses ``ℓ = (p-1)/2``.
    """
    _check_prime(p)
    return sp.simplify(
        sp.Add(*(quantum_dim(j, p) * theta(j, p) * s_entry(j, ell, p)
                 for j in admissible_labels(p)))
    )


def gauss_sum(p: int) -> sp.Expr:
    """The source's weighted sum ``G_p = Σ_j d_j θ_j S_{j0}``."""
    _check_prime(p)
    return sp.Add(*(quantum_dim(j, p) * theta(j, p) * s_entry(j, 0, p)
                    for j in admissible_labels(p)))


def tau_gauss(p: int) -> sp.Expr:
    """The classical Gauss-sum phase ``τ_p = e^{iπ/4} / sqrt(p)``."""
    _check_prime(p)
    return sp.exp(_I * PI / 4) / sp.sqrt(p)


def gauss_mismatch(p: int, dps: int = 40) -> float:
    """``|G_p - τ_p|`` at ``dps`` digits (numerical comparison only)."""
    _check_prime(p)
    difference = sp.N(gauss_sum(p) - tau_gauss(p), dps)
    return float(sp.Abs(difference))


# ---------------------------------------------------------------------------
# RT weights, Euler factors and braid bookkeeping
# ---------------------------------------------------------------------------

def rt_weight(p: int, n: int) -> sp.Rational:
    """The local RT weight ``p^{-n}`` as an exact rational."""
    if n < 0:
        raise ValueError("n must be non-negative")
    if p < 2:
        raise ValueError("p must be at least 2")
    return sp.Rational(1, p**n)


def truncated_euler_factor(p: int, terms: int) -> sp.Rational:
    """``Σ_{n=0}^{terms-1} p^{-n}`` as an exact rational."""
    if terms < 0:
        raise ValueError("terms must be non-negative")
    if p < 2:
        raise ValueError("p must be at least 2")
    return sp.Add(*(rt_weight(p, n) for n in range(terms)))


def euler_factor_closed_form(p: int, terms: int) -> sp.Rational:
    """The finite geometric closed form of the truncated Euler factor."""
    if terms < 0:
        raise ValueError("terms must be non-negative")
    if p < 2:
        raise ValueError("p must be at least 2")
    return (1 - rt_weight(p, terms)) / (1 - sp.Rational(1, p))


def writhe(word: Iterable[int]) -> int:
    """Writhe of a braid word: the sum of its signed generator exponents."""
    return sum(int(e) for e in word)


def full_twist_writhe(n: int) -> int:
    """Writhe of the ``n``-fold full twist ``(σ_1 … σ_{n-1})^n``: ``n(n-1)``."""
    if n < 1:
        raise ValueError("the braid group B_n needs n >= 1")
    return n * (n - 1)


# ---------------------------------------------------------------------------
# Periodic-orbit counting
# ---------------------------------------------------------------------------

def fixed_vertices(p: int, n: int) -> int:
    """The source's count of ``σ_p^n``-fixed vertices: ``p^n + 1``."""
    _check_prime(p)
    if n < 0:
        raise ValueError("n must be non-negative")
    return p**n + 1


def primitive_orbit_count(p: int, n: int) -> int:
    """Primitive length-``n`` orbits, by Möbius inversion of ``p^d + 1``.

    ``n * P(n) = Σ_{d|n} μ(n/d) (p^d + 1)``.  The source's Proposition in
    ``1_1.tex`` instead labels all ``p^n + 1`` fixed vertices "orbits of
    length n"; for composite ``n`` that overcounts non-primitive orbits.
    """
    _check_prime(p)
    if n < 1:
        raise ValueError("n must be positive")
    total = sum(int(sp.mobius(n // d)) * (p**d + 1) for d in sp.divisors(n))
    if total % n != 0:
        raise ArithmeticError("Möbius count not divisible by the period")
    return total // n


__all__ = [
    "PI",
    "admissible_labels",
    "quantum_dim",
    "s_entry",
    "theta",
    "total_quantum_dim_sq",
    "sin_sq_sum_mod_cyclotomic",
    "total_quantum_dim_numeric_residual",
    "verlinde_column_sum",
    "gauss_sum",
    "tau_gauss",
    "gauss_mismatch",
    "rt_weight",
    "truncated_euler_factor",
    "euler_factor_closed_form",
    "writhe",
    "full_twist_writhe",
    "fixed_vertices",
    "primitive_orbit_count",
]
