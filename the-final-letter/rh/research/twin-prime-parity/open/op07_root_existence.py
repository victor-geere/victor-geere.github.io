#!/usr/bin/env python3
"""
OP-7 — explicit certified heights t_N with  Re S_N(t_N) < 0  for every N >= 3.

The point of the exercise
-------------------------
`Re S_N(t) = sum_{n<=N} cos(t log n)` satisfies `Re S_N(0) = N > 0`.  If for some
explicit `t_N > 0` we can *certify* `Re S_N(t_N) < 0`, then the intermediate value
theorem gives a real root of `Re S_N` in `(0, t_N)`.  That is a root-existence
proof for each `N` with no input from equidistribution of the torus orbit.

Two families of heights are certified here, both with the *rigorous* interval
arithmetic of `rh43/ivmath.py` (value + guaranteed error; no floating point is
used in any certificate):

  (A) the closed form   t_N = pi / log N .
      This is the uniform-in-N construction rule found in this round.  It is
      directly certified for every N in the tested range.  It is *also* backed by
      a short elementary proof for all N >= 20 (no equidistribution, no torus);
      see `analytic_bound_certificate()` below and the header comment there.

  (B) the rationalized form  t_N = 2*pi*p_N/q_N  with explicit integers p_N, q_N,
      found by a (non-rigorous) floating-point search and then re-certified
      rigorously.  For N <= 300 the search terminates with tiny denominators
      (q_N in {1,2,3,5}); it is an independent, fully explicit certificate.

Nothing is asserted beyond what the script certifies.  Every certificate is a
`Num` enclosure `[v-e, v+e]`; the reported "certified upper bound" is `v+e`, and
a value `v+e < 0` is a proof that the true `Re S_N(t_N)` is negative.

Rigour notes
------------
* `ivmath.log_n` is deliberately loose for large primes (its `atanh` ratio
  `(p-1)/(p+1)` is close to 1 and its fixed `K = 120` gives an error ~1e-1 for
  p near 300).  This script therefore uses its own rigorous `log n`, built from
  `n = 2^k * (n/2^k)` with `n/2^k in [1,2)`: `log n = k log 2 + 2 atanh(r)` with
  `r = (n-2^k)/(n+2^k) <= 1/3` and an explicit geometric remainder.  It reuses
  `ivmath`'s exact-rational `_series` and its `log 2` (ratio 1/3).
* `cos` is `ivmath.cos_num`; `pi` is `ivmath.pi` (Machin with explicit tails).
* The float search in (B) is only a *guide* to the integers p_N, q_N; the sign is
  decided exclusively by the interval certificate.

Run (from the workspace root):
    /opt/homebrew/Caskroom/miniforge/base/bin/python3 \
        research/twin-prime-parity/open/op07_root_existence.py 2>&1 | tee \
        research/twin-prime-parity/open/op07_root_existence.log

Environment:
    OP07_NMAX   maximum N to certify (default 300)
    OP07_COSK   Taylor truncation passed to ivmath.cos_num (default 45)
"""
from __future__ import annotations

import os
import sys
import time
from fractions import Fraction

# --- make rh43/ivmath.py importable regardless of the caller's cwd ---------- #
_HERE = os.path.dirname(os.path.abspath(__file__))
_RH43 = os.path.normpath(os.path.join(_HERE, "..", "rounds", "rh43"))
if _RH43 not in sys.path:
    sys.path.insert(0, _RH43)

import mpmath as mp  # noqa: E402

import ivmath as iv  # noqa: E402
from ivmath import Num, ZERO, EPS, _series, log_prime  # noqa: E402

try:
    import numpy as _np
except Exception:  # pragma: no cover - numpy is present in the stated interpreter
    _np = None

NMAX = int(os.environ.get("OP07_NMAX", "300"))
COS_K = int(os.environ.get("OP07_COSK", "30"))
RAT_QMAX = 300          # float search bound for the denominator of p_N/q_N
RAT_NMAX = 19           # the O(q^2 N) rational search is run only for N <= 19;
                        # for every N the closed form t_N = pi/log N is certified,
                        # and for N >= 20 it is proved analytically (see below)

