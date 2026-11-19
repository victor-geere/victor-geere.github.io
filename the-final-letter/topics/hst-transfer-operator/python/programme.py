"""Exact finite computations for the HST transfer operator.

All arithmetic is exact rational arithmetic.  The module has no import-time
side effects and makes no analytic or spectral claim.
"""
from __future__ import annotations

from fractions import Fraction


def _check_n(n: int) -> None:
    if n < 0:
        raise ValueError("n must be non-negative")


def branch0(n: int, y: Fraction) -> Fraction:
    """The zero-branch inverse at depth ``n``."""
    _check_n(n)
    return y / (1 + Fraction(1, n + 2))


def branch1(n: int, y: Fraction) -> Fraction:
    """The one-branch inverse at depth ``n``."""
    _check_n(n)
    return y / (1 + Fraction(1, n + 2)) + 1


def greedy_map(n: int, x: Fraction) -> Fraction:
    """The normalised greedy remainder map at depth ``n``."""
    _check_n(n)
    delta = 1 if x >= 1 else 0
    return (1 + Fraction(1, n + 2)) * (x - delta)


def weight(n: int, k: int) -> Fraction:
    """The archived transfer weight ``(n+1)/(n+2)^k``."""
    _check_n(n)
    if k < 0:
        raise ValueError("k must be non-negative")
    return Fraction(n + 1, (n + 2) ** k)


def weight_sum(N: int, k: int) -> Fraction:
    """The finite weight sum ``Σ_{n<N} (n+1)/(n+2)^k``."""
    if N < 0:
        raise ValueError("N must be non-negative")
    return sum((weight(n, k) for n in range(N)), Fraction(0))


def constant_action(N: int, k: int, c: Fraction) -> Fraction:
    """The finite transfer operator on the constant function ``c``."""
    return c * 2 * weight_sum(N, k)


def weight_one_lower(n: int) -> Fraction:
    """The ``k=1`` weight ``(n+1)/(n+2)`` is at least ``1/2``."""
    _check_n(n)
    return weight(n, 1)
