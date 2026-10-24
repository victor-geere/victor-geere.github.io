#!/usr/bin/env python3
"""010/rigorous/check_exp_num.py — regression test for the `exp_num` soundness bug.

Background: `eta_interval.exp_num` returned a zero-width *point* for any positive-width
negative interval (the two endpoints were swapped and `ivmath.Num` silently clamps a
negative radius to 0).  `check_engine.py` did not catch it because its main containment
checks use *point* sigma-intervals; the bug only shows on positive-width boxes, which is
exactly what the Route-B curvature bounds feed.

This script asserts containment on positive-width inputs; it fails on the pre-fix code
and passes after it.  Read-only.

    python3 check_exp_num.py       # exit 0 iff all containments hold
"""
import sys
import mpmath as mp

mp.mp.dps = 60
from fractions import Fraction as F
import ivmath as iv
import eta_interval as E

E.fast_mode()
fails = 0


def check(name, ok, detail=""):
    global fails
    print(("  PASS  " if ok else "  FAIL  ") + name + (("   " + detail) if detail else ""))
    if not ok:
        fails += 1


print("010/rigorous/check_exp_num.py — exp_num / n_pow_neg_sigma on positive-width inputs")

# ---------------------------------------------------------------- exp_num, direct
print("\n[1] exp_num contains {e^{y.lo}, e^{y.hi}} for positive-width negative y")
for (a, b) in [(-0.5, -0.4), (-1.2, -0.8), (-4.0, -1.0), (-10.0, -9.0), (-30.0, -1.0)]:
    y = iv.Num(mp.mpf(a), (mp.mpf(b) - mp.mpf(a)) / 2)
    N = E.exp_num(y)
    ok = N.e >= 0 and N.contains(mp.e ** y.lo) and N.contains(mp.e ** y.hi)
    check(f"y = [{a},{b}]", ok, f"width {mp.nstr(2 * N.e, 3)}")

# --------------------------------------------------- n_pow_neg_sigma, Route-B boxes
print("\n[2] n_pow_neg_sigma contains {n^-s_hi, n^-s_lo} on Route-B-sized sigma boxes")
for (n, slo, shi) in [(100, 0.5, 13 / 24), (200, 0.5, 13 / 24), (500, 0.5, 13 / 24),
                      (100, 0.5, 0.6), (100, 0.5, 3 / 4), (100, 0.5, 1.0)]:
    N = E.n_pow_neg_sigma(n, slo, shi)
    lo = mp.mpf(n) ** (-mp.mpf(shi))
    hi = mp.mpf(n) ** (-mp.mpf(slo))
    check(f"n = {n}, sigma in [{slo:.4f},{shi:.4f}]", N.e >= 0 and N.contains(lo) and N.contains(hi))

# -------------------------------------------------------------- eta_box, real boxes
print("\n[3] eta_box contains eta at all corners/midpoints of positive-width boxes")


def contains_cx(box, t):
    return box.re.contains(t.real) and box.im.contains(t.imag)


for (s_lo, s_hi, t_lo, t_hi) in [(F(1, 2), F(13, 24), F(14), F(14)),
                                 (F(49, 100), F(51, 100), F(60, 5), F(60, 5)),
                                 (F(1, 2), F(53, 100), F(30), F(30)),
                                 (F(3, 4), F(19, 25), F(20), F(20)),
                                 (F(1, 2), F(13, 24), F(20), F(20))]:
    box = E.eta_box(s_lo, s_hi, t_lo, t_hi, K=60)
    bad = 0
    for sc in (mp.mpf(float(s_lo)), (mp.mpf(float(s_lo)) + mp.mpf(float(s_hi))) / 2,
               mp.mpf(float(s_hi))):
        for tc in (mp.mpf(float(t_lo)), (mp.mpf(float(t_lo)) + mp.mpf(float(t_hi))) / 2,
                   mp.mpf(float(t_hi))):
            s = sc + 1j * tc
            truth = (1 - mp.power(2, 1 - s)) * mp.zeta(s)
            if not contains_cx(box, truth):
                bad += 1
    check(f"sigma [{float(s_lo):.4f},{float(s_hi):.4f}] x t [{float(t_lo):.2f},{float(t_hi):.2f}]",
          bad == 0, f"{bad} corner failures")

print(("\n0 fail(s)" if not fails else f"\n{fails} FAILURE(S)"))
sys.exit(1 if fails else 0)
