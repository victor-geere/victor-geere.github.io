"""Greedy harmonic sine / twin-prime parity — exact finite-prefix layer.

The archived ``summary-rh`` programme asks whether the greedy harmonic sine
can reach the parity barrier for twin primes.  Its one clean parity-side
result is the *finite-prefix indeterminacy theorem* for the two-point
Liouville correlation

    S(x, h) = sum_{1 <= n <= N} lambda(n) lambda(n + h).

This module implements that finite logical layer exactly.  ``lambda`` is the
Liouville function ``(-1)^Omega(n)`` with ``Omega`` the number of prime
factors counted with multiplicity.  Everything here is integer arithmetic,
so every identity tested is exact rather than numerical.

Nothing in this module asserts two-point Chowla, the twin prime conjecture,
the Riemann hypothesis, Sarnak's conjecture, or Elliott's conjecture.
"""

from __future__ import annotations

from functools import lru_cache

import sympy as sp


@lru_cache(maxsize=None)
def omega(n: int) -> int:
    """`Ω n`, the number of prime factors of `n`, counted with multiplicity."""
    if n < 0:
        raise ValueError("omega is defined for non-negative integers")
    if n <= 1:
        return 0
    return int(sum(e for _, e in sp.factorint(n).items()))


def liouville(n: int) -> int:
    """The Liouville function `λ n = (-1)^(Ω n)`; `λ 0 = 1`."""
    return 1 if omega(n) % 2 == 0 else -1


def shift_prod(h: int, n: int) -> int:
    """The Chowla summand `λ n * λ(n + h)`."""
    if h < 0:
        raise ValueError("the shift must be non-negative")
    return liouville(n) * liouville(n + h)


def corr(h: int, N: int) -> int:
    """The two-point correlation `S(N, h) = Σ_{1 ≤ n ≤ N} λ n λ(n+h)`."""
    if h < 0:
        raise ValueError("the shift must be non-negative")
    if N < 0:
        raise ValueError("the correlation length must be non-negative")
    return sum(shift_prod(h, n) for n in range(1, N + 1))


def liouville_slice(a: int, n: int) -> int:
    """`λ` with the single value at index `a` negated."""
    if a < 0 or n < 0:
        raise ValueError("indices must be non-negative")
    return -liouville(a) if n == a else liouville(n)


def corr_slice(h: int, a: int, N: int) -> int:
    """The correlation built from the one-point slice at index `a`."""
    return sum(
        liouville_slice(a, n) * liouville_slice(a, n + h)
        for n in range(1, N + 1)
    )


def slice_l2_mass(a: int, N: int) -> int:
    """`Σ_{1 ≤ n ≤ N} (λ_a(n) − λ(n))²`, the `ℓ²` mass of the flip."""
    if a < 0 or N < 0:
        raise ValueError("indices must be non-negative")
    return sum(
        (liouville_slice(a, n) - liouville(n)) ** 2 for n in range(1, N + 1)
    )


def slice_perturbation(h: int, a: int) -> int:
    """Closed form for `corr_slice(h,a,a) − corr(h,a)` when `0 < h < a`.

    The flip at index `a` touches exactly the summands at `n = a` and
    `n = a − h`; the result is the fixed two-point statistic
    `−2 λ(a)λ(a+h) − 2 λ(a−h)λ(a)`.
    """
    if not 0 < h < a:
        raise ValueError("the closed form requires 0 < h < a")
    return (
        -2 * liouville(a) * liouville(a + h)
        - 2 * liouville(a - h) * liouville(a)
    )


def prefix_agreement(h: int, a: int, N: int) -> bool:
    """Exact check of `corr_slice(h,a,N) = corr(h,N)` on the prefix `N+h < a`."""
    if N + h >= a:
        raise ValueError("prefix agreement needs N + h < a")
    return corr_slice(h, a, N) == corr(h, N)
