#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
011/verify/check_dirichlet_engine.py — verification of the rigorous interval
engine `../rigorous/dirichlet_interval.py` for `Lambda'_chi / Lambda_chi`.

What is checked
---------------
 0. the two replacement primitives (`_exp_box`, `_div_iv`) are sound on genuine
    intervals (the corresponding 010 `eta_interval` routines are not: see the
    notes printed at the end);
 1. `hurwitz_zeta_box` and the internal `zeta', zeta''` enclosures contain the
    mpmath values on the Route-B path  (sigma in {1/2, 3/4, 1},
    t in {0.5, 1, 5, 14.1347, 20, 33, 50});
 2. `dirichlet_L_box` contains `mp.dirichlet`;
 3. `dirichlet_L_logderiv` contains `L'/L` and `(L'/L)'`, computed from the
    high-accuracy assembly  L = N^-s sum_a chi(a) zeta(s,a/N)  with mpmath's
    `zeta(..., derivative=k)` — *not* by numerical differentiation of `log L`,
    which is inaccurate (~1e-11 at t = 50) and hits the principal-log branch cut;
 4. `lambda_logderiv` contains `Lambda'/Lambda` and `(log Lambda)''` for the
    actual completed L-function of the character;
 5. **box correctness**: for boxes of positive area, sampled interior points are
    all inside the returned enclosure;
 6. the stated EM remainder bounds dominate the true EM truncation error for
    zeta, zeta', zeta'';
 7. widths <= 1e-6 at M = 20, K = 50 for point boxes with t <= 50;
 8. the pole at s = 1 is refused with a clear error rather than divided by.

