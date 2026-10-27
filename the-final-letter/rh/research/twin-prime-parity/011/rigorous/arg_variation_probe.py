#!/usr/bin/env python3
"""arg_variation_probe.py -- is Var(arg Lambda) along a horizontal edge controlled, or is it the count?

Journal 313 retracted journal 312's claim that the total-variation route for hH is free of the zero
count, on the grounds that total variation is an OSCILLATION quantity (sin(1000x) has range 2 and
variation 2000) and therefore is not controlled by the strip bounds.

This script makes that an argument-with-evidence rather than an argument.  Along the horizontal
segment sigma in [1/2, 1] at height t:

    LogDeriv Lambda = LogDeriv Gamma_R + zeta'/zeta,
    Im(LogDeriv Lambda) = d/dsigma arg Lambda,

so integrating |Im(LogDeriv Lambda)| in sigma gives the ARGUMENT VARIATION exactly.  We measure it,
next to the FULL integral that hH must bound, and compare both with log t.

For Lambda = pi^{-s/2} Gamma(s/2) zeta(s) (Nz = 1, trivial character) we use the stable form
    LogDeriv Gamma_R(s) = -(1/2) log pi + (1/2) psi(s/2)
from journal 273 (never form deriv f / f numerically for Gamma-like f -- journal 280).

Heights are taken at MIDPOINTS of consecutive zeta zeros, i.e. zero-free, which is where hH's
integrable case lives.

Deterministic (mpmath, dps=20).  Run: python3 arg_variation_probe.py
"""
from mpmath import mp, mpf, mpc, log, pi, digamma, zeta, zetazero, diff, quad, nstr
mp.dps = 20

def logderiv_triv(s):
    """-(1/2) log pi + (1/2) psi(s/2): the stable LogDeriv Gamma_R."""
    return -mpf(1) / 2 * log(pi) + mpf(1) / 2 * digamma(s / 2)

def landau(s):
    """LogDeriv(Lambda)(s) = LogDeriv Gamma_R(s) + zeta'/zeta(s)."""
    return logderiv_triv(s) + diff(zeta, s) / zeta(s)

def var_arg(t):
    """int_{1/2}^{1} |Im(LogDeriv Lambda(sigma + it))| d sigma = the argument variation."""
    return quad(lambda x: abs(landau(mpc(x, t)).imag), [mpf(1) / 2, mpf(1)], maxdegree=8)

def var_full(t):
    """int_{1/2}^{1} ||LogDeriv Lambda(sigma + it)|| d sigma -- what hH must bound."""
    return quad(lambda x: abs(landau(mpc(x, t))), [mpf(1) / 2, mpf(1)], maxdegree=8)

# zero-free heights: midpoints of consecutive zeta-zero ordinates
g = [zetazero(k).imag for k in range(1, 13)]
mids = [(g[k] + g[k + 1]) / 2 for k in range(len(g) - 1)]

print("argument variation vs the full integral on the horizontal edge [1/2,1], at zero-free heights")
print("%10s %10s %16s %16s %12s %12s"
      % ("t", "log t", "Var(arg Lambda)", "int ||Lambda'/Lambda||", "Var/log t", "full/log t"))
print("-" * 82)
for t in mids:
    va, vf, lt = var_arg(t), var_full(t), log(t)
    print("%10s %10s %16s %16s %12s %12s"
          % (nstr(t, 8), nstr(lt, 6), nstr(va, 8), nstr(vf, 8),
             nstr(va / lt, 6), nstr(vf / lt, 6)))

print()
print("VERDICT")
print("  * read the two ratio columns: if either stays bounded as t grows, the corresponding")
print("    quantity is a genuine O(log t) and the interface's hH shape is plausible for it;")
print("  * the ARGUMENT VARIATION is the column journal 313 predicts is NOT controlled by the")
print("    strip bounds, because total variation is an oscillation quantity;")
print("  * this is a SMALL-t window (the first 12 zeta zeros, t up to ~60).  If the ratios look")
print("    bounded here that is NOT evidence of O(log t) at scale -- it is only evidence about")
print("    whether the variation behaves like the full integral or like something much larger.")
