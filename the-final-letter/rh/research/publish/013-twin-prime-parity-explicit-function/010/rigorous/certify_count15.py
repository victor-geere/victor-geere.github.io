#!/usr/bin/env python3
"""rh45/rigorous/certify_count15.py — Route B at T=15: N(15) via I3, with the Lean
Turing reduction then giving: every zero with 1/2 < Im < 15 is simple and on the line
(γ1 is the single certified on-line zero there)."""
import sys
import time
import mpmath as mp
from fractions import Fraction
import eta_interval as E
mp.mp.dps = 30
T = 15
print("Route B count at T=%d, Lf_const=30 (cited |zeta'/zeta| bound gives |f'|<30 on the path)" % T, flush=True)
t0 = time.time()
Ire, Iim, Nest = E.I3_certificate(Fraction(T), steps_per_unit=50, K=50, Lf_const=30)
k = int(mp.nint(Nest.v))
ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
print("  N(15) in [%s,%s] -> %s   (%.0fs)" % (mp.nstr(Nest.lo,8), mp.nstr(Nest.hi,8),
      ("N(15)=%d CERTIFIED" % k) if ok else "UNDECIDED", time.time()-t0), flush=True, file=sys.stderr)
if ok and k == 1:
    print("  TURING: #certified on-line zeros with 1/2<Im<15 = 1 = N(15)", flush=True)
    print("  => every zero with 1/2<Im<15 is simple and on the critical line.", flush=True)
