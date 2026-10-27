"""
core_probe.py -- numerical probes for the odd core C(K) = sum_{k<=K} lambda(2k-1)lambda(2k+1)
                  versus the shift-1 sum S_1(x) = sum_{n<=x} lambda(n)lambda(n+1).

Builds lambda up to N via an exact O(N log log N) numpy sieve (prime-power flips +
"large prime factor" flip), then reports:

  (1) the exact decomposition  S_2(x) = S_1(x/2) + C(x/2) + O(1)
      and the identity         sum_{m<=M} lambda(m^2-1) = S_2(M/2) + O(1)
  (2) normalised partial sums at a geometric grid of scales
  (3) random-walk-normalised running maxima  max_{K<=X} |C(K)|/sqrt(K)
  (4) dyadic-block decomposition  (is cancellation spread over scales?)
  (5) local (arithmetic-progression) bias of the core sequence
  (6) sanity: sum lambda(n)/n  (PNT check)

Everything is a finite-range statistic.  No finite computation decides o(x).
"""

import sys
import time
import numpy as np

N = int(sys.argv[1]) if len(sys.argv) > 1 else 10**8
t0 = time.time()


def liouville_sieve(N):
    """Return array lam[0..N] with lam[n] = (-1)^{Omega(n)}."""
    lam = np.ones(N + 1, dtype=np.int8)
    rem = np.arange(N + 1, dtype=np.int64)  # rem[n] will become n / (smooth part)
    r = int(N**0.5) + 1
    sieve = np.ones(r + 1, dtype=bool)
    sieve[:2] = False
    for i in range(2, int(r**0.5) + 1):
        if sieve[i]:
            sieve[i * i :: i] = False
    primes = np.nonzero(sieve)[0]
    for p in primes:
        pk = int(p)
        while pk <= N:
            s = slice(pk, N + 1, pk)
            lam[s] *= -1
            rem[s] //= p
            pk *= p
    nz = rem > 1  # exactly the n with a prime factor > sqrt(N)
    lam[nz] *= -1
    lam[0] = 0
    return lam


print(f"N = {N}")
lam = liouville_sieve(N)
print(f"[sieve]      {time.time()-t0:.1f}s")

# ---------------------------------------------------------------- sequences
n = np.arange(1, N + 1, dtype=np.int64)
# term1[n] = lam(n)lam(n+1), term2[n] = lam(n)lam(n+2)
term1 = (lam[1:N] * lam[2 : N + 1]).astype(np.int64)
term2 = (lam[1 : N - 1] * lam[3 : N + 1]).astype(np.int64)
# core term: c_k = lam(2k-1)lam(2k+1) for k = 1..(N-1)//2
Kmax = (N - 1) // 2
c = (lam[1 : 2 * Kmax : 2] * lam[3 : 2 * Kmax + 2 : 2]).astype(np.int64)
S1 = np.cumsum(term1)
S2 = np.cumsum(term2)
C = np.cumsum(c)
print(f"[cumsums]    {time.time()-t0:.1f}s  len(S2)={len(S2)} len(C)={len(C)}")

print("\n=== (1) exact reduction checks ===")
for x in [10**3, 10**5, 10**7]:
    lhs = int(S2[x - 1])
    xh = x // 2
    rhs = int(S1[xh - 1]) + int(C[xh - 1])
    print(f"  x={x:>10}: S_2(x)={lhs:>10}   S_1(x/2)+C(x/2)={rhs:>10}   diff={lhs-rhs}")

# sum_{m<=M} lam(m^2-1)  vs  S_2(M/2):  needs m^2-1 <= N
Mmax = int((N + 1) ** 0.5)
mm = np.arange(2, Mmax + 1, dtype=np.int64)
poly = np.cumsum(lam[mm * mm - 1].astype(np.int64))
for M in [100, 1000, Mmax]:
    if M - 1 <= len(poly):
        lhs = int(poly[M - 2])  # m = 2..M
        xh = M // 2
        rhs = int(S2[xh - 1])
        print(f"  M={M:>8}: sum_{{m<=M}} lam(m^2-1)={lhs:>8}   S_2(M/2)={rhs:>8}   diff={lhs-rhs}")

