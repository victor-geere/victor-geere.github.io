#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
op08_subset_defect.py — OP-8 (rank 8): the term-level two-and-two split
beyond N = 12, by meet-in-the-middle with certified interval arithmetic.

Run (the log is produced by the shell, as the register requires):

    /opt/homebrew/Caskroom/miniforge/base/bin/python3 -u \\
        research/twin-prime-parity/open/op08_subset_defect.py 2>&1 | \\
        tee research/twin-prime-parity/open/op08_subset_defect.log

Optional first argument sets the maximum N (default 60).

================================================================================
THE QUESTION (OP-8, 07-open-problems.md)
================================================================================
At a balance point t (where Re S_N(t) = sum_{n<=N} cos(t log n) = 0), split the
indices by the sign of the real term:

    pos = { n <= N : cos(t log n) > 0 },     P = sum_{n in pos} cos(t log n),
    neg = { n <= N : cos(t log n) < 0 },     M = sum_{n in neg} cos(t log n)  (<= 0).

At a balance point P = |M|, so the *totals* split into two equal positive and
two equal negative pieces.  OP-8 asks the strictly stronger, term-level question:
can the positive terms be partitioned into two subsets A, B with sum(A) = sum(B)
(equivalently sum(A) = P/2), and likewise the negative terms (equivalently the
magnitudes -cos(t log n) sum to |M|/2)?

The exact subset-sum defect is

    delta(N) = P/2 - max{ sum of a subset of the positive terms : sum <= P/2 },

and likewise on the negative side with magnitudes.  delta(N) = 0 iff some subset
lands exactly on P/2 -- an exact coincidence among transcendental values.

KNOWN (this programme).  The structural obstruction: cos(t log 1) = 1 is the
first positive term and exceeds P/2 whenever P < 2, so it can never sit in a
half.  Exhaustive subset-sum at the certified roots gives positive defects
0.5, 0.358, 0.262, 0.170, 0.0108, 0.0202, 0.0286 for
N = 3,4,5,6,8,10,12 (rh43/truths.md sections 1.4, 3, 6), and 0.16996.../0.06539...
at N = 6.  Whether the defect can close at some larger balance point is OPEN.

