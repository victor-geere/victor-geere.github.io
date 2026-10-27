#!/usr/bin/env python3
"""rh45/rigorous/certify_zeros.py — rigorous on-line zero certificates (Route A, existence)."""
import sys
import time, sys
import mpmath as mp
from fractions import Fraction
import eta_interval as E

mp.mp.dps = 60
GAM = [mp.im(mp.zetazero(k)) for k in range(1, 6)]
print("Rigorous Z(t) sign-change certificates (sigma = 1/2)")
fails = 0
for k, g in enumerate(GAM, 1):
    t0 = Fraction(mp.nstr(g, 45))
    t = time.time()
    cert = E.Z_sign_certificate(t0, K=80, N=10, iters=14)
    if cert is None:
        print("  gamma_%d = %s : NO CERTIFICATE" % (k, mp.nstr(g, 20))); fails += 1; continue
    a, b, Za, Zb = cert
    neg = Za if Za.sign() < 0 else Zb
    pos = Zb if Za.sign() < 0 else Za
    print("  gamma_%d: Z<0 on [%s, %s] and Z>0 on [%s, %s]  -> zero in (%.3e-wide bracket)  %.0fs"
          % (k, mp.nstr(neg.lo, 10), mp.nstr(neg.hi, 10), mp.nstr(pos.lo, 10), mp.nstr(pos.hi, 10),
             float(b - a), time.time() - t), file=sys.stderr)
    assert Za.sign() * Zb.sign() < 0
print("certificates:", len(GAM) - fails, "/", len(GAM))
sys.exit(1 if fails else 0)
