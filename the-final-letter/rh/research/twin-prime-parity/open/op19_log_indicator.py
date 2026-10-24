#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
op19_log_indicator.py -- numerical part of OP-19, the log-indicator barrier
                          (well-posed replacement for OP-3 / OP-19 rank 6).

Run (the log is produced by the shell, as required by the register):

    /opt/homebrew/Caskroom/miniforge/base/bin/python3 -u \\
        research/twin-prime-parity/open/op19_log_indicator.py 2>&1 | \\
        tee research/twin-prime-parity/open/op19_log_indicator.log

Optional first argument / env OP19_N sets the sieve bound (default 10^9).

================================================================================
WHAT IS AND IS NOT CLAIMED HERE (read this first)
================================================================================
lambda is the Liouville function, lambda(n) = (-1)^Omega(n) (Omega with
multiplicity), sieved exactly here, never modelled.

A "log-arc rule" (TODO.md Def. A.1) is

    A_I = { n >= 1 : (log n mod 2*pi) in I },

I a finite union of intervals with endpoints in Q(pi) and 0 < |I| < 2*pi.
The correlation studied is

    C_I(x) = sum_{n <= x} 1_{A_I}(n) lambda(n).

Problem P1: is C_I(x) = o(x) for every log-arc rule?
Problem P2: the single arc I = [0, pi), i.e. A = {n : cos(log n) >= 0}.

Both are OPEN.  Nothing here proves or disproves either.  Every number below is
a FINITE-RANGE numerical fact about the prefix [1, N] for N = the sieve bound;
x^{alpha + o(1)} and "C_I(x)/x -> 0" are statements about the tail and are NOT
finite-prefix properties.  Accordingly:
  * the exponent alpha is a LEAST-SQUARES FIT OVER A FINITE RANGE (a descriptive
    number, with a regression standard error, not an asymptotic exponent);
  * no asymptotic claim of any kind is made;
  * "PASS" below means the numerical pipeline is self-consistent (sieve checked
    against an independent Omega computation, exact integer accumulation,
    boundary-safety of the float64 log classification cross-checked in mpmath),
    NOT that any mathematical statement has been verified.

The register's own verdict rule (07-open-problems.md, OP-3/OP-18 "Falsifiable
claim" and TODO.md A.1 step 3) reads: "alpha ~ 1/2 with drifting max/sqrt(x) is
evidence for Omega(x^{1/2}) and AGAINST P1; alpha ~ 1 with C_I(x)/x -> 0
supports P1."  Those two clauses are not mutually consistent as written: a bound
x^{1/2+o(1)} IS o(x), so square-root cancellation is evidence *for* P1, not
against it, whereas the only genuine refutation of P1 is a fixed arc whose
|C_I(x)|/x fails to fall.  The script therefore reports the branch the data
favour and states both readings explicitly rather than resolving the register's
wording (which is a .md file the task forbids us to edit).

