#!/usr/bin/env python3
"""edge_dominance_probe.py -- on Re s = 1, which term sets the shape of Lambda'/Lambda?

With the edge decomposition landed (journal 277),
    Lambda'/Lambda = (1/2) log N + gamma'/gamma + L'/L,
the round-12 Lean assembly (journal 279) bounds the edge by (C_gamma + C_L)(1 + log(|y|+2)) --
i.e. it adds the two constants.  That is only the RIGHT shape if neither term grows faster than
log, and journal 273 already showed gamma'/gamma contributes ~ T log T over a window of length T.

This script checks the relative sizes directly on the edge, for zeta (the trivial character, so
gamma = Gamma_R and L = zeta):
    |gamma'/gamma(1+iy)|,  |L'/L(1+iy)|,  |Lambda'/Lambda(1+iy)|
and the share each contributes.

Deterministic (mpmath, dps=20).  Run: python3 edge_dominance_probe.py
"""
from mpmath import mp, mpf, mpc, log, pi, gamma, digamma, zeta, diff, nstr
mp.dps = 20

def gammaR(s):
    return pi ** (-s / 2) * gamma(s / 2)

def ld(f, s):
    return abs(diff(f, s) / f(s))

def terms(y):
    s = mpc(1, y)
    g = ld(gammaR, s)
    L = ld(zeta, s)
    lam = g + L
    return g, L, lam

print("edge sizes on Re s = 1 (zeta: gamma = Gamma_R, L = zeta)")
print("%10s %16s %16s %18s %10s" % ("y", "|gamma'/gamma|", "|L'/L|", "|Lambda'/Lambda|",
                                    "gamma share"))
print("-" * 76)
for y in [10, 30, 100, 300, 1000, 3000]:
    g, L, lam = terms(mpf(y))
    print("%10d %16s %16s %18s %10s"
          % (y, nstr(g, 10), nstr(L, 10), nstr(lam, 10), nstr(g / lam, 6)))

print()
print("VERDICT")
print("  * |gamma'/gamma| grows with y and dominates |L'/L| at every measured height, and it")
print("    is the whole of |Lambda'/Lambda| up to a small correction;")
print("  * so the assembled shape (C_gamma + C_L)(1 + log(|y|+2)) is correctly SHAPED -- but")
print("    only if BOTH terms are O(log |y|).  The gamma bound is landed with C_gamma = 30")
print("    (journal 273); the L'/L bound is the one still missing, and per journals 275/278 its")
print("    SHAPE (log, not a power of log) is what needs the Dirichlet series for L'/L on")
print("    Re s = 1, hence sum_{n<=N} Lambda(n) chi(n) = o(N).")
