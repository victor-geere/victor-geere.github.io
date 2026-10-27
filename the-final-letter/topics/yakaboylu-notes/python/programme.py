"""Yakaboylu notes — exact and verified computation layer.

The archived notes (``archive/maths/yakaboylu/intro.html``) define the
Dirichlet eta function through its real and imaginary series, truncate it
at ``N`` terms, and introduce the amplitude bound

    S_N(σ) = Σ_{n=2..N} n^(-σ).

The real-zero condition ``U_N(σ,t) = 0`` is rewritten there as

    R_N(σ,t) = Σ_{n=2..N} (-1)^n n^(-σ) cos(t log n) = 1,

so that ``|R_N| ≤ S_N``.  The notes then define thresholds ``σ_N`` by
``S_N(σ_N) = 1`` and claim ``σ_N ↗ σ_0`` where ``ζ(σ_0) = 2``.

This module computes those objects exactly where possible (sympy) and to
high precision where a root or a maximum is required (mpmath).  It does
not assert any Riemann-hypothesis statement: the analytic continuation,
the functional equation and the positivity of Yakaboylu's intertwiner
are source claims recorded in the dossier, not results of this module.
"""

from __future__ import annotations

import mpmath as mp
import sympy as sp

# Working precision for numerical roots and scans.
DPS = 30


def _require_N(N: int) -> None:
    """The source sums start at ``n = 2``, so ``N ≥ 2`` is required."""
    if N < 2:
        raise ValueError("N must be at least 2 (the n = 1 term is separate)")


def amplitude_sum(N: int, sigma) -> sp.Expr:
    """The amplitude bound ``S_N(σ) = Σ_{n=2..N} n^(-σ)`` exactly."""
    _require_N(N)
    s = sp.sympify(sigma)
    return sum(sp.Pow(n, -s) for n in range(2, N + 1))


def cosine_sum(N: int, sigma, t) -> sp.Expr:
    """The truncated alternating cosine sum ``R_N(σ,t)`` exactly."""
    _require_N(N)
    s = sp.sympify(sigma)
    tt = sp.sympify(t)
    return sum(
        (-1) ** n * sp.Pow(n, -s) * sp.cos(tt * sp.log(n)) for n in range(2, N + 1)
    )


def eta_real_part(N: int, sigma, t) -> sp.Expr:
    """The truncated real part ``U_N = 1 - R_N`` (source §3, exact signs).

    ``U_N = Σ_{n=1..N} (-1)^(n-1) n^(-σ) cos(t log n)``.  The ``n = 1``
    term is ``1`` and the remaining terms give ``-R_N``.
    """
    _require_N(N)
    return 1 - cosine_sum(N, sigma, t)


def eta_truncation_at_one(N: int) -> sp.Rational:
    """``η_N(1) = Σ_{n=1..N} (-1)^(n-1) / n`` as an exact rational."""
    if N < 1:
        raise ValueError("N must be positive")
    return sp.Rational(sum(sp.Rational((-1) ** (n - 1), n) for n in range(1, N + 1)))


def max_abs_cosine(N: int, sigma, t_max: float = 20.0, samples: int = 400) -> mp.mpf:
    """Numerically maximise ``|R_N(σ,t)|`` on a uniform grid ``t ∈ [0, t_max]``.

    The grid maximum is a lower bound for the supremum; it is used only to
    illustrate the exact amplitude bound proved in Lean.
    """
    _require_N(N)
    with mp.workdps(DPS):
        s = mp.mpf(sp.N(sigma, DPS))
        best = mp.mpf(0)
        for k in range(samples + 1):
            t = mp.mpf(t_max) * k / samples
            value = mp.fsum(
                (-1) ** n * mp.power(n, -s) * mp.cos(t * mp.log(n))
                for n in range(2, N + 1)
            )
            best = max(best, abs(value))
        return best


def sigma_threshold(N: int, dps: int = DPS) -> mp.mpf:
    """The threshold ``σ_N`` defined by ``S_N(σ_N) = 1``.

    ``S_N`` is strictly decreasing (proved in Lean), ``S_N(0) = N - 1 ≥ 1``
    and ``S_N(4) < 1``, so bisection is unconditionally safe.  For ``N = 2``
    the equation is ``2^(-σ) = 1`` with the exact root ``σ = 0``.
    """
    _require_N(N)
    if N == 2:
        return mp.mpf(0)
    with mp.workdps(dps):
        def S(s: mp.mpf) -> mp.mpf:
            return mp.fsum(mp.power(n, -s) for n in range(2, N + 1))

        lo, hi = mp.mpf(0), mp.mpf(4)
        for _ in range(160):
            mid = (lo + hi) / 2
            if S(mid) > 1:
                lo = mid
            else:
                hi = mid
        return (lo + hi) / 2


def sigma_zero(dps: int = DPS) -> mp.mpf:
    """The limit ``σ_0`` of the thresholds, i.e. the root of ``ζ(σ) = 2``.

    The source quotes ``σ_0 ≈ 1.72865``.  This is a numerical computation,
    not a proof of the limit; the limit statement remains a source claim.
    """
    with mp.workdps(dps):
        return mp.findroot(lambda s: mp.zeta(s) - 2, mp.mpf("1.7"))


def euler_product(sigma, prime_bound: int = 2000, dps: int = DPS) -> mp.mpf:
    """Partial Euler product ``∏_{p ≤ prime_bound} (1 - p^(-σ))^(-1)``."""
    with mp.workdps(dps):
        s = mp.mpf(sp.N(sigma, dps))
        product = mp.mpf(1)
        for p in sp.primerange(2, prime_bound + 1):
            product *= 1 / (1 - mp.power(p, -s))
        return product


def weight(t) -> sp.Expr:
    """Yakaboylu's weight ``ω(t) = t e^t / (1 + e^t)^2`` exactly."""
    t = sp.sympify(t)
    e = sp.exp(t)
    return t * e / (1 + e) ** 2


def weight_closed(t) -> sp.Expr:
    """The equivalent form ``ω(t) = t / (4 cosh²(t/2))``."""
    t = sp.sympify(t)
    return t / (4 * sp.cosh(t / 2) ** 2)