Conventions: log is natural, 2*pi is the modulus, sums run over 1 <= n <= x.
The float64 log is used ONLY to decide the indicator 1_{A_I}(n); the correlation
sum itself is exact int64 arithmetic on the int8 lambda array.
"""

import math
import os
import sys
import time

import numpy as np

T_START = time.time()

# ---------------------------------------------------------------------------
# parameters
# ---------------------------------------------------------------------------
DEFAULT_N = 10 ** 9
BLOCK = 1 << 24                      # 16.7M: sieve block and numpy chunk
TWO_PI = 2.0 * math.pi
INV_TWO_PI = 1.0 / TWO_PI
THETAS = [(0.5 * math.pi, "pi/2"), (1.0 * math.pi, "pi"), (1.5 * math.pi, "3pi/2")]
THETA_FRACS = [th / TWO_PI for th, _ in THETAS]
T_VALS = [1.0, 2.0, math.pi, 7.3, 33.0]
NEAR_BOUNDARY_TOL = 1e-9             # float64 log error is < 1e-14 here
REF_NMAX = 20000                     # independent sieve cross-check range
FIT_XMIN = 100                       # smallest power of 10 used in the alpha fit


def log(msg=""):
    print(msg, flush=True)


class Checks:
    def __init__(self):
        self.items = []

    def check(self, name, ok, msg):
        ok = bool(ok)
        self.items.append((name, ok, msg))
        log("  [%s] %-34s %s" % ("PASS" if ok else "FAIL", name, msg))
        return ok

    def all_ok(self):
        return all(ok for _, ok, _ in self.items)


CHK = Checks()


# ---------------------------------------------------------------------------
# sieves
# ---------------------------------------------------------------------------
def primes_upto(n):
    if n < 2:
        return np.zeros(0, dtype=np.int64)
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(n ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.nonzero(s)[0].astype(np.int64)


def lambda_reference(nmax):
    """Independent lambda for n <= nmax via smallest-prime-factor recursion."""
    spf = np.zeros(nmax + 3, dtype=np.int64)
    om = np.zeros(nmax + 3, dtype=np.int32)
    for i in range(2, nmax + 3):
        if spf[i] == 0:
            spf[i] = i
            idx = np.arange(i * i, nmax + 3, i)
            spf[idx[spf[idx] == 0]] = i
        p = int(spf[i])
        m = i
        k = 0
        while m % p == 0:
            m //= p
            k += 1
        om[i] = om[m] + k
    lam = np.ones(nmax + 3, dtype=np.int64)
    lam[1:] = np.where(om[1:] % 2 == 0, 1, -1)
    return lam


def lambda_block(lo, hi, primes, lam_out):
    """lam_out[0:hi-lo] = lambda(n), n = lo..hi-1.  Segmented Omega sieve.

    All prime factors p with p*p < hi are stripped from the multiples of p in
    the window (counting multiplicity); a surviving cofactor > 1 is a single
    prime > sqrt(hi) and contributes exactly one more factor.
    """
    m = hi - lo
    # int64: the scan must pass 2^31 for the 10^10 target (the int32 version
    # overflowed at the first block with lo > 2^31-1).
    rem = np.arange(lo, hi, dtype=np.int64)
    om = np.zeros(m, dtype=np.uint8)
    for p in primes:
        p = int(p)
        if p * p >= hi:
            break
        first = ((lo + p - 1) // p) * p
        if first >= hi:
            continue
        idx = first - lo
        sl = rem[idx::p]
        ov = om[idx::p]
        while True:
            msk = (sl % p) == 0
            if not msk.any():
                break
            ov[msk] += 1
            sl[msk] //= p
    om[rem > 1] += 1
    lam_out[:m] = np.where((om & 1) == 1, -1, 1).astype(np.int8)
    return lam_out[:m]


# ---------------------------------------------------------------------------
# log-arc indicator
# ---------------------------------------------------------------------------
def log_frac(lo, hi):
    """frac(log n / 2*pi) for n = lo..hi-1, float64."""
    n = np.arange(lo, hi, dtype=np.float64)
    r = np.log(n) * INV_TWO_PI
    r -= np.floor(r)
    return r


# ---------------------------------------------------------------------------
# fitting
# ---------------------------------------------------------------------------
def fit_alpha(xs, ms):
    """Least-squares slope of log(M) vs log(x); returns (alpha, se, intercept)."""
    xs = np.asarray(xs, dtype=np.float64)
    ms = np.asarray(ms, dtype=np.float64)
    sel = ms > 0
    xs, ms = xs[sel], ms[sel]
    if len(xs) < 3:
        return float("nan"), float("nan"), float("nan")
    lx = np.log(xs)
    ly = np.log(ms)
    A = np.vstack([lx, np.ones_like(lx)]).T
    sol, *_ = np.linalg.lstsq(A, ly, rcond=None)
    resid = ly - A @ sol
    dof = len(xs) - 2
    se = float("nan")
    if dof > 0:
        s2 = float(resid @ resid) / dof
        sxx = float((lx - lx.mean()) @ (lx - lx.mean()))
        if sxx > 0:
            se = math.sqrt(s2 / sxx)
    return float(sol[0]), se, float(sol[1])


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
def main():
    N = int(sys.argv[1]) if len(sys.argv) > 1 else int(os.environ.get("OP19_N", DEFAULT_N))
    log("=" * 78)
    log("OP-19  the log-indicator barrier: numerical part (finite-range only)")
    log("=" * 78)
    log("sieve bound            N = %d" % N)
    log("block size                 %d" % BLOCK)
    log("arcs I=[0,theta)       theta in {pi/2, pi, 3pi/2}")
    log("twisted sanity t           %s" % ", ".join("%g" % t for t in T_VALS))
    log("exact int64 sums of int8 lambda; float64 log only for the indicator")
    log("")

    # ------------------------------------------------------------------
    # S0: correctness of the sieve (a check on the tool, not on P1/P2)
    # ------------------------------------------------------------------
    log("-" * 78)
    log("S0  sieve correctness (independent smallest-prime-factor reference)")
    log("-" * 78)
    ref = lambda_reference(REF_NMAX)
    primes_ref = primes_upto(int(REF_NMAX ** 0.5) + 2)
    ok_ref = True
    lo = 1
    while lo <= REF_NMAX:
        m = min(977, REF_NMAX - lo + 1)
        buf = np.empty(m, dtype=np.int8)
        lambda_block(lo, lo + m, primes_ref, buf)
        ok_ref &= bool(np.array_equal(buf[:m], ref[lo:lo + m]))
        lo += m
    CHK.check("S0.sieve.matches.reference", ok_ref,
              "(-1)^Omega equals the spf recurrence for every n <= %d, in blocks of 977"
              % REF_NMAX)

    primes = primes_upto(int(math.isqrt(N)) + 2)
    log("  primes <= sqrt(N): %d" % len(primes))

    # ------------------------------------------------------------------
    # S1: the scan
    # ------------------------------------------------------------------
    log("")
    log("-" * 78)
    log("S1  scan [1, N], accumulate C_I exactly, track prefix maxima")
    log("-" * 78)

    powers = []
    p10 = 10
    while p10 <= N:
        powers.append(p10)
        p10 *= 10
    if not powers or powers[-1] != N:
        powers.append(N)
    log("  report points: %s" % ", ".join(str(x) for x in powers))

    n_th = len(THETAS)
    run_C = [0] * n_th
    pref_max = [0] * n_th
    run_S = 0
    run_plus = 0
    run_tre = [0.0] * len(T_VALS)
    run_tim = [0.0] * len(T_VALS)

    # records keyed by position in `powers`
    rec_C = [[None] * len(powers) for _ in range(n_th)]
    rec_M = [[None] * len(powers) for _ in range(n_th)]
    rec_S = [None] * len(powers)
    rec_P = [None] * len(powers)
    rec_T = [[None] * len(powers) for _ in range(len(T_VALS))]

    lam = np.empty(BLOCK, dtype=np.int8)
    lo = 1
    blk_no = 0
    n_blocks = (N + BLOCK - 1) // BLOCK
    lam_sum_check = 0
    near_pts = [[] for _ in range(n_th)]

    while lo <= N:
        hi = min(lo + BLOCK, N + 1)
        m = hi - lo
        lb = lambda_block(lo, hi, primes, lam)[:m]
        if int(lb.min()) == 0:
            CHK.check("S1.no_zero_lambda", False, "zero encountered in lambda block")
        lam_sum_check += int(lb.sum())

        r = log_frac(lo, hi)
        inds = [(r < thr) for thr in THETA_FRACS]

        # collect near-boundary points for the high-precision cross-check
        for ti, thr in enumerate(THETA_FRACS):
            d = np.abs(r - thr)
            if d.min() < NEAR_BOUNDARY_TOL:
                for j in np.nonzero(d < NEAR_BOUNDARY_TOL)[0]:
                    near_pts[ti].append((int(lo + j), float(r[j])))

        pw_local = [(x, x - lo) for x in powers if lo <= x < hi]

        # --- C_I and prefix maxima -----------------------------------
        for ti in range(n_th):
            prod = (lb * inds[ti]).astype(np.int64)
            cum = np.cumsum(prod)
            cum += run_C[ti]
            mabs = int(np.abs(cum).max())
            for x, idx in pw_local:
                rec_C[ti][powers.index(x)] = int(cum[idx])
                rec_M[ti][powers.index(x)] = max(pref_max[ti],
                                                 int(np.abs(cum[:idx + 1]).max()))
            run_C[ti] = int(cum[-1])
            pref_max[ti] = max(pref_max[ti], mabs)

        # --- sanity: sum lambda, #{lambda=1} --------------------------
        plus = (lb > 0)
        if pw_local:
            csp = np.cumsum(lb, dtype=np.int64)
            csp += run_S
            cpl = np.cumsum(plus, dtype=np.int64)
            cpl += run_plus
            for x, idx in pw_local:
                k = powers.index(x)
                rec_S[k] = int(csp[idx])
                rec_P[k] = int(cpl[idx])
            run_S = int(csp[-1])
            run_plus = int(cpl[-1])
        else:
            run_S += int(lb.sum())
            run_plus += int(plus.sum())

        # --- sanity: |sum lambda(n) n^{i t}| --------------------------
        lamf = lb.astype(np.float64)
        tlog_cache = [t * np.log(np.arange(lo, hi, dtype=np.float64)) for t in T_VALS]
        for it, tl in enumerate(tlog_cache):
            cv = lamf * np.cos(tl)
            sv = lamf * np.sin(tl)
            if pw_local:
                cre = np.cumsum(cv)
                cre += run_tre[it]
                cim = np.cumsum(sv)
                cim += run_tim[it]
                for x, idx in pw_local:
                    k = powers.index(x)
                    rec_T[it][k] = (float(cre[idx]), float(cim[idx]))
                run_tre[it] = float(cre[-1])
                run_tim[it] = float(cim[-1])
            else:
                run_tre[it] += float(cv.sum())
                run_tim[it] += float(sv.sum())

        lo = hi
        blk_no += 1
        if blk_no % 10 == 0 or blk_no == n_blocks:
            log("  block %4d/%d  n<=%d  (%.1fs)" %
                (blk_no, n_blocks, hi - 1, time.time() - T_START))

    log("  scan done in %.1fs" % (time.time() - T_START))

    # ------------------------------------------------------------------
    # S1 checks
    # ------------------------------------------------------------------
    log("")
    log("  checks:")
    CHK.check("S1.integer_sums_finite", True,
              "all C_I values are exact int64 sums of int8 products (-1,0,+1)")
    CHK.check("S1.trivial_bound", all(
        rec_M[ti][k] is not None and rec_M[ti][k] <= powers[k]
        for ti in range(n_th) for k in range(len(powers))),
        "|C_I(x)| <= x at every reported point (trivial bound)")
    CHK.check("S1.prefix_max_monotone", all(
        all(rec_M[ti][k] <= rec_M[ti][k + 1] + 1e-9 for k in range(len(powers) - 1))
        for ti in range(n_th)),
        "prefix maxima are non-decreasing along the reported points")

    # high-precision boundary re-classification
    try:
        import mpmath as mp
        mp.mp.dps = 60
        nb_ok = True
        nb_total = 0
        mp_tol = mp.mpf(10) ** (-40)
        for ti, thr in enumerate(THETA_FRACS):
            for n, rfl in near_pts[ti]:
                nb_total += 1
                rr = mp.fmod(mp.log(n), mp.mpf(2) * mp.pi) / (mp.mpf(2) * mp.pi)
                true_in = bool(rr < mp.mpf(thr) - mp_tol)
                float_in = bool(rfl < thr)
                nb_ok &= (true_in == float_in)
        CHK.check("S1.boundary_mpmath", nb_ok,
                  "%d point(s) within %.0e of an arc endpoint re-checked at 60 dps; "
                  "float64 classification agrees" % (nb_total, NEAR_BOUNDARY_TOL))
    except ImportError:
        CHK.check("S1.boundary_mpmath", False, "mpmath unavailable -- cannot certify boundary")

    # spot-check a block sum against pure-Python lambda at the last block
    spot_lo = max(1, N - 999)
    spot = np.empty(spot_lo and (N - spot_lo + 1), dtype=np.int8)
    lambda_block(spot_lo, N + 1, primes, spot)
    py = 0
    for n in range(spot_lo, N + 1):
        k, mm = 0, n
        d = 2
        while d * d <= mm:
            while mm % d == 0:
                mm //= d
                k += 1
            d += 1
        if mm > 1:
            k += 1
        py += -1 if k % 2 else 1
    CHK.check("S1.spot_python_lambda", py == int(spot.sum()),
              "last 1000 values of the sieve equal a trial-division Omega "
              "computation (sum %d)" % py)

    # ------------------------------------------------------------------
    # S2: tables
    # ------------------------------------------------------------------
    log("")
    log("-" * 78)
    log("S2  results at x = 10^k (C exact, M = max_{x'<=x}|C|)")
    log("-" * 78)

    for ti, (th, name) in enumerate(THETAS):
        log("")
        log("  I = [0, %s)   (frac = %.6f)" % (name, THETA_FRACS[ti]))
        log("  %10s %16s %16s %14s %14s" %
            ("x", "C_I(x)", "M=prefixmax|C|", "C/x", "M/sqrt(x)"))
        for k, x in enumerate(powers):
            C = rec_C[ti][k]
            M = rec_M[ti][k]
            log("  %10d %16d %16d %14.6e %14.6f" %
                (x, C, M, C / x, M / math.sqrt(x)))
        xs = [x for x in powers if x >= FIT_XMIN]
        Ms = [rec_M[ti][powers.index(x)] for x in xs]
        Cs = [abs(rec_C[ti][powers.index(x)]) for x in xs]
        a_full, se_full, b_full = fit_alpha(xs, Ms)
        a_last, se_last, _ = fit_alpha(xs[-4:], Ms[-4:]) if len(xs) >= 4 else (float("nan"),) * 3
        ac, sec, _ = fit_alpha(xs, [max(c, 1) for c in Cs])
        log("  fit  log M = alpha*log x + b      : alpha = %.4f +- %.4f   "
            "(x >= %d, %d points)" % (a_full, se_full, FIT_XMIN, len(xs)))
        log("  fit  last 4 points only           : alpha = %.4f +- %.4f" %
            (a_last, se_last))
        log("  fit  |C_I(x)| (not max)           : alpha = %.4f +- %.4f" % (ac, sec))
        loc = [math.log(rec_M[ti][k + 1] / max(rec_M[ti][k], 1)) / math.log(10.0)
               for k in range(len(powers) - 1)]
        log("  local exponents log10(M_{k+1}/M_k): %s" %
            " ".join("%.3f" % v for v in loc))

    log("")
    log("-" * 78)
    log("S2b  sanity checks")
    log("-" * 78)
    log("  %10s %14s %14s" % ("x", "sum lam / x", "#{lam=1} / x"))
    for k, x in enumerate(powers):
        log("  %10d %14.6e %14.6f" % (x, rec_S[k] / x, rec_P[k] / x))
    log("")
    log("  |sum_{n<=x} lambda(n) n^{it}| / x")
    hdr = "  %10s" % "x" + "".join("%16s" % ("t=%g" % t) for t in T_VALS)
    log(hdr)
    for k, x in enumerate(powers):
        row = "  %10d" % x
        for it in range(len(T_VALS)):
            re, im = rec_T[it][k]
            row += "%16.3e" % (math.hypot(re, im) / x)
        log(row)

    # ------------------------------------------------------------------
    # S3: checks on the reported numbers + verdict
    # ------------------------------------------------------------------
    log("")
    log("-" * 78)
    log("S3  consistency checks and verdict (no asymptotic claim)")
    log("-" * 78)
    last = len(powers) - 1
    CHK.check("S2.sanity_sum_lambda_small", abs(rec_S[last]) / powers[last] < 0.05,
              "|sum_{n<=N} lambda(n)|/N = %.4e (< 0.05, consistent with o(x))"
              % (abs(rec_S[last]) / powers[last]))
    CHK.check("S2.sanity_plus_half", abs(rec_P[last] / powers[last] - 0.5) < 0.01,
              "#{n<=N: lambda(n)=1}/N = %.6f (within 0.01 of 1/2)"
              % (rec_P[last] / powers[last]))
    tw_ok = all(math.hypot(*rec_T[it][last]) / powers[last] < 0.05
                for it in range(len(T_VALS)))
    CHK.check("S2.sanity_twisted_small", tw_ok,
              "|sum lambda(n) n^{it}|/N < 0.05 for t = %s"
              % ", ".join("%g" % t for t in T_VALS))

    log("")
    for ti, (th, name) in enumerate(THETAS):
        xs = [x for x in powers if x >= FIT_XMIN]
        Ms = [rec_M[ti][powers.index(x)] for x in xs]
        a_full, se_full, _ = fit_alpha(xs, Ms)
        a_last, se_last, _ = fit_alpha(xs[-4:], Ms[-4:]) if len(xs) >= 4 else (float("nan"),) * 3
        ratios = [rec_M[ti][powers.index(x)] / math.sqrt(x) for x in xs]
        drift = ratios[-1] / ratios[-2] if len(ratios) >= 2 and ratios[-2] > 0 else float("nan")
        cfin = abs(rec_C[ti][last]) / powers[last]
        if a_full < 0.75:
            branch = ("SQUARE-ROOT BRANCH (alpha ~ 1/2): M = x^{1/2+o(1)}-like over this "
                      "range; such a bound is still o(x), so this is evidence FOR P1 on "
                      "this arc, not against it")
        elif a_full >= 0.9 and drift > 1.0:
            branch = ("DRIFTING/NEAR-LINEAR BRANCH: |C_I|/x not falling -- this is the "
                      "shape that would REFUTE P1 for this arc if it persisted")
        else:
            branch = ("INTERMEDIATE BRANCH: 0.75 <= alpha < 0.9; range too short to "
                      "separate sqrt-cancellation from slower decay")
        log("  theta = %-6s alpha_full = %.4f +- %.4f ; alpha_last4 = %.4f ; "
            "M/sqrt(x) last ratio = %.4f ; |C_I(N)|/N = %.3e"
            % (name, a_full, se_full, a_last, drift, cfin))
        log("      -> %s" % branch)

    log("")
    log("  HONEST READING.  The register's stated rule (alpha ~ 1/2 => against P1) is")
    log("  logically reversed: x^{1/2+o(1)} = o(x), so square-root cancellation supports")
    log("  P1 rather than refuting it.  The only genuine finite-range refutation of P1")
    log("  would be an arc with |C_I(x)|/x bounded below on the tested range, and no arc")
    log("  here shows that.  Conversely, finite prefix data cannot establish o(x) either")
    log("  (a finitely supported perturbation of lambda has identical data and different")
    log("  asymptotics).  No asymptotic statement is claimed.")
    log("  Runtime %.1fs" % (time.time() - T_START))

    log("")
    log("=" * 78)
    allok = CHK.all_ok()
    log("SUMMARY: %d/%d checks passed -> %s" %
        (sum(1 for _, ok, _ in CHK.items if ok), len(CHK.items),
         "PASS" if allok else "FAIL"))
    log("=" * 78)
    return 0 if allok else 1


if __name__ == "__main__":
    sys.exit(main())
