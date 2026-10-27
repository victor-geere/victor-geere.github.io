#!/usr/bin/env python3
"""rh45/rigorous/certify_unique.py — Theorem A certificates: unique simple on-line zeros."""
import time, sys
import mpmath as mp
from fractions import Fraction
import eta_interval as E

mp.mp.dps = 60
GAM = [mp.im(mp.zetazero(k)) for k in range(1, 6)]
print("Theorem A certificates: Z(a)<0<Z(b) and Z'>0 on [a,b]  (=> unique simple on-line zero)")
fails = 0
for k, g in enumerate(GAM, 1):
    t0 = Fraction(mp.nstr(g, 45))
    t = time.time()
    cert = E.unique_simple_certificate(t0)
    if cert is None:
        print("  gamma_%d: NO CERTIFICATE" % k); fails += 1; continue
    a, b, Za, Zb, Zpb = cert
    print("  gamma_%d: bracket width %.1e | Z(a) in [%s,%s] | Z(b) in [%s,%s] | Z' in [%s,%s] > 0  (%.0fs)"
          % (k, float(b - a), mp.nstr(Za.lo, 6), mp.nstr(Za.hi, 6), mp.nstr(Zb.lo, 6), mp.nstr(Zb.hi, 6),
             mp.nstr(Zpb.lo, 6), mp.nstr(Zpb.hi, 6), time.time() - t))
print("certificates:", len(GAM) - fails, "/", len(GAM))
sys.exit(1 if fails else 0)