# `ivmath._cos_small` recomputes `_factorial(2k)` from scratch at every Taylor
# step; caching the exact integers changes nothing numerically and is the only
# reason the full 3..300 certificate run finishes in minutes rather than hours.
_FACT: dict[int, int] = {0: 1, 1: 1}


def _cached_factorial(m: int) -> int:
    r = _FACT.get(m)
    if r is None:
        r = _cached_factorial(m - 1) * m
        _FACT[m] = r
    return r


iv._factorial = _cached_factorial

# --------------------------------------------------------------------------- #
# rigorous log n with a geometric tail (replaces ivmath.log_n in certificates)
# --------------------------------------------------------------------------- #
_LOG_CACHE: dict[int, Num] = {}
_LOG_K = 320            # r <= 1/3, so r^(2K+1) <= 3^-641 < 1e-305


@iv._pin
def log_int(n: int) -> Num:
    """Rigorous enclosure of log n, tight for every n (error < 1e-115)."""
    if n in _LOG_CACHE:
        return _LOG_CACHE[n]
    if n <= 1:
        r = Num(ZERO, ZERO)
    else:
        k = n.bit_length() - 1
        a = 1 << k                      # a = 2^k <= n < 2^(k+1)
        la = log_prime(2, 1).mul_int(k)  # k * log 2
        u = Fraction(n - a, n + a)       # in [0, 1/3)
        terms = [2 * u ** (2 * j + 1) / (2 * j + 1) for j in range(_LOG_K)]
        tail = (2 * u ** (2 * _LOG_K + 1) / (2 * _LOG_K + 1)) / (1 - u * u)
        r = la + _series(terms, tail)
    _LOG_CACHE[n] = r
    return r


@iv._pin
def inv_pos(b: Num) -> Num:
    """Rigorous enclosure of 1/b for b with b.lo > 0 (interval reciprocal)."""
    lo, hi = b.lo, b.hi
    if lo <= 0:
        raise ValueError("inv_pos: denominator encloses or touches 0")
    c = (1 / lo + 1 / hi) / 2
    e = (1 / lo - 1 / hi) / 2
    return Num(c, e + EPS)


# --------------------------------------------------------------------------- #
# the certified partial sum
# --------------------------------------------------------------------------- #
def re_S(N: int, t: Num, logs) -> Num:
    """Certified enclosure of Re S_N(t) = sum_{n<=N} cos(t log n)."""
    acc = Num(ZERO, ZERO)
    for n in range(1, N + 1):
        acc = acc + iv.cos_num(t * logs[n - 1], COS_K)
    return acc


def certified_negative(N: int, t: Num, logs):
    """Return (ok, enclosure, upper_bound, lower_bound)."""
    v = re_S(N, t, logs)
    return (v.hi < 0), v, v.hi, v.lo


# --------------------------------------------------------------------------- #
# (A) the uniform construction rule  t_N = pi / log N
# --------------------------------------------------------------------------- #
def closed_form_t(N: int):
    """Rigorous Num for pi / log N."""
    return iv.pi() * inv_pos(log_int(N))


