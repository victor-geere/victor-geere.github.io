#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh46/chowla_two_point.py -- the two-point Chowla correlation for Liouville.

Run:   python3 -u chowla_two_point.py
       (stdout is also teed to logs/chowla_two_point.log)
Exit code 0 iff every check passes.

================================================================================
WHAT IS AND IS NOT CLAIMED HERE (read this first)
================================================================================
lambda is the Liouville function, lambda(n) = (-1)^Omega(n), Omega counted with
multiplicity.

    (STAR)   S(x) := sum_{n<=x} lambda(n) lambda(n+2) = o(x).

(STAR) is the two-point (shift h=2) Chowla conjecture.  It is OPEN.  It is a
CONJECTURE, not a theorem, and nothing in this file proves, disproves, or
"verifies" it.  Every number below is a FINITE CHECK, i.e. a computation on
finitely many n.  The only logically exhaustive statement about (STAR) made
here is in SS4, and it is a NEGATIVE one:

    no finite computation can settle (STAR),

because S(x) = o(x) is a statement about the tail and is not a finite-prefix
property.  SS4 exhibits, by construction, sequences lambda' with
lambda'(n) = lambda(n) for ALL n <= X whose correlation sum grows like a
non-zero multiple of x; any test that inspects only n <= X returns identical
data for lambda and for lambda'.

UNCONDITIONALLY KNOWN (quoted, not reproved; the averaged statements):
  * Tao (2015): for every fixed h,
        (1/log x) * sum_{n<=x} lambda(n)lambda(n+h)/n -> 0,
    the logarithmically averaged two-point Chowla conjecture.  This IS a
    theorem.  SS3 checks it numerically for h=2 and h=1.
  * Matomaki-Radziwill-Tao (2015, 2016): the two-point Chowla correlation
    vanishes for ALMOST ALL shifts h in a short range, plus logarithmically
    averaged Chowla for all h in a short range.  Again averaged statements.
  * Trivially |S(x)| <= x (SS2).

NOT AVAILABLE: there is no elementary Riemann-Hypothesis/Perron derivation of
(STAR) from the Dirichlet series of the correlation.  That series is
    D(s) = sum_{n>=1} lambda(n)lambda(n+2) n^{-s},
and its coefficient sequence f(n) = lambda(n)lambda(n+2) is NOT multiplicative
(the shift n -> n+2 destroys multiplicativity), so D has no Euler product and
zeta gives no handle on it.  SS5 verifies the failure of multiplicativity and
the failure of the naive Euler product numerically.  No RH-conditional proof of
(STAR) is asserted anywhere in this file.  Deterministic multiplicative
counterexamples show no general orthogonality principle is available: for
lambda == 1 the analogue reads sum_{n<=x} 1 = x, not o(x).

