#!/usr/bin/env python3
"""T=15 Route B count: WORK=60, K=40, value-only, Lf_const=30."""
import sys, os, time
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'rh43'))
import mpmath as mp
mp.mp.dps = 40
import ivmath as iv
iv.WORK = 60
import eta_interval as E
E._D = 10 ** 18
from fractions import Fraction
print("Route B T=15 (WORK=60, K=40, value-only, Lf=30, 48 steps/unit)", flush=True)
t0 = time.time()
Ire, Iim, Nest = E.I3_certificate(Fraction(15), steps_per_unit=48, K=40, Lf_const=30)
k = int(mp.nint(Nest.v)); ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
print("  N(15) in [%s,%s] -> %s  (%.0fs)" % (mp.nstr(Nest.lo,8), mp.nstr(Nest.hi,8),
      ("N(15)=%d CERTIFIED" % k) if ok else "UNDECIDED", time.time()-t0), flush=True)
if ok and k == 1:
    print("  TURING: N(15)=1 = #certified on-line zeros with 1/2<Im<15 (gamma_1)", flush=True)
    print("  => every zero with 1/2<Im<15 is simple and on the critical line.", flush=True)
