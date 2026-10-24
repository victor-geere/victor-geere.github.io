#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
op09_complex_zero.py — OP-9: exact complex vanishing of the zeta partial sums

    S_N(t) = sum_{n=1}^{N} n^{-it} = sum_{n=1}^{N} exp(-i t log n)   (in C),

for N = 4..10 on the real interval t in [0,T], T default 1000.

WHAT IS PROVED HERE (and what is not)
-------------------------------------
The script decides, with *rigorous interval arithmetic* (mpmath.iv, directed
rounding), for each N one of

  (A) NO ZERO EXISTS on the covered range: a certified positive lower bound
      |S_N(t)| >= delta > 0 for every t in [0,T]; or
  (B) the range is NOT fully decided, in which case the script reports every
      unresolved sub-interval (the only places a zero could hide).

The certificate is a branch-and-bound on cells [a,b] with midpoint m and
half-width h=(b-a)/2:

    |S_N(t)| >= |S_N(m)| - sup_{xi in [a,b]} |S_N'(xi)| * h
             >= |S_N(m)| - ( |S_N'(m)| + L2 * h ) * h ,      L2 = sum_{n<=N} (log n)^2 ,

by the mean value theorem applied twice (|S_N'| is itself Lipschitz with
constant L2 = sum (log n)^2, since |(n^{-it})''| = (log n)^2).  The quantities
|S_N(m)| (lower bound) and |S_N'(m)| (upper bound) are obtained from interval
enclosures of Re S_N, Im S_N and their t-derivatives at m.  If the right side is
> 0 the cell contains no zero and the value is a certified lower bound there;
otherwise the cell is bisected and the test repeated, to a depth cap.

The derivative comes for free: with c_n = cos(t log n), s_n = sin(t log n),

    Re S_N = sum c_n ,   Im S_N = -sum s_n ,
    Re S_N' = -sum (log n) s_n ,   Im S_N' = -sum (log n) c_n .

Honest logical status.  A positive lower bound proves "no zero exists" on the
covered set.  Failure to certify is reported as "not decided" and must never be
read as "no zero found therefore no zero".  For a *complex-valued* function of a
real variable there is no IVT/degree-1 existence test of the form "Re and Im
both change sign in a box": the curve can pass from quadrant I to quadrant III
through II or IV without hitting 0, and a nonzero winding of an open arc does
not force it through 0 either.  The script therefore does not manufacture a
zero bracket; existence would need an independent argument (as for N=2, where
S_2(pi/log 2)=0 exactly).  N=2 is run as a CONTROL: the method must refuse to
certify around its tangential zeros, and it does.  N=3 is a CONTROL with a known
Lean theorem (zetaPartial_three_ne_zero): the method must certify.

Run:
    /opt/homebrew/Caskroom/miniforge/base/bin/python3 \
        research/twin-prime-parity/open/op09_complex_zero.py \
        2>&1 | tee research/twin-prime-parity/open/op09_complex_zero.log

Exit status is 0; the last line is a PASS/FAIL summary.
"""
from __future__ import annotations

import argparse
import math
import os
import sys
import time
from fractions import Fraction

import numpy as np
from mpmath import iv


# ---------------------------------------------------------------------------
# Optional independent cross-check engine: the rh43 auditor's rational
# fixed-point interval arithmetic (rounds/rh43/verify/independent_check.py).
# It uses exact rationals and its own pi/log/sin/cos Taylor engines, so it
# shares no code path with mpmath.iv.
# ---------------------------------------------------------------------------
def _load_auditor():
    here = os.path.dirname(os.path.abspath(__file__))
    cand = os.path.join(here, "..", "rounds", "rh43", "verify")
    if os.path.isdir(cand) and cand not in sys.path:
        sys.path.insert(0, cand)
    try:
        import independent_check as IC  # type: ignore
        return IC
    except Exception as exc:  # pragma: no cover
        print("  [self-check] auditor unavailable (%s)" % exc)
        return None


AUDITOR = _load_auditor()

# ---------------------------------------------------------------------------
# Rigorous engine: interval arithmetic at IV_DPS decimal digits (directed
# rounding inside mpmath.iv).  Widths of a generic evaluation at IV_DPS = 40
# are ~1e-39, thirteen orders below the smallest lower bounds reported below.
# ---------------------------------------------------------------------------
IV_DPS = 40
iv.dps = IV_DPS


def iv_frac(fr: Fraction):
    """The exact rational fr as a rigorous interval (outward-rounded division)."""
    return iv.mpf(fr.numerator) / iv.mpf(fr.denominator)


def make_logs(N: int):
    """Rigorous enclosures of log n (2<=n<=N) and of L2 = sum (log n)^2."""
    logs = {n: iv.log(n) for n in range(2, N + 1)}
    l2 = iv.mpf(0)
    for v in logs.values():
        l2 = l2 + v * v
    return logs, l2


def eval_point(N: int, logs, t_iv):
    """Rigorous enclosures of S_N, S_N' at the (interval) point t_iv."""
    re = iv.mpf(1)
    im = iv.mpf(0)
    dre = iv.mpf(0)
    dim = iv.mpf(0)
    for n in range(2, N + 1):
        th = t_iv * logs[n]
        c = iv.cos(th)
        s = iv.sin(th)
        re = re + c
        im = im - s
        dre = dre - logs[n] * s
        dim = dim - logs[n] * c
    return re, im, dre, dim


def cell_bound(N: int, logs, l2, m: Fraction, h: Fraction):
    """Certified lower bound of |S_N| on [m-h, m+h] (all rigorous interval ops).

    Returns (bound_lo, mag_lo, d_hi): bound_lo is a floating point lower bound
    of the certificate (>=0 means certified zero-free); mag_lo and d_hi are the
    interval lower bound of |S_N(m)| and upper bound of |S_N'(m)|.
    """
    re, im, dre, dim = eval_point(N, logs, iv_frac(m))
    mag = iv.sqrt(re * re + im * im)          # interval containing |S_N(m)|
    ders = iv.sqrt(dre * dre + dim * dim)     # interval containing |S_N'(m)|
    h_iv = iv_frac(h)
    slope = ders + l2 * h_iv                  # >= sup_{cell} |S_N'|
    bnd = mag - slope * h_iv
    return bnd.a, mag.a, ders.b


# ---------------------------------------------------------------------------
# Branch and bound over [0, T]
# ---------------------------------------------------------------------------

def certify(N: int, T: Fraction, h0: Fraction, max_depth: int,
            time_limit: float, verbose: bool = True):
    """Certify |S_N| > 0 on [0,T] (or report the unresolved cells)."""
    logs, l2 = make_logs(N)
    t_start = time.time()

    n_cells0 = math.ceil(T / h0)
    cells = []
    for k in range(n_cells0):
        a = h0 * k
        b = h0 * (k + 1) if k + 1 < n_cells0 else T
        if b > T:
            b = T
        cells.append((a, b, 0))
    # last cell may be degenerate if T is a multiple of h0
    cells = [c for c in cells if c[0] < c[1]]

    stack = list(cells)
    min_bound = None
    min_cell = None
    unresolved = []
    resolved_width = Fraction(0)
    evals = 0
    timed_out = False

    while stack:
        a, b, d = stack.pop()
        m = (a + b) / 2
        h = (b - a) / 2
        bnd, mag, dhi = cell_bound(N, logs, l2, m, h)
        evals += 1
        if bnd > 0:
            resolved_width += (b - a)
            if min_bound is None or bnd < min_bound:
                min_bound = bnd
                min_cell = (a, b, mag, dhi)
        elif d >= max_depth or (b - a) < Fraction(1, 10 ** 18):
            unresolved.append((a, b, mag, dhi))
        else:
            stack.append((a, m, d + 1))
            stack.append((m, b, d + 1))
        if evals % 20000 == 0 and time.time() - t_start > time_limit:
            timed_out = True
            unresolved.extend((x[0], x[1], None, None) for x in stack)
            break

    elapsed = time.time() - t_start
    return {
        "N": N,
        "evals": evals,
        "elapsed": elapsed,
        "min_bound": min_bound,
        "min_cell": min_cell,
        "unresolved": unresolved,
        "resolved_width": resolved_width,
        "T": T,
        "timed_out": timed_out,
        "n_cells_init": len(cells),
    }


# ---------------------------------------------------------------------------
# Empirical (NOT certified) scan, for orientation only
# ---------------------------------------------------------------------------

def empirical_min(N: int, T: float, step: float):
    ln = np.log(np.arange(1, N + 1))
    best = (float("inf"), 0.0)
    ntot = int(math.ceil(T / step))
    chunk = 400_000
    start = 0
    while start < ntot:
        stop = min(ntot, start + chunk)
        tt = np.arange(start, stop, dtype=np.float64) * step
        re = np.ones_like(tt)
        im = np.zeros_like(tt)
        for k in range(1, N):
            re += np.cos(tt * ln[k])
            im -= np.sin(tt * ln[k])
        ab = np.hypot(re, im)
        i = int(np.argmin(ab))
        if ab[i] < best[0]:
            best = (float(ab[i]), float(tt[i]))
        start = stop
    return best


def fmt(x, digits: int = 6) -> str:
    if x is None:
        return "n/a"
    if x == 0:
        return "0"
    if abs(x) < 1e-3 or abs(x) >= 1e5:
        return "%.4e" % x
    return "%.*f" % (digits, x)


# ---------------------------------------------------------------------------
# Self-check of the rigorous engine
# ---------------------------------------------------------------------------

def self_check(order, T: Fraction, per_N: int = 20):
    """Validate the iv enclosures used by the certificate.

    Two independent routes:
      * plain mpmath at 120 dps (a different precision path), and
      * the rh43 auditor's exact rational fixed-point interval engine.
    For each sampled t and each of Re, Im, Re', Im', the route's (tight)
    enclosure must lie inside our iv enclosure.  A single failure would
    invalidate the certificate.
    """
    import mpmath as mp

    tot = {"mpmath": [0, 0], "auditor": [0, 0]}
    fails = []

    for N in order:
        logs, l2 = make_logs(N)
        for j in range(per_N):
            m = T * Fraction(2 * j + 1, 2 * per_N)
            re, im, dre, dim = eval_point(N, logs, iv_frac(m))

            saved = mp.mp.dps
            mp.mp.dps = 120
            try:
                tm = mp.mpf(m.numerator) / mp.mpf(m.denominator)
                tre = mp.mpf(1)
                tim = mp.mpf(0)
                tdr = mp.mpf(0)
                tdi = mp.mpf(0)
                for n in range(2, N + 1):
                    L = mp.log(n)
                    th = tm * L
                    c = mp.cos(th)
                    s = mp.sin(th)
                    tre += c
                    tim -= s
                    tdr -= L * s
                    tdi -= L * c
            finally:
                mp.mp.dps = saved

            comps = [(re, tre), (im, tim), (dre, tdr), (dim, tdi)]
            for ours, truth in comps:
                tot["mpmath"][1] += 1
                if not (ours.a <= truth <= ours.b):
                    tot["mpmath"][0] += 1
                    fails.append(("mpmath", N, float(m), str(ours), str(truth)))

            if AUDITOR is not None:
                a = AUDITOR.Iv(m)
                r2, i2 = AUDITOR.reim_S(N, a)
                dr2 = AUDITOR.dre_S(N, a)
                di2 = AUDITOR.dim_S(N, a)

                def mpf_of(fr):
                    mp.mp.dps = 120
                    return mp.mpf(fr.numerator) / mp.mpf(fr.denominator)

                for ours, aud in ((re, r2), (im, i2), (dre, dr2), (dim, di2)):
                    tot["auditor"][1] += 1
                    lo = mpf_of(aud.loF)
                    hi = mpf_of(aud.hiF)
                    if not (ours.a <= lo and hi <= ours.b):
                        tot["auditor"][0] += 1
                        fails.append(("auditor", N, float(m), str(ours), str((lo, hi))))
    return tot, fails


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main(argv=None):
    ap = argparse.ArgumentParser(description="OP-9 certified complex-zero search")
    ap.add_argument("--T", type=str, default="1000", help="upper end of the t-range")
    ap.add_argument("--h0", type=str, default="1/20", help="initial cell width")
    ap.add_argument("--maxdepth", type=int, default=60)
    ap.add_argument("--time", type=float, default=1200.0, help="per-N time limit (s)")
    ap.add_argument("--Ns", type=str, default="4,5,6,7,8,9,10")
    ap.add_argument("--controls", type=str, default="2,3")
    args = ap.parse_args(argv)

    T = Fraction(args.T)
    h0 = Fraction(args.h0)
    Ns = [int(s) for s in args.Ns.split(",") if s]
    ctrls = [int(s) for s in args.controls.split(",") if s]

    print("=" * 78)
    print("OP-9  exact complex vanishing  S_N(t) = sum_{n<=N} n^{-it} = 0")
    print("=" * 78)
    print("engine        : mpmath.iv interval arithmetic, %d dps, directed rounding" % IV_DPS)
    print("certificate   : |S_N(t)| >= |S_N(m)| - (|S_N'(m)| + L2*h)*h  on [m-h,m+h]")
    print("range         : t in [0, %s]   (initial cell width h0 = %s, max depth %d)"
          % (T, h0, args.maxdepth))
    print("targets       : N = %s" % ", ".join(map(str, Ns)))
    print("controls      : N = %s  (N=2 must FAIL to certify: exact zeros; "
          "N=3 must certify: Lean theorem)" % ", ".join(map(str, ctrls)))
    print("")
    print("NOTE.  A certified lower bound proves NO ZERO EXISTS on the covered")
    print("set.  An unresolved interval is reported as NOT DECIDED -- it is not a")
    print("zero, and a failed certification is not a proof of non-existence.")
    print("=" * 78)

    order = Ns + [n for n in ctrls if n not in Ns]

    # ---------------------------------------------------------- engine self-test
    print("\n" + "-" * 78)
    print("SELF-CHECK of the rigorous engine (before any certificate is claimed)")
    print("-" * 78)
    check_order = sorted(set(order))
    tot, fails = self_check(check_order, T)
    print("  route A: plain mpmath at 120 dps        %d/%d enclosures contain the value"
          % (tot["mpmath"][1] - tot["mpmath"][0], tot["mpmath"][1]))
    if AUDITOR is not None:
        print("  route B: rh43 auditor (exact rational intervals, independent engine)")
        print("           %d/%d of our enclosures contain its tight enclosure"
              % (tot["auditor"][1] - tot["auditor"][0], tot["auditor"][1]))
    else:
        print("  route B: rh43 auditor NOT available")
    selfcheck_ok = (tot["mpmath"][0] == 0 and
                    (AUDITOR is None or tot["auditor"][0] == 0))
    if selfcheck_ok:
        print("  => engine validated: 0 containment failures on %d component checks"
              % (tot["mpmath"][1] + tot["auditor"][1]))
    else:
        print("  => ENGINE SELF-CHECK FAILED (%d failures); no certificate claimed"
              % len(fails))
        for f in fails[:5]:
            print("     ", f)

    results = {}
    for N in order:
        is_ctrl = N in ctrls
        tag = "CONTROL" if is_ctrl else "TARGET "
        print("\n" + "-" * 78)
        print("[%s] N = %d" % (tag, N))
        print("-" * 78)
        t0 = time.time()
        emin, et = empirical_min(N, float(T), 1e-3)
        print("  empirical (float, NOT a certificate) min |S_%d| over [0,%s]"
              % (N, T))
        print("      ~ %s  at t ~ %s   (grid step 1e-3)" % (fmt(emin, 9), fmt(et, 6)))
        r = certify(N, T, h0, args.maxdepth, args.time)
        results[N] = r
        print("  interval branch-and-bound: %d evaluations, %.1f s, "
              "%d initial cells" % (r["evals"], r["elapsed"], r["n_cells_init"]))
        cov = float(r["resolved_width"] / T)
        print("  covered (certified zero-free) fraction of [0,%s]: %.6f"
              % (T, cov))
        print("  exact coverage check: uncovered measure = %s (as float %.3e) -> %s"
              % (T - r["resolved_width"], float(T - r["resolved_width"]),
                 "COMPLETE" if r["resolved_width"] == T and not r["unresolved"]
                 else "INCOMPLETE"))
        if r["unresolved"]:
            print("  UNRESOLVED cells: %d  (coverage NOT complete)"
                  % len(r["unresolved"]))
            for (a, b, mag, dhi) in r["unresolved"][:8]:
                print("      t in [%s, %s]   (width %s)"
                      % (fmt(float(a), 12), fmt(float(b), 12),
                         fmt(float(b - a), 3)))
            if len(r["unresolved"]) > 8:
                print("      ... and %d more" % (len(r["unresolved"]) - 8))
        if r["min_bound"] is not None:
            a, b, mag, dhi = r["min_cell"]
            if r["unresolved"]:
                print("  certified lower bound on the covered part: "
                      "|S_%d(t)| > %s" % (N, fmt(r["min_bound"], 9)))
            else:
                print("  certified lower bound:  |S_%d(t)| > %s   for all t in [0,%s]"
                      % (N, fmt(r["min_bound"], 9), T))
            print("      tightest cell: t in [%s, %s],  |S_N(m)| >= %s, "
                  "|S_N'(m)| <= %s" % (fmt(float(a), 9), fmt(float(b), 9),
                                       fmt(mag, 9), fmt(dhi, 9)))
        print("  elapsed %.1f s" % (time.time() - t0))

    # ------------------------------------------------------------------ table
    print("\n" + "=" * 78)
    print("SUMMARY TABLE")
    print("=" * 78)
    print("%-4s %-6s %-16s %-22s %s" %
          ("N", "kind", "covered t-range", "certified statement", "status"))
    all_targets_ok = True
    target_lines = []
    for N in Ns:
        r = results[N]
        full = (not r["unresolved"])
        if full:
            stmt = "|S_%d(t)| > %s on [0,%s]" % (N, fmt(r["min_bound"], 6), T)
            status = "CERTIFIED zero-free"
            rng = "[0, %s]  (full)" % T
        else:
            stmt = "|S_%d(t)| > %s on covered part" % (N, fmt(r["min_bound"], 6))
            status = "%d UNRESOLVED" % len(r["unresolved"])
            rng = "[0, %s]  (partial)" % T
            all_targets_ok = False
        target_lines.append((N, rng, stmt, status))
        print("%-4d %-6s %-16s %-22s %s" % (N, "target", rng, stmt, status))

    print("")
    print("Controls (not part of the target PASS/FAIL):")
    ctrl_ok = True
    for N in ctrls:
        r = results[N]
        full = (not r["unresolved"])
        if N == 2:
            good = not full     # must fail to certify: exact tangential zeros
            print("  N=2: %s  (%d unresolved cells; exact zeros at "
                  "t=(2k+1)pi/log2)" % ("as expected (method refuses to certify)" if good
                                        else "UNEXPECTED: certified zero-free", len(r["unresolved"])))
            ctrl_ok = ctrl_ok and good
        else:
            good = full
            mb = fmt(r["min_bound"], 6) if r["min_bound"] is not None else "n/a"
            print("  N=3: %s  (certified |S_3(t)| > %s on [0,%s]%s)"
                  % ("as expected (zero-free certified)" if good else "UNRESOLVED",
                     mb, T, "" if full else ", partial"))
            ctrl_ok = ctrl_ok and good

    # ------------------------------------------------------------------- money
    print("")
    print("=" * 78)
    if all_targets_ok and ctrl_ok and selfcheck_ok:
        print("PASS: every target N = %s is certified zero-free on the whole"
              % ",".join(map(str, Ns)))
        print("      interval [0, %s]; engine self-check clean; controls behave "
              "as known" % T)
        print("      (N=2 tangential zeros not certified, N=3 zero-free certified).")
    else:
        print("FAIL: certification is NOT complete for every target N on [0, %s]."
              % T)
        if not selfcheck_ok:
            print("      Engine self-check failed.")
        if not all_targets_ok:
            print("      Unresolved targets: %s"
                  % ", ".join("N=%d (%d cells)" % (N, len(results[N]["unresolved"]))
                              for N in Ns if results[N]["unresolved"]))
        if not ctrl_ok:
            print("      A control check did not behave as known.")
    print("=" * 78)
    return 0


if __name__ == "__main__":
    sys.exit(main())