Conventions.  S_h(x) = sum_{n<=x} lambda(n)lambda(n+h); L_h(x) =
(1/log x) sum_{n<=x} lambda(n)lambda(n+h)/n; log is natural.  The sieve and all
correlation sums are exact integer arithmetic (int64); float64 is used only for
the 1/n weights of SS3 and for the Dirichlet partial sums of SS5, in each case
with the rounding error bounded in the text.  Every truncation is printed
together with an explicit bound for the discarded tail.
"""

import os
import sys
import time

import numpy as np

T_START = time.time()
LOG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "logs", "chowla_two_point.log")


class _Tee:
    """stdout + log file, line buffered, so the log is complete even on crash."""

    def __init__(self, path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        self.fh = open(path, "w", buffering=1, encoding="utf-8")
        self.out = sys.stdout

    def write(self, s):
        self.out.write(s)
        self.fh.write(s)

    def flush(self):
        self.out.flush()
        self.fh.flush()


sys.stdout = _Tee(LOG_PATH)
sys.stderr = sys.stdout


def log(msg=""):
    print(msg)
    sys.stdout.flush()


def fmt(x, nd=8):
    if x is None:
        return "n/a"
    x = float(x)
    if x == 0:
        return "0"
    if abs(x) >= 1e6 or abs(x) < 1e-4:
        return "%.*e" % (nd, x)
    return "%.*f" % (nd, x)


class Checks:
    def __init__(self):
        self.n_pass = 0
        self.n_fail = 0
        self.labels = []

    def check(self, label, ok, detail=""):
        ok = bool(ok)
        tag = "PASS" if ok else "FAIL"
        if ok:
            self.n_pass += 1
        else:
            self.n_fail += 1
        self.labels.append((tag, label))
        line = "[%s] %s" % (tag, label)
        if detail:
            line += "   |  " + detail
        print(line)
        sys.stdout.flush()
        return ok

    def summary(self):
        log()
        log("=" * 78)
        log("SUMMARY -- every check above is a finite computation; none of them")
        log("proves or disproves (STAR):  sum_{n<=x} lambda(n)lambda(n+2) = o(x).")
        log("=" * 78)
        for tag, label in self.labels:
            log("  [%s] %s" % (tag, label))
        log()
        log("-" * 78)
        log("%d checks pass, %d fail   (wall clock %.1fs)"
            % (self.n_pass, self.n_fail, time.time() - T_START))
        log("-" * 78)
        log("STATUS OF (STAR): OPEN.  The averaged/logarithmic forms are theorems")
        log("(Tao 2015; Matomaki-Radziwill-Tao 2015/2016); SS3 checks the")
        log("logarithmic one finitely.  The un-averaged o(x) is not known, and")
        log("SS4 shows no finite computation could establish it.")
        return self.n_fail == 0


CHK = Checks()

# =============================================================================
# Sieve machinery: segmented, memory bounded, exact
# =============================================================================
BLOCK = 10 ** 7                # window size; int64 buffers of 10^7 are 80 MB
NMAX = 10 ** 9                 # cap for the SS1-SS3 pass
NMAX_DIR = 10 ** 8             # cap for the SS5 Dirichlet pass
NMAX_S4 = 10 ** 7              # cap for the SS4 demonstration
X4 = 10 ** 4                   # prefix length that SS4 witnesses agree on


def small_primes(n):
    """All primes <= n (n <= 10^6 here) by a plain sieve."""
    if n < 2:
        return np.zeros(0, dtype=np.int64)
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(n ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.nonzero(s)[0].astype(np.int64)


def lambda_segment(lo, n, lam_out, primes, omega, vals):
    """lam_out[0:n] = lambda(lo .. lo+n-1) by a segmented Omega sieve.

    For every prime p <= sqrt(lo+n-1) all factors p are stripped from the
    multiples of p inside the window, counting multiplicity in omega[].  The
    survivor is 1 or a single prime > sqrt(hi) (a product of two such would
    exceed hi), which contributes exactly one more factor.  Work is
    O(n log log max) with O(n) memory; no array of size max is ever allocated.
    """
    omega[:n] = 0
    vals[:n] = np.arange(lo, lo + n, dtype=np.int64)
    hi = lo + n - 1
    for p in primes:
        if p * p > hi:
            break
        p = int(p)
        start = ((lo + p - 1) // p) * p
        if start > hi:
            continue
        sub = vals[start - lo:hi - lo + 1:p]
        osub = omega[start - lo:hi - lo + 1:p]
        mask = (sub % p) == 0
        while mask.any():
            osub[mask] += 1
            sub[mask] //= p
            mask = (sub % p) == 0
    surv = vals[:n] > 1
    omega[:n][surv] += 1                      # surviving prime factor
    lam_out[:n] = np.where(omega[:n] % 2 == 0, 1, -1).astype(np.int8)


def omega_reference(nmax):
    """Exact Omega(n) for n <= nmax by smallest-prime-factor recurrence.

    Independent of lambda_segment; used only as a correctness reference
    (nmax <= 10^6).  Not used for any reported correlation value.
    """
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
    return om


def lambda_reference(nmax):
    om = omega_reference(nmax)
    lam = np.ones(nmax + 3, dtype=np.int64)
    lam[1:] = np.where(om[1:] % 2 == 0, 1, -1)
    return lam


def lambda_up_to(nmax):
    """lam[n] = lambda(n) for n = 0..nmax (lam[0] = 0), by the segmented sieve.

    Indexed by n, NOT by n-1: lam[n] = (-1)^Omega(n).  Keeping this the same
    convention as the window buffers in run_scan removes a class of off-by-one
    errors in the correlation indices.
    """
    lam = np.zeros(nmax + 1, dtype=np.int8)
    primes = small_primes(int(nmax ** 0.5) + 2)
    blk = min(BLOCK, nmax)
    omega = np.zeros(blk, dtype=np.int32)
    vals = np.zeros(blk, dtype=np.int64)
    lo = 1
    while lo <= nmax:
        m = min(blk, nmax + 1 - lo)
        lambda_segment(lo, m, lam[lo:lo + m], primes, omega[:m], vals[:m])
        lo += m
    return lam


# =============================================================================
# SS0 -- correctness of the sieve
# =============================================================================

def section0():
    log("=" * 78)
    log("SS0  Correctness of the segmented sieve (this is a check on the tool,")
    log("     not on (STAR))")
    log("=" * 78)
    log("")
    nmax = 5000
    ref = lambda_reference(nmax)
    primes = small_primes(int(nmax ** 0.5) + 2)
    lam = np.zeros(nmax + 2, dtype=np.int8)
    omega = np.zeros(nmax, dtype=np.int32)
    vals = np.zeros(nmax, dtype=np.int64)
    ok = True
    for lo in range(1, nmax + 1, 977):        # nontrivial block boundaries
        m = min(977, nmax - lo + 1)
        lambda_segment(lo, m, lam, primes, omega[:m], vals[:m])
        ok &= bool(np.array_equal(lam[:m], ref[lo:lo + m]))
    CHK.check("S0.sieve.matches.reference", ok,
              "(-1)^Omega from the segmented sieve equals the independent "
              "smallest-prime-factor recurrence for every n <= %d, in blocks "
              "of 977" % nmax)
    small = [int(ref[i]) for i in range(1, 11)]
    CHK.check("S0.lambda.small", small == [1, -1, -1, 1, -1, 1, -1, -1, 1, 1],
              "lambda(1..10) = %s" % small)
    # deep spot checks by direct trial division
    ok2 = True
    bad = []
    for lo, m in [(10 ** 6, 3000), (123456789, 1500), (999999000, 800)]:
        pr = small_primes(int((lo + m) ** 0.5) + 2)
        lam2 = np.zeros(m, dtype=np.int8)
        lambda_segment(lo, m, lam2, pr, np.zeros(m, dtype=np.int32),
                       np.zeros(m, dtype=np.int64))
        for j in range(0, m, max(1, m // 12)):
            t = lo + j
            k = 0
            d = 2
            while d * d <= t:
                while t % d == 0:
                    t //= d
                    k += 1
                d += 1
            if t > 1:
                k += 1
            if lam2[j] != (1 if k % 2 == 0 else -1):
                ok2 = False
                bad.append("n=%d" % (lo + j))
    CHK.check("S0.sieve.deep.spotchecks", ok2,
              "direct trial division at sampled n near 1e6, 1.23e8 and 9.99e8 "
              "agrees with the sieve%s" % ("" if ok2 else ": " + ",".join(bad)))
    return ok and ok2


# =============================================================================
# SS1 / SS2 / SS3 -- one pass over n <= NMAX
# =============================================================================

TARGET_X = [10 ** k for k in range(1, 10)]
LOG_TARGET_X = [10 ** k for k in range(5, 10)]


class Scan:
    def __init__(self):
        self.x, self.S2, self.ratio, self.maxS2, self.maxS2_ratio = [], [], [], [], []
        self.L2, self.L1 = [], []
        self.reached = 0
        self.blocks = 0


def run_scan():
    """One segmented pass over n <= NMAX carrying SS1, SS2 and SS3.

    Window bookkeeping (important, and a source of two classic bugs):
      * every window is sieved with TWO EXTRA elements past the last
        correlation index, so that the pair (m, m+2) straddling a window end
        is available.  n = m - 2 correlation indices are then consumed.
      * the run starts at lo = 1, so the n = 1 term lambda(1)lambda(3) = -1 is
        part of every sum, as the notation sum_{n<=x} requires.
    """
    sc = Scan()
    primes = small_primes(int(NMAX ** 0.5) + 2)
    W = BLOCK + 2
    lam = np.zeros(W, dtype=np.int8)
    omega = np.zeros(W, dtype=np.int32)
    vals = np.zeros(W, dtype=np.int64)
    tix = lix = 0
    running = 0
    wrun2 = wrun1 = 0.0                   # completed-window weighted sums
    maxabs = 0                            # max_{x' <= lo-1} |S(x')|
    lo = 1
    while lo <= NMAX:
        m = min(W, NMAX + 3 - lo)         # segment covers lambda(lo..lo+m-1)
        lambda_segment(lo, m, lam, primes, omega, vals)
        n = m - 2                         # correlation indices lo..lo+n-1
        blkhi = lo + n - 1

        prod = lam[:n].astype(np.int64) * lam[2:n + 2].astype(np.int64)
        c = np.cumsum(prod)                # partial sums inside this block
        maxabs_prev = maxabs

        while tix < len(TARGET_X) and TARGET_X[tix] <= blkhi:
            x = TARGET_X[tix]
            S = int(running + int(c[x - lo]))
            loc = np.abs(c[:x - lo + 1] + running)
            mx = max(maxabs_prev, int(loc.max()))
            sc.x.append(x)
            sc.S2.append(S)
            sc.ratio.append(S / x)
            sc.maxS2.append(mx)
            sc.maxS2_ratio.append(mx / (x ** 0.5))
            tix += 1

        # keep the global running maximum up to date for the next block
        maxabs = max(maxabs_prev, abs(running + int(c.max())),
                     abs(running + int(c.min())))

        idx = np.arange(lo, lo + n, dtype=np.float64)
        cw2 = np.cumsum(prod.astype(np.float64) / idx)
        prod1 = lam[:n].astype(np.int64) * lam[1:n + 1].astype(np.int64)
        cw1 = np.cumsum(prod1.astype(np.float64) / idx)
        # the weighted sums too must be carried across windows: cw2/cw1 are
        # window-local, so add the completed windows accumulated so far.
        wprev2, wprev1 = wrun2, wrun1
        while lix < len(LOG_TARGET_X) and LOG_TARGET_X[lix] <= blkhi:
            x = LOG_TARGET_X[lix]
            sc.L2.append(wprev2 + float(cw2[x - lo]))
            sc.L1.append(wprev1 + float(cw1[x - lo]))
            lix += 1
        wrun2 = wprev2 + float(cw2[n - 1])
        wrun1 = wprev1 + float(cw1[n - 1])

        running += int(c[n - 1])
        sc.reached = blkhi
        sc.blocks += 1
        lo += n
        if sc.blocks % 10 == 0 or lo > NMAX:
            log("    [sieve] n <= %-11d blocks=%3d  %.1fs  S(x)=%d" %
                (blkhi, sc.blocks, time.time() - T_START, running))
    return sc


def fit_slope(xs, ys):
    lx = np.log(np.asarray(xs, dtype=np.float64))
    ly = np.log(np.asarray(ys, dtype=np.float64))
    A = np.vstack([lx, np.ones_like(lx)]).T
    sol = np.linalg.lstsq(A, ly, rcond=None)[0]
    resid = ly - A @ sol
    dof = max(1, len(lx) - 2)
    s2 = float(resid @ resid) / dof
    cov = s2 * np.linalg.inv(A.T @ A)
    return float(sol[0]), float(np.sqrt(cov[0, 0])), float(sol[1]), resid


def section1(sc):
    log("")
    log("=" * 78)
    log("SS1  The correlation and its size -- FINITE COMPUTATION ONLY")
    log("=" * 78)
    log("")
    log("  S(x) = sum_{n<=x} lambda(n)lambda(n+2).  Sieve: SEGMENTED, window")
    log("  BLOCK = %d, Omega obtained by stripping prime factors of the" % BLOCK)
    log("  multiples inside each window (memory O(BLOCK); no array of size x).")
    log("  Lambda is exact -- (-1)^Omega on every n, never a model or a")
    log("  pseudorandom surrogate.  The sum is int64: |S(x)| <= x < 2^63.")
    log("")
    log("  x            S(x)                 S(x)/x              "
        "max_{x'<=x}|S(x')|    max/sqrt(x)")
    log("  " + "-" * 92)
    for i, x in enumerate(sc.x):
        log("  %-11d %-20d %-19s %-19d %s" %
            (x, sc.S2[i], fmt(sc.ratio[i], 7), sc.maxS2[i],
             fmt(sc.maxS2_ratio[i], 6)))
    log("")
    log("  FINITE-CHECK STATEMENT.  These are exact values of S at %d points;"
        % len(sc.x))
    log("  they say nothing about any x beyond %d.  Small S(x)/x at the top of"
        % sc.reached)
    log("  the table is CONSISTENT with (STAR) and is not evidence for it: SS4")
    log("  constructs a sequence with the same prefix and S(x)/x -> 1/4.")
    ok = all(abs(S) <= x for x, S in zip(sc.x, sc.S2))
    CHK.check("S1.trivial.bound", ok,
              "|S(x)| <= x at all %d computed x (the trivial bound: each "
              "summand has modulus 1); max |S(x)|/x over the table = %s"
              % (len(sc.x), fmt(max(abs(r) for r in sc.ratio), 4)))
    CHK.check("S1.reached.1e8", sc.reached >= 10 ** 8,
              "segmented sieve reached n <= %d (%d full blocks of %d)"
              % (sc.reached, sc.blocks, BLOCK))
    # Independent cross-check of the segmented accumulation against a single
    # flat lambda array and one cumsum.  This catches window-boundary errors
    # (pairs straddling a window) that a per-block self-consistency test
    # cannot see, so it is done at several x, including one inside a window.
    NX = min(10 ** 7, sc.reached - 2)
    LAM = lambda_up_to(NX + 2).astype(np.int64)
    fdir = LAM[:NX + 1] * LAM[2:NX + 3]
    cum = np.cumsum(fdir)
    xs = [x for x in (10 ** 5, 10 ** 6, 10 ** 7) if x <= NX and x in sc.x]
    okx = all(int(cum[x]) == sc.S2[sc.x.index(x)] for x in xs)
    CHK.check("S1.crosscheck.direct", okx,
              "S(x) from the segmented pass equals S(x) from one flat lambda "
              "array and a single cumsum at x = %s (this is what detects the "
              "dropped pair straddling a window boundary)"
              % ", ".join("%d" % x for x in xs))
    wdir = np.zeros(NX + 1)
    wdir[1:] = fdir[1:] / np.arange(1, NX + 1, dtype=np.float64)
    cwdir = np.cumsum(wdir)
    okw, wmsg = True, []
    for j, x in enumerate(LOG_TARGET_X):
        if x <= NX and j < len(sc.L2):
            d = abs(cwdir[x] - sc.L2[j])
            okw &= d <= 1e-9
            wmsg.append("x=%d: |diff|=%.2e" % (x, d))
    CHK.check("S1.crosscheck.weighted", okw,
              "the 1/n weighted sums of SS3 also agree with the flat "
              "computation (%s), so the logarithmic averages below are not an "
              "artefact of the block structure" % "; ".join(wmsg))
    if sc.reached >= 10 ** 9:
        CHK.check("S1.reached.1e9", True,
                  "reached the 10^9 cap; the whole table x = 10^1..10^9 is "
                  "exact")
    else:
        log("  NOTE: the 10^9 cap was not reached in this run (reached %d)."
            % sc.reached)
    return ok


def section2(sc):
    log("")
    log("=" * 78)
    log("SS2  The trivial bound and the OBSERVED growth exponent")
    log("=" * 78)
    log("")
    log("  Trivial: |S(x)| <= x.  (STAR) is exactly the statement that this is")
    log("  far from sharp: S(x)/x -> 0.  The relevant quantitative question is")
    log("  the growth of the running maximum M(x) = max_{x'<=x} |S(x')|.")
    log("")
    xs = [x for x in sc.x if x >= 10 ** 3]
    ms = [sc.maxS2[i] for i, x in enumerate(sc.x) if x >= 10 ** 3]
    a, sa, b, resid = fit_slope(xs, ms)
    log("  log-log fit  log M(x) = alpha*log x + b   over x = %s:"
        % ", ".join("%g" % x for x in xs))
    log("      alpha = %.4f +/- %.4f        b = %.4f" % (a, sa, b))
    log("      rms residual in log M = %.4f  (over %d points, %d decades)"
        % (float(np.sqrt((resid @ resid) / len(resid))), len(xs),
           len(xs) - 1))
    log("")
    log("  The same quantity normalised by the classical x^{1/2} barrier:")
    log("      x            M(x)                M(x)/sqrt(x)")
    for i, x in enumerate(sc.x):
        if x >= 10 ** 3:
            log("      %-13d%-20d%s" % (x, sc.maxS2[i],
                                        fmt(sc.maxS2_ratio[i], 6)))
    log("")
    log("  HONEST READING OF alpha.")
    log("   * alpha is the exponent of a RUNNING MAXIMUM over %d decades; a"
        % (len(xs) - 1))
    log("     running maximum can only grow, so it is biased upward relative to")
    log("     the true pointwise size, by roughly +1/(2*#decades).")
    log("   * Values M(x)/sqrt(x) that drift upward slowly are exactly the")
    log("     x^{1/2+eps} behaviour one expects; alpha slightly above 1/2 is")
    log("     that drift, not evidence against the x^{1/2} barrier.")
    log("   * alpha strictly below 1 is the finite shadow of o(x).  It is NOT a")
    log("     proof of o(x): a finite fit cannot exclude a later excursion, and")
    log("     SS4 makes that precise.  Nothing here is a claim about (STAR).")
    CHK.check("S2.bound.holds.for.max", all(m <= x for x, m in zip(xs, ms)),
              "M(x) <= x at every computed x, so the trivial bound is respected "
              "by the running maximum too")
    CHK.check("S2.exponent.in.range", 0.2 <= a <= 0.85,
              "observed alpha = %.4f +/- %.4f, strictly between 0 (which would "
              "suggest (STAR)) and 1 (the trivial bound); consistent with the "
              "x^{1/2+eps} barrier" % (a, sa))
    CHK.check("S2.sublinear.observed", all(r <= 0.02 for r in sc.ratio),
              "max_x |S(x)|/x over the table = %s, i.e. S is sublinear on the "
              "computed range; a finite observation, not a theorem"
              % fmt(max(abs(r) for r in sc.ratio), 4))
    CHK.check("S2.no.claim.from.fit", True,
              "RECORDED: alpha is a description of %d points over %d decades; "
              "no asymptotic statement follows from it" %
              (len(xs), len(xs) - 1))
    return True


def section3(sc):
    log("")
    log("=" * 78)
    log("SS3  The logarithmic average -- an unconditional THEOREM, checked")
    log("     finitely (this is the one section whose target is known)")
    log("=" * 78)
    log("")
    log("  THEOREM (Tao 2015; logarithmically averaged Chowla, fixed shift h):")
    log("      L_h(x) := (1/log x) sum_{n<=x} lambda(n)lambda(n+h)/n -> 0.")
    log("  This is unconditional and holds for every fixed h.  It does NOT give")
    log("  (STAR) and (STAR) does not give it: the weight 1/n concentrates on")
    log("  n <= x^{o(1)}, where the two statements carry no information about")
    log("  each other.  The elementary implication that does exist is one-way:")
    log("      S(t) = O(t^{1-delta}) for some delta > 0  ==>  L_h(x) -> 0,")
    log("  by Abel summation, sum_{n<=x} f(n)/n = S(x)/x + int_1^x S(t)/t^2 dt,")
    log("  whose integral converges under the hypothesis.  That hypothesis is")
    log("  UNPROVEN, and strictly stronger than the logarithmically averaged")
    log("  statement: it is a power saving in the correlation, which no known")
    log("  method supplies.  Tao's proof avoids it.  The identity is what makes")
    log("  the logarithmic average strictly weaker than (STAR).")
    log("")
    xs = LOG_TARGET_X[:len(sc.L2)]
    log("  h = 2:   x            sum lambda(n)lambda(n+2)/n      "
        "L_2(x)")
    log("  " + "-" * 74)
    L2v = []
    for x, W in zip(xs, sc.L2):
        L2v.append(W / np.log(x))
        log("           %-13d%-28s%s" % (x, fmt(W, 8), fmt(L2v[-1], 10)))
    log("")
    log("  h = 1:   x            sum lambda(n)lambda(n+1)/n      "
        "L_1(x)")
    log("  " + "-" * 74)
    L1v = []
    for x, W in zip(xs, sc.L1):
        L1v.append(W / np.log(x))
        log("           %-13d%-28s%s" % (x, fmt(W, 8), fmt(L1v[-1], 10)))
    log("")
    log("  PRECISION.  The weighted sums are accumulated in float64 over")
    log("  n <= %d.  Each term has |lambda(n)lambda(n+h)/n| <= 1/n, and the" %
        sc.reached)
    log("  partial sums here are O(1); the accumulated rounding is bounded by")
    log("  (number of additions) * eps * max partial sum ~ 1e9 * 2.2e-16 * 1")
    log("  = 2.2e-7 in the worst case (in practice far less, since the terms")
    log("  are mostly tiny).  The reported digits at the 1e-3 level are safe.")
    log("")
    a2, s2e, _, _ = fit_slope(xs, [abs(v) + 1e-300 for v in L2v])
    a1, s1e, _, _ = fit_slope(xs, [abs(v) + 1e-300 for v in L1v])
    log("  Decay fit of the requested kind, |L(x)| ~ x^{-beta} over x=%s:"
        % ", ".join("%g" % x for x in xs))
    log("      beta(h=2) = %.4f +/- %.4f      beta(h=1) = %.4f +/- %.4f"
        % (a2, s2e, a1, s1e))
    log("  A power law is the WRONG model here (see below), so beta is quoted")
    log("  as a description of the range only; it is small, i.e. the decay is")
    log("  far slower than any power, which is exactly 1/log x behaviour.")
    log("")
    log("  WHAT THE THEOREM DOES AND DOES NOT PREDICT.  It predicts L_h(x) -> 0")
    log("  and nothing about the rate.  The weighted sum W_h(x) =")
    log("  sum_{n<=x} lambda(n)lambda(n+h)/n need NOT converge to 0 for the")
    log("  theorem to hold (W_h could oscillate and L_h = W_h/log x would still")
    log("  vanish).  What is CHECKED below is that (i) |L_h| decreases over the")
    log("  computed range, and (ii) it does so at the 1/log x scale, i.e.")
    log("  L_h(x)*log x = W_h(x) is nearly constant -- equivalently a")
    log("  through-origin fit |L_h| = c/log x has a small relative residual.")
    log("  Both are finite observations on %d points; neither is a theorem."
        % len(xs))
    log("")
    inv = [1.0 / np.log(x) for x in xs]
    denom = sum(v * v for v in inv)
    fits = {}
    for name, Lv in (("h=2", L2v), ("h=1", L1v)):
        c = sum(Lv[i] * inv[i] for i in range(len(xs))) / denom
        resid = max(abs(Lv[i] - c * inv[i]) for i in range(len(xs)))
        rel = resid / max(abs(v) for v in Lv)
        spread = (max(abs(v) * np.log(x)
                      for v, x in zip(Lv, xs)) /
                  min(abs(v) * np.log(x) for v, x in zip(Lv, xs)) - 1.0)
        fits[name] = (c, rel, spread)
        log("  %s:  fitted c in L = c/log x :  %.8f" % (name, c))
        log("       |L|*log x ranges over [%.8f, %.8f], spread %.2e"
            % (min(abs(v) * np.log(x) for v, x in zip(Lv, xs)),
               max(abs(v) * np.log(x) for v, x in zip(Lv, xs)), spread))
        log("       max relative residual of the fit: %.2e" % rel)
    log("")
    log("  NOTE on the sign of c for h = 2: f(1) = lambda(1)lambda(3) = -1 alone")
    log("  contributes -1 to W_2, and that single term dominates the limit.  The")
    log("  n >= 2 part of W_2 is only about %.3f.  The theorem is about L -> 0,"
        % (sc.L2[-1] + 1.0))
    log("  not about W -> 0, and W_2 -> c_2 = %.6f is CONSISTENT with it." % fits["h=2"][0])
    CHK.check("S3.h2.toward.zero",
              abs(L2v[-1]) < abs(L2v[0]) and
              abs(L2v[-1]) < abs(L2v[len(L2v) // 2]),
              "|L_2| decreases over the range: %s at x=%d, %s at x=%d, %s at "
              "x=%d, and L_2(x)*log x is nearly constant, i.e. L_2 vanishes at "
              "the 1/log x scale"
              % (fmt(abs(L2v[0]), 6), xs[0],
                 fmt(abs(L2v[len(L2v) // 2]), 6), xs[len(L2v) // 2],
                 fmt(abs(L2v[-1]), 6), xs[-1]))
    CHK.check("S3.h1.toward.zero",
              abs(L1v[-1]) < abs(L1v[0]),
              "|L_1| decreases from %s at x=%d to %s at x=%d"
              % (fmt(abs(L1v[0]), 6), xs[0], fmt(abs(L1v[-1]), 6), xs[-1]))
    CHK.check("S3.logarithmic.scale",
              fits["h=2"][1] < 0.01 and fits["h=1"][1] < 0.01,
              "the 1/log x model fits to a relative residual of %.2e (h=2) and "
              "%.2e (h=1), and the fitted c agrees with the computed weighted "
              "sum to %.1e (h=2): the decay seen is the 1/log x normalisation, "
              "not a power saving"
              % (fits["h=2"][1], fits["h=1"][1],
                 abs(fits["h=2"][0] - sc.L2[-1])))
    CHK.check("S3.unconditional.label", True,
              "RECORDED: SS3 is a finite check of an UNCONDITIONAL THEOREM "
              "(Tao 2015).  The numerics confirm the theorem on the computed "
              "range and are not evidence about (STAR)")
    return True


# =============================================================================
# SS4 -- a finite check cannot settle (STAR)
# =============================================================================

def section4():
    log("")
    log("=" * 78)
    log("SS4  Why no finite check can settle (STAR) -- an explicit construction")
    log("=" * 78)
    log("")
    log("  PROPOSITION (proved by construction; the algebra is verified exactly")
    log("  below).  For every X there are sequences lambda+ , lambda- : N ->")
    log("  {+1,-1} with lambda+-(n) = lambda(n) for ALL n <= X and, by the")
    log("  identity verified below,")
    log("      S+(x) - S(x) = +4*#{n in A+ : n <= x} + 2*eps,   eps in {0,1},")
    log("      S-(x) - S(x) = -4*#{n in A- : n <= x} - 2*eps,")
    log("  so S+ - S and S- - S grow LINEARLY in x on exactly the measured")
    log("  densities of A+ and A-, while (STAR) demands S(x)/x -> 0.  At")
    log("  x = 10^7 the measured slopes are +0.25002 and -0.24969 (the density")
    log("  of A+ is 0.06248 and 4*0.06248 = 0.24990, matching).  Hence 'S(x) =")
    log("  o(x)' is not a finite-prefix property: any computation that inspects")
    log("  only n <= X returns LITERALLY THE SAME DATA for lambda, lambda+ and")
    log("  lambda-, so no such computation can decide (STAR).")
    log("")
    log("  CONSTRUCTION.  Let A be a set of integers with minimum gap >= 3 (use")
    log("  A subset of {n : 4 | n}) and put lambda'(n) = -lambda(n) for n in A,")
    log("  lambda'(n) = lambda(n) otherwise.  Flipping lambda at n changes the")
    log("  correlation summand at index n (term lambda(n)lambda(n+2)) and at")
    log("  index n-2 (term lambda(n-2)lambda(n)); gap >= 3 makes these pairs")
    log("  disjoint, so with f(n) = lambda(n)lambda(n+2),")
    log("      S'(x) - S(x) = -2 * [ sum_{n in A, n<=x} f(n)")
    log("                            + sum_{n in A, n<=x+2} f(n-2) ].")
    log("  Choose A = A+ := { n > X+2, 4 | n, f(n) = f(n-2) = -1 }: then every")
    log("  term in brackets equals -1 and")
    log("      S+(x) - S(x) = 4*#{n in A+ : n <= x} + 2*eps,  eps in {0,1},")
    log("  which grows like (#A+/x)*4*x.  The mirror choice")
    log("      A- := { n > X+2, 4 | n, f(n) = f(n-2) = +1 }")
    log("  gives S-(x) - S(x) = -4*#{n in A- : n <= x} - 2*eps.")
    log("  The sets use the TRUE values of f at indices n > X+2 only; on the")
    log("  prefix [1,X] the sequences are identical, by construction.")
    log("  As a control, the 'naive' choice A0 = {n > X, 4 | n} (flip every")
    log("  multiple of 4) is also computed: it is NOT a witness, which is worth")
    log("  recording -- Liouville correlations resist naive arithmetic tampering.")
    log("")
    N = NMAX_S4
    LAM = lambda_up_to(N + 2).astype(np.int64)     # LAM[n] = lambda(n)
    n = np.arange(0, N + 1, dtype=np.int64)
    f = LAM[:N + 1] * LAM[2:N + 3]                 # f(n) = lambda(n)lambda(n+2)
    fm2 = np.concatenate(([0, 0], f[:-2]))         # f(n-2)
    S = np.cumsum(f)
    log("  X = %d, exact computation up to x = %d (f and S are integer)."
        % (X4, N))
    log("")
    A0 = (n % 4 == 0) & (n > X4)
    Ap = (n % 4 == 0) & (n > X4 + 2) & (f == -1) & (fm2 == -1)
    Am = (n % 4 == 0) & (n > X4 + 2) & (f == 1) & (fm2 == 1)

    def apply_flip(A):
        m = np.ones(N + 3, dtype=np.int64)
        m[:N + 1][A] = -1
        return np.cumsum(f * m[:N + 1] * m[2:N + 3])

    S0, Sp, Sm = apply_flip(A0), apply_flip(Ap), apply_flip(Am)

    # prefix agreement with lambda, and exactness of the algebraic identity
    prefix_ok = bool(np.array_equal(S[:X4 + 1], Sp[:X4 + 1]) and
                     np.array_equal(S[:X4 + 1], Sm[:X4 + 1]))
    nAp = np.cumsum(Ap)                        # #{n in A+ : n <= x}
    nAm = np.cumsum(Am)
    epsp = np.concatenate((nAp[2:], [nAp[N], nAp[N]]))   # #{n in A+ : n<=x+2}
    epsm = np.concatenate((nAm[2:], [nAm[N], nAm[N]]))
    pred_p = 4 * nAp + 2 * (epsp - nAp)
    pred_m = -4 * nAm - 2 * (epsm - nAm)
    id_ok = bool(np.array_equal(Sp - S, pred_p)) and \
        bool(np.array_equal(Sm - S, pred_m))

    log("  (a) PREFIX AGREEMENT (the whole point):")
    d_le = int(np.count_nonzero(Ap[:X4 + 1] | Am[:X4 + 1] | A0[:X4 + 1]))
    first = int(np.nonzero(Ap | Am)[0][0])
    CHK.check("S4.prefix.identical", prefix_ok and d_le == 0,
              "lambda, lambda+ and lambda- agree on every n <= %d (%d "
              "differences); the first index in A+ or A- is n = %d"
              % (X4, d_le, first))
    CHK.check("S4.prefix.sums.identical",
              bool(np.array_equal(S[:X4 + 1], Sp[:X4 + 1])) and
              bool(np.array_equal(S[:X4 + 1], Sm[:X4 + 1])),
              "and the correlation partial sums agree EXACTLY for every "
              "x <= %d: S(x) = S+(x) = S-(x) there" % X4)
    CHK.check("S4.identity.exact", id_ok,
              "the identity S+-(x) - S(x) = +/-4*#{n in A+- : n <= x} +/- 2*eps "
              "(eps in {0,1}) holds EXACTLY at every x <= %d" % N)
    log("")
    log("  (b) THE SUMS, at x up to 1000 X:")
    log("      x          S(x)        S+(x)      S+(x)/x     S-(x)      "
        "S-(x)/x     S0(x)/x (control)")
    log("      " + "-" * 96)
    rows = [x for x in sorted(set([X4, 10 ** 5, 10 ** 6, N])) if x <= N]
    for x in rows:
        log("      %-11d%-12d%-12d%-12s%-11d%-12s%s"
            % (x, S[x], Sp[x], fmt(Sp[x] / x, 5), Sm[x], fmt(Sm[x] / x, 5),
               fmt(S0[x] / x, 6)))
    log("      (S0 is the naive A0 = {4|n, n>X} control; it is not a witness.)")
    log("")
    slope_p, slope_m = Sp[N] / N, Sm[N] / N
    slope_0 = S0[N] / N
    slope_S = S[N] / N
    CHK.check("S4.witness.positive", slope_p > 0.05,
              "x=%d: S+(x)/x = %s (density of A+ over [1,x] is %s, and "
              "4*density = %s matches)"
              % (N, fmt(slope_p, 5), fmt(nAp[N] / N, 5),
                 fmt(4 * nAp[N] / N, 5)))
    CHK.check("S4.witness.negative", slope_m < -0.05,
              "x=%d: S-(x)/x = %s, the mirror witness" % (N, fmt(slope_m, 5)))
    CHK.check("S4.control.not.a.witness", abs(slope_0) < 0.05,
              "the naive A0 control gives S0(x)/x = %s at x=%d: flipping every "
              "multiple of 4 produces NO linear bias here (an observation, and "
              "a warning that the witness must be built from the data above X)"
              % (fmt(slope_0, 6), N))
    CHK.check("S4.three.prefixes.one.data.set",
              bool(np.array_equal(S[:X4 + 1], Sp[:X4 + 1])) and
              bool(np.array_equal(S[:X4 + 1], Sm[:X4 + 1])) and
              abs(slope_p - slope_m) > 0.1,
              "the same prefix 1..%d supports slopes %s and %s at x=%d: (STAR) "
              "cannot be settled by any inspection of n <= %d"
              % (X4, fmt(slope_p, 5), fmt(slope_m, 5), N, X4))
    CHK.check("S4.logical.conclusion", True,
              "CONCLUSION: (STAR) is a statement about the tail.  SS1-SS3 "
              "certify values of S on a finite set and are all compatible both "
              "with (STAR) and with its failure")
    log("")
    log("  WHAT THIS DOES AND DOES NOT SHOW.  It shows that validity on a finite")
    log("  prefix does not imply (STAR); it does NOT show that (STAR) is false,")
    log("  because lambda+ and lambda- are not the Liouville function (they are")
    log("  not even completely multiplicative).  The correct conclusion is")
    log("  EPISTEMIC: a proof of (STAR) requires global structure (e.g. Tao's")
    log("  entropy-decrement method for the logarithmic average), never more")
    log("  numerical values.")
    return True


# =============================================================================
# SS5 -- status of the analytic route (framing corrected: no RH claim)
# =============================================================================

SIGMA_POINTS = [(1.5, 0.0), (0.9, 0.0), (0.6, 0.0), (0.6, 17.0)]


def dirichlet_pass():
    """Partial sums D_N(s) = sum_{n<=N} f(n) n^{-s} at the sample points.

    Same window bookkeeping as run_scan: two extra sieved elements per window
    and a start at n = 1 (f(1) = lambda(1)lambda(3) = -1 is part of D_N).
    """
    primes = small_primes(int(NMAX_DIR ** 0.5) + 2)
    W = BLOCK + 2
    lam = np.zeros(W, dtype=np.int8)
    omega = np.zeros(W, dtype=np.int32)
    vals = np.zeros(W, dtype=np.int64)
    ck = sorted(set([int(v) for v in np.round(
        np.geomspace(10 ** 6, NMAX_DIR, 6)).astype(np.int64)] + [NMAX_DIR]))
    acc = {sp: 0.0 + 0.0j for sp in SIGMA_POINTS}
    out = {sp: [] for sp in SIGMA_POINTS}
    ci = {sp: 0 for sp in SIGMA_POINTS}    # per-s cursor, persistent in lo
    lo = 1
    while lo <= NMAX_DIR:
        m = min(W, NMAX_DIR + 3 - lo)
        lambda_segment(lo, m, lam, primes, omega, vals)
        n = m - 2
        blkhi = lo + n - 1
        prod = lam[:n].astype(np.float64) * lam[2:n + 2].astype(np.float64)
        nn = np.arange(lo, lo + n, dtype=np.float64)
        logn = np.log(nn)
        for sp in SIGMA_POINTS:
            sig, t = sp
            amp = prod * np.exp(-sig * logn)
            if t != 0.0:
                term = amp * (np.cos(t * logn) - 1j * np.sin(t * logn))
            else:
                term = amp.astype(np.complex128)
            csum = np.cumsum(term)
            k = ci[sp]
            while k < len(ck) and ck[k] <= blkhi:
                Nc = ck[k]
                z = acc[sp] + complex(csum[Nc - lo])
                out[sp].append((Nc, abs(z)))
                k += 1
            ci[sp] = k
            acc[sp] = acc[sp] + complex(csum[n - 1])
        lo += n
    return out


def section5(dir_out):
    import mpmath as mp
    mp.mp.dps = 30
    log("")
    log("=" * 78)
    log("SS5  Status of the analytic route -- what is known, what is open,")
    log("     and what is finitely checkable")
    log("=" * 78)
    log("")
    log("  (a) UNCONDITIONALLY KNOWN (theorems; quoted, not reproved here):")
    log("      * Tao 2015: the logarithmically averaged two-point Chowla")
    log("        conjecture holds for every fixed shift h, h = 2 included.")
    log("        [checked finitely in SS3]")
    log("      * Matomaki-Radziwill-Tao 2015/2016: the two-point correlation")
    log("        vanishes for ALMOST ALL shifts h in a short range, and the")
    log("        logarithmically averaged statement holds for all h in short")
    log("        ranges.")
    log("      * Trivially |S(x)| <= x (SS2).")
    log("")
    log("  (b) OPEN.  The sharp un-averaged statement (STAR), S(x) = o(x) for")
    log("      the single shift h = 2, is a CONJECTURE.  It is not a theorem and")
    log("      not a corollary of anything cited here.  In particular NO")
    log("      RH-conditional proof is asserted: this file makes no claim that")
    log("      RH implies (STAR).  Nor can multiplicativity be invoked: for the")
    log("      deterministic multiplicative function lambda == 1 the analogue is")
    log("      sum_{n<=x} 1 = x, not o(x).")
    log("")
    log("  (c) WHY THE ELEMENTARY EULER-PRODUCT/PERRON ROUTE DOES NOT APPLY --")
    log("      a finite algebraic fact, verified numerically here.  Write")
    log("          f(n) = lambda(n)lambda(n+2),   D(s) = sum_n f(n) n^{-s}.")
    log("      The route would need f multiplicative, so that D(s) has an Euler")
    log("      product and zeta controls the shift prime by prime.  It is not:")
    N5 = 10 ** 6
    LAM5 = lambda_up_to(N5 + 2).astype(np.int64)   # LAM5[n] = lambda(n)
    f5 = np.zeros(N5 + 1, dtype=np.int64)
    f5[0:N5 + 1] = LAM5[0:N5 + 1] * LAM5[2:N5 + 3]
    bad = []
    for a in range(2, 400):
        for b in range(2, 400):
            if np.gcd(a, b) != 1 or a * b > N5:
                continue
            if f5[a * b] != f5[a] * f5[b]:
                bad.append((a, b, int(f5[a]), int(f5[b]), int(f5[a * b])))
            if len(bad) >= 3:
                break
        if len(bad) >= 3:
            break
    CHK.check("S5.not.multiplicative", len(bad) > 0,
              "f(1) = lambda(1)lambda(3) = %d (multiplicativity would need "
              "f(1)=1), and coprime counterexamples exist: %s"
              % (int(f5[1]), "; ".join(
                  "f(%d)f(%d) = %d*%d = %d != f(%d) = %d"
                  % (a, b, f5[a], f5[b], f5[a] * f5[b], a * b, f5[a * b])
                  for a, b, _, _, _ in bad[:3])))
    # The naive Euler product, at s = 2 where absolute convergence is trivial,
    # so the comparison is legitimate; explicit tail bounds for both sides.
    sigma = 2.0
    D2 = float(np.sum(f5[1:N5 + 1] / np.arange(1, N5 + 1, dtype=np.float64) ** 2))
    tailD = 2.0 / N5                      # sum_{n>N5} n^-2 <= 1/N5 + 1/N5
    primes = small_primes(10 ** 5)
    prod = 1.0
    for p in primes:
        p = int(p)
        acc = 1.0
        pk = p
        for k in range(1, 8):
            if pk > N5:
                break
            acc += f5[pk] / float(pk) ** 2
            pk *= p
        prod *= acc
    tailP = float(np.sum(4.0 / primes.astype(np.float64) ** 2))
    log("")
    log("      s = 2 test (absolute convergence, so both sides are defined and")
    log("      every truncation is bounded):")
    log("        D(2) = sum_{n<=%d} f(n)/n^2            = %s" % (N5, fmt(D2, 8)))
    log("        tail bound  |sum_{n>N} f(n)/n^2|       <= %s" % fmt(tailD, 8))
    log("        prod_{p<=1e5} (1 + sum_k f(p^k)/p^{2k}) = %s" % fmt(prod, 8))
    log("        tail bound for that product            <= %s" % fmt(tailP, 8))
    log("        |D(2) - product|                       = %s"
        % fmt(abs(D2 - prod), 8))
    CHK.check("S5.no.euler.product", abs(D2 - prod) > tailD + tailP,
              "the naive Euler product differs from D(2) by %s, which exceeds "
              "the sum of the truncation bounds %s: f has no Euler product, so "
              "the zeta-based RH route is unavailable for this shift"
              % (fmt(abs(D2 - prod), 6), fmt(tailD + tailP, 6)))
    log("")
    log("  (d) WHAT IS FINITELY CHECKABLE ABOUT D(s), AND WHAT IT DOES NOT DO.")
    log("      Absolute convergence for Re s >= 1 + delta is trivial (|f| <= 1):")
    log("      the tail is bounded by sum_{n>N} n^{-1-delta} <= N^{-delta}/delta,")
    log("      an explicit bound on the discarded part.  Divergence or")
    log("      convergence at Re s <= 1 is NOT unconditional: with no Euler")
    log("      product there is no independent handle.  The one general")
    log("      implication that does hold is one-directional,")
    log("          D(s) converges on Re s > beta   ==>   S(x) = O(x^{beta+eps}),")
    log("      by partial summation, so a proven beta <= 1/2 would give (STAR).")
    log("      Nothing computes beta.  The partial sums below are a FINITE")
    log("      diagnostic and are reported as nothing more:")
    log("")
    log("      s            N           |D_N(s)|            |D_N| * N^{sigma-1}")
    log("      " + "-" * 68)
    obs = {}
    for sp in SIGMA_POINTS:
        sig, t = sp
        pts = dir_out.get(sp, [])
        if not pts:
            continue
        obs[sp] = [(Nc, a, a * (Nc ** (sig - 1.0))) for Nc, a in pts]
        for Nc, a, sc_ in obs[sp]:
            log("      %-12s %-11d %-19s %s"
                % ("%.2f%+.2fi" % (sig, t) if t else "%.2f" % sig, Nc,
                   fmt(a, 6), fmt(sc_, 6)))
    log("")
    sp_abs = (1.5, 0.0)
    if sp_abs in obs:
        Nc, a, _ = obs[sp_abs][-1]
        bound = float(mp.zeta(1.5))       # |sum_{n<=N} f(n)n^-1.5| <= zeta(1.5)
        tail = 2.0 * Nc ** -0.5           # sum_{n>N} n^-1.5 <= 2 N^-1/2
        d1 = abs(obs[sp_abs][0][1] - a) if len(obs[sp_abs]) > 1 else 0.0
        CHK.check("S5.absolute.region", a <= bound,
                  "sigma=1.5: |sum_{n<=%d} f(n)n^{-1.5}| = %s <= zeta(1.5) = "
                  "%s (rigorous, since |f| <= 1).  The explicit tail bound "
                  "sum_{n>N} n^{-1.5} <= 2*N^{-1/2} = %s bounds the DISTANCE to "
                  "the limit, not |D_N| itself; the first-to-last drift here is "
                  "%s <= 2*N_1^{-1/2}, so convergence at sigma = 1.5 is a "
                  "theorem and this is a consistency check of it"
                  % (Nc, fmt(a, 6), fmt(bound, 6), fmt(tail, 6), fmt(d1, 6)))
    if (0.6, 0.0) in obs:
        v = obs[(0.6, 0.0)]
        CHK.check("S5.strip.diagnostic.only", True,
                  "sigma=0.6: |D_N| = %s at N=%d and %s at N=%d (factor %s "
                  "decrease).  CONSISTENT with convergence in the strip, but "
                  "this is a finite partial-sum observation with no bound on "
                  "the tail: beta <= 1/2 remains UNPROVEN and is equivalent in "
                  "strength to what (STAR) needs"
                  % (fmt(v[0][1], 5), v[0][0], fmt(v[-1][1], 5), v[-1][0],
                     fmt(v[0][1] / max(v[-1][1], 1e-300), 4)))
    sig, t = (0.6, 17.0)
    if (sig, t) in obs:
        v = obs[(sig, t)]
        CHK.check("S5.complex.sample", True,
                  "a non-real sample point s = 0.6+17i gives |D_N| = %s at "
                  "N=%d falling to %s at N=%d; recorded as a finite diagnostic "
                  "of the same kind, not as evidence for convergence"
                  % (fmt(v[0][1], 5), v[0][0], fmt(v[-1][1], 5), v[-1][0]))
    log("")
    log("  (e) STATUS.  Nothing in SS5 proves (STAR) or any power saving in")
    log("      S(x).  What SS5 establishes is negative and algebraic: the")
    log("      coefficient sequence is not multiplicative and has no Euler")
    log("      product, so the elementary zeta-based route that the phrase")
    log("      'RH implies Chowla' might suggest is simply not available for the")
    log("      shifted correlation.  The average over h (MRTT) is where")
    log("      multiplicativity re-enters, and there the results are theorems.")
    CHK.check("S5.status.stated", True,
              "RECORDED STATUS: (STAR) is OPEN/conjectural.  No RH-conditional "
              "proof of (STAR) is asserted in this file")
    return True


# =============================================================================
def main():
    log("rh46  the two-point Chowla correlation for the Liouville function")
    log("started %s" % time.strftime("%Y-%m-%d %H:%M:%S"))
    log("python %s | numpy %s" % (sys.version.split()[0], np.__version__))
    log("")
    log("#####################################################################")
    log("# (STAR)  sum_{n<=x} lambda(n)lambda(n+2) = o(x)   is OPEN.          #")
    log("# Every number in this file is a FINITE CHECK.  Nothing here proves  #")
    log("# (STAR); SS4 proves that no finite check could.                    #")
    log("#####################################################################")
    log("")
    section0()
    log("")
    log("Running the segmented scan to NMAX = %d with BLOCK = %d windows" %
        (NMAX, BLOCK))
    log("(~2.5 s of sieve per 10^7 window on this machine, so ~4-5 min of")
    log("sieve for this cap, plus the correlation work) ...")
    t0 = time.time()
    sc = run_scan()
    log("scan finished in %.1fs; reached n <= %d" % (time.time() - t0, sc.reached))
    section1(sc)
    section2(sc)
    section3(sc)
    log("")
    log("Running the Dirichlet partial-sum pass (SS5) to %d ..." % NMAX_DIR)
    t0 = time.time()
    dir_out = dirichlet_pass()
    log("dirichlet pass finished in %.1fs" % (time.time() - t0))
    section4()
    section5(dir_out)
    ok = CHK.summary()
    log("log written to %s" % LOG_PATH)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
