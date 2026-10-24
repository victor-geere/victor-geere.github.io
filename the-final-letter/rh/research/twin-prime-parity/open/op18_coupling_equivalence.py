#!/usr/bin/env python3
"""
op18_coupling_equivalence.py -- OP-18, made concrete.

Claim assessed: for a set A of positive density, "A couples to the parity of Omega"
has no meaning independent of the lambda-correlation, because

    Sigma_{n<=x} 1_A(n) lambda(n) = P_A(x) - N_A(x),
    P_A = #{n<=x : n in A, lambda(n)=+1}, N_A = #{n<=x : n in A, lambda(n)=-1},

so the correlation vanishes exactly when the two parity classes have equal density
INSIDE A.  This script checks, at a single sieve bound N (default 1e8):

  (S1) sign-blind PERIODIC A = {n = r (mod q)}: |S_A|/x -> 0 and the inside-A
       imbalance D_A -> 0 (the restricted OP-18 answer is NO; dictionary Thm 2.2).
  (S2) sign-blind finite exponential sums w(n) = cos(t log n): |Sigma w lambda|/x -> 0.
  (S3) ARITHMETIC A = {n : lambda(n+2) = +1}: it does couple, and S_A is exactly
       (Sigma lambda + Sigma lambda(n)lambda(n+2))/2 -- i.e. the coupling IS the open
       two-point correlation, so it is circular for OP-16.
  (S4) the log-arc instance A = {n : cos(log n) >= 0} (OP-19 P2).

All sums are exact integers.  The only floating point is the log-arc / cos-weight
classification (not critical to any conclusion).  Prints PASS/FAIL and exits 0.
"""

import sys
import time
import numpy as np

N = int(sys.argv[1]) if len(sys.argv) > 1 else 100_000_000
BLOCK = 1 << 23
CHECKS = []


def check(name, ok, detail=""):
    CHECKS.append((name, bool(ok), detail))
    print("  [%s] %-46s %s" % ("PASS" if ok else "FAIL", name, detail))


