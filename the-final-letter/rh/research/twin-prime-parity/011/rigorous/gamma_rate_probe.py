#!/usr/bin/env python3
"""gamma_rate_probe.py -- quantify the archimedean rate gap that O1.T6/O1.T5 rest on.

The true asymptotic (Stirling) is
    |Gamma(sigma + i t)| ~ sqrt(2 pi) |t|^(sigma - 1/2) exp(-(pi/2)|t|),
so the *sharp* rate in the exponential is c* = pi/2 = 1.5707963...

The question this script answers numerically:
  (1) confirm c* from the exact Gamma;
  (2) what rate does the committed GammaSeq bound actually deliver?
      Norm bound:  ||GammaSeq s n|| <= (1/sigma) * N! / |t|^N,  N = ceil|t|
      (Mathlib-free restatement of GammaBounds.norm_GammaSeq_le_eventually),
      i.e. rate c_GammaSeq = -log( N!/|t|^N ) / |t|  -> 1;
  (3) how much of the gap is the *product* term the bound discards, i.e.
      sum_{j<=n} log sqrt((sigma+j)^2+t^2) - (n+1) log|t|  ~  (pi/2)|t| ?

Output: a table over t in {10, 30, 100, 300, 1000} for sigma = 1/2 and 1.
Deterministic; no randomness.  Run: python3 gamma_rate_probe.py
"""
from mpmath import mp, mpf, log, sqrt, exp, pi, gamma, ceil, nstr, factorial
mp.dps = 30

SIGMAS = [mpf(1)/2, mpf(1)]
TS = [10, 30, 100, 300, 1000]

def sharp_rate(sigma, t):
    """-(1/|t|) log( |Gamma| / |t|^(sigma-1/2) ) -- should -> pi/2."""
    g = abs(gamma(mp.mpc(sigma, t)))
    return -(log(g) - (sigma - mpf(1)/2)*log(t)) / t

def gammaseq_rate(sigma, t):
    """rate delivered by the committed GammaSeq bound: -(1/|t|) log( N!/|t|^N )."""
    N = int(ceil(t))
    return -(log(factorial(N)) - N*log(t)) / t

def product_shift(sigma, t):
    """sum_{j<=n} log sqrt((sigma+j)^2+t^2) - (n+1) log t  at n = ceil|t|."""
    N = int(ceil(t))
    s = mpf(0)
    for j in range(N+1):
        s += mpf(1)/2 * log((sigma+j)**2 + t**2)
    return s - (N+1)*log(t)

print("sharp rate c* = pi/2 =", nstr(pi/2, 12))
print()
hdr = f"{'t':>6} {'sharp(1/2)':>12} {'sharp(1)':>10} {'GammaSeq':>10} {'prodshift(1/2)':>16} {'/t':>8}"
print(hdr); print("-"*len(hdr))
for t in TS:
    T = mpf(t)
    a, b = sharp_rate(SIGMAS[0], T), sharp_rate(SIGMAS[1], T)
    c = gammaseq_rate(SIGMAS[0], T)
    ps = product_shift(SIGMAS[0], T)
    print(f"{t:>6} {nstr(a,8):>12} {nstr(b,8):>10} {nstr(c,8):>10} {nstr(ps,10):>16} {nstr(ps/T,8):>8}")

print()
print("VERDICT  (measured, and it refutes the natural hypothesis)")
print("  * the sharp rate is pi/2 = 1.5707963..., and the exact Gamma attains it;")
print("  * the committed GammaSeq bound delivers rate -> 1  (n!/|t|^n, n = ceil|t|);")
print("  * the product shift  sum_{j<=n} log sqrt((sigma+j)^2+t^2) - (n+1)log|t|")
print("    is  ~0.132*|t|, NOT (pi/2)|t| -- so the discarded product mass accounts")
print("    for only a small part of the gap;")
print("  * consequently the *diagonal* rate of GammaSeq at n = ceil|t| is only")
print("      1 + 0.132 = 1.132,  still far below pi/2 = 1.571.")
print()
print("  => ANY bound on ||GammaSeq|| uniform in n >= ceil|t| (which is what")
print("     GammaBounds.norm_GammaSeq_le_eventually gives, and what")
print("     norm_Gamma_le_of_GammaSeq_bound consumes) is capped at rate 1: the")
print("     sharp rate lives in the limit n -> infinity for fixed t, which is")
print("     exactly the content of Stirling.  The GammaSeq route is therefore")
print("     CLOSED as a path to the sharp rate; see research-journal.md 265/266.")
