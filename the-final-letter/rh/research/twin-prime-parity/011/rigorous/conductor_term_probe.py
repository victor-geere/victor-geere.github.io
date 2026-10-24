#!/usr/bin/env python3
"""conductor_term_probe.py -- the conductor term in the edge bound (O1.T10 step 1).

dirichletCompleted chi s = N^(s/2) * completedLFunction chi s   (Generic.lean:250), so
    logDeriv (dirichletCompleted chi) s
        = (1/2) log N + logDeriv (completedLFunction chi) s,
and the interface's integrand completedLogDeriv chi is the LEFT side while the landed assembly
(journal 281) bounds the RIGHT side's second term.  Step 1 of O1.T10 is to attach (1/2) log N.

The point of this probe: (1/2) log N is CONSTANT IN y, so it can only shift the multiplicative
constant in the shape C(1 + log(|y|+2)) -- it must not change the SHAPE.  This script checks
that claim numerically over a spread of conductors N and heights y.

Deterministic.  Run: python3 conductor_term_probe.py
"""
from mpmath import mp, mpf, log, nstr
mp.dps = 20

print("the conductor term is y-INDEPENDENT: it shifts the constant, not the shape")
print("%8s %14s %12s %12s" % ("N", "(1/2)log N", "y", "y-part"))
print("-" * 50)
for N in [3, 12, 100, 1000, 10**6]:
    half = mpf(1) / 2 * log(N)
    ypart = "n/a (const)"
    print("%8d %14s %12s %12s" % (N, nstr(half, 10), "-", ypart))

print()
print("shape check: is (1/2)log N <= C(1 + log(|y|+2)) for C = 30 + (1/2)log N ?")
print("%8s %14s %12s %14s %10s" % ("N", "(1/2)log N", "y", "C(1+log(|y|+2))", "ok?"))
print("-" * 66)
ok = True
for N in [3, 1000, 10**6]:
    C = 30 + mpf(1) / 2 * log(N)
    for y in [0, 1, 10, 1000]:
        rhs = C * (1 + log(abs(y) + 2))
        good = (mpf(1) / 2 * log(N)) <= rhs
        ok = ok and good
        print("%8d %14s %12d %14s %10s"
              % (N, nstr(mpf(1) / 2 * log(N), 8), y, nstr(rhs, 10), "yes" if good else "NO"))

print()
print("VERDICT")
print("  * all shape checks pass (%s), so attaching the conductor term is a CONSTANT shift:"
      % ("yes" if ok else "NO"))
print("    (V)'s shape C(1 + log(|y|+2)) survives with C = 30 + C_L + (1/2)log N;")
print("  * so O1.T10 step 1 is purely the identity")
print("        logDeriv (dirichletCompleted chi) s")
print("            = (1/2) log N + logDeriv (completedLFunction chi) s")
print("    on Re s = 1 -- and it CANNOT be stated for general Re s > 0, because the proof needs")
print("    completedLFunction chi s != 0, i.e. L chi s != 0, which Mathlib supplies ONLY on the")
print("    line (LFunction_ne_zero_of_re_eq_one).  The edge case is exactly what the interface")
print("    needs, so this restriction is harmless -- and it is worth recording BEFORE writing the")
print("    Lean, since it fixes the statement's shape.")
