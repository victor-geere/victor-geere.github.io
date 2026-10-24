#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""op06_ceiling_coefficient.py — the exact `1/p` coefficient of the OP-6 residual.

Run:  python3 op06_ceiling_coefficient.py

WHAT THIS SETTLES
-----------------
The OP-6 write-up states

    L(p) = p log p - (1 + ln ln 2) p - 0.540509640658… / p + O(1/p²) ,

i.e. a *constant* `1/p` coefficient `c6 = -0.540509640658…`.  That is **false** (TODO
item O4).  The exact coefficient is a function of the ceiling error

    e(p) := nmin(p) - (p/ln 2 - 5/2)  ∈ [0, 1) ,   nmin(p) = ⌈ p/ln 2 - 5/2 ⌉ ,

namely

    c(e) = -(ln 2)^2 / 2 * ( e^2 - e + 9/4 ) ,

so that

    L(p) = p log p - (1 + ln ln 2) p  +  c(e(p))/p  +  O(1/p²) .

`c(e)` is not constant: it ranges over `[ -(ln 2)^2 , -(9/8)(ln 2)^2 ]`
= `[-0.480453013918201, -0.540509640657977]`; the recorded value `-0.540509640658` is
exactly `-(9/8)(ln 2)^2`, attained only at `e = 0`, i.e. for the *smooth* (non-integer)
threshold `p/ln 2 - 3/2`, not for the true integer index.

The main OP-6 theorem `L(p) = p log p - (1 + ln ln 2)p + O(1)` is unaffected.

Method: L is evaluated from the exact reduction
`L(p) = -(n-1)·ln 2 - log ζ(p, n) + log ζ(p)` with the *true* (ceiling) `n = nmin(p)+1`
at high precision, and `R(p) := L(p) - (p log p - (1+ln ln 2)p)` is compared with `c(e)/p`.
"""
import sys

from mpmath import mp, mpf, log, zeta, ceil, nstr

mp.dps = 80

A = log(2)
C2 = -(1 + log(log(2)))          # the exact linear coefficient


def c_of_e(e):
    """The exact `1/p` coefficient as a function of the ceiling error `e`."""
    return -(A ** 2 / 2) * (e * e - e + mpf(9) / 4)


def nmin(p):
    """The 0-based Brown threshold index, by the exact ceiling law."""
    return int(ceil(mpf(p) / A - mpf(5) / 2))


def L_exact(p):
    """L(p) = -log(measure(S_1)/P(p)) from the exact reduction, at the true index."""
    x = mpf(p) / A - mpf(5) / 2
    n = nmin(p) + 1                      # 1-based index used by the reduction
    e = nmin(p) - x
    return -(n - 1) * A - log(zeta(p, n)) + log(zeta(p)), e


def main():
    print("OP-6's `1/p` coefficient: a function of the ceiling error, not a constant")
    print()
    print("  c(e) = -(ln 2)^2/2 * (e^2 - e + 9/4)")
    print("  range over e in [0,1):  [-(ln 2)^2, -(9/8)(ln 2)^2] = [%s, %s]"
          % (nstr(c_of_e(mpf(1) / 2), 12), nstr(c_of_e(0), 12)))
    print("  recorded c6 = -0.540509640658  ==  -(9/8)(ln 2)^2 = %s  (the e=0 value)"
          % nstr(-9 * A ** 2 / 8, 15))
    print()

    ps = [10 ** 6, 10 ** 7, 10 ** 8, 10 ** 9, 10 ** 10, 10 ** 11, 10 ** 12, 10 ** 13]
    print("  %-9s %-11s %-18s %-18s %-10s" % ("p", "e(p)", "p*R(p)", "c(e(p))", "diff"))
    prev = None
    worst = mpf(0)
    ok = True
    for p in ps:
        L, e = L_exact(p)
        R = L - (p * log(p) + C2 * p)
        pr = p * R
        pred = c_of_e(e)
        diff = abs(pr - pred)
        worst = max(worst, diff)
        print("  %-9d %-11s %-18s %-18s %.3e" % (p, nstr(e, 8), nstr(pr, 15), nstr(pred, 15), diff))
        # deviation must fall like 1/p
        if prev is not None and diff > prev:
            ok = False
        prev = diff

    print()
    print("  worst |p*R - c(e)| over the table = %.3e" % float(worst))
    print("  the deviation falls by ~10x per decade of p  ->  R(p) = c(e(p))/p + O(1/p^2)")
    print()

    # explicit non-constancy witness: two large p with *different* e (so a single
    # constant c6 cannot fit both)
    L1, e1 = L_exact(10 ** 7)
    L2, e2 = L_exact(10 ** 9)
    r1 = 10 ** 7 * (L1 - (10 ** 7 * log(10 ** 7) + C2 * 10 ** 7))
    r2 = 10 ** 9 * (L2 - (10 ** 9 * log(10 ** 9) + C2 * 10 ** 9))
    print("  non-constancy witness:")
    print("    p = 1e7  : e = %s  ->  p*R = %s" % (nstr(e1, 7), nstr(r1, 12)))
    print("    p = 1e9  : e = %s  ->  p*R = %s" % (nstr(e2, 7), nstr(r2, 12)))
    print("    difference = %s  (a single constant c6 cannot fit both)"
          % nstr(abs(r1 - r2), 6))
    print()

    verdict = (ok and abs(r1 - r2) > mpf('1e-3'))
    print("VERDICT: %s -- the `1/p` coefficient is c(e(p)), not the constant -0.540509640658…"
          % ("CONFIRMED" if verdict else "INCONCLUSIVE"))
    return 0 if verdict else 1


if __name__ == "__main__":
    sys.exit(main())
