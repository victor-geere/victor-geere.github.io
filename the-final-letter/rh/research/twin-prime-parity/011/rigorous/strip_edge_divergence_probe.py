#!/usr/bin/env python3
"""strip_edge_divergence_probe.py -- is the horizontal-edge integral of the interface finite?

CriticalStripLogDerivBound (011/lean/DirichletZeroCounting.lean) asserts, for ALL t0 < t1 and T,
    (integral over x in [1/2,1] of ||logDeriv Lambda_chi (x + t0*i)||)  + (vertical) + (same at t1)
      <= C (1 + log(N(T+2))) (1 + |t1 - t0|).

The horizontal edges are the line segments Im z = t0 and Im z = t1, Re z in [1/2,1].
logDeriv of a completed L-function has a SIMPLE POLE at every zero rho of the completed L-function.
So if some zero rho has Im rho = t0 (or t1) and Re rho in [1/2,1], the integrand has a 1/|x - Re rho|
singularity on the path.  A 1D integral of 1/|x - x0| over an interval CONTAINING x0 diverges
logarithmically; in the measure-theoretic (Mathlib) reading the integral is then 0 because the
function is not integrable.

This script measures the divergence for zeta: at the critical-line zero rho_1 = 1/2 + i*gamma_1 the
edge integral over [1/2+eps, 1] behaves like log(1/eps); at a generic height it stays bounded.

Run: python3 strip_edge_divergence_probe.py   (deterministic; mpmath, dps=20)
"""
from mpmath import mp, mpf, mpc, log, zetazero, diff, quad, nstr
mp.dps = 20

g1 = zetazero(1).imag          # = 14.1347251417...
X0 = mpf(1)/2

def logderiv(s):
    return diff(lambda z: mp.zeta(z), s) / mp.zeta(s)

def edge_integral(t, eps):
    f = lambda x: abs(logderiv(mpc(x, t)))
    return quad(f, [X0 + eps, mpf(1)], maxdegree=8)

print("zero ordinate gamma_1 =", nstr(g1, 12))
print("closed-form prediction for a simple zero at Re = 1/2:")
print("   int_{1/2+eps}^{1} dx/|x-1/2| = log(1/(2 eps))")
print()
print(f"{'height':>26} {'eps':>8} {'edge integral':>18} {'minus log(1/(2eps))':>22}")
print("-"*78)
for label, t in [("t = gamma_1 (AT the zero)", g1), ("t = gamma_1 + 1 (generic)", g1 + 1)]:
    for e in [mpf(10)**-2, mpf(10)**-4, mpf(10)**-6, mpf(10)**-8]:
        val = edge_integral(t, e)
        pred = log(1/(2*e))
        print(f"{label:>26} {nstr(e,2):>8} {nstr(val,10):>18} {nstr(val-pred,6):>22}")

print()
print("VERDICT (measured)")
print("  * at t = gamma_1 the edge integral GROWS like log(1/eps) as eps -> 0: it is not")
print("    integrable on [1/2,1] -- the singularity sits exactly at the endpoint Re = 1/2;")
print("  * at a generic height it is bounded and O(1);")
print("  * so the interface's horizontal-edge integrals are *divergent* whenever t0 or t1 is")
print("    the ordinate of a zero of the completed L-function with Re in [1/2,1].  Under the")
print("    Mathlib convention int of a non-integrable function = 0, the interface holds")
print("    vacuously at those heights and carries no information there; read as an improper")
print("    integral it is FALSE there.")
print("  * the interface quantifies over ALL t0 < t1, so the exceptional heights are included.")