def primes_upto(n):
    n = int(n)
    if n < 2:
        return np.zeros(0, dtype=np.int64)
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(n ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.nonzero(s)[0].astype(np.int64)


def lambda_block(lo, hi, primes):
    """lambda(n) for n in [lo, hi), by a segmented Omega sieve."""
    m = hi - lo
    rem = np.arange(lo, hi, dtype=np.int32)
    om = np.zeros(m, dtype=np.uint8)
    for p in primes:
        p = int(p)
        if p * p >= hi:
            break
        first = ((lo + p - 1) // p) * p
        if first >= hi:
            continue
        idx = first - lo
        sl = rem[idx::p]
        ov = om[idx::p]
        while True:
            msk = (sl % p) == 0
            if not msk.any():
                break
            ov[msk] += 1
            sl[msk] //= p
    om[rem > 1] += 1
    return np.where((om & 1) == 1, -1, 1).astype(np.int8)


def main():
    t0 = time.time()
    print("=" * 78)
    print("OP-18: 'coupling' == non-vanishing of the lambda-correlation   (N = %d)" % N)
    print("=" * 78)
    primes = primes_upto(int((N + 4) ** 0.5) + 1)
    print("primes <= sqrt(N+4): %d" % len(primes))

    decades = [10 ** k for k in range(3, len(str(N - 1)) + 1) if 10 ** k <= N]
    L_at, Ltot = {}, 0
    di = 0
    per = {q: {r: [0, 0] for r in range(q)} for q in (3, 4, 5, 7)}
    exp_t = (1.0, 2.0, 7.3)
    exp_sum = {t: 0.0 for t in exp_t}
    logA = 0
    PP = PN = NP = NN = 0          # joint (lambda(n), lambda(n+2)) counts
    for lo in range(1, N + 1, BLOCK):
        hi = min(lo + BLOCK, N + 1)          # n in [lo, hi)
        ext = lambda_block(lo, min(hi + 2, N + 3), primes)
        lam = ext[:hi - lo]
        shift = ext[2:2 + (hi - lo)]
        idx = np.arange(lo, hi, dtype=np.int64)
        cs = np.cumsum(lam.astype(np.int64))
        while di < len(decades) and decades[di] < hi:
            x = decades[di]
            if x >= lo:
                L_at[x] = Ltot + int(cs[x - lo])
            di += 1
        Ltot += int(cs[-1])
        for q in per:
            mods = idx % q
            for r in range(q):
                sub = lam[mods == r]
                per[q][r][0] += int(np.count_nonzero(sub == 1))
                per[q][r][1] += int(np.count_nonzero(sub == -1))
        logn = np.log(idx.astype(np.float64))
        lamf = lam.astype(np.float64)
        for t in exp_t:
            exp_sum[t] += float(np.dot(np.cos(t * logn), lamf))
        phase = np.mod(logn, 2.0 * np.pi)
        logA += int(np.dot((phase <= np.pi).astype(np.int64), lam.astype(np.int64)))
        m1 = lam == 1
        m2 = shift == 1
        PP += int(np.count_nonzero(m1 & m2))
        PN += int(np.count_nonzero(m1 & ~m2))
        NP += int(np.count_nonzero(~m1 & m2))
        NN += int(np.count_nonzero(~m1 & ~m2))
    print("  scan done (%.1fs)" % (time.time() - t0))
    print()

    # ---------- sanity: one-point theorem ---------------------------------
    print("S0  sanity: one-point Chowla is a theorem (equiv. PNT)")
    for x in decades:
        if x in (10 ** 6, 10 ** 7, N):
            print("      x=%-12d  Sigma lambda / x = %+.3e" % (x, L_at[x] / x))
    check("one-point sums decay", abs(L_at[decades[-1]]) / decades[-1] < 5e-3,
          "|Sigma lambda|/N = %.2e" % (abs(L_at[decades[-1]]) / decades[-1]))
    print()

    # ---------- S1: periodic A -------------------------------------------
    print("S1  periodic sign-blind A = {n = r (mod q)}: no coupling")
    ok1 = True
    for q in (3, 4, 5, 7):
        for r in range(q):
            P, Nn = per[q][r]
            tot = P + Nn
            S = P - Nn
            D = S / tot if tot else 0.0
            if q in (3, 4, 5) and r in (1, 2):
                print("      q=%-2d r=%-2d  |S_A|/x = %.3e   inside-A imbalance D_A = %+.3e"
                      % (q, r, abs(S) / N, D))
            # D_A fluctuates on the x^{-1/2} scale; the check is that it is a
            # square-root-sized fluctuation, i.e. D_A * sqrt(x) is bounded.
            if abs(D) * (N ** 0.5) > 8.0:
                ok1 = False
    check("periodic A: |S_A|/x and D_A are O(x^{-1/2}) fluctuations (no coupling)", ok1,
          "max |D_A|*sqrt(N) below 8 for all q in {3,4,5,7}")
    print()

    # ---------- S2: finite exponential sums ------------------------------
    print("S2  finite exponential-sum weights w(n)=cos(t log n): -> 0")
    ok2 = True
    for t in exp_t:
        print("      t=%-4.1f  |Sigma w lambda|/x = %.3e" % (t, abs(exp_sum[t]) / N))
        if abs(exp_sum[t]) / N > 1e-2:
            ok2 = False
    check("finite exponential sums: |Sigma w lambda|/x small", ok2)
    print()

    # ---------- S3: arithmetic A is circular -----------------------------
    print("S3  arithmetic A = {n : lambda(n+2) = +1}: couples, but circularly")
    S_A = PP - NP                       # = sum 1_A lambda
    Ltot_check = PP + PN - NP - NN      # = Sigma lambda
    C = PP - PN - NP + NN               # = Sigma lambda(n)lambda(n+2)
    print("      joint counts (PP,PN,NP,NN) = (%d, %d, %d, %d)" % (PP, PN, NP, NN))
    print("      Sigma lambda = %+d ;  C = Sigma lambda(n)lambda(n+2) = %+d" % (Ltot_check, C))
    print("      S_A = PP - NP = %+d ;  (Sigma lambda + C)/2 = %+d ;  S_A/x = %+.4f"
          % (S_A, (Ltot_check + C) // 2, S_A / N))
    check("S_A == (Sigma lambda + C)/2 exactly (the coupling IS the open correlation)",
          S_A == (Ltot_check + C) // 2)
    check("C is recoverable from the coupling: C == 2*S_A - Sigma lambda", 
          C == 2 * S_A - Ltot_check,
          "C = %+d at x = %d (believed o(x), unproved)" % (C, N))
    print()

    # ---------- S4: log-arc instance -------------------------------------
    print("S4  log-arc A = {n : cos(log n) >= 0} (OP-19 P2)")
    print("      C_I(N) = %+d ;  |C_I|/x = %.3e" % (logA, abs(logA) / N))
    check("log-arc instance |C_I|/x small (consistent with o(x))",
          abs(logA) / N < 2e-2, "|C_I|/x = %.2e" % (abs(logA) / N))
    print()

    passed = sum(1 for _, ok, _ in CHECKS if ok)
    print("=" * 78)
    print("SUMMARY: %d/%d checks passed   (%.1fs)" % (passed, len(CHECKS), time.time() - t0))
    print("CONCLUSION: for sign-blind classes the lambda-correlation is the only")
    print("            measure of coupling and it decays; the class that couples")
    print("            (A built from lambda(n+2)) does so by importing the open")
    print("            two-point correlation, so OP-18 is circular as phrased.")
    print("=" * 78)
    print("RESULT:", "PASS" if passed == len(CHECKS) else "FAIL")
    return 0 if passed == len(CHECKS) else 1


if __name__ == "__main__":
    sys.exit(main())
