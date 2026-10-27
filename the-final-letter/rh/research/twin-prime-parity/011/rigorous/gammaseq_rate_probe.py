#!/usr/bin/env python3
"""gammaseq_rate_probe.py -- where does the sharp rate pi/2 come from, now that Stirling is allowed?

SETTING.  GammaSeq(s, n) = n^s * n! / prod_{k=0}^{n} (s+k), and the committed bound is
    ||GammaSeq(s,n)|| <= (1/sigma) * n! / |t|^n      (journal 266 measured its rate -> 1).
With Stirling now AUTHORISED, n! may be replaced by its asymptotics.

TWO DIFFERENT EXPONENTIAL RATES, and this script separates them:

  (A) n = ceil|t|, i.e. the LARGE-SIGMA-or-small-n regime.  Then
        log(n!/|t|^n) ~ n log n - n - n log|t| ~ -n   (since n ~ |t|),
      a rate of exactly 1.  The PRODUCT contributes the integral
        int_0^1 log sqrt(x^2+1) dx = (1/2)(log 2 - 2 + pi/2) = 0.1323...
      (journal 266 measured 0.132).  So this regime gives rate 1 + 0.1323 = 1.1323, NOT pi/2.

  (B) n -> infinity with |t| FIXED, i.e. the limit that defines Gamma.  Here
        log Gamma(s) = lim_n [ s log n + log n! - sum_{k=0}^n log(s+k) ],
      and the sharp rate comes from Re(s log s) = sigma log|s| - |t| * arg(s) with arg(s) -> pi/2,
      i.e. the EXPONENTIAL rate is supplied by the ARGUMENT of s, not by the factorial.

This script checks (A) numerically against the closed form 0.1323, and confirms (B) by comparing the
exact ||Gamma|| rate pi/2 with what the two regimes attribute to it.

Deterministic (mpmath, dps=20).  Run: python3 gammaseq_rate_probe.py
"""
from mpmath import mp, mpf, log, pi, sqrt, quad, gamma, nstr
mp.dps = 20

closed = (log(2) - 2 + pi / 2) / 2
num = quad(lambda x: log(sqrt(x * x + 1)), [0, 1])
print("(A) the product mass of the n ~ |t| regime")
print("    closed form (1/2)(log2 - 2 + pi/2) = %s" % nstr(closed, 12))
print("    direct integral int_0^1 log sqrt(x^2+1) dx = %s" % nstr(num, 12))
print("    journal 266 measured 0.132 -> consistent: rate = 1 + %s = %s, NOT pi/2 = %s"
      % (nstr(closed, 6), nstr(1 + closed, 8), nstr(pi / 2, 8)))
print()
print("(B) the asymptotic regime: |Gamma(sigma+it)| ~ sqrt(2pi)|t|^(sigma-1/2) e^(-pi|t|/2)")
print("    so the EXPONENTIAL rate is pi/2, and it must come from Re(s log s), whose")
print("    -|t|arg(s) term tends to -|t| pi/2.  Check against exact |Gamma|:")
print("%10s %10s %22s %12s" % ("t", "sigma", "|Gamma(sigma+it)|", "rate/rpi2"))
print("-" * 60)
for t in [20, 100, 400]:
    for sigma in [mpf("0.25"), mpf("1.0")]:
        v = abs(gamma(mp.tmpc if False else __import__("mpmath").mpc(sigma, t)))
        logfit = -log(v) / t
        print("%10d %10s %22s %12s" % (t, nstr(sigma, 4), nstr(v, 8), nstr(logfit / (pi / 2), 6)))
print()
print("VERDICT")
print("  * regime (A) (n ~ |t|) caps out at rate 1 + 0.1323 = 1.1323 -- strictly below pi/2 = 1.5708.")
print("    So replacing n! by Stirling does NOT by itself reach the sharp rate; journal 266's")
print("    finding is confirmed and its 0.132 constant is now IDENTIFIED as the integral above.")
print("  * regime (B) (n -> infinity, |t| fixed) is where pi/2 lives: it is the -|t|arg(s) term of")
print("    Re(s log s), i.e. an ARGUMENT effect, and the rate/target column above tends to 1.")
print("  * CONSEQUENCE for T6 now that Stirling is authorised: the route is not 'Stirling on n!'")
print("    (that gives 1.1323) but the n -> infinity LIMIT of the product sum, i.e. real-analysis")
print("    work of Euler-Maclaurin type on sum_{k<=n} log|s+k| with the arg(s) -> pi/2 limit.")
print("    Mathlib supplies Stirling for n! (Analysis/SpecialFunctions/Stirling.lean:")
print("    factorial_isEquivalent_stirling, le_factorial_stirling, sqrt_pi_le_stirlingSeq) but")
print("    nothing for that limit, so the limit is the new work.")
