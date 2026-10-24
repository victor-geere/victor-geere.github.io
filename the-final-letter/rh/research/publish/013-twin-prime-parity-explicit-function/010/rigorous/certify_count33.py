#!/usr/bin/env python3
"""T=33 Route B count, UNCONDITIONAL: extends the Turing window past gamma_5 = 32.935.

This is item T2 of `research/TODO.md`.  With `Lf_const=None` (T1) the certificate is
unconditional.

Two parameters matter and both were measured:
* `K = 100`: the Euler-accelerated `eta` enclosure needs `K >= ~0.25*t` to stay tight.
  At `t = 33`, `K = 40` yields a `1.8e10`-wide (useless) `zeta` enclosure, `K = 80` is
  marginal (one top-segment box still fails), `K = 100` is clean.
* `steps/unit = 32`: the total midpoint error is `avg(Lf)*L/(8*steps)`, which must stay
  below `pi/2`; 32 leaves ~33% margin at the measured `avg(Lf)`.

N(33) = 5 and the five certified on-line zeros gamma_1..gamma_5 lie in (1/2, 33), so the
Turing step gives: every zero with 1/2 < Im < 33 is simple and on the critical line.
"""
import sys, os, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mpmath as mp
mp.mp.dps = 40
import eta_interval as E
E.fast_mode()
E._D = 10 ** 18
from fractions import Fraction

T = 33
STEPS = 32
# NB: K must be >= ~0.25*t for the Euler-accelerated eta/eta' enclosures to stay tight:
# at t=33, K=40 gives a 1.8e10-wide zeta enclosure (useless), K=80 is marginal (one box
# fails), K=100 is clean.  See the K-vs-t table in research/TODO.md item T2.
K = 100
print("Route B T=33, UNCONDITIONAL (Lf computed per step, no cited constant)", flush=True)
print("  config: fast mode work=60 EPS=1e-40, K=%d, steps/unit=%d" % (K, STEPS), flush=True)
t0 = time.time()
Ire, Iim, Nest = E.I3_certificate(Fraction(T), steps_per_unit=STEPS, K=K, Lf_const=None)
k = int(mp.nint(Nest.v)); ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
print("  N(%d) in [%s,%s] -> %s  (%.0fs)" % (T, mp.nstr(Nest.lo, 8), mp.nstr(Nest.hi, 8),
      ("N(%d)=%d CERTIFIED" % (T, k)) if ok else "UNDECIDED", time.time() - t0), flush=True, file=sys.stderr)
if ok and k == 5:
    print("  UNCONDITIONAL: no cited |zeta'/zeta| bound was used; Lf is enclosed per step.", flush=True)
    print("  TURING: N(33)=5 = #certified on-line zeros with 1/2<Im<33 (gamma_1..gamma_5)", flush=True)
    print("  => every zero with 1/2<Im<33 is simple and on the critical line.", flush=True)
sys.exit(0 if ok else 1)
