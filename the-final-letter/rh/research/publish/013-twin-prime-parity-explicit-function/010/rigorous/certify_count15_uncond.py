#!/usr/bin/env python3
"""T=15 Route B count, UNCONDITIONAL: Lf is computed per step by interval arithmetic.

This is item T1 of `research/TODO.md`.  The earlier certificate
(`certify_count15d.py`) used `Lf_const = 30`, justified only by the *cited*
`|ζ′/ζ| ≤ A log(t+2)` bound with `A = 1`.  Here `Lf_const=None`, so for every step the
engine encloses `f′ = (log ξ)″` on that step's box and uses its magnitude as the
curvature bound.  No cited input enters; the certificate is unconditional.

Configuration: certified fast mode (work = 60, EPS = 1e-40), K = 40, steps/unit = 24.
The step boxes whose t-range is within `eta_interval._SING_WINDOW` of a removable
singularity `t_k = 2 pi k / ln 2` (including `t_0 = 0`) are enclosed by
`zeta_local_box`; the other boxes use the quotient engines.  `steps/unit = 24`
(rather than 12) is needed because the interval curvature bound is dominated by the
Euler-series phase error, which grows like the box height.
"""
import sys, os, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mpmath as mp
mp.mp.dps = 40
import eta_interval as E
E.fast_mode()
E._D = 10 ** 18
from fractions import Fraction

STEPS = 24
print("Route B T=15, UNCONDITIONAL (Lf computed per step, no cited constant)", flush=True)
print("  config: fast mode work=60 EPS=1e-40, K=40, steps/unit=%d" % STEPS, flush=True)
t0 = time.time()
Ire, Iim, Nest = E.I3_certificate(Fraction(15), steps_per_unit=STEPS, K=40, Lf_const=None)
k = int(mp.nint(Nest.v)); ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
print("  N(15) in [%s,%s] -> %s  (%.0fs)" % (mp.nstr(Nest.lo, 8), mp.nstr(Nest.hi, 8),
      ("N(15)=%d CERTIFIED" % k) if ok else "UNDECIDED", time.time() - t0), flush=True, file=sys.stderr)
if ok and k == 1:
    print("  UNCONDITIONAL: no cited |zeta'/zeta| bound was used; Lf is enclosed per step.", flush=True)
    print("  TURING: N(15)=1 = #certified on-line zeros with 1/2<Im<15 (gamma_1)", flush=True)
    print("  => every zero with 1/2<Im<15 is simple and on the critical line.", flush=True)
sys.exit(0 if ok else 1)
