#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""rh45/rigorous/check_engine.py — validate the rigorous enclosure engine.

Checks (all bounds, no floats in the enclosures):
  1. n^{-1/2} and sqrt2 enclosures contain the true values;
  2. the elementary exp bound e^y in [1+y, 1+y+y^2] (and the Taylor version);
  3. eta point enclosures at rational (sigma,t) contain mpmath's value, with
     the reported width;
  4. the tail bound dominates the true Euler truncation error at a test point;
  5. the winding diagnostic: which boundary boxes contain 0 (documents that
     arc-boxes are too pessimistic and that the point-wise Z route is needed).

Exit 0 iff every containment check passes.
"""
import time, sys
import mpmath as mp
import eta_interval as E
import ivmath as iv

mp.mp.dps = 60
fails = []


def check(label, ok, detail=""):
    print(("[PASS] " if ok else "[FAIL] ") + label + (("   |  " + detail) if detail else ""))
    if not ok:
        fails.append(label)


def contains(box, ref):
    return box.re.lo <= mp.mpf(mp.re(ref)) <= box.re.hi and box.im.lo <= mp.mpf(mp.im(ref)) <= box.im.hi


# 1. sqrt enclosures (compare at high precision: the tiny errors are lost at 60 dps)
mp.mp.dps = iv.WORK
for n in [2, 3, 5, 47, 101]:
    b = E.n_inv_sqrt(n)
    check("n^{-1/2} enclosure n=%d" % n, b.lo <= mp.mpf(1)/mp.sqrt(n) <= b.hi,
          "width %.2e" % float(b.hi-b.lo))
s2 = E.sqrt2()
check("sqrt2 enclosure", s2.lo <= mp.sqrt(2) <= s2.hi, "width %.2e" % float(s2.hi-s2.lo))
mp.mp.dps = 60

# 2. elementary exp (Taylor form)
for y in ['0.0', '0.03', '-0.04']:
    e = E.exp_small(y, y)
    check("exp_small %s" % y, e.lo <= mp.e**mp.mpf(y) <= e.hi, "width %.2e" % float(e.hi-e.lo))

# 3/4. eta point enclosures + tail dominance
for (sig, t, K) in [("0.5", "14.134725141734693", 60), ("0.5", "20.0", 60),
                    ("0.49", "14.134725141734693", 60), ("0.51", "14.0", 60)]:
    s = mp.mpf(sig) + 1j*mp.mpf(t)
    box = E.eta_box(mp.mpf(sig), mp.mpf(sig), mp.mpf(t), mp.mpf(t), K)
    ref = mp.altzeta(s)
    check("eta enclosure contains value  sigma=%s t=%s K=%d" % (sig, t, K),
          contains(box, ref), "width %.2e  |center-value| %.2e" %
          (float(max(box.re.hi-box.re.lo, box.im.hi-box.im.lo)),
           float(abs(mp.mpc(box.re.v, box.im.v) - ref))))
    check("tail bound exceeds |error|       sigma=%s t=%s K=%d" % (sig, t, K),
          max(box.re.hi-box.re.lo, box.im.hi-box.im.lo) >= abs(mp.mpc(box.re.v, box.im.v) - ref) - mp.mpf('1e-30'),
          "tail radius %.2e" % float(E.tail_radius(t, sig, K)))

# 5. winding diagnostic: scan the vertical edge boxes and report the closest one
t0 = mp.im(mp.zetazero(1))
print("\nwinding diagnostic at gamma1 =", mp.nstr(t0, 12))
for (lab, s_lo, s_hi, t_lo, t_hi) in [
        ("right edge sigma=0.51, t near gamma1",
         mp.mpf('0.51'), mp.mpf('0.51'), t0 - mp.mpf('0.05'), t0 - mp.mpf('0.03')),
        ("right edge sigma=0.51, t at gamma1",
         mp.mpf('0.51'), mp.mpf('0.51'), t0 - mp.mpf('0.001'), t0 + mp.mpf('0.001')),
        ("horizontal, sigma 0.49..0.51 at t=gamma1-0.2",
         mp.mpf('0.49'), mp.mpf('0.51'), t0 - mp.mpf('0.2'), t0 - mp.mpf('0.2'))]:
    box = E.eta_box(s_lo, s_hi, t_lo, t_hi, 60)
    print("   %-46s  excludes0=%s  |center|=%.3e  width=%.2e"
          % (lab, box.excludes_zero(), float(mp.sqrt(box.re.v**2 + box.im.v**2)),
             float(max(box.re.hi-box.re.lo, box.im.hi-box.im.lo))))

print("\n%d fail(s)" % len(fails))
sys.exit(1 if fails else 0)
