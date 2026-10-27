#!/usr/bin/env python3
"""lower_bound_probe.py -- the QUANTITATIVE non-vanishing of L near the line, and its exponent.

Mathlib has (Nonvanishing.lean:310)

  norm_LFunction_product_ge_one {x : R} (hx : 0 < x) (y : R) :
      || L_triv(1+x)^3 * L_chi(1+x+I*y)^4 * L_{chi^2}(1+x+2*I*y) || >= 1

Together with the two elementary horizontal bounds in the same file --
L_triv(1+x) = O(1/x)  and  L_{chi^2}(1+x+2iy) = O(1) as x -> 0+ -- this gives
||L_chi(1+x+iy)||^4 >= c x^3, i.e.  ||L_chi(1+x+iy)|| >= c' x^{3/4}.

This script checks the exponent numerically on zeta (the trivial-character case, where the
same inequality gives the same exponent), by regressing log|zeta(1+x+iy)| on log x.

Deterministic (mpmath, dps=20).  Run: python3 lower_bound_probe.py
"""
from mpmath import mp, mpf, mpc, log, zeta, zetazero, nstr
mp.dps = 20

for y in [mpf(0), mpf("14.1347251417"), mpf(100)]:
    print("y = %s" % nstr(y, 12))
    print("%12s %18s %12s" % ("x", "abs(zeta(1+x+iy))", "log|.|/log x"))
    print("-" * 46)
    for x in [mpf("1e-1"), mpf("1e-2"), mpf("1e-3"), mpf("1e-4"), mpf("1e-5")]:
        v = abs(zeta(mpc(1 + x, y)))
        print("%12s %18s %12s" % (nstr(x, 2), nstr(v, 10), nstr(log(v) / log(x), 8)))
    print()

print("VERDICT  (measured; it refutes the exponent I predicted)")
print("  * for FIXED y != 0 the quantity |zeta(1+x+iy)| converges to a POSITIVE CONSTANT as")
print("    x -> 0+ (0.32622 at y = gamma_1; 1.63424 at y = 100), and the exponent")
print("    log|.|/log x goes to 0, NOT to -3/4.  That is non-vanishing made explicit: the")
print("    limit is |L(1+iy)| > 0.  So for each fixed y the lower bound is a constant c(y).")
print("  * the x^{3/4} shape (Mathlib's norm_LFunction_product_ge_one combined with the two")
print("    horizontal isBigO's) is the bound UNIFORM IN y -- needed exactly when y sits at a")
print("    zero ordinate or at 0 (where the y = 0 row shows the pole's exponent -1).")
print("  * CONSEQUENCE for (V): the lower bound on L is elementary and in-tree in both forms.")
print("    What is still open is the SHARP SHAPE of the upper bound on L'/L.  Cauchy at")
print("    radius x = 1/log T with the uniform lower bound gives only")
print("        |L'/L| <= (M/x) * x^{-3/4}/c = O((log T)^{11/4}),")
print("    a POWER of log rather than log -- too weak for the interface's")
print("    C(1 + log(NT))(1 + |t1 - t0|) shape; and with the fixed-y constant c(y) there is no")
print("    uniformity at all.  The sharp shape needs the Dirichlet series for L'/L on")
print("    Re s = 1, whose convergence needs sum_{n<=N} Lambda(n)chi(n) = o(N).")
print("  * SO journal 275's PNT-strength verdict stands, now for a sharper reason: it is the")
print("    SHAPE (log T, not a power of log T) that needs the series, not the lower bound.")