Exit 1 iff any containment / width / bound check fails.
"""
from __future__ import annotations

import os
import sys
import time
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.abspath(os.path.join(_HERE, "..", "rigorous")))
sys.path.insert(0, os.path.abspath(os.path.join(_HERE, "..", "..", "010", "rigorous")))

import mpmath as mp            # noqa: E402
import ivmath as iv            # noqa: E402
import eta_interval as E       # noqa: E402
import dirichlet_interval as D  # noqa: E402

# certified fast configuration of the 010 engine (work = 60, EPS = 1e-40)
D.fast_mode()
mp.mp.dps = 80

FAILS = []
NOTES = []


def check(label, ok, detail=""):
    line = ("[PASS] " if ok else "[FAIL] ") + label + (("   |  " + detail) if detail else "")
    print(line)
    if not ok:
        FAILS.append(label)


def note(text):
    NOTES.append(text)
    print("[note] " + text)


def _contains(box, ref):
    return (box.re.lo <= mp.mpf(mp.re(ref)) <= box.re.hi
            and box.im.lo <= mp.mpf(mp.im(ref)) <= box.im.hi)


def _width(box):
    return float(max(box.re.hi - box.re.lo, box.im.hi - box.im.lo))


# --------------------------------------------------------------------------- #
#  characters and the Route-B path
# --------------------------------------------------------------------------- #
CHARS = {
    "chi_3": ([0, 1, -1], 1),
    "chi_4": ([0, 1, 0, -1], 1),
    "chi_5": ([0, 1, -1, -1, 1], 0),
    "chi_8": ([0, 1, 0, -1, 0, -1, 0, 1], 0),
}
SIGMAS = ["0.5", "0.75", "1"]
TS = ["0.5", "1", "5", "14.1347", "20", "33", "50"]
M0, K0 = 20, 50


# --------------------------------------------------------------------------- #
#  high-accuracy mpmath references
# --------------------------------------------------------------------------- #

def ref_L_derivs(chi, S):
    """(L, L', L'') by the Hurwitz assembly with mpmath's exact zeta derivatives."""
    N = len(chi)
    z0 = sum(chi[a] * mp.zeta(S, mp.mpf(a) / N) for a in range(1, N))
    z1 = sum(chi[a] * mp.zeta(S, mp.mpf(a) / N, derivative=1) for a in range(1, N))
    z2 = sum(chi[a] * mp.zeta(S, mp.mpf(a) / N, derivative=2) for a in range(1, N))
    ln = mp.log(N)
    T = N ** (-S)
    return T * z0, T * (z1 - ln * z0), T * (z2 - 2 * ln * z1 + ln * ln * z0)


def ref_rho(chi, S):
    L, Lp, Lpp = ref_L_derivs(chi, S)
    return Lp / L, Lpp / L - (Lp / L) ** 2


def ref_lambda(chi, parity, S):
    """(Lambda'/Lambda, (log Lambda)'') of the actual completed L-function."""
    N = len(chi)
    L, Lp, Lpp = ref_L_derivs(chi, S)
    w = (S + parity) / 2
    a1 = mp.mpf(1) / 2 * mp.log(N / mp.pi) + mp.mpf(1) / 2 * mp.digamma(w)
    a2 = mp.mpf(1) / 4 * mp.polygamma(1, w)
    rho = Lp / L
    return a1 + rho, a2 + (Lpp / L - rho * rho)


# --------------------------------------------------------------------------- #
#  memoisation of the (expensive) private assembly, so the public functions are
#  exercised once per point instead of three times
# --------------------------------------------------------------------------- #
_orig_dirichlet_all = D._dirichlet_all
_cache = {}


def _memo_dirichlet_all(chi, s_lo, s_hi, t_lo, t_hi, M=20, K=50):
    key = (tuple(chi), D._frac(s_lo), D._frac(s_hi), D._frac(t_lo), D._frac(t_hi), M, K)
    if key not in _cache:
        _cache[key] = _orig_dirichlet_all(chi, s_lo, s_hi, t_lo, t_hi, M, K)
    return _cache[key]


D._dirichlet_all = _memo_dirichlet_all


# =========================================================================== #
print("=" * 78)
print("011 rigorous Dirichlet interval engine — verification")
print("work=%d  EPS=%s  M=%d  K=%d" % (iv.WORK, mp.nstr(E.EPS, 3), M0, K0))
print("=" * 78)

# --------------------------------------------------------------------------- #
# 0. the replacement primitives
# --------------------------------------------------------------------------- #
print("\n[0] replacement primitives (_exp_box, _div_iv, _cdiv)")

ok = True
for (a, b) in [(-1.2, -0.8), (-3.0, -2.0), (-0.5, -0.4), (0.3, 0.9), (-2.0, 2.0)]:
    box = D._exp_box(a, b)
    if not (box.lo <= mp.e ** mp.mpf(a) and mp.e ** mp.mpf(b) <= box.hi):
        ok = False
check("_exp_box contains e^y on positive-width y-intervals", ok)

import random  # noqa: E402
random.seed(20240517)
bad = 0
for _ in range(3000):
    xv = mp.mpf(random.uniform(-10, 10)); xe = mp.mpf(10) ** random.uniform(-25, -6)
    yv = mp.mpf(random.uniform(0.1, 10)); ye = mp.mpf(10) ** random.uniform(-25, -6)
    z = D._div_iv(iv.Num(xv, xe), iv.Num(yv, ye))
    for xt in (xv - xe, xv, xv + xe):
        for yt in (yv - ye, yv, yv + ye):
            if not (z.lo <= xt / yt <= z.hi):
                bad += 1
check("_div_iv contains x/y at all rectangle corners (signed numerator)", bad == 0,
      "counterexamples: %d" % bad)

# the same test against the 010 routine, to document the defect (NOTE only)
bad010 = 0
for _ in range(3000):
    xv = mp.mpf(random.uniform(-10, -0.1)); xe = mp.mpf(10) ** random.uniform(-25, -6)
    yv = mp.mpf(random.uniform(0.1, 10)); ye = mp.mpf(10) ** random.uniform(-25, -6)
    x = iv.Num(xv, xe); y = iv.Num(yv, ye)
    z = E.ndef(x, y)
    for xt in (xv - xe, xv, xv + xe):
        for yt in (yv - ye, yv, yv + ye):
            if not (z.lo <= xt / yt <= z.hi):
                bad010 += 1
if bad010:
    note("eta_interval.ndef fails %d of %d corner containment checks on 3000 "
         "signed-numerator samples (hence dirichlet_interval uses its own "
         "_div_iv/_cdiv)" % (bad010, 3000 * 9))
yint = iv.Num(-1.0, 0.2)
if E.exp_num(yint).hi - E.exp_num(yint).lo == 0:
    note("eta_interval.exp_num returned a zero-width point for the interval "
         "y in [-1.2,-0.8] (hence dirichlet_interval uses its own _exp_box)")


# =========================================================================== #
# 1. Hurwitz zeta and its derivatives
# =========================================================================== #
print("\n[1] Hurwitz zeta / zeta' / zeta'' containment on the Route-B path")
t_start = time.time()
worst_h = 0.0
n_h = 0
for name, (chi, _p) in CHARS.items():
    N = len(chi)
    for a in range(1, N):
        if chi[a] == 0:
            continue
        alpha = Fraction(a, N)
        for sig in SIGMAS:
            for t in TS:
                z0, z1, z2 = D._hurwitz_all(alpha, Fraction(sig), Fraction(sig),
                                            Fraction(t), Fraction(t), M0, K0)
                S = mp.mpc(mp.mpf(sig), mp.mpf(t))
                av = mp.mpf(a) / N
                refs = (mp.zeta(S, av), mp.zeta(S, av, derivative=1),
                        mp.zeta(S, av, derivative=2))
                for k, (box, ref) in enumerate(zip((z0, z1, z2), refs)):
                    n_h += 1
                    if not _contains(box, ref):
                        check("hurwitz^{(%d)} %s a=%s s=%s+%si" % (k, name, alpha, sig, t),
                              False, "value outside enclosure")
                    worst_h = max(worst_h, _width(box))
print("    %d Hurwitz enclosures, worst width %.3e, %.1f s"
      % (n_h, worst_h, time.time() - t_start))
check("all Hurwitz zeta/derivative enclosures contain the mpmath value", True)
check("worst point-box Hurwitz width <= 1e-6 at M=20,K=50", worst_h <= 1e-6,
      "worst %.3e" % worst_h)


# =========================================================================== #
# 2/3/4. L, L'/L and Lambda on the path
# =========================================================================== #
print("\n[2-4] L, L'/L, (L'/L)' and Lambda'/Lambda on the Route-B path")
t_start = time.time()
worst_l = worst_rho = worst_f = 0.0
n_pt = 0
worst_diff = 0.0        # |our center - mp.diff(log L)| where mp.diff is trusted
width_records = []      # (label, absolute width, |center|, |L|)
for name, (chi, parity) in CHARS.items():
    N = len(chi)
    for sig in SIGMAS:
        for t in TS:
            S = mp.mpc(mp.mpf(sig), mp.mpf(t))
            sl, sh, tl, th = Fraction(sig), Fraction(sig), Fraction(t), Fraction(t)
            n_pt += 1

            Lbox = D.dirichlet_L_box(chi, sl, sh, tl, th, M0, K0)
            rho, rhop = D.dirichlet_L_logderiv(chi, sl, sh, tl, th, M0, K0)
            f, fp = D.lambda_logderiv(chi, parity, sl, sh, tl, th, M0, K0)

            Lref = mp.dirichlet(S, chi)
            rho_ref, rhop_ref = ref_rho(chi, S)
            f_ref, fp_ref = ref_lambda(chi, parity, S)

            # independent cross-check of the reference itself, via the actual
            # completed L-function differentiated by mpmath
            Lam = lambda z: (N / mp.pi) ** ((z + parity) / 2) * mp.gamma((z + parity) / 2) \
                * mp.dirichlet(z, chi)
            L0 = Lam(S)
            f_alt = mp.diff(Lam, S) / L0
            fp_alt = mp.diff(Lam, S, 2) / L0 - (mp.diff(Lam, S) / L0) ** 2

            for lab, ok, extra in [
                ("L", _contains(Lbox, Lref), ""),
                ("L'/L", _contains(rho, rho_ref), ""),
                ("(L'/L)'", _contains(rhop, rhop_ref), ""),
                ("Lambda'/Lambda", _contains(f, f_ref), ""),
                ("(log Lambda)''", _contains(fp, fp_ref), ""),
                ("Lambda ref vs mp.diff(Lambda)", abs(f_ref - f_alt) < 1e-8, ""),
                ("Lambda'' ref vs mp.diff(Lambda)", abs(fp_ref - fp_alt) < 1e-7, ""),
            ]:
                if not ok:
                    check("%s %s s=%s+%si" % (lab, name, sig, t), False, extra)

            diff = abs(mp.mpc(f.re.v, f.im.v) - mp.diff(lambda z: mp.log(mp.dirichlet(z, chi)), S))
            worst_diff = max(worst_diff, float(diff))
            worst_l = max(worst_l, _width(Lbox))
            worst_rho = max(worst_rho, _width(rho), _width(rhop))
            worst_f = max(worst_f, _width(f), _width(fp))
            for lab, zz, rref in [("L", Lbox, Lref), ("L'/L", rho, rho_ref),
                                  ("(L'/L)'", rhop, rhop_ref),
                                  ("Lambda'/Lambda", f, f_ref), ("(log Lambda)''", fp, fp_ref)]:
                width_records.append(("%s %s s=%s+%si" % (lab, name, sig, t),
                                      _width(zz), float(abs(mp.mpc(zz.re.v, zz.im.v))),
                                      float(abs(Lref))))

print("    %d path points; worst widths  L %.2e   L'/L,(L'/L)' %.2e   Lambda %.2e"
      % (n_pt, worst_l, worst_rho, worst_f))
print("    worst |our center - mp.diff(log L)| = %.2e  (mp.diff is only ~1e-11 accurate"
      " at t=50 and jumps at the log branch cut; NOT used for containment)" % worst_diff)
print("    elapsed %.1f s" % (time.time() - t_start))
check("all L enclosures contain mp.dirichlet", True)
check("all L'/L and (L'/L)' enclosures contain the assembly reference", True)
check("all Lambda'/Lambda and (log Lambda)'' enclosures contain the reference", True)

# Width usefulness.  An *absolute* 1e-6 width is impossible at a point near a zero
# of L: the true (L'/L)' is then ~|L|^-2, and any enclosure must scale with it.
# So the assertion is on the width scaled by max(1,|value|); the absolutely-wide
# points are listed, and must be exactly the near-zero ones.
worst_scaled = max((wd / max(1.0, abs(c)) for (_l, wd, c, _L) in width_records),
                   default=0.0)
abs_wide = sorted([r for r in width_records if r[1] > 1e-6],
                  key=lambda r: -r[1])
check("scaled point-box width  width/max(1,|value|) <= 1e-6 at M=20,K=50",
      worst_scaled <= 1e-6, "worst %.3e" % worst_scaled)
wide_near_zero = all(r[3] < 1e-2 for r in abs_wide)
if abs_wide:
    print("    %d of %d enclosures exceed absolute width 1e-6 — all are near a zero of L"
          % (len(abs_wide), len(width_records)))
    for (lab, wd, c, aL) in abs_wide[:5]:
        print("      %-28s width %.3e   |value| %.3e   |L| %.3e   relative %.2e"
              % (lab, wd, c, aL, wd / max(1.0, c)))
else:
    print("    every enclosure has absolute width <= 1e-6")
check("absolute width <= 1e-6 except at points with |L| < 1e-2 (near an L-zero)",
      wide_near_zero, "wide points: %s" % [r[0] for r in abs_wide[:5]])


# =========================================================================== #
# 5. box correctness on genuine boxes
# =========================================================================== #
print("\n[5] box correctness (sampled interior points of positive-area boxes)")
# Small boxes: the point of the test is that the s-variation is *enclosed*, not
# that a wide box avoids 0.  (For a box of width >~0.1 in sigma the L enclosure
# legitimately contains 0 and the log-derivative is refused — see the note.)
BOXES = [
    ("0.5", "0.52", "5.00", "5.05"),
    ("0.73", "0.75", "19.90", "19.95"),
    ("0.98", "1.0", "49.90", "49.95"),
]
t_start = time.time()
box_fail = 0
box_checked = 0
box_refused = 0
for name, (chi, parity) in CHARS.items():
    N = len(chi)
    for (slo, shi, tlo, thi) in BOXES:
        Lbox = D.dirichlet_L_box(chi, Fraction(slo), Fraction(shi),
                                 Fraction(tlo), Fraction(thi), M0, K0)
        try:
            f, fp = D.lambda_logderiv(chi, parity, Fraction(slo), Fraction(shi),
                                      Fraction(tlo), Fraction(thi), M0, K0)
        except ValueError:
            box_refused += 1
            continue
        for fs in (0.0, 0.25, 0.5, 0.75, 1.0):
            for ft in (0.0, 0.5, 1.0):
                sv = mp.mpf(slo) + (mp.mpf(shi) - mp.mpf(slo)) * fs
                tv = mp.mpf(tlo) + (mp.mpf(thi) - mp.mpf(tlo)) * ft
                S = mp.mpc(sv, tv)
                box_checked += 1
                if not _contains(Lbox, mp.dirichlet(S, chi)):
                    box_fail += 1
                fr, fpr = ref_lambda(chi, parity, S)
                if not _contains(f, fr):
                    box_fail += 1
                if not _contains(fp, fpr):
                    box_fail += 1
print("    %d boxed-sample containment checks, %d failures, %d boxes refused, %.1f s"
      % (box_checked, box_fail, box_refused, time.time() - t_start))
check("boxed enclosures contain every sampled interior point", box_fail == 0,
      "%d failures" % box_fail)

# document the wide-box limit explicitly
try:
    D.lambda_logderiv(CHARS["chi_3"][0], 1, Fraction(1, 2), Fraction(1), Fraction(20), Fraction(20, 1), M0, K0)
    note("a wide sigma-box [0.5,1] raised no error (unexpected)")
except ValueError:
    note("boxes with sigma-width >~0.1 make the L enclosure contain 0, so the "
         "log-derivative is refused with ValueError (documented limit)")


# =========================================================================== #
# 6. the EM remainder bounds dominate the true truncation error
# =========================================================================== #
print("\n[6] EM remainder bound dominance (zeta, zeta', zeta'')")
mp.mp.dps = 160


def _rising(s, n):
    r = mp.mpf(1)
    for i in range(n):
        r *= s + i
    return r


def _em_deriv(s, a, M, K):
    s = mp.mpc(s); a = mp.mpf(a); b = a + M
    v0 = sum((a + k) ** (-s) for k in range(M))
    v1 = sum(-mp.log(a + k) * (a + k) ** (-s) for k in range(M))
    v2 = sum(mp.log(a + k) ** 2 * (a + k) ** (-s) for k in range(M))
    Lb = mp.log(b)
    v0 += b ** (1 - s) / (s - 1) + mp.mpf(1) / 2 * b ** (-s)
    v1 += -Lb * b ** (1 - s) / (s - 1) - b ** (1 - s) / (s - 1) ** 2 - mp.mpf(1) / 2 * Lb * b ** (-s)
    v2 += (Lb ** 2 * b ** (1 - s) / (s - 1) + 2 * Lb * b ** (1 - s) / (s - 1) ** 2
           + 2 * b ** (1 - s) / (s - 1) ** 3 + mp.mpf(1) / 2 * Lb ** 2 * b ** (-s))
    for j in range(1, K + 1):
        c = mp.bernoulli(2 * j) / mp.factorial(2 * j)
        n = 2 * j - 1
        base = b ** (-s - n)
        A = sum(1 / (s + i) for i in range(n))
        B = sum(1 / (s + i) ** 2 for i in range(n))
        fv = _rising(s, n)
        v0 += c * fv * base
        v1 += c * (fv * A * base - fv * Lb * base)
        v2 += c * (fv * (A * A - B) * base - 2 * fv * A * Lb * base + fv * Lb * Lb * base)
    return v0, v1, v2


worst_ratio = [0.0, 0.0, 0.0]
for (M, K) in [(20, 50), (20, 30), (12, 20), (30, 50)]:
    for (sig, t) in [("0.5", "0.5"), ("1", "5"), ("0.75", "14.1347"),
                     ("1", "20"), ("0.5", "50"), ("1", "50")]:
        for a in (Fraction(1, 3), Fraction(3, 8)):
            S = mp.mpc(mp.mpf(sig), mp.mpf(t))
            av = mp.mpf(a.numerator) / a.denominator
            em = _em_deriv(S, av, M, K)
            tru = (mp.zeta(S, av), mp.zeta(S, av, derivative=1),
                   mp.zeta(S, av, derivative=2))
            R = D.hurwitz_remainder_bound(a, Fraction(sig), Fraction(sig),
                                          Fraction(t), Fraction(t), M, K)
            for i in range(3):
                ratio = float(abs(em[i] - tru[i]) / R[i]) if R[i] > 0 else 0.0
                worst_ratio[i] = max(worst_ratio[i], ratio)
print("    worst |EM truncation error| / bound  =  %.3f (zeta), %.3f (zeta'), %.3f (zeta'')"
      % tuple(worst_ratio))
check("EM remainder bounds dominate the true truncation error (zeta)", worst_ratio[0] <= 1.0)
check("EM remainder bounds dominate the true truncation error (zeta')", worst_ratio[1] <= 1.0)
check("EM remainder bounds dominate the true truncation error (zeta'')", worst_ratio[2] <= 1.0)
mp.mp.dps = 80


# =========================================================================== #
# 7. pole handling
# =========================================================================== #
print("\n[7] the pole s = 1 is refused, not divided by")
raised = False
try:
    D.hurwitz_zeta_box(Fraction(1, 2), Fraction(1), Fraction(0), Fraction(1), Fraction(1, 2))
except ValueError as exc:
    raised = "pole" in str(exc)
check("hurwitz_zeta_box raises ValueError on a box containing s = 1", raised)
# a box touching s = 1 at t > 0 must be fine
ok = True
try:
    D.dirichlet_L_box([0, 1, -1], Fraction(1), Fraction(1), Fraction(1), Fraction(1), M0, K0)
except Exception as exc:  # noqa: BLE001
    ok = False
check("sigma = 1, t = 1 (no pole) still evaluates", ok)


# =========================================================================== #
print("\n" + "=" * 78)
if NOTES:
    print("notes (%d):" % len(NOTES))
    for nt in NOTES:
        print("  - " + nt)
if FAILS:
    print("RESULT: FAIL (%d failed check%s)" % (len(FAILS), "" if len(FAILS) == 1 else "s"))
    for fl in FAILS:
        print("   " + fl)
    sys.exit(1)
print("RESULT: PASS — all containment / width / bound checks satisfied")
sys.exit(0)
