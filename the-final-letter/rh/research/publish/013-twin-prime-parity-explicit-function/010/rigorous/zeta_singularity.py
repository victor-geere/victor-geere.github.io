#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""010/rigorous/zeta_singularity.py — validate the removable-singularity handling.

`zeta = eta/(1 - 2^{1-s})` has a removable singularity on `Re s = 1` at
`t_k = 2 pi k / ln 2` (9.0647..., 18.1294...).  The quotient engines
`zeta_prime_point` / `zeta_second_point` cannot enclose a box that meets (or even
comes near) `t_k`; `zeta_local_box` replaces them there by a Taylor expansion
about a regular centre with a Cauchy-controlled remainder.

This script checks, in the certified fast mode (`work = 60`, `EPS = 1e-40`, K = 40):

  1. `singular_ts` encloses 2 pi k / ln 2 and `box_near_singularity` flags the
     boxes that actually straddle the first singular point;
  2. for a window of boxes around `t_1`, `zeta_local_box` encloses `zeta`, `zeta'`,
     `zeta''` at several points of each box (mpmath references at 60 dps);
  3. `xi_logderiv` — i.e. the fallback actually used by `I3_certificate` with
     `Lf_const=None` — encloses `xi'/xi` and `(log xi)''` on those boxes.

Exit 0 iff every containment check passes.  Runtime is a few minutes (each local
box runs a Cauchy boundary bound); it performs no side effects.
"""
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import mpmath as mp  # noqa: E402
mp.mp.dps = 60

import eta_interval as E  # noqa: E402
from fractions import Fraction as F  # noqa: E402

E.fast_mode()
E._D = 10 ** 18

TWO_PI_OVER_LOG2 = mp.mpf(2) * mp.pi / mp.log(2)

fails = []


def check(label, ok, detail=""):
    print(("[PASS] " if ok else "[FAIL] ") + label + (("   |  " + detail) if detail else ""))
    if not ok:
        fails.append(label)


def _d1(s):
    return mp.diff(lambda w: mp.zeta(w), s)


def _d2(s):
    return mp.diff(lambda w: mp.zeta(w), s, 2)


def _true_logxi(s):
    return mp.log(s * (s - 1) / 2) - s / 2 * mp.log(mp.pi) \
        + mp.log(mp.gamma(s / 2)) + mp.log(mp.zeta(s))


def _true_f(s):
    return mp.diff(_true_logxi, s)


def _true_fp(s):
    return mp.diff(lambda w: mp.diff(_true_logxi, w), s)


def _contains(z, val):
    return z.re.lo <= mp.re(val) <= z.re.hi and z.im.lo <= mp.im(val) <= z.im.hi


def main():
    # 1. the singular points and the detection helper
    ts = E.singular_ts(mp.mpf(20))
    check("singular_ts encloses t_1 = 2 pi / ln 2",
          len(ts) >= 1 and ts[0].lo <= TWO_PI_OVER_LOG2 <= ts[0].hi,
          "t_1 in [%s, %s]" % (mp.nstr(ts[0].lo, 12), mp.nstr(ts[0].hi, 12)))
    check("singular_ts encloses t_2 = 4 pi / ln 2",
          len(ts) >= 2 and ts[1].lo <= 2 * TWO_PI_OVER_LOG2 <= ts[1].hi)
    check("box [9, 9+1/12] is flagged",
          E.box_near_singularity(F(1), F(1), F(9), F(9) + F(1, 12)) is not None)
    check("box [8, 9/2+4] is not flagged",
          E.box_near_singularity(F(1), F(1), F(8), F(8) + F(1, 2)) is None)

    # boxes around t_1, including the two that merely come near it
    boxes = [(F(9), F(9) + F(1, 12)), (F(9) + F(1, 12), F(9) + F(1, 6)),
             (F(92, 10), F(92, 10) + F(1, 12)), (F(89, 10), F(89, 10) + F(1, 12))]

    for (tlo, thi) in boxes:
        t0 = time.time()
        z, zp, zpp = E.zeta_local_box(F(1), F(1), tlo, thi, 40)
        bad = []
        for frac in (F(0), F(1, 2), F(1)):
            t = float(tlo) + (float(thi) - float(tlo)) * float(frac)
            s = 1 + 1j * t
            if not _contains(z, mp.zeta(s)):
                bad.append("zeta@%s" % t)
            if not _contains(zp, _d1(s)):
                bad.append("zeta'@%s" % t)
            if not _contains(zpp, _d2(s)):
                bad.append("zeta''@%s" % t)
        check("zeta_local_box contains zeta,zeta',zeta''   t in [%s,%s]"
              % (float(tlo), float(thi)), not bad,
              "%s   %.0fs" % (",".join(bad) if bad else "ok", time.time() - t0))

    # 3. the fallback path of xi_logderiv (what I3_certificate with Lf_const=None uses)
    for (tlo, thi) in boxes:
        t0 = time.time()
        f, fp = E.xi_logderiv(F(1), F(1), tlo, thi, 40, 10)
        bad = []
        for frac in (F(0), F(1, 2), F(1)):
            t = float(tlo) + (float(thi) - float(tlo)) * float(frac)
            s = 1 + 1j * t
            if not _contains(f, _true_f(s)):
                bad.append("xi'/xi@%s" % t)
            if not _contains(fp, _true_fp(s)):
                bad.append("(log xi)''@%s" % t)
        Lf = mp.sqrt((abs(fp.re.v) + fp.re.e) ** 2 + (abs(fp.im.v) + fp.im.e) ** 2)
        check("xi_logderiv fallback contains xi'/xi, (log xi)''   t in [%s,%s]"
              % (float(tlo), float(thi)), not bad,
              "%s   Lf<=%s   %.0fs" % (",".join(bad) if bad else "ok", mp.nstr(Lf, 8), time.time() - t0))

    print("\n%d fail(s)" % len(fails))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