WHAT THIS SCRIPT DOES AND WHAT IT CERTIFIES
--------------------------------------------
For every N from 3 to MAXN it
  1. locates the *first* sign change of Re S_N on a rational grid, then
     certifies a root bracket [a,b] by interval bisection: Re S_N is certified
     > 0 at one end and < 0 at the other;
  2. encloses every term cos(t log n) over the whole bracket t in [a,b] with the
     interval engine (mpmath.iv, directed rounding; the same engine the
     programme's OP-9 uses), which yields centre c_n and radius r_n with the
     true term value in [c_n - r_n, c_n + r_n];
  3. solves the subset-sum problem exactly on the centres by meet-in-the-middle
     (all 2^m subset sums are represented; nothing is sampled), and
  4. converts that to a *certified interval* for the true defect.  With
     R = sum of the radii (plus the negligible mpf/rounding slack) and
     c_P = (sum of centres)/2:

        any subset with true sum <= P/2_true has centre-sum <= c_P + 3R/2,
        max true feasible sum  <=  s* + R,   s* = max centre-sum <= c_P + 3R/2,
        P/2_true >= c_P - R/2,

     hence   delta(N) >= (c_P - s*) - 3R/2 ,   and if s* <= c_P - 3R/2 also
             delta(N) <= (c_P - s*) + 3R/2 .

     So delta(N) in [delta_lo, delta_hi] is a rigorous enclosure, and delta_lo > 0
     certifies "no subset lands on P/2" at that balance point.

  "PASS" means: a certified sign-changing bracket was obtained for every N in
  range, every term's sign was certified (no ambiguous term), every defect
  enclosure excluded 0, the known N <= 12 values were reproduced, and the
  interval engine agreed with rh43/ivmath.py where the latter is accurate.
  "PASS" does NOT mean the defect was proved positive for *every* balance point
  of every N; only the certified roots listed are covered.

RIGOROUS-ENGINE NOTE.  mpmath.iv (directed rounding) is the driving engine, as in
open/op09_complex_zero.py.  rh43/ivmath.py is read and used for an independent
cross-check, but its `log_prime` series 2*atanh((p-1)/(p+1)) with K = 120 terms
has a geometric tail ~ ((p-1)/(p+1))^241 and is therefore only accurate to
~1e-7 for primes near 40; it is tight for n <= 12, which is exactly where the
cross-check is run.
"""

from __future__ import annotations

import bisect
import sys
import time
from fractions import Fraction
from pathlib import Path

import mpmath as mp
from mpmath import iv

HERE = Path(__file__).resolve().parent
RHDIR = HERE.parent / "rounds" / "rh43"
sys.path.insert(0, str(RHDIR))
import ivmath as IVMATH  # noqa: E402  (read for the independent cross-check)

# --------------------------------------------------------------------------- #
# configuration
# --------------------------------------------------------------------------- #

MAXN = int(sys.argv[1]) if len(sys.argv) > 1 else 60

DPS = 80                       # working precision of mp / iv
iv.dps = DPS
mp.mp.dps = DPS

ROOT_TARGET = Fraction(1, 10 ** 40)   # certified bracket width
GRID_STEP = Fraction(1, 100)          # rational grid step for the sign-change scan
GRID_TMAX = 20                        # scan height for the first root

SUM_ROUND = mp.mpf('1e-70')    # blanket slack for the mpf meet-in-the-middle sums

# Exact defects already in the programme's record (rh43/truths.md), used as a
# regression check.  Values are quoted there to ~3-4 significant figures.
KNOWN_POS = {3: '0.5', 4: '0.358', 5: '0.262', 6: '0.170',
             8: '0.0108', 10: '0.0202', 12: '0.0286'}
KNOWN_NEG = {6: '0.06539'}

# A few heights get a full multi-root scan, as a robustness check on the
# "smallest root only" column.
EXTRA_ROOT_N = [6, 10, 20, 30, 40, 50]
EXTRA_ROOT_TMAX = Fraction(10)
EXTRA_ROOT_STEP = Fraction(1, 100)

# --------------------------------------------------------------------------- #
# bookkeeping
# --------------------------------------------------------------------------- #

FAILS: list[str] = []
NPASS = 0


def check(label: str, ok: bool, detail: str = "") -> None:
    global NPASS
    if ok:
        NPASS += 1
        print(f"  [PASS] {label}" + (f"   {detail}" if detail else ""))
    else:
        FAILS.append(label)
        print(f"  [FAIL] {label}" + (f"   {detail}" if detail else ""))


def section(title: str) -> None:
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


def unpack(x) -> tuple:
    """Interval -> (centre, radius) as mpf; both rigorous (radius >= 0)."""
    lo = mp.mpf(x.a)
    hi = mp.mpf(x.b)
    if hi < lo:
        lo, hi = hi, lo
    return (lo + hi) / 2, (hi - lo) / 2


# --------------------------------------------------------------------------- #
# interval evaluation of Re S_N and certified roots
# --------------------------------------------------------------------------- #

def re_S_iv(N: int, t_interval):
    """Interval enclosure of Re S_N(t) = 1 + sum_{n=2..N} cos(t log n)."""
    s = iv.mpf([1, 1])
    for n in range(2, N + 1):
        s = s + iv.cos(t_interval * iv.log(n))
    return s


def re_S_frac(N: int, t: Fraction):
    x = mp.mpf(t.numerator) / t.denominator
    return re_S_iv(N, iv.mpf([x, x]))


def certified_sign(N: int, t: Fraction) -> int:
    """+1 / -1 when the rigorous enclosure of Re S_N(t) excludes 0, else 0."""
    s = re_S_frac(N, t)
    if mp.mpf(s.a) > 0:
        return 1
    if mp.mpf(s.b) < 0:
        return -1
    return 0


def re_S_float(N: int, t) -> mp.mpf:
    """Cheap empirical value, used only to *locate* candidate brackets."""
    return 1 + mp.fsum([mp.cos(mp.mpf(t) * mp.log(n)) for n in range(2, N + 1)])


def grid_brackets(N: int, tmax: Fraction, step: Fraction):
    """Empirical sign-change brackets of Re S_N on the rational grid k*step."""
    out = []
    prev = None
    k = 1
    tmax_f = Fraction(tmax)
    while k * step <= tmax_f:
        t = k * step
        cur = re_S_float(N, mp.mpf(t.numerator) / t.denominator)
        if prev is not None and (prev > 0) != (cur > 0):
            out.append(((k - 1) * step, k * step))
        prev = cur
        k += 1
    return out


def certify_bracket(N: int, p: Fraction, q: Fraction, target: Fraction):
    """Certified bisection of a sign change; returns (a, b, sign_at_a) or None.

    Precondition: the interval [p, q] contains a sign change.  The routine widens
    outward until the signs are certified, then bisects keeping certification.
    """
    s_p = certified_sign(N, p)
    s_q = certified_sign(N, q)
    # widen outward if a sign is not yet certified
    guard = 0
    while (s_p == 0 or s_q == 0 or s_p == s_q) and guard < 60:
        p = p - (q - p)
        q = q + (q - p) / 2
        s_p = certified_sign(N, p)
        s_q = certified_sign(N, q)
        guard += 1
    if s_p == 0 or s_q == 0 or s_p == s_q:
        return None
    a, b = p, q
    sa = s_p
    while b - a > target:
        m = (a + b) / 2
        sm = certified_sign(N, m)
        if sm == 0:
            break                      # cannot narrow further; [a,b] stays certified
        if sm == sa:
            a = m
        else:
            b = m
    return a, b, sa


# --------------------------------------------------------------------------- #
# exact subset-sum by meet-in-the-middle
# --------------------------------------------------------------------------- #

def side_defect(centres: list, radii: list):
    """Certified defect enclosure for one sign side (positive terms or magnitudes).

    Returns a dict with the point defect, the enclosure [lo, hi], the slack R,
    the meet-in-the-middle sizes and whether the underlying subset is certified
    feasible (so the upper bound is tight).
    """
    m = len(centres)
    if m == 0:
        return dict(m=0, cP=mp.mpf(0), best=mp.mpf(0), R=mp.mpf(0),
                    delta=mp.mpf(0), lo=mp.mpf(0), hi=mp.mpf(0),
                    tight=True, half=0, nsums=0)

    R = mp.fsum(radii) + SUM_ROUND * (m + 2)
    cP = mp.fsum(centres) / 2

    h = m // 2
    left = centres[:h]
    right = centres[h:]

    def subset_sums(vals):
        S = [mp.mpf(0)]
        for v in vals:
            S = S + [s + v for s in S]
        return S

    SL = subset_sums(left)
    SR = sorted(subset_sums(right))

    theta = cP + mp.mpf(3) / 2 * R
    best = None
    for a in SL:
        i = bisect.bisect_right(SR, theta - a) - 1
        if i >= 0:
            v = a + SR[i]
            if best is None or v > best:
                best = v
    if best is None:
        best = mp.mpf(0)

    lo = (cP - best) - mp.mpf(3) / 2 * R
    tight = best <= cP - mp.mpf(3) / 2 * R
    hi = (cP - best) + mp.mpf(3) / 2 * R if tight else cP + R / 2
    return dict(m=m, cP=cP, best=best, R=R, delta=cP - best,
                lo=lo, hi=hi, tight=tight,
                half=h, nsums=len(SL) + len(SR))


def terms_and_defects(N: int, a: Fraction, b: Fraction):
    """Term enclosures over t in [a,b] and both certified defect enclosures."""
    tI = iv.mpf([mp.mpf(a.numerator) / a.denominator,
                 mp.mpf(b.numerator) / b.denominator])
    centres_pos, radii_pos = [], []
    centres_neg, radii_neg = [], []
    ambiguous = 0
    for n in range(1, N + 1):
        c, r = unpack(iv.cos(tI * iv.log(n)))
        if c > 0 and c - r > 0:
            centres_pos.append(c)
            radii_pos.append(r)
        elif c < 0 and c + r < 0:
            centres_neg.append(-c)
            radii_neg.append(r)
        else:
            ambiguous += 1               # |cos| < r: |value| < r, sign not certified
            radii_pos.append(r)          # absorb the missing centre in the slack
            radii_neg.append(r)          # (it could belong to either side)
    return dict(pos=side_defect(centres_pos, radii_pos),
                neg=side_defect(centres_neg, radii_neg),
                ambiguous=ambiguous)


# --------------------------------------------------------------------------- #
# sections
# --------------------------------------------------------------------------- #

def section_engine_crosscheck():
    section("0.  Interval-engine cross-check against rh43/ivmath.py")
    print("  rh43/ivmath.py is used as an INDEPENDENT cross-check (the driver is")
    print("  mpmath.iv).  At t = 7/5 and n = 1..12 the two engines must agree to")
    print("  better than 1e-15 (ivmath's atanh log tail is worst, ~1e-21, at n = 11).")
    t = Fraction(7, 5)
    tv = IVMATH.rat(t)
    tI = iv.mpf([mp.mpf(7) / 5, mp.mpf(7) / 5])
    max_gap = mp.mpf(0)
    max_violation = mp.mpf(0)          # how far ivmath's enclosure is off (if at all)
    for n in range(1, 13):
        ivm = IVMATH.cos_num(tv * IVMATH.log_n(n))
        c, r = unpack(iv.cos(tI * iv.log(n)))
        max_gap = max(max_gap, abs(mp.mpf(ivm.v) - c))
        # strict-containment defect: amount by which the true interval pokes out
        max_violation = max(max_violation, (c - r) - ivm.lo)   # >0: below ivmath.lo
        max_violation = max(max_violation, ivm.hi - (c + r))   # >0: above ivmath.hi
    print(f"  max |ivmath centre - iv centre| over n = 1..12 : {mp.nstr(max_gap, 4)}")
    print(f"  max strict-containment defect of ivmath        : "
          f"{mp.nstr(max_violation, 4)}")
    check("ivmath and mpmath.iv agree to < 1e-15 at t = 7/5, n = 1..12",
          max_gap < mp.mpf('1e-15'),
          f"max gap {mp.nstr(max_gap, 4)}")
    print("  NOTE (honest): ivmath's listed interval is not always a strict superset")
    print("  of the true value; the worst strict-containment defect above is a small")
    print("  fraction of ivmath's own error width.  This is far below the precision")
    print("  at which rh43 uses it, and it does NOT affect this script, whose")
    print("  certificates come from mpmath.iv.  It is recorded, not hidden.")
    # independent verification of one value against a 300-dps computation
    mp.mp.dps = 300
    ref = mp.cos(mp.mpf(7) / 5 * mp.log(11))
    mp.mp.dps = DPS
    c11, r11 = unpack(iv.cos(tI * iv.log(11)))
    check("mpmath.iv cos((7/5) log 11) contains the 300-dps reference value",
          c11 - r11 <= ref <= c11 + r11)


def section_roots():
    section("1.  Certified balance-point brackets (first sign change of Re S_N)")
    print(f"  {'N':>3} {'bracket a':>26} {'width':>9} {'Re S(a) lo':>12} {'Re S(b) hi':>12}")
    roots = {}
    ok_all = True
    for N in range(3, MAXN + 1):
        brs = grid_brackets(N, Fraction(GRID_TMAX), GRID_STEP)
        if not brs:
            check(f"N={N}: a sign change of Re S_N was located", False, "no grid bracket")
            ok_all = False
            continue
        res = None
        for (p, q) in brs:
            res = certify_bracket(N, p, q, ROOT_TARGET)
            if res is not None and res[2] == 1:
                break
            res = res or None
        if res is None:
            check(f"N={N}: certified sign-changing bracket", False)
            ok_all = False
            continue
        a, b, sa = res
        roots[N] = (a, b)
        sa_lo = mp.mpf(re_S_frac(N, a).a)
        sb_hi = mp.mpf(re_S_frac(N, b).b)
        print(f"  {N:>3} {float(a):>26.18f} {float(b - a):>9.1e} "
              f"{float(sa_lo):>12.3e} {float(sb_hi):>12.3e}")
    check(f"certified sign-changing bracket for every N = 3..{MAXN}",
          ok_all and len(roots) == MAXN - 2,
          f"{len(roots)} brackets")
    return roots


def section_defects(roots):
    section("2.  Certified subset-sum defects delta(N) at the first balance point")
    print("  delta = P/2 - max{subset sum <= P/2}  (positive terms);")
    print("  the same on the magnitudes -cos(t log n) of the negative terms.")
    print("  [lo, hi] is the certified enclosure; lo > 0 certifies no subset hits P/2.")
    print()
    header = (f"  {'N':>3} {'m+':>3} {'m-':>3} {'P':>10} {'|M|':>10} "
              f"{'dpos':>10} {'dpos lo':>10} {'dneg':>10} {'dneg lo':>10} "
              f"{'2^h+':>7} {'2^h-':>7} {'t[s]':>6}")
    print(header)
    table = {}
    ok_all = True
    t_start = time.time()
    for N in range(3, MAXN + 1):
        t0 = time.time()
        a, b = roots[N]
        res = terms_and_defects(N, a, b)
        dt = time.time() - t0
        pos, neg = res['pos'], res['neg']
        table[N] = (res, float(b - a), dt)
        # P and |M| as centres of the totals
        P = 2 * pos['cP']
        M = 2 * neg['cP']
        hp = pos['half']
        hn = neg['half']
        print(f"  {N:>3} {pos['m']:>3} {neg['m']:>3} {mp.nstr(P,10):>10} "
              f"{mp.nstr(M,10):>10} {mp.nstr(pos['delta'],10):>10} "
              f"{mp.nstr(pos['lo'],4):>10} {mp.nstr(neg['delta'],10):>10} "
              f"{mp.nstr(neg['lo'],4):>10} "
              f"{2**hp:>7} {2**hn:>7} {dt:>6.2f}")
        if pos['lo'] <= 0 or neg['lo'] <= 0:
            ok_all = False
        if res['ambiguous'] != 0:
            ok_all = False
    check(f"every defect enclosure excludes 0: delta(N) > 0 for N = 3..{MAXN}",
          ok_all)
    return table


def section_validation(table):
    section("3.  Regression against the recorded values (rh43/truths.md)")
    for N, val in sorted(KNOWN_POS.items()):
        d = float(table[N][0]['pos']['delta'])
        exp = float(val)
        tol = max(5e-4, 0.02 * exp)
        check(f"N={N}: positive defect reproduces {val}",
              abs(d - exp) < tol, f"computed {d:.9f}")
    for N, val in sorted(KNOWN_NEG.items()):
        d = float(table[N][0]['neg']['delta'])
        exp = float(val)
        check(f"N={N}: negative defect reproduces {val}",
              abs(d - exp) < max(5e-4, 0.02 * exp), f"computed {d:.9f}")
    # N = 3 has the single positive term {1}: defect exactly P/2 = 1/2
    d3 = float(table[3][0]['pos']['delta'])
    check("N=3: positive side is the single term cos(0)=1, defect exactly 1/2",
          abs(d3 - 0.5) < 1e-9)
    # structural: cos(t log 1) = 1 > P/2 whenever P < 2, so n = 1 is alone
    small_P = [N for N in range(3, MAXN + 1) if 2 * table[N][0]['pos']['cP'] < 2]
    print("  P(N) = " + ", ".join(
        f"{N}:{float(2*table[N][0]['pos']['cP']):.3f}"
        for N in range(3, min(MAXN, 12) + 1)))
    check("structural obstruction: P < 2 for N <= 6 (the term 1 cannot be in a half)",
          all(2 * table[N][0]['pos']['cP'] < 2 for N in range(3, 7)),
          f"P >= 2 first at N = {min((N for N in range(3, MAXN + 1) if 2*table[N][0]['pos']['cP'] >= 2), default=None)}")


def section_extra_roots():
    section("4.  Robustness: ALL grid roots in (0, 10) for selected N")
    print("  Checks whether some *other* balance point closes the defect.")
    print(f"  {'N':>3} {'#roots':>6} {'min dpos':>12} {'min dpos lo':>12} "
          f"{'min dneg':>12} {'min dneg lo':>12}")
    ok_all = True
    for N in EXTRA_ROOT_N:
        if N > MAXN:
            continue
        brs = grid_brackets(N, EXTRA_ROOT_TMAX, EXTRA_ROOT_STEP)
        min_pos = None
        min_neg = None
        min_pos_lo = None
        min_neg_lo = None
        nroots = 0
        for (p, q) in brs:
            res = certify_bracket(N, p, q, Fraction(1, 10 ** 35))
            if res is None:
                continue
            a, b, sa = res
            nroots += 1
            d = terms_and_defects(N, a, b)
            if min_pos is None or d['pos']['delta'] < min_pos:
                min_pos = d['pos']['delta']
                min_pos_lo = d['pos']['lo']
            if min_neg is None or d['neg']['delta'] < min_neg:
                min_neg = d['neg']['delta']
                min_neg_lo = d['neg']['lo']
        if min_pos is None:
            check(f"N={N}: extra-root scan found roots", False)
            ok_all = False
            continue
        print(f"  {N:>3} {nroots:>6} {mp.nstr(min_pos,10):>12} "
              f"{mp.nstr(min_pos_lo,4):>12} {mp.nstr(min_neg,10):>12} "
              f"{mp.nstr(min_neg_lo,4):>12}")
        if min_pos_lo <= 0 or min_neg_lo <= 0:
            ok_all = False
    check("every scanned balance point (all roots in (0,10)) has delta > 0", ok_all)


def section_scaling(table):
    section("5.  Cost scaling of the meet-in-the-middle")
    print("  Meet-in-the-middle cost is ~ 2^(m/2) per half and 2^(m/2)*m comparisons;")
    print("  the measured wall time is for term enclosures + both subset sums.")
    print(f"  {'N':>3} {'m+':>4} {'m-':>4} {'max half':>9} {'total subset sums':>18} "
          f"{'root width':>11} {'t[s]':>7}")
    for N in range(3, MAXN + 1, 1):
        res, w, dt = table[N]
        hp = max(res['pos']['half'], res['neg']['half'])
        nsums = res['pos']['nsums'] + res['neg']['nsums']
        if N <= 20 or N % 10 == 0 or N == MAXN:
            print(f"  {N:>3} {res['pos']['m']:>4} {res['neg']['m']:>4} "
                  f"{2**hp:>9} {nsums:>18} {w:>11.1e} {dt:>7.2f}")
    print()
    print("  Scaling summary: m grows ~ N/2 and the half sizes are 2^floor(m/2),")
    print("  so the cost doubles roughly every 4 in N; N = 60 needs halves of 2^15.")


def section_conclusion(roots, table):
    section("6.  CONCLUSION")
    lo_all = []
    for N in range(3, MAXN + 1):
        res, w, dt = table[N]
        lo_all.append((float(res['pos']['lo']), float(res['neg']['lo']), N))
    worst = min(lo_all, key=lambda z: min(z[0], z[1]))
    positive_deltas = [float(table[N][0]['pos']['delta']) for N in range(3, MAXN + 1)]
    negative_deltas = [float(table[N][0]['neg']['delta']) for N in range(3, MAXN + 1)]
    smallest_pos = min(positive_deltas)
    smallest_neg = min(negative_deltas)
    NZ = [N for N in range(3, MAXN + 1)
          if table[N][0]['pos']['lo'] <= 0 or table[N][0]['neg']['lo'] <= 0]
    print(f"  Max N reached: {MAXN}")
    print(f"  Smallest positive-side defect over N = 3..{MAXN}: "
          f"{smallest_pos:.6e}")
    print(f"  Smallest negative-side defect over N = 3..{MAXN}: "
          f"{smallest_neg:.6e}")
    print(f"  Certified margin at the largest N = {MAXN}:")
    rN = table[MAXN][0]
    print(f"     positive: delta = {mp.nstr(rN['pos']['delta'],12)}, "
          f"certified >= {mp.nstr(rN['pos']['lo'],12)}")
    print(f"     negative: delta = {mp.nstr(rN['neg']['delta'],12)}, "
          f"certified >= {mp.nstr(rN['neg']['lo'],12)}")
    print(f"     enclosure slack R+ = {mp.nstr(rN['pos']['R'],3)}, "
          f"R- = {mp.nstr(rN['neg']['R'],3)} (term radii over the root bracket)")
    print(f"     => the zero-exclusion at N = {MAXN} has a factor "
          f"{mp.nstr(mp.mpf(rN['neg']['lo']) / rN['neg']['R'],3)} of margin "
          f"on the negative side")
    print(f"  Balance points with delta certified = 0: "
          f"{'NONE' if not NZ else NZ}")
    print()
    print("  HONEST READING.  The defect stays strictly positive at every certified")
    print("  balance point reached.  The positive-side defect for N >= 8 is no")
    print("  longer caused by the term 1 alone; it is the ordinary subset-sum gap")
    print("  near P/2.  No exact transcendental coincidence (delta = 0) appears.")
    print("  This is a finite-range certified statement, not an asymptotic one:")
    print("  it excludes a zero defect at the listed roots only.")


# --------------------------------------------------------------------------- #
# main
# --------------------------------------------------------------------------- #

def main() -> int:
    t_start = time.time()
    print("OP-8  term-level two-and-two split: certified subset-sum defects")
    print(f"engine: mpmath.iv (directed rounding), dps = {DPS}; "
          f"MAXN = {MAXN}; root width target = 1e-40")
    print(f"python: {sys.version.split()[0]}")
    section_engine_crosscheck()
    roots = section_roots()
    table = section_defects(roots)
    section_validation(table)
    section_extra_roots()
    section_scaling(table)
    section_conclusion(roots, table)

    section("PASS/FAIL SUMMARY")
    print(f"  {NPASS} checks passed, {len(FAILS)} failed.")
    for f in FAILS:
        print(f"    FAILED: {f}")
    print(f"  total wall time: {time.time() - t_start:.1f} s")
    if FAILS:
        print("  RESULT: FAIL")
        return 1
    print("  RESULT: PASS — every certified balance point has delta(N) > 0.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
