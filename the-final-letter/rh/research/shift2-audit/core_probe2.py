"""
core_probe2.py -- second-round probes for the shift-2 audit.

Focus: (a) exact algebraic identities relating the core to polynomial sums;
       (b) "constancy / run-length" statistics, which are the exact quantity that
           MR's short-interval machinery bites on when it proves |mean| <= 1-delta;
       (c) bias of the core sequence.

Everything is finite-range; nothing here decides o(x).
"""

import sys, time
import numpy as np

N = int(sys.argv[1]) if len(sys.argv) > 1 else 10**8
t0 = time.time()


def liouville_sieve(N):
    lam = np.ones(N + 1, dtype=np.int8)
    rem = np.arange(N + 1, dtype=np.int64)
    r = int(N**0.5) + 1
    sieve = np.ones(r + 1, dtype=bool); sieve[:2] = False
    for i in range(2, int(r**0.5) + 1):
        if sieve[i]:
            sieve[i * i :: i] = False
    for p in np.nonzero(sieve)[0]:
        pk = int(p)
        while pk <= N:
            s = slice(pk, N + 1, pk)
            lam[s] *= -1
            rem[s] //= p
            pk *= p
    lam[rem > 1] *= -1
    lam[0] = 0
    return lam


lam = liouville_sieve(N)
print(f"N={N}  [sieve {time.time()-t0:.1f}s]")

# ---------- (a) identity 1: sum_{m=2}^{x+1} lambda(m^2-1) = S_2(x) exactly ----
Xmax = int((N + 1) ** 0.5) - 1
m = np.arange(2, Xmax + 2, dtype=np.int64)
poly = np.cumsum(lam[m * m - 1].astype(np.int64))          # index j <-> m = j+2
S2 = np.cumsum((lam[1 : Xmax + 2] * lam[3 : Xmax + 4]).astype(np.int64))
print("\n(a1) exact identity  sum_{m<=x+1} lam(m^2-1)  ==  S_2(x) ?")
for x in [10, 100, 1000, 5000, Xmax]:
    lhs = int(poly[x - 2]) if x >= 2 else 0     # m = 2..x+1
    rhs = int(S2[x - 1])
    print(f"   x={x:>7}  poly={lhs:>7}  S2={rhs:>7}  diff={lhs-rhs}")

# ---------- (a) identity 2: core autocorrelation = odd part of shift 4 -------
K2 = (N - 5) // 2
c = (lam[1 : 2 * K2 + 1 : 2] * lam[3 : 2 * K2 + 2 : 2]).astype(np.int64)   # c_k, k<=K2
lhs = np.cumsum(c[:-1] * c[1:])                                            # sum_{k<=K} c_k c_{k+1}
odd4 = (lam[1 : 2 * K2 : 2] * lam[5 : 2 * K2 + 4 : 2]).astype(np.int64)     # lam(2k-1)lam(2k+3)
rhs = np.cumsum(odd4)
print("\n(a2) exact identity  sum c_k c_{k+1}  ==  sum lam(2k-1)lam(2k+3) ?")
for K in [10, 1000, 10**6]:
    print(f"   K={K:>8}  lhs={int(lhs[K-1]):>8}  rhs={int(rhs[K-1]):>8}  diff={int(lhs[K-1]-rhs[K-1])}")

# ---------- (b) run-length structure: what MR's method can bite on ----------
def longest_run(seq):
    """longest run of +1 and longest run of -1 in a +-1 numpy array"""
    if len(seq) == 0:
        return 0, 0
    idx = np.flatnonzero(np.diff(seq) != 0)
    bounds = np.concatenate(([0], idx + 1, [len(seq)]))
    lens = np.diff(bounds)
    vals = seq[bounds[:-1]]
    return int(lens[vals == 1].max()), int(lens[vals == -1].max())

rng = np.random.default_rng(7)
print("\n(b) longest constant run (the quantity MR-type arguments contradict)")
print("    for a random +-1 sequence of length n, max run ~ log2(n) + O(1)")
n = len(c)
print(f"    core c_k = lam(2k-1)lam(2k+1),  n = {n}")
print(f"      longest run of +1 = {longest_run(c)[0]}, of -1 = {longest_run(c)[1]}   (log2 n = {np.log2(n):.1f})")
d = (lam[1 : n + 1] * lam[2 : n + 2]).astype(np.int64)  # shift-1 terms lam(n)lam(n+1)
print(f"    shift-1 terms lam(n)lam(n+1),  n = {n}")
print(f"      longest run of +1 = {longest_run(d)[0]}, of -1 = {longest_run(d)[1]}")
for t in range(3):
    r = rng.integers(0, 2, size=n) * 2 - 1
    print(f"    random control {t}: longest +1 run = {longest_run(r)[0]}, longest -1 run = {longest_run(r)[1]}")

# ---------- (c) bias over dyadic blocks -------------------------------------
print("\n(c) fraction of +1 in c_k, overall and per dyadic block")
print(f"    overall: {(c>0).mean():.5f}   (1/2 => {(c>0).mean()-0.5:+.5f})")
print(f"{'j':>4} {'len':>12} {'frac +1':>10} {'sqrt(len)*(frac-1/2)':>22}")
for j in range(3, int(np.log2(n)) + 1):
    lo, hi = 2**j, min(2 ** (j + 1), n)
    blk = c[lo:hi]
    f = (blk > 0).mean()
    print(f"{j:>4} {len(blk):>12} {f:>10.5f} {np.sqrt(len(blk))*(f-0.5):>22.3f}")

print(f"\n[done] {time.time()-t0:.1f}s")