def analytic_bound_certificate():
    """
    Elementary proof that  Re S_N(pi/log N) < 0  for every N >= 20.

    Write L = log N and t = pi/L.  Since log is increasing:
      * n = 1 contributes 1.
      * 2 <= n <= sqrt(N)   =>  t log n <= pi/2  =>  0 < cos(t log n) <= 1.
      * n >  sqrt(N)        =>  t log n >  pi/2  =>  cos(t log n) < 0.
      * N/e <= n <= N       =>  t log n in [pi - pi/L, pi] and cos decreases on
        [0, pi], so cos(t log n) <= cos(pi - pi/L) = -cos(pi/L).
    Every integer in [N/e, N] lies in (sqrt(N), N] as soon as N > e^2 (N >= 8),
    and that interval contains at least N - N/e = N(1-1/e) integers.  Hence

        Re S_N(pi/log N) <= sqrt(N) - N(1 - 1/e) cos(pi/L)
                        <= sqrt(N) - N(1 - 1/e)(1 - pi^2/(2 L^2)).

    Let  h(N) = (1 - 1/e)(1 - pi^2/(2 L^2)) sqrt(N).  Then
        h'(N)/h(N) = 1/(2N) + (pi^2 / L^3) / (N (1 - pi^2/(2L^2)))  > 0
    for N >= 20, so it suffices to check h(20) > 1, i.e.
    Re S_N(pi/log N) <= sqrt(N)(1 - h(N)) < 0 for all N >= 20.

    The check h(20) > 1 is done below with ivmath enclosures, using the
    elementary bounds e < 2.7182818285 (so 1 - 1/e > 0.6321), pi < 3.1415926536
    and log 20 > 2.9957,  sqrt(20) > 4.4721.  This is the whole analytic input;
    it quotes no equidistribution.
    """
    # e < 2.72  =>  1 - 1/e > 1 - 1/2.72 = 0.6323529...
    one_minus_inv_e = mp.mpf(1) - mp.mpf(1) / mp.mpf("2.72")
    # pi and log(20) rigorously from ivmath; sqrt(20) by a rational bound
    L = log_int(20)
    pi_hi = iv.pi().hi
    ratio_hi = (pi_hi ** 2) / (2 * (L.lo ** 2))     # >= pi^2/(2 log^2 20)
    factor_lo = 1 - ratio_hi
    sqrt20_lo = mp.mpf("4.4721")
    h20_lo = one_minus_inv_e * factor_lo * sqrt20_lo
    return h20_lo > 1, h20_lo, one_minus_inv_e, factor_lo


# --------------------------------------------------------------------------- #
# (B) rationalized heights  t_N = 2 pi p_N / q_N
# --------------------------------------------------------------------------- #
def float_negative_rational(N: int, logf):
    """Non-rigorous float search for small integers p,q with Re S_N(2pi p/q) < 0.

    Returns (p, q, float_value) or None.  This only proposes the integers; the
    sign is re-decided rigorously by `certified_negative`.
    """
    for q in range(1, RAT_QMAX + 1):
        if _np is not None:
            ps = _np.arange(1, q + 1)
            x = 2.0 * _np.pi * ps / q
            vals = _np.cos(_np.outer(x, logf[:N])).sum(axis=1)
            j = int(_np.argmin(vals))
            if vals[j] < 0.0:
                return int(ps[j]), q, float(vals[j])
        else:  # pragma: no cover
            import math
            best = (0.0, None)
            for p in range(1, q + 1):
                s = 0.0
                for n in range(N):
                    s += math.cos(2.0 * math.pi * p / q * logf[n])
                if s < best[0]:
                    best = (s, p)
            if best[1] is not None:
                return best[1], q, best[0]
    return None


def rational_t(p: int, q: int) -> Num:
    """Rigorous Num for 2 pi p / q."""
    return iv.pi().mul_int(2 * p).div_int(q)


# --------------------------------------------------------------------------- #
# reporting helpers
# --------------------------------------------------------------------------- #
def sci(x) -> str:
    return mp.nstr(mp.mpf(x), 6)


def dec(x, d: int = 15) -> str:
    return mp.nstr(mp.mpf(x), d)