print("\n=== (2) normalised partial sums (the objects that must be o(1)) ===")
print(f"{'x':>12} {'S1(x)/x':>12} {'S2(x)/x':>12} {'S1/rt(x)':>10} {'S2/rt(x)':>10}")
xs = [10**3, 10**4, 10**5, 10**6, 10**7, 10**8, 2 * 10**7, 5 * 10**7]
for x in xs:
    if x <= len(S1):
        print(
            f"{x:>12} {S1[x-1]/x:>12.5f} {S2[x-1]/x:>12.5f} "
            f"{S1[x-1]/np.sqrt(x):>10.3f} {S2[x-1]/np.sqrt(x):>10.3f}"
        )
print(f"\n{'K':>12} {'C(K)/K':>12} {'C(K)/rt(K)':>12} {'max_{j<=K}|C|/rt(j)':>20}")
run = np.abs(C) / np.sqrt(np.arange(1, len(C) + 1))
runmax = np.maximum.accumulate(run)
for K in [10**3, 10**4, 10**5, 10**6, 10**7, Kmax // 2, Kmax]:
    if K <= len(C):
        print(f"{K:>12} {C[K-1]/K:>12.5f} {C[K-1]/np.sqrt(K):>12.3f} {runmax[K-1]:>20.3f}")

print("\n=== (3) random-walk control (iid +-1, same length as core) ===")
rng = np.random.default_rng(12345)
for trial in range(3):
    rc = rng.integers(0, 2, size=len(C)) * 2 - 1
    R = np.cumsum(rc)
    rm = np.maximum.accumulate(np.abs(R) / np.sqrt(np.arange(1, len(R) + 1)))
    print(
        f"  trial {trial}: |R(Kmax)|/rt(Kmax)={abs(R[-1])/np.sqrt(len(R)):.3f}  "
        f"max_K |R|/rt(K)={rm[-1]:.3f}  R(Kmax)/Kmax={R[-1]/len(R):.2e}"
    )
print("  (a true random walk has max_K |R|/sqrt(K) typically 1-3, and |R|/K -> 0)")

print("\n=== (4) dyadic blocks: where does the cancellation live? ===")
print("  block j = (2^j, 2^{j+1}];  'z' = block sum / sqrt(block length);  white noise: |z| ~ 1")
print(f"{'j':>4} {'block len':>12} {'core z':>9} {'shift1 z':>9} {'|C|/rt(K) at 2^j':>18}")
for j in range(3, int(np.log2(len(C))) + 1):
    lo, hi = 2**j, min(2 ** (j + 1), len(C))
    bc = int(c[lo - 1 : hi].sum())
    b1 = int(term1[lo - 1 : hi].sum())
    L = hi - lo
    print(
        f"{j:>4} {L:>12} {bc/np.sqrt(L):>9.3f} {b1/np.sqrt(L):>9.3f} "
        f"{abs(C[hi-1])/np.sqrt(hi):>18.3f}"
    )

print("\n=== (5) local bias of the core: max over residues mod q ===")
print("  z(q) = max_a |sum_{k<=K, k=a mod q} c(k)| / sqrt(K/q);  white noise: z ~ sqrt(2 log q)")
Kb = min(len(C), 2 * 10**7)
kk = np.arange(1, Kb + 1, dtype=np.int64)
cb = c[:Kb]
print(f"  K = {Kb}")
worst = []
for q in range(2, 121):
    sums = np.array([cb[a::q].sum() for a in range(q)], dtype=np.int64)
    z = np.abs(sums) / np.sqrt(Kb / q)
    worst.append((z.max(), q, int(np.argmax(np.abs(sums)))))
worst.sort(reverse=True)
print("  worst 6 (q, residue):", [(f"z={z:.2f}", f"q={q}", f"a={a}") for z, q, a in worst[:6]])
# calibration: same statistic on a random +-1 sequence
rc = rng.integers(0, 2, size=Kb) * 2 - 1
worst_r = []
for q in range(2, 121):
    sums = np.array([rc[a::q].sum() for a in range(q)], dtype=np.int64)
    worst_r.append(np.abs(sums).max() / np.sqrt(Kb / q))
worst_r.sort(reverse=True)
print(f"  random control: worst 3 z = {[round(v,2) for v in worst_r[:3]]}, median z = {np.median(worst_r):.2f}")

print("\n=== (6) sanity ===")
nz = np.arange(1, min(N, 10**7) + 1)
print(f"  sum_{{n<=1e7}} lam(n)/n = {np.sum(lam[1:10**7+1]/nz):.5f}   (PNT: -> 0)")

print(f"\n[done] {time.time()-t0:.1f}s")
