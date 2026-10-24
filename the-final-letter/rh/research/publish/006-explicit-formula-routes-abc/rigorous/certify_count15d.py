#!/usr/bin/env python3
"""T=15 Route B count: fast mode (work=60, EPS=1e-40), K=40, value-only, Lf_const=30.

The precision is set through `eta_interval.fast_mode()`, which moves `WORK` and the
rounding slack `EPS` together (see the contract in `eta_interval.py` and
`check_fast_mode.py`).  An earlier revision set `iv.WORK = 60` alone, leaving the
400-digit `EPS` in place; the enclosure widths are truncation-dominated, so the
certificate is unchanged, but only `fast_mode()` satisfies the stated contract.
"""
import sys, os, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mpmath as mp
mp.mp.dps = 40
import eta_interval as E
E.fast_mode()          # work = 60, EPS = 1e-40 (contract-satisfying fast mode)
E._D = 10 ** 18
from fractions import Fraction
print("Route B T=15 (fast mode: work=60, K=40, value-only, Lf=30, 48 steps/unit)", flush=True)
t0 = time.time()
Ire, Iim, Nest = E.I3_certificate(Fraction(15), steps_per_unit=48, K=40, Lf_const=30)
k = int(mp.nint(Nest.v)); ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
print("  N(15) in [%s,%s] -> %s  (%.0fs)" % (mp.nstr(Nest.lo,8), mp.nstr(Nest.hi,8),
      ("N(15)=%d CERTIFIED" % k) if ok else "UNDECIDED", time.time()-t0), flush=True, file=sys.stderr)
if ok and k == 1:
    print("  TURING: N(15)=1 = #certified on-line zeros with 1/2<Im<15 (gamma_1)", flush=True)
    print("  => every zero with 1/2<Im<15 is simple and on the critical line.", flush=True)