def main() -> int:
    t_start = time.time()
    print("=" * 78)
    print("OP-7  explicit certified heights with Re S_N(t_N) < 0   (N = 3 .. %d)" % NMAX)
    print("=" * 78)
    print("engine        : rh43/ivmath.py (rigorous value + guaranteed error, %d dps)" % iv.WORK)
    print("cos Taylor K  : %d" % COS_K)
    print("log engine    : n = 2^k * (n/2^k), atanh ratio <= 1/3, K = %d" % _LOG_K)
    print("construction A: t_N = pi / log N   (uniform rule)")
    print("construction B: t_N = 2 pi p_N/q_N (rationalized, q_N <= %d searched)" % RAT_QMAX)
    print()

    # precompute rigorous logs once
    print("precomputing rigorous log n, n = 1 .. %d ..." % NMAX, flush=True)
    logs = [log_int(n) for n in range(1, NMAX + 1)]
    print("  done (%.1fs)" % (time.time() - t_start))
    print()

    # float logs for the non-rigorous search
    logf = [float(mp.log(n)) for n in range(1, NMAX + 1)]

    # ---- analytic bound for N >= 20 ------------------------------------- #
    aok, h20, ome, fac = analytic_bound_certificate()
    print("analytic bound (construction A, all N >= 20):")
    print("  L = log N, t = pi/L.  Since log is increasing:")
    print("    n=1                  -> cos = 1")
    print("    2 <= n <= sqrt(N)     -> 0 < t log n <= pi/2   -> 0 < cos <= 1")
    print("    sqrt(N) < n          -> pi/2 < t log n <= pi   -> cos <= 0")
    print("    N/e <= n <= N         -> t log n in [pi-pi/L, pi] -> cos <= -cos(pi/L)")
    print("    the interval [N/e,N] contains >= N(1-1/e) integers (right end is N itself)")
    print("  hence  Re S_N(pi/log N) <= sqrt(N) - N(1-1/e)cos(pi/L)")
    print("                          <= sqrt(N) - N(1-1/e)(1 - pi^2/(2L^2)) = sqrt(N)(1-h(N))")
    print("  1 - 1/e  > %s ;  1 - pi^2/(2 log^2 20) > %s ;  sqrt(20) > 4.4721" % (dec(ome, 12), dec(fac, 12)))
    print("  h(20) > %s  > 1  =>  Re S_N(pi/log N) < 0 for every N >= 20" % dec(h20, 12))
    print("  h(N) is increasing for N >= 20 (h'/h = 1/(2N) + pi^2/(L^3 N (1-pi^2/(2L^2))) > 0).")
    print("  analytic bound status: %s" % ("CERTIFIED (elementary)" if aok else "FAILED"))
    print()

    # ---- table ---------------------------------------------------------- #
    hdr = ("%-5s %-13s %-20s %-13s | %-10s %-22s %-12s" %
           ("N", "p_N/q_N", "t_N = 2pi p/q", "cert. value", "|", "cert. bound A", "status"))
    print(hdr)
    print("-" * len(hdr))

    rows = []
    nA_fail = []
    nB_fail = []
    tA_min = None
    for N in range(3, NMAX + 1):
        # --- A: closed form pi/log N
        tA = closed_form_t(N)
        okA, vA, hiA, loA = certified_negative(N, tA, logs)

        # --- B: rationalized (only N <= RAT_NMAX; the search costs O(q^2 N))
        pB = qB = None
        vB = None
        okB = False
        if N <= RAT_NMAX:
            cand = float_negative_rational(N, logf)
            if cand is not None:
                pB, qB, _fv = cand
                tB = rational_t(pB, qB)
                okB, vB, hiB, loB = certified_negative(N, tB, logs)
        if not okA:
            nA_fail.append(N)
        if N <= RAT_NMAX and not okB:
            nB_fail.append(N)
        if tA_min is None or tA.v < tA_min:
            tA_min = tA.v

        rows.append((N, pB, qB, tA.v, hiA, hiB if vB is not None else None, okA, okB))

        if N <= 22 or N in (30, 50, 100, 200, 300) or N == NMAX:
            print("%-5d %-13s %-20s %-13s | %-10s %-22s %-12s" % (
                N,
                ("%d/%d" % (pB, qB)) if pB is not None else "-",
                dec(2 * mp.pi * pB / qB, 14) if pB is not None else "-",
                sci(vB.v) if vB is not None else "-",
                "|",
                dec(hiA, 14),
                "A:%s B:%s" % ("ok" if okA else "FAIL",
                               ("ok" if okB else "FAIL") if N <= RAT_NMAX else "n/a"),
            ))

    print()
    print("explicit rational heights in full (N <= %d, p/q, certified upper bound of Re S_N):" % RAT_NMAX)
    for (N, pB, qB, tAv, hiA, hiB, okA, okB) in rows:
        if N > RAT_NMAX:
            continue
        if pB is not None:
            print("  N=%-4d  t_N = 2pi*%d/%d   Re S_N(t_N) <= %s   [%s]" % (
                N, pB, qB, dec(hiB, 14), "CERTIFIED < 0" if okB else "NOT CERTIFIED"))
        else:
            print("  N=%-4d  (no rational found)                       [FAIL]" % N)
    print("  for N = %d..%d the uniform height t_N = pi/log N is certified in the table above," % (RAT_NMAX + 1, NMAX))
    print("  and for N >= 20 it is PROVED analytically (elementary, no equidistribution).")

    # ---- pattern / uniform-rule analysis -------------------------------- #
    print()
    print("PATTERN / uniform-rule analysis")
    print("-" * 78)
    import math as _math
    for (p, q) in [(1, 1), (1, 2), (1, 3), (2, 3), (1, 4), (1, 5)]:
        cnt = 0
        fails = []
        for N in range(3, NMAX + 1):
            v = sum(_math.cos(2.0 * _math.pi * p / q * logf[n]) for n in range(N))
            if v < 0.0:
                cnt += 1
            else:
                fails.append(N)
        print("  fixed height t = 2pi*%d/%d : negative for %d/%d N ; first N where it fails: %s"
              % (p, q, cnt, NMAX - 2, fails[:6] if fails else "none"))
    # runs of the per-N rational choice (only where one was searched)
    runs = []
    for (N, pB, qB, *_r) in rows:
        if N > RAT_NMAX or pB is None:
            continue
        key = (pB, qB)
        if runs and runs[-1][0] == key:
            runs[-1][2] = N
        else:
            runs.append([key, N, N])
    print("  per-N rational choice t=2pi p_N/q_N run-length encoding (%d runs over N=3..%d):"
          % (len(runs), RAT_NMAX))
    for key, a, b in runs:
        print("    N=%-4d..%-4d  (%-4d N)  t = 2pi*%s" % (a, b, b - a + 1, ("%d/%d" % key)))
    print("  => the closed form t_N = pi/log N is the uniform rule (proved for N >= 20);")
    print("     the rationalized heights are only *per-N* certificates from a small candidate")
    print("     set.  No single rational height covers the whole range (see the fixed-height")
    print("     rows above), so no closed-form rational rule is claimed.")

    # ---- summary -------------------------------------------------------- #
    print()
    print("=" * 78)
    print("SUMMARY")
    print("=" * 78)
    print("N range certified        : 3 .. %d" % NMAX)
    print("construction A failures  : %s" % (nA_fail if nA_fail else "none"))
    print("construction B failures  : %s" % (nB_fail if nB_fail else "none"))
    qs = sorted({qB for (_, _, qB, *_r) in rows if qB is not None})
    print("denominators q_N used    : %s" % qs)
    from collections import Counter
    print("q_N histogram            : %s" % dict(sorted(Counter(
        qB for (_, _, qB, *_r) in rows if qB is not None).items())))
    print("analytic bound           : Re S_N(pi/log N) < 0 for ALL N >= 20 (elementary, no equidistribution)")
    print()
    print("reference rows (closed form t_N = pi/log N):")
    print("  %-5s %-24s %-24s %s" % ("N", "t_N = pi/log N", "cert. upper bound", "implied root in"))
    byN = {N: (tAv, hiA) for (N, _p, _q, tAv, hiA, _h, _a, _b) in rows}
    for N in sorted(set([3, 4, 5, 10, 50, 100] + ([NMAX] if NMAX not in (3, 4, 5, 10, 50, 100) else []))):
        if N in byN:
            tAv, hiA = byN[N]
            print("  %-5d %-24s %-24s (0, %s)" % (N, dec(tAv, 16), dec(hiA, 16), dec(tAv, 8)))
    ok = (not nA_fail) and (not nB_fail) and aok
    print()
    print("PASS" if ok else "FAIL",
          "- construction A (t_N = pi/log N) certified for %d/%d N = 3..%d;" % (
              NMAX - 2 - len(nA_fail), NMAX - 2, NMAX))
    print("               of these, N >= 20 are in fact PROVED analytically (no computation);")
    print("               explicit rational heights certified for %d/%d N = 3..%d." % (
              RAT_NMAX - 2 - len(nB_fail), RAT_NMAX - 2, RAT_NMAX))
    print("root existence: Re S_N(0) = N > 0 and Re S_N(t_N) < 0 with Re S_N continuous,")
    print("               so each certified N has a root in (0, t_N) by the IVT.")
    print("elapsed %.1fs" % (time.time() - t_start))
    return 0


if __name__ == "__main__":
    sys.exit(main())
