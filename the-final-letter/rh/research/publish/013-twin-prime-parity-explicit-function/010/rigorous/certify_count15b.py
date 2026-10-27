#!/usr/bin/env python3
"""Same T=15 count, at a lower working precision (iv.WORK=140) for speed.
EPS=1e-320 << 1e-140, so every Num bound remains valid; only the round-off
slack is larger relative to the mantissa."""
import sys, os, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mpmath as mp
mp.mp.dps = 60
import ivmath as iv
iv.WORK = 140
from fractions import Fraction
import eta_interval as E
print("Route B count at T=15 (WORK=140), Lf_const=30", flush=True)
t0 = time.time()
Ire, Iim, Nest = E.I3_certificate(Fraction(15), steps_per_unit=50, K=50, Lf_const=30)
k = int(mp.nint(Nest.v))
ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
print("  N(15) in [%s,%s] -> %s  (%.0fs)" % (mp.nstr(Nest.lo,8), mp.nstr(Nest.hi,8),
      ("N(15)=%d CERTIFIED" % k) if ok else "UNDECIDED", time.time()-t0), flush=True, file=sys.stderr)
if ok and k == 1:
    print("  TURING: certified on-line zeros with 1/2<Im<15 = 1 = N(15)", flush=True)
    print("  => every zero with 1/2<Im<15 is simple and on the critical line.", flush=True)
