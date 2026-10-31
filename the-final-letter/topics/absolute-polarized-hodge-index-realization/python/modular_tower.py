"""Finite-level checks for the endomotive / modular-tower candidate.

The level-11 weight-two newform is

    f(q) = q * prod_{n>=1} (1-q^n)^2 (1-q^{11n})^2.

Its coefficients at primes p != 11 are the Hecke eigenvalues a_p.  The
Ramanujan--Petersson bound |a_p| <= 2 sqrt(p) is the finite-level
Hodge--Riemann positivity of the tower.
"""

from __future__ import annotations

import math

__all__ = [
    "eta_series",
    "convolve",
    "level11_form",
    "hecke_eigenvalues",
    "ramanujan_bound_ok",
    "primes_upto",
]


def eta_series(n: int) -> list[int]:
    """Coefficients of prod_{m>=1}(1-q^m) up to q^n (pentagonal theorem)."""
    e = [0] * (n + 1)
    e[0] = 1
    k = 1
    while True:
        g1 = k * (3 * k - 1) // 2
        g2 = k * (3 * k + 1) // 2
        if g1 > n and g2 > n:
            break
        sign = -1 if k % 2 else 1
        if g1 <= n:
            e[g1] += sign
        if g2 <= n:
            e[g2] += sign
        k += 1
    return e


def convolve(a: list[int], b: list[int], n: int) -> list[int]:
    out = [0] * (n + 1)
    for i, ai in enumerate(a):
        if ai == 0 or i > n:
            continue
        limit = min(len(b) - 1, n - i)
        for j in range(limit + 1):
            if b[j]:
                out[i + j] += ai * b[j]
    return out


def level11_form(n: int) -> list[int]:
    """Coefficients [a_0, ..., a_n] of the level-11 weight-2 form."""
    eta = eta_series(n)
    eta2 = convolve(eta, eta, n)
    eta11 = [eta[k // 11] if k % 11 == 0 else 0 for k in range(n + 1)]
    eta11_2 = convolve(eta11, eta11, n)
    f = convolve(eta2, eta11_2, n)
    out = [0] * (n + 1)
    for k in range(1, n + 1):
        out[k] = f[k - 1]
    return out


def primes_upto(n: int) -> list[int]:
    if n < 2:
        return []
    sieve = bytearray([1]) * (n + 1)
    sieve[0] = sieve[1] = 0
    for p in range(2, int(math.isqrt(n)) + 1):
        if sieve[p]:
            sieve[p * p:n + 1:p] = b"\x00" * (((n - p * p) // p) + 1)
    return [p for p in range(2, n + 1) if sieve[p]]


def hecke_eigenvalues(n: int, level: int = 11) -> dict[int, int]:
    """a_p for primes p <= n, p != level."""
    coeffs = level11_form(n)
    return {p: coeffs[p] for p in primes_upto(n) if p != level}


def ramanujan_bound_ok(n: int, level: int = 11) -> bool:
    for p, ap in hecke_eigenvalues(n, level).items():
        if abs(ap) > 2 * math.sqrt(p) + 1e-12:
            return False
    return True


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    coeffs = level11_form(30)
    print("level-11 coefficients q^1..q^15:", coeffs[1:16])
    print("Hecke a_p (p<=50):", hecke_eigenvalues(50))
    print("Ramanujan bound holds:", ramanujan_bound_ok(300))
