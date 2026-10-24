#!/usr/bin/env python3
"""shift_two_split_check.py — numerical cross-check of the machine-checked parity split
(ConeLean.chowlaSum_shift_two_split).

    sum_{n < 2M} lam(n) lam(n+2)  ==  sum_{j < M} lam(j) lam(j+1)  +  sum_{k < M} lam(2k+1) lam(2k+3)

The Lean theorem is the proof; this only checks that the statement I formalised is the statement I
think it is, on real data.  Independent implementation (direct array slicing, no shared code path
with the Lean proof).
"""
import numpy as np, importlib.util

spec = importlib.util.spec_from_file_location("es", "exceptional_set.py")
es = importlib.util.module_from_spec(spec); spec.loader.exec_module(es)

N = 2 ** 22
lam = es.liouville_sieve(N).astype(np.int64)

ok = True
print("[split] cross-check of ConeLean.chowlaSum_shift_two_split")
for M in (1, 2, 7, 100, 1000, 10 ** 5, 10 ** 6):
    lhs = int(np.sum(lam[0:2 * M] * lam[2:2 * M + 2]))
    rhs1 = int(np.sum(lam[0:M] * lam[1:M + 1]))
    rhs2 = int(np.sum(lam[1:2 * M:2] * lam[3:2 * M + 2:2]))
    good = (lhs == rhs1 + rhs2)
    ok &= good
    print(f"[split] M = {M:>8d}:  LHS = {lhs:>9d}   h=1 part = {rhs1:>9d}   "
          f"core part = {rhs2:>9d}   difference = {lhs - rhs1 - rhs2}   {'OK' if good else 'MISMATCH'}")
print(f"[split] all checks passed: {ok}")

# how does the core behave, against a random +-1 sequence of the same length?
M = 2 ** 20                      # keep 2M+2 <= N so both slices have length M
core = lam[1:2 * M:2] * lam[3:2 * M + 2:2]
rng = np.random.default_rng(7)
rc = rng.choice(np.array([-1, 1], dtype=np.int64), size=M)
for name, a in (("core", core), ("random", rc)):
    S = np.cumsum(a)
    G = np.arange(1, M + 1, dtype=np.float64)
    d = S / np.sqrt(G)
    print(f"[split] {name:6s}: S(M)/sqrt(M) = {d[-1]:+.3f}   max|d| = {np.max(np.abs(d)):.3f}   "
          f"mean = {a.mean():+.5f}")
print("[split] HEURISTIC: finite-range only; no finite computation decides o(K).")
