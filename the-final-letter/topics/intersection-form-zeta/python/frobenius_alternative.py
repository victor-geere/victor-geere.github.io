"""Finite demonstrations for the Frobenius-alternative note.

The note ``notes/05-frobenius-alternative.md`` proposes two replacements for
the missing global Frobenius correspondence:

* the **algebraic shadow** — Hecke correspondences on a Shimura curve, whose
  Eichler--Shimura relation identifies the Hecke operator ``T_p`` with
  ``Frob_p + p Frob_p^{-1}`` on the reduction; the Ramanujan--Petersson bound
  ``|a_p| <= 2 sqrt(p)`` is the corresponding Riemann hypothesis, proved by
  Deligne;
* the **scaling correspondence** — the measured relation
  ``(x, lambda x)`` on the adele class space, whose trace formula is the
  explicit formula and whose absorption spectrum is the multiset of
  non-trivial zeros.

This module supplies the finite, falsifiable part:

* ``ramanujan_tau`` computes the Hecke eigenvalues of the weight-12 form
  ``Delta`` exactly from the eta product;
* ``check_ramanujan_bound`` verifies the Ramanujan--Petersson inequality for
  primes up to a cutoff;
* ``elliptic_trace_table`` computes ``a_p = p + 1 - #E(F_p)`` for a non-CM
  elliptic curve and exhibits the variation that rules out a single algebraic
  correspondence specialising to Frobenius at every prime.

Nothing here proves the Riemann hypothesis; the bounds are finite checks of a
theorem (Deligne) and of a no-go heuristic made precise in the note.
"""

from __future__ import annotations

from math import isqrt

__all__ = [
    "eta_series",
    "ramanujan_tau",
    "check_ramanujan_bound",
    "tau_multiplicativity_ok",
    "hecke_recurrence_ok",
    "point_count",
    "elliptic_trace_table",
    "has_fixed_trace",
    "legendre_symbol",
    "primes_upto",
]


# ---------------------------------------------------------------------------
# Ramanujan tau: the Hecke eigenvalues of the weight-12 form Delta
# ---------------------------------------------------------------------------

def eta_series(n: int) -> list[int]:
    """Coefficients of ``prod_{m>=1} (1 - q^m)`` up to ``q^n``.

    Uses Euler's pentagonal number theorem:
    ``prod (1-q^m) = sum_k (-1)^k q^{k(3k-1)/2}``.
    """
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


def _convolve(a: list[int], b: list[int], n: int) -> list[int]:
    out = [0] * (n + 1)
    for i, ai in enumerate(a):
        if ai == 0 or i > n:
            continue
        limit = min(len(b) - 1, n - i)
        for j in range(limit + 1):
            bj = b[j]
            if bj:
                out[i + j] += ai * bj
    return out


def _poly_pow(a: list[int], exponent: int, n: int) -> list[int]:
    result = [0] * (n + 1)
    result[0] = 1
    base = a[:]
    e = exponent
    while e:
        if e & 1:
            result = _convolve(result, base, n)
        e >>= 1
        if e:
            base = _convolve(base, base, n)
    return result


