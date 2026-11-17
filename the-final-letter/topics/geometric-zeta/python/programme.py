"""Computation layer for the geometric-zeta decompositions.

The exact identities checked here are unconditional and valid on `Re s > 1`:

* additive:  ζ(s) = 1 + Σ_{a∈A} 1/(a^s − 1),  A = non-perfect-powers ≥ 2;
* Lambert:   Σ_{k≥1} q^k/(1 − q^k) = Σ_{n≥1} d(n) q^n  (|q| < 1);
* logarithm: log ζ(s) = Σ_p Σ_{m≥1} p^{−ms}/m.

No zero location, positivity, or functional equation is used.
"""

from __future__ import annotations

import math

import mpmath


def is_perfect_power(n: int) -> bool:
    """True iff ``n = a^m`` for some integers ``a ≥ 2`` and ``m ≥ 2``."""
    if n < 4:
        return False
    for m in range(2, n.bit_length() + 1):
        a = int(round(n ** (1.0 / m)))
        for cand in (a - 1, a, a + 1):
            if cand >= 2 and cand**m == n:
                return True
    return False


def non_perfect_powers(n_max: int) -> list[int]:
    """The bases ``2 ≤ a ≤ n_max`` that are not perfect powers."""
    return [a for a in range(2, n_max + 1) if not is_perfect_power(a)]


def additive_partial(s: complex, n_max: int) -> complex:
    """``1 + Σ_{a∈A, a≤n_max} 1/(a^s − 1)``."""
    z = mpmath.mpc(s)
    return 1 + mpmath.fsum(1 / (mpmath.power(a, z) - 1) for a in non_perfect_powers(n_max))


def all_bases_partial(s: complex, n_max: int) -> complex:
    """``1 + Σ_{2≤a≤n_max} 1/(a^s − 1)`` (the non-unique-base comparison)."""
    z = mpmath.mpc(s)
    return 1 + mpmath.fsum(1 / (mpmath.power(a, z) - 1) for a in range(2, n_max + 1))


def lambert_partial(q: complex, n_max: int) -> complex:
    """``Σ_{k≤n_max} q^k/(1 − q^k)``."""
    z = mpmath.mpc(q)
    return mpmath.fsum(mpmath.power(z, k) / (1 - mpmath.power(z, k)) for k in range(1, n_max + 1))


def divisor_series_partial(q: complex, n_max: int) -> complex:
    """``Σ_{n≤n_max} d(n) q^n``, with ``d(n)`` the divisor count."""
    counts = [0] * (n_max + 1)
    for d in range(1, n_max + 1):
        for n in range(d, n_max + 1, d):
            counts[n] += 1
    z = mpmath.mpc(q)
    return mpmath.fsum(counts[n] * mpmath.power(z, n) for n in range(1, n_max + 1))


def additive_residual(s: complex, n_max: int) -> float:
    """``|1 + Σ_{a∈A, a≤n_max} 1/(a^s−1) − ζ(s)|``."""
    return float(abs(additive_partial(s, n_max) - mpmath.zeta(mpmath.mpc(s))))


def lambert_residual(q: complex, n_max: int) -> float:
    """``|Σ_{k≤n_max} q^k/(1−q^k) − Σ_{n≤n_max} d(n)q^n|``."""
    return float(abs(lambert_partial(q, n_max) - divisor_series_partial(q, n_max)))


def prime_power_log_partial(s: complex, p_max: int) -> complex:
    """``Σ_{p≤p_max} Σ_{m: p^m≤p_max} p^{−ms}/m``."""
    z = mpmath.mpc(s)
    total = mpmath.mpc(0)
    for p in range(2, p_max + 1):
        if all(p % d for d in range(2, int(math.isqrt(p)) + 1)):
            pk = p
            m = 1
            while pk <= p_max:
                total += mpmath.power(p, -z * m) / m
                pk *= p
                m += 1
    return total


def log_residual(s: complex, p_max: int) -> float:
    """``|Σ_{p≤p_max} Σ_m p^{−ms}/m − log ζ(s)|``."""
    return float(abs(prime_power_log_partial(s, p_max) - mpmath.log(mpmath.zeta(mpmath.mpc(s)))))


def lattice_Ej(sigma: float, j: int, n_max: int = 40) -> mpmath.mpf:
    """``E_j(σ) = Σ_{1≤k,m≤n_max} (k−m)^{2j}/(k²+m²)^σ``."""
    s = mpmath.mpf(sigma)
    total = mpmath.mpf(0)
    for k in range(1, n_max + 1):
        for m in range(1, n_max + 1):
            total += mpmath.mpf((k - m) ** (2 * j)) / (mpmath.mpf(k * k + m * m) ** s)
    return total


def lattice_lower_bound(sigma: float, J: int, n_max: int = 40) -> mpmath.mpf:
    """The lower bound of ``INEQUALITY.md``:
    ``2^σ Σ_{j=0}^J Γ(σ+j)/(j! Γ(σ)) E_j(σ+j)``.
    """
    s = mpmath.mpf(sigma)
    total = mpmath.mpf(0)
    for j in range(J + 1):
        coeff = mpmath.power(2, s) * mpmath.gamma(s + j) / (
            mpmath.factorial(j) * mpmath.gamma(s)
        )
        total += coeff * lattice_Ej(sigma + j, j, n_max)
    return total


def lattice_bound_ratio(sigma: float, J: int, n_max: int = 40) -> float:
    """``lattice_lower_bound(σ, J) / ζ(σ)^2`` (should be < 1)."""
    return float(lattice_lower_bound(sigma, J, n_max) / mpmath.zeta(mpmath.mpf(sigma)) ** 2)
