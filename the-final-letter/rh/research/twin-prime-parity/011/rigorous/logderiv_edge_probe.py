#!/usr/bin/env python3
"""logderiv_edge_probe.py -- how big is the L'/L term on the vertical edge Re s = 1?

(V) of the interface asks for
    int_{t0}^{t1} ||Lambda'/Lambda(1 + i y)|| dy  <=  C (1 + log(N(T+2))) (1 + |t1 - t0|),
and Lambda'/Lambda = (1/2) log N + (gamma'/gamma) + (L'/L).  Journal 273 measured the gamma
part and found it is ~ T log T over a window of length T -- it SATURATES the bound.  So the
question for L'/L is only whether it stays below the same order; the classical answer is far
stronger: int_0^T |zeta'/zeta(1+it)| dt = O(log^2 T), which is o(T log T).

This script measures both faces for zeta (the L'/L factor is the same object for a
nonprincipal character, up to the Dirichlet coefficients):
  (1) pointwise:  |zeta'/zeta(1+it)|  vs  log t
  (2) integral :  int_0^T |zeta'/zeta(1+it)| dt  vs  T, log T, log^2 T

Deterministic (mpmath, dps=20).  Run: python3 logderiv_edge_probe.py
"""
from mpmath import mp, mpf, mpc, log, zeta, diff, quad, nstr
mp.dps = 20

def ld(t):
    s = mpc(1, t)
    return abs(diff(lambda z: zeta(z), s) / zeta(s))

print("(1) pointwise |zeta'/zeta(1 + i t)| on the edge")
print("%10s %16s %10s %10s" % ("t", "abs(L'/L)", "log t", "/log t"))
print("-" * 50)
for t in [10, 30, 100, 300, 1000, 3000]:
    v = ld(mpf(t))
    print("%10d %16s %10s %10s" % (t, nstr(v, 10), nstr(log(t), 8), nstr(v / log(t), 8)))

print()
print("(2) integral  int_0^T |zeta'/zeta(1+it)| dt")
print("%6s %16s %10s %12s %14s" % ("T", "integral", "/ T", "/ log^2 T", "/ (T log T)"))
print("-" * 64)
for T in [10, 30, 100, 300, 1000]:
    val = quad(lambda t: ld(t), [mpf(1), mpf(T)], maxdegree=8)
    l2 = log(T) ** 2
    print("%6d %16s %10s %12s %14s"
          % (T, nstr(val, 10), nstr(val / T, 8), nstr(val / l2, 8),
             nstr(val / (T * log(T)), 8)))

print()
print("VERDICT  (measured; it corrects the guess I brought to this round)")
print("  * the integral is O(T), NOT O(log^2 T): the /T column is 0.23, 0.53, 0.74, 0.80, 0.81")
print("    (settling near 1), while the /log^2 T column diverges (0.44 -> 16.97).  So the")
print("    classical mean-square bound I recalled does NOT apply to this quantity; the edge")
print("    integral of L'/L is LINEAR in the window length.")
print("  * that is still LOWER ORDER than the gamma term, which journal 273 measured as")
print("    T log T.  So (V)'s order is set by gamma, and L'/L needs only to stay below it.")
print("  * pointwise the values stay well under log t over t <= 3000 (0.19 .. 1.21), i.e.")
print("    consistent with -- but no evidence for the growth rate of -- the classical")
print("    L'/L(1+it) << log t.  A pointwise logarithmic bound is the natural Lean target.")
print("  * CONSEQUENCE: it SUFFICES to prove ||L'/L(1+iy)|| <= C(1 + log(|y|+2)) pointwise;")
print("    integrating over [t0,t1] then gives C(1+log(T+2))|t1-t0|, the needed order.")