def ramanujan_tau(n: int) -> list[int]:
    """``[tau(0), ..., tau(n)]`` for ``Delta(q) = q prod (1-q^m)^24``.

    ``tau(0) = 0``.  The coefficients are the Hecke eigenvalues of the unique
    normalised cusp form of weight 12 for ``SL_2(Z)``.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    if n == 0:
        return [0]
    eta = eta_series(n - 1)
    eta24 = _poly_pow(eta, 24, n - 1)
    tau = [0] * (n + 1)
    for m in range(1, n + 1):
        tau[m] = eta24[m - 1]
    return tau


def check_ramanujan_bound(n: int) -> dict:
    """Check ``|tau(p)| <= 2 p^(11/2)`` for all primes ``p <= n``.

    Returns a dictionary with the primes tested, the worst ratio
    ``|tau(p)| / (2 p^(11/2))``, and the offending prime (if any).
    """
    tau = ramanujan_tau(n)
    worst = 0.0
    worst_p = None
    bad = []
    for p in primes_upto(n):
        lhs = abs(tau[p])
        # Use an exact comparison: 2 p^(11/2) is irrational for
        # odd p, so compare squares instead: lhs^2 <= 4 p^11.
        if lhs * lhs > 4 * p ** 11:
            bad.append(p)
        ratio = lhs / (2 * p ** 5.5)
        if ratio > worst:
            worst = ratio
            worst_p = p
    return {
        "cutoff": n,
        "primes": len(list(primes_upto(n))),
        "worst_ratio": worst,
        "worst_prime": worst_p,
        "bad": bad,
    }


def tau_multiplicativity_ok(n: int) -> bool:
    """Check ``tau(mn) = tau(m) tau(n)`` for coprime ``m, n`` with ``mn <= n``."""
    tau = ramanujan_tau(n)
    for m in range(1, n + 1):
        for k in range(1, n // m + 1):
            if _gcd(m, k) != 1:
                continue
            if tau[m * k] != tau[m] * tau[k]:
                return False
    return True


def hecke_recurrence_ok(n: int) -> bool:
    """Check the Hecke recurrence at prime powers.

    For a prime ``p`` and ``r >= 1``:
    ``tau(p^(r+1)) = tau(p) tau(p^r) - p^11 tau(p^(r-1))``.
    """
    tau = ramanujan_tau(n)
    for p in primes_upto(n):
        power = p
        prev = 1  # tau(p^0)
        cur = tau[p]
        while power * p <= n:
            nxt = tau[p] * cur - p ** 11 * prev
            if tau[power * p] != nxt:
                return False
            prev, cur = cur, nxt
            power *= p
    return True


# ---------------------------------------------------------------------------
# The algebraic no-go illustration: a_p is not the trace of a fixed map
# ---------------------------------------------------------------------------

def legendre_symbol(a: int, p: int) -> int:
    """Legendre symbol ``(a/p)`` for an odd prime ``p``."""
    a %= p
    if a == 0:
        return 0
    return 1 if pow(a, (p - 1) // 2, p) == 1 else -1


def point_count(a: int, b: int, p: int) -> int:
    """Number of points of ``y^2 = x^3 + a x + b`` over ``F_p``."""
    if p < 5:
        # Brute force for the tiny fields, where the Legendre shortcut is
        # awkward (p = 2 is not odd).
        count = 1
        for x in range(p):
            for y in range(p):
                if (y * y - (x * x * x + a * x + b)) % p == 0:
                    count += 1
        return count
    count = 1  # point at infinity
    for x in range(p):
        rhs = (x * x * x + a * x + b) % p
        count += 1 + legendre_symbol(rhs, p)
    return count


def elliptic_trace_table(a: int, b: int, primes: list[int]) -> dict[int, int]:
    """``a_p = p + 1 - #E(F_p)`` for ``E: y^2 = x^3 + a x + b``."""
    return {p: p + 1 - point_count(a, b, p) for p in primes}


def has_fixed_trace(table: dict[int, int]) -> bool:
    """Whether all displayed ``a_p`` equal one integer.

    A single algebraic correspondence over ``Q`` would act on a fixed
    cohomology group with eigenvalues independent of ``p``; its trace would be
    constant across primes.  For a non-CM curve the displayed table is not
    constant, so no such correspondence can specialise to Frobenius at every
    prime.
    """
    values = list(table.values())
    return len(values) > 0 and all(v == values[0] for v in values)


# ---------------------------------------------------------------------------
# Small integer helpers (avoid importing sympy in this module)
# ---------------------------------------------------------------------------

def _gcd(a: int, b: int) -> int:
    while b:
        a, b = b, a % b
    return a


def primes_upto(n: int) -> list[int]:
    if n < 2:
        return []
    sieve = bytearray([1]) * (n + 1)
    sieve[0] = sieve[1] = 0
    for p in range(2, isqrt(n) + 1):
        if sieve[p]:
            sieve[p * p:n + 1:p] = b"\x00" * (((n - p * p) // p) + 1)
    return [p for p in range(2, n + 1) if sieve[p]]


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    tau = ramanujan_tau(200)
    print("tau(1..10):", tau[1:11])
    print("Ramanujan bound:", check_ramanujan_bound(500))
    primes = primes_upto(120)
    table = elliptic_trace_table(1, 1, primes)
    print("a_p (y^2=x^3+x+1):", table)
    print("fixed trace?", has_fixed_trace(table))
