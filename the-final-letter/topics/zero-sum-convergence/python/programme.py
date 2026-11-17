"""Computation layer for the zero-sum convergence programme.

* ``zero_count`` — number of nontrivial zeros with ``|Im ρ| ≤ T``;
* ``counting_ratio`` — ``N(T)/(T log T)``, testing the counting bound;
* ``gaussian_zero_sum`` — partial sum of ``Re H_c(ρ)`` over zeros with
  ``|Im ρ| ≤ T``;
* ``trivial_gaussian_sum`` — partial sum of the Gaussian over the trivial
  zeros ``−2(n+1)``.

Numerical work uses ``mpmath``; no side effects on import.
"""

from __future__ import annotations

import math

import mpmath


def gaussian_test(c: float, sigma: float, s: complex) -> complex:
    """``H_c(s) = 2πσ² exp(σ²(s − 1/2)²) exp(−c(s − 1/2))``."""
    z = mpmath.mpc(s)
    return (2 * mpmath.pi * sigma ** 2
            * mpmath.exp(sigma ** 2 * (z - 0.5) ** 2)
            * mpmath.exp(-c * (z - 0.5)))


def zero_count(T: float) -> int:
    """Number of nontrivial zeros with ``|Im ρ| ≤ T``."""
    if T <= 0:
        return 0
    n = 0
    while True:
        gamma = float(mpmath.im(mpmath.zetazero(n + 1)))
        if abs(gamma) > T:
            return n
        n += 1


def counting_ratio(T: float) -> float:
    """``N(T)/(T log T)`` — should stay below the Riemann–von Mangoldt constant."""
    if T <= 1:
        raise ValueError("T must exceed 1")
    return zero_count(T) / (T * math.log(T))


def gaussian_zero_sum(c: float, sigma: float, T: float) -> float:
    """Sum of ``Re H_c(ρ)`` over zeros with ``|Im ρ| ≤ T``."""
    total = 0.0
    n = 0
    while True:
        z = mpmath.zetazero(n + 1)
        if abs(float(mpmath.im(z))) > T:
            return total
        total += float(mpmath.re(gaussian_test(c, sigma, z)))
        n += 1


def trivial_gaussian_sum(sigma: float, N: int = 200) -> float:
    """Sum of ``exp(−σ²(2(n+1))²)`` for ``n < N``."""
    return float(sum(math.exp(-(sigma * 2 * (n + 1)) ** 2) for n in range(N)))
