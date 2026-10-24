#!/usr/bin/env python3
"""Probe: can the section-2/3 greedy harmonic decomposition of the *indices* of
the zeta series be pushed through the series?

All statements below are exact (integer/rational) or plain floating-point
illustrations; no asymptotic claim is inferred from a finite computation.

Run:  python3 decomposition_lab_zeta_probe.py
"""
import math, cmath, time
from fractions import Fraction as F

# ============================================================ greedy (lab sec 2)
def greedy_pairs(n, step_cap=6000, digit_cap=1_500_000):
    """Greedy Egyptian expansion of the integer n, distinct denominators >= 1.

    Integer-pair arithmetic (no Fraction gcd): the remainder is num/den.
    Stops early if the denominator exceeds ``digit_cap`` bits (the tail is
    Sylvester-like and its denominators grow doubly exponentially)."""
    ds = []
    num, den, d = n, 1, 1
    while num and len(ds) < step_cap and den.bit_length() < digit_cap:
        d = max(d, -(-den // num))          # d = max(d, ceil(den/num))
        ds.append(d)
        num, den = num * d - den, den * d   # r <- r - 1/d
        d += 1
    return ds, num, den

def digits(x):
    return int(x.bit_length() / math.log2(10)) + 1

def H(k):
    return sum(F(1, i) for i in range(1, k + 1))

def k_of(n):
    """largest k with H_k <= n  (the length of the initial block 1..k in D(n))."""
    k, s = 1, F(1, 1)
    while s + F(1, k + 1) <= n:
        k += 1
        s += F(1, k)
    return k

# ============================================================ promotion (lab 2/3)
def promote_counts(counts):
    """Promote k copies of 1/d to the largest admissible 1/e (greedy).
    Returns (new counts, number of moves).  Value-preserving."""
    c = {d: k for d, k in counts.items() if k}
    moves = 0
    changed = True
    while changed:
        changed = False
        for d in sorted(c, reverse=True):
            if c.get(d, 0) <= 0:
                continue
            for e in sorted(c, reverse=True):
                if e >= d:
                    continue
                g = math.gcd(d, e)
                k, j = d // g, e // g
                if k > 1 and c.get(d, 0) >= k:
                    t = c[d] // k
                    c[d] -= t * k
                    c[e] = c.get(e, 0) + t * j
                    moves += 1
                    changed = True
                    break
            if changed:
                break
    return {d: k for d, k in c.items() if k}, moves

def value(counts):
    return sum(F(k, d) for d, k in counts.items())

# ================================================================ P1
print("=" * 78)
print("P1. Greedy Egyptian expansion of the integer n (lab sec 2, start d=1)")
print("    term count ~ e^(n-gamma); last denominator doubly exponentially large")
print("=" * 78)
print(f"{'n':>3} {'#terms':>9} {'H_k<=n, k':>10} {'e^(n-gamma)':>12} {'last denom (digits)':>21}")
for n in range(1, 8):
    t0 = time.time()
    ds, num, den = greedy_pairs(n)
    e = math.exp(n - 0.5772156649015329)
    last = f"{digits(ds[-1]):,}" if ds else "0"
    flag = "" if num == 0 else "  (stopped early: tail cannot be written down)"
    print(f"{n:>3} {len(ds):>9} {k_of(n):>10} {e:>12.3g} {last:>21}{flag}")
    if n <= 4:
        print("      D =", ds)
    if n == 4:
        print("      (the last denominator already has 44 digits)")

# ================================================================ P2
print()
print("=" * 78)
print("P2. Membership  a_d(n) = 1[d in D(n)]  is a step function of n, not periodic")
print("    d in D(n)  <=>  d <= k(n)  (initial block); k(n) ~ e^(n-gamma)")
print("=" * 78)
Ns = 6
D = {n: set(greedy_pairs(n, step_cap=400, digit_cap=200_000)[0]) for n in range(1, Ns + 1)}
for d in (2, 3, 4, 5, 10, 20, 40, 80):
    first = next((n for n in range(1, Ns + 1) if d in D[n]), None)
    row = " ".join("1" if d in D[n] else "." for n in range(1, Ns + 1))
    print(f"  d={d:>3}  first n={str(first):>4}   n=1..{Ns}: {row}")
print("  k(n):", {n: k_of(n) for n in range(1, Ns + 1)})
print("  => membership is a threshold in n, eventually constant 1.  No q>1 makes")
print("     a_d q-periodic in n, so the index-regrouping has no finite Fourier")
print("     (character) expansion -- unlike the residue-class twist of 007.")

# ================================================================ P3
print()
print("=" * 78)
print("P3. Promotion is vacuous on one integer; it only bites when several")
print("    integers are pooled, and then it forgets which n contributed what")
print("=" * 78)
for n in range(1, 5):
    ds, _, _ = greedy_pairs(n)
    counts = {}
    for d in ds:
        counts[d] = counts.get(d, 0) + 1
    after, moves = promote_counts(counts)
    print(f"  single n={n}: distinct denominators only, so moves={moves} "
          f"(nothing to promote)")
A = range(1, 6)
pooled = {}
for n in A:
    for d in greedy_pairs(n, step_cap=400, digit_cap=200_000)[0]:
        pooled[d] = pooled.get(d, 0) + 1
prom, moves = promote_counts(pooled)
print(f"  pooled A={list(A)}: sum={float(value(pooled)):.1f} = "
      f"{float(value(prom)):.1f} after {moves} promotion moves; "
      f"#groups {len(pooled)} -> {len(prom)}")
print(f"    e.g. 1/2 had {pooled.get(2,0)} copies -> {prom.get(2,0)} copies of 1/2")
print("  => the promoted representation carries the *total* sum only; the")
print("     attribution to each n (hence each phase n^{-it}) is destroyed.")

# ================================================================ P4
print()
print("=" * 78)
print("P4. Egyptian-tier Dirichlet series  Z(s) = sum_d c_d d^-s,  A = {1..N}")
print("    By construction Z(1) = sum_{n<=N} n, supported on ~e^N denominators")
print("=" * 78)
for N in range(1, 5):
    counts = {}
    for n in range(1, N + 1):
        for d in set(greedy_pairs(n, step_cap=200, digit_cap=100_000)[0]):
            counts[d] = counts.get(d, 0) + 1
    print(f"  N={N}: Z(1)={float(value(counts)):>7.1f}  N(N+1)/2={N*(N+1)//2:>3}  "
          f"#distinct d={len(counts):>5}  max d: {digits(max(counts))} digits")
    # value of the Egyptian-tier series at s = 1/2 + i*gamma_1
    g1 = 14.134725141734693
    Z = sum(k * cmath.exp(-(0.5 + 1j * g1) * cmath.log(d)) for d, k in counts.items())
    print(f"         Z(1/2+i*gamma_1) = {Z.real:+.6f}{Z.imag:+.6f}i   "
          f"(zeta(1/2+i*gamma_1)=0 by definition of gamma_1)")

# ================================================================ P5
print()
print("=" * 78)
print("P5. The tier that DOES carry zero information: the prime-power tier")
print("    log zeta(s) = sum_{n>=2} Lambda(n)/(log n) n^-s  (von Mangoldt)")
print("=" * 78)
import mpmath as mp
mp.mp.dps = 30
def von_mangoldt(N):
    lam = [0.0] * (N + 1)
    sieve = bytearray([1]) * (N + 1)
    sieve[0:2] = b"\x00\x00"
    for p in range(2, int(N ** 0.5) + 1):
        if sieve[p]:
            sieve[p * p::p] = bytearray(len(sieve[p * p::p]))
    for p in range(2, N + 1):
        if sieve[p]:
            pk = p
            while pk <= N:
                lam[pk] = math.log(p)
                pk *= p
    return lam
Lam = von_mangoldt(200000)
for s in (mp.mpf(2), mp.mpf("1.5"), mp.mpf(1) + mp.mpf("0.5") * 1j):
    lhs = mp.log(mp.zeta(s))
    rhs = mp.mpf(0)
    for n in range(2, len(Lam)):
        if Lam[n]:
            rhs += Lam[n] / math.log(n) * mp.power(n, -s)
    print(f"  s={mp.nstr(s,10):>22}:  |log zeta(s) - sum| = {mp.nstr(abs(lhs-rhs),4)}")

# ================================================================ P6
print()
print("=" * 78)
print("P6. No finite partial sum of the zeta series vanishes at a zero")
print("    |S_N(1/2+i*gamma_1)| ~ 0.0707*sqrt(N)  (rh43 Thm 4.1)")
print("=" * 78)
g1 = 14.134725141734693
print(f"{'N':>8} {'|S_N(1/2+i g1)|':>18} {'|S_N|/sqrt(N)':>16}")
for N in (10**2, 10**3, 10**4, 10**5, 10**6):
    S = sum(cmath.exp(-(0.5 + 1j * g1) * math.log(n)) for n in range(1, N + 1))
    print(f"{N:>8} {abs(S):>18.6f} {abs(S)/math.sqrt(N):>16.6f}")
print("  (grows like 0.0707*sqrt(N): the zero lives in the Euler-Maclaurin")
print("   tail, not in the terms -- so no term-level partition can locate it.)")
