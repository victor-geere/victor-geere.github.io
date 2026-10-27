#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
von_mangoldt_sieves.py
======================
Reference implementation and self-check for the paper
"Sieves for the von Mangoldt Function" (publish/001-von-mangoldt-sieves/von-mangoldt-sieves.html).

Self-contained: Python 3 standard library only.

It implements the four algorithms of the paper and verifies them against each
other and against the exact divisor identity

        prod_{d | n} exp(Lambda(d)) = n          (Proposition 2.2),

which is checked in integer arithmetic, so the verification is exact.

Run:  python3 von_mangoldt_sieves.py [N]        (default N = 2000)
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import math
import sys
from typing import List

Table = List[int]          # table[n] = 0 if Lambda(n) = 0, else the prime p with n = p^k


# --------------------------------------------------------------------------- #
#  Algorithm A — prime-power marking sieve
# --------------------------------------------------------------------------- #
def sieve_A(N: int) -> Table:
    """Prime-power marking.  table[n] = prime p if n = p^k, else 0."""
    tab = [0] * (N + 1)
    is_p = [True] * (N + 1)
    for p in range(2, N + 1):
        if is_p[p]:
            pk = p
            while pk <= N:                 # mark p, p^2, p^3, ...
                tab[pk] = p                # Lambda(p^k) = log p
                pk *= p
            for m in range(p * p, N + 1, p):
                is_p[m] = False
    return tab


# --------------------------------------------------------------------------- #
#  Algorithm B' — divisor-sum sieve, integer form
# --------------------------------------------------------------------------- #
def sieve_B_integer(N: int) -> Table:
    """Integer divisor-sum sieve: P(n) = prod_{d|n, d<n} exp Lambda(d), q = n / P(n)."""
    P = [1] * (N + 1)
    tab = [0] * (N + 1)
    for n in range(2, N + 1):
        q = n // P[n]                      # divides exactly (Prop. 2.2)
        if q != 1:                         # q is prime
            tab[n] = q
        for m in range(2 * n, N + 1, n):
            P[m] *= q                      # q = exp(Lambda(n)); q = 1 is a no-op
    return tab


# --------------------------------------------------------------------------- #
#  Algorithm B — divisor-sum sieve, real form
# --------------------------------------------------------------------------- #
def sieve_B_real(N: int) -> List[float]:
    acc = [0.0] * (N + 1)
    lam = [0.0] * (N + 1)
    for n in range(1, N + 1):
        lam[n] = math.log(n) - acc[n]
        for m in range(2 * n, N + 1, n):
            acc[m] += lam[n]
    return lam


# --------------------------------------------------------------------------- #
#  Algorithm C — Mobius-convolution sieve
# --------------------------------------------------------------------------- #
def sieve_C(N: int) -> List[float]:
    mu = [0] * (N + 1)
    mu[1] = 1
    primes: List[int] = []
    comp = [False] * (N + 1)
    for i in range(2, N + 1):
        if not comp[i]:
            primes.append(i)
            mu[i] = -1
        for p in primes:
            if i * p > N:
                break
            comp[i * p] = True
            if i % p == 0:
                mu[i * p] = 0
                break
            mu[i * p] = -mu[i]
    lam = [0.0] * (N + 1)
    for d in range(1, N + 1):              # Lambda = mu * log
        if mu[d] != 0:
            for m in range(d, N + 1, d):
                lam[m] += mu[d] * math.log(m // d)
    return lam


# --------------------------------------------------------------------------- #
#  checks
# --------------------------------------------------------------------------- #
def divisors(n: int) -> List[int]:
    ds = []
    i = 1
    while i * i <= n:
        if n % i == 0:
            ds.append(i)
            if i != n // i:
                ds.append(n // i)
        i += 1
    return ds


def check_divisor_identity(tab: Table, N: int) -> int:
    """prod_{d|n} exp(Lambda(d)) == n, in exact integer arithmetic."""
    failures = 0
    for n in range(1, N + 1):
        prod = 1
        for d in divisors(n):
            if tab[d]:
                prod *= tab[d]
        if prod != n:
            failures += 1
            if failures <= 5:
                print("   divisor identity fails at n = %d (product %d)" % (n, prod))
    return failures


def psi_from_table(tab: Table, x: int) -> float:
    return sum(math.log(tab[n]) for n in range(2, x + 1) if tab[n])


def main(argv: List[str]) -> int:
    N = int(argv[1]) if len(argv) > 1 else 2000
    print("von Mangoldt sieves — self-check, N = %d" % N)

    A = sieve_A(N)
    Bi = sieve_B_integer(N)
    Br = sieve_B_real(N)
    C = sieve_C(N)

    ok = True

    mism = [n for n in range(1, N + 1) if A[n] != Bi[n]]
    print("  [1] Algorithm A  vs  Algorithm B' (integer detection): %d mismatches" % len(mism))
    ok &= not mism

    f = check_divisor_identity(A, N)
    print("  [2] exact divisor identity  prod_{d|n} exp(Lambda(d)) = n : %d failures" % f)
    ok &= f == 0

    bad_r = [n for n in range(1, N + 1)
             if abs(Br[n] - (math.log(A[n]) if A[n] else 0.0)) > 1e-9]
    bad_c = [n for n in range(1, N + 1)
             if abs(C[n] - (math.log(A[n]) if A[n] else 0.0)) > 1e-9]
    print("  [3] Algorithm B (real) vs table: %d mismatches" % len(bad_r))
    print("  [4] Algorithm C (Mobius) vs table: %d mismatches" % len(bad_c))
    ok &= not bad_r and not bad_c

    print("  Chebyshev psi(x), computed by Algorithm A:")
    big = max(N, 10 ** 6)
    A_big = A if big <= N else sieve_A(big)
    print("    %9s %24s" % ("x", "psi(x)"))
    for k in range(1, 7):
        x = 10 ** k
        print("    %9d %24.15f" % (x, psi_from_table(A_big, x)))

    from math import lcm
    for n in (10, 20):
        psi = psi_from_table(A, n)
        lhs = math.exp(psi)
        rhs = lcm(*range(1, n + 1))
        rel = abs(lhs - rhs) / rhs
        print("  [5] exp psi(%d) = %.6f, lcm(1..%d) = %d, rel. err %.2e"
              % (n, lhs, n, rhs, rel))
        ok &= rel < 1e-12

    print("RESULT:", "ALL CHECKS PASS" if ok else "FAILURES")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
