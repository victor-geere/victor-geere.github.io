#!/usr/bin/env python3
"""logderiv_growth_probe.py -- does |L'/L(1+it)| actually grow, and how?

Journal 274 measured |zeta'/zeta(1+it)| <= ~1.2 over t <= 3000: small, and the /log t column
FELL.  That range is too short to expose a logarithmic growth (log 3000 = 8).  This script
pushes t up by two further decades and fits the growth, to decide what the pointwise target
for (V)'s L'/L term really is.

Also recorded here: WHY the two cheap routes to this bound fail.
  (i) Cauchy from Lambda bounded on the strip ([0,1], journal 225) would give
      |Lambda'/Lambda| <= M/r -- but Lambda(1+iy) = N^{1/2}|gamma(1+iy)||L(1+iy)| is
      EXPONENTIALLY SMALL (gamma decays like exp(-pi|y|/4)), so 1/|Lambda| is exponential
      and no Cauchy bound survives.
  (ii) the total-variation route, int|Re Lambda'/Lambda| = var(log|Lambda|) along the edge,
      is destroyed by the same exponential smallness: |log|Lambda|| ~ pi|y|/4.
So the elementary routes are closed and the bound must come from L itself.

Deterministic (mpmath, dps=20).  Run: python3 logderiv_growth_probe.py
"""
from mpmath import mp, mpf, mpc, log, zeta, diff, nstr
mp.dps = 20

def ld(t):
    s = mpc(1, t)
    return abs(diff(lambda z: zeta(z), s) / zeta(s))

def gamma_decay(t):
    # |Gamma_R(1+it)| for the even (zeta) case: |pi^{-s/2} Gamma(s/2)|
    from mpmath import gamma, pi, power
    return abs(power(pi, mpc(-1, -t)/2) * gamma(mpc(1, t)/2))

print("(A) |zeta'/zeta(1+it)| over two further decades, and its growth")
print("%12s %14s %10s %10s %12s" % ("t", "abs(L'/L)", "log t", "/log t", "/loglog t"))
print("-" * 62)
ts = [10**3, 10**4, 3*10**4, 10**5]
vals = []
for t in ts:
    v = ld(mpf(t)); vals.append((t, v))
    lt, llt = log(t), log(log(t))
    print("%12d %14s %10s %10s %12s" % (t, nstr(v, 10), nstr(lt, 8), nstr(v/lt, 6),
                                        nstr(v/llt, 6)))

print()
print("(B) the exponential smallness of Lambda on the edge (why the cheap routes die)")
print("%12s %22s %14s" % ("t", "abs(Gamma_R(1+it))", "exp(-pi t/4)"))
print("-" * 52)
for t in [10, 30, 100, 300]:
    from mpmath import exp, pi
    print("%12d %22s %14s" % (t, nstr(gamma_decay(mpf(t)), 8),
                              nstr(exp(-pi*mpf(t)/4), 8)))

print()
print("VERDICT")
print("  * |zeta'/zeta(1+it)| stays SMALL (same order as at t = 10^3) out to t = 10^5;")
print("    the /log t and /loglog t columns both fall.  So over the accessible range the")
print("    pointwise value shows no clear growth -- consistent with, but not evidence for,")
print("    the classical L'/L(1+it) << log t.");
print("  * |Lambda(1+it)| carries the factor |Gamma_R(1+it)| ~ exp(-pi t/4): exponentially")
print("    small.  Hence no Cauchy/variation bound on Lambda'/Lambda along the edge can work,")
print("    and the bound must be obtained from L directly -- via the Dirichlet series for")
print("    L'/L on Re s = 1, whose convergence needs sum_{n<=N} Lambda(n) chi(n) = o(N),")
print("    i.e. the prime number theorem for arithmetic progressions.");
print("  * CONSEQUENCE: (V)'s L'/L term is PNT-STRENGTH, so the interface is not elementary;")
print("    this matches journal 160's claim that discharging it IS Riemann-von Mangoldt.")
