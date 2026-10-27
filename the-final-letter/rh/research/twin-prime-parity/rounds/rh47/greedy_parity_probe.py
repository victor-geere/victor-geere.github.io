#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh47/greedy_parity_probe.py -- FIRST HONEST RECONNAISSANCE on the three
candidate bridges B1-B3 between the greedy harmonic sine (rh41/rh42) and the
parity problem for the twin-prime conjecture (rh46).

Run:   python3 -u rh47/greedy_parity_probe.py
       (stdout is also teed to verify/greedy_parity_probe.log)
Exit code 0 iff every check passes.

================================================================================
WHAT IS AND IS NOT CLAIMED HERE (read this first)
================================================================================
The stated goal of round rh47 is "use the greedy harmonic sine to solve the
parity problem for the twin prime conjecture".  THAT GOAL IS NOT ACHIEVED, and
NOTHING below is progress on it.  Nothing here proves, disproves, or approaches
the twin prime conjecture or the parity problem; every number is a FINITE CHECK
on finitely many rational targets.  The one logically exhaustive statement made
here is a NEGATIVE structural one, in SS1:

    the greedy support A(x) is Sylvester-sparse: if m_1 < m_2 < ... are its
    elements then m_{i+1} >= m_i(m_i - 1) + 1, so a support with 20 elements
    has its largest element >= s_20, a number with 106721 decimal digits.

Hence the "large support" regime in which SS2 was asked to look for a parity
signal contains no target whose support elements can be factored -- let alone a
target that carries a parity class.  SS2 therefore reports an EMPTY admissible
sample, and then runs the requested statistic on the largest computable
supports as a clearly labelled, threshold-relaxed diagnostic.  That diagnostic
produces a LARGE nominal deviation under the size-matched range control of the
specification; SS2 kills it with positional controls and reports the smallest
counterexample to its own finding.

The objects (all recomputed from the definitions, never taken on trust):

  * the greedy word.  x in (0,1), r_0 = x; at step n >= 0 take 1/(n+2) iff
    r_n >= 1/(n+2) and subtract, else skip.  Support A(x) = {n taken}, written
    as a subset of {2,3,4,...} via m = n+2.  Equivalently (this is what makes
    the exact computation cheap, and it is verified against a literal
    step-by-step simulation in SS1) the support is the greedy Egyptian
    expansion: m_1 = ceil(1/x), m_{i+1} = least m > m_i with 1/m <= r_i.
  * the signed (Tau) alphabet alpha_n = (-1)^n/(n+2)^p and the budgets
    P(p) = 2^{-p} zeta(p), N(p) = (1-2^{-p}) zeta(p) - 1 (rh42).
  * lambda(n) = (-1)^{Omega(n)}, Omega with multiplicity (rh46).

Precision policy.  Supports are computed in EXACT rational arithmetic
(Fraction); the reported supports are exact integers.  Lambda and the parity of
Omega for SS2/SS3/SS4 come from an exact prime-power sieve up to 10^7 and,
above that, from exact factorisation (Miller-Rabin + Pollard-Brent) of
individual support elements up to 10^13; no probabilistic surrogate is ever
used for lambda itself.  The only float64 quantities are the Dirichlet partial
sums of SS4, each reported with an explicit tail and rounding bound, and the
Monte-Carlo control means of SS2, whose resolution 1/R is stated.  zeta/eta
values are mpmath at 40 dps.
"""

from __future__ import annotations

import collections
import math
import os
import random
import sys
import time
from fractions import Fraction

import numpy as np
import mpmath as mp

try:                                    # Python >= 3.11
    sys.set_int_max_str_digits(0)       # s_20 has six figures of digits
except Exception:
    pass

T_START = time.time()
HERE = os.path.dirname(os.path.abspath(__file__))
LOG_PATH = os.path.join(HERE, "verify", "greedy_parity_probe.log")

# ---------------------------------------------------------------------------
# logging / checks
# ---------------------------------------------------------------------------


class _Tee:
    """stdout + log file, line buffered, so the log survives a crash."""

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
        log(line)
        return ok

    def summary(self):
        log()
        log("=" * 78)
        log("SUMMARY -- every check above is a FINITE CHECK on finitely many")
        log("rational targets.  None of them proves or disproves the twin prime")
        log("conjecture, the parity problem, or two-point Chowla.")
        log("=" * 78)
        for tag, label in self.labels:
            log("  [%s] %s" % (tag, label))
        log()
        log("-" * 78)
        log("%d checks pass, %d fail   (wall clock %.1fs)"
            % (self.n_pass, self.n_fail, time.time() - T_START))
        log("-" * 78)
        return self.n_fail == 0


CHK = Checks()

# ===========================================================================
# shared constants
# ===========================================================================
BMAX = 200              # SS1 sample A: all a/b with b <= BMAX
N_BIG = 400             # SS1 sample B: random rationals, b in [1e6, 1e12]
BIG_LO, BIG_HI = 10 ** 6, 10 ** 12
L_LAM = 10 ** 7         # exact lambda sieve bound (parity of Omega)
L_EXT = 10 ** 13        # element bound for exact factorisation (Pollard-Brent)
MIN_K = 4               # relaxed SS2 threshold (the spec asks for 20, see SS1)
EXCL = 20               # the specification's exclusion threshold
R_MC = 500              # Monte-Carlo size for per-target control p-values
SEED = 47

# Sylvester's sequence s_1 = 2, s_{i+1} = s_i(s_i - 1) + 1: the minimal
# possible chain of greedy denominators (proved in SS1).  Built only to s_21
# (s_22 already has ~4.3e5 digits); SS1 computes len(str(s_20)) = 106721 at run time.
SYL = [2]
for _ in range(20):
    SYL.append(SYL[-1] * (SYL[-1] - 1) + 1)


# ===========================================================================
# exact greedy support
# ===========================================================================
def greedy_support(p: int, q: int):
    """Exact support of the greedy word for x = p/q, 0 < p < q.

    Shortcut form: the least m with 1/m <= r is ceil(1/r) = ceil(v/u) for
    r = u/v, and every index strictly between is skipped (its term is too
    large).  So the support is built in O(|A|) exact Fraction operations.  The
    result is verified against the literal step-by-step rule in SS1.
    """
    r = Fraction(p, q)
    out = []
    m = 2
    while r > 0:
        u, v = r.numerator, r.denominator
        mm = -(-v // u)                 # ceil(1/r)
        if mm < m:
            mm = m
        out.append(mm)
        r -= Fraction(1, mm)
        m = mm + 1
    return out


def greedy_support_stepwise(p: int, q: int, cap: int):
    """The literal definition, integer arithmetic, no shortcut.

    Returns (support, terminated).  Independent of greedy_support(); used as
    the correctness control for it (capped, so only shallow targets).
    """
    out = []
    for n in range(cap):
        m = n + 2
        if p * m >= q:                  # r >= 1/m  <=>  p/q >= 1/m
            out.append(m)
            p = p * m - q
            q = q * m
            g = math.gcd(p, q)
            p //= g
            q //= g
            if p == 0:
                return out, True
    return out, False


# ===========================================================================
# lambda: exact, by sieve (<= L_LAM) and by factorisation (<= L_EXT)
# ===========================================================================
def sieve_lambda_omega(N):
    """(lam, ompar): lam[n] = (-1)^Omega(n), ompar[n] = Omega(n) mod 2.

    Exact: the parity of Omega is toggled once per prime power pk <= N
    dividing n.  Memory O(N) bytes; no float is involved.
    """
    comp = np.zeros(N + 1, dtype=bool)
    comp[:2] = True
    for i in range(2, int(N ** 0.5) + 1):
        if not comp[i]:
            comp[i * i::i] = True
    primes = np.nonzero(~comp)[0]
    ompar = np.zeros(N + 1, dtype=np.uint8)
    for p in primes:
        pk = int(p)
        while pk <= N:
            ompar[pk::pk] ^= 1
            pk *= int(p)
    lam = np.where(ompar == 0, 1, -1).astype(np.int8)
    lam[0] = 0
    return lam, ompar


_MR_BASES = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)


def is_prime(n: int) -> bool:
    """Deterministic Miller-Rabin for n < 3.3e24 (these bases suffice)."""
    if n < 2:
        return False
    for p in _MR_BASES:
        if n % p == 0:
            return n == p
    d = n - 1
    s = 0
    while d % 2 == 0:
        d //= 2
        s += 1
    for a in _MR_BASES:
        x = pow(a, d, n)
        if x == 1 or x == n - 1:
            continue
        for _ in range(s - 1):
            x = x * x % n
            if x == n - 1:
                break
        else:
            return False
    return True


def pollard_brent(n: int) -> int:
    """A non-trivial factor of composite n (Brent's variant)."""
    if n % 2 == 0:
        return 2
    while True:
        y = random.randrange(1, n)
        c = random.randrange(1, n)
        m = 128
        g = r = q = 1
        x = ys = y
        while g == 1:
            x = y
            for _ in range(r):
                y = (y * y + c) % n
            k = 0
            while k < r and g == 1:
                ys = y
                for _ in range(min(m, r - k)):
                    y = (y * y + c) % n
                    q = q * abs(x - y) % n
                g = math.gcd(q, n)
                k += m
            r *= 2
        if g == n:
            g = 1
            while g == 1:
                ys = (ys * ys + c) % n
                g = math.gcd(abs(x - ys), n)
        if g != n:
            return g


def build_small_primes(limit):
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return [int(p) for p in np.nonzero(s)[0]]


SMALL_PRIMES = build_small_primes(10 ** 4)


def factor_omega(n: int) -> int:
    """Omega(n) with multiplicity, exact, for n <= ~1e15 in practice."""
    cnt = 0
    for p in SMALL_PRIMES:
        if p * p > n:
            if n > 1:
                cnt += 1
            return cnt
        while n % p == 0:
            n //= p
            cnt += 1
        if n == 1:
            return cnt
    stack = [n]
    while stack:
        m = stack.pop()
        if m == 1:
            continue
        if is_prime(m):
            cnt += 1
            continue
        d = pollard_brent(m)
        stack.append(d)
        stack.append(m // d)
    return cnt


_LAM_MEMO = {}


def make_lam_at(lam):
    def lam_at(m: int) -> int:
        if m <= L_LAM:
            return int(lam[m])
        v = _LAM_MEMO.get(m)
        if v is None:
            v = 1 if factor_omega(m) % 2 == 0 else -1
            _LAM_MEMO[m] = v
        return v
    return lam_at


def _sign_stats(support, lam_at):
    signs = [lam_at(m) for m in support]
    k = len(signs)
    return k, sum(signs) / k, sum(1 for x in signs if x > 0), signs


# ===========================================================================
# SS1 -- the supports are non-trivial (control) and are Sylvester-sparse
# ===========================================================================
def section1():
    log("=" * 78)
    log("SS1  The greedy supports: sample, support-size distribution, and the")
    log("     exclusion rule (a control on the object, not on the twin primes)")
    log("=" * 78)
    log()
    log("  Definition of record.  x = p/q in (0,1), r_0 = x; at step n >= 0 take")
    log("  1/(n+2) iff r_n >= 1/(n+2), else skip.  A(x) = {m = n+2 : taken}.")
    log("  Exact computation: the least admissible m is ceil(1/r), so the")
    log("  support is the greedy Egyptian expansion of x; Fraction arithmetic")
    log("  throughout, and the shortcut is cross-checked against the literal")
    log("  step-by-step rule below.")
    log()

    # ---- correctness control: shortcut vs literal step-by-step -----------
    ver_targets = [(1, 2), (1, 3), (2, 3), (3, 4), (1, 5), (5, 6), (11, 12),
                   (19, 20), (4, 17), (3, 7)]
    ok_step = True
    step_msg = []
    for p, q in ver_targets:
        fast = greedy_support(p, q)
        slow, term = greedy_support_stepwise(p, q, cap=min(fast[-1] + 3, 4 * 10 ** 6))
        agree = term and fast == slow
        ok_step &= agree
        if (p, q) == (4, 17):
            step_msg.append("4/17: %s (last element %d)" % (fast, fast[-1]))
    CHK.check("S1.greedy.shortcut.equals.stepwise", ok_step,
              "the O(|A|) ceil-chain support equals the literal step-by-step "
              "simulation for %d targets, e.g. %s"
              % (len(ver_targets), "; ".join(step_msg)))
    log("  Controls: %s" % "; ".join(
        "%d/%d -> %s" % (p, q, greedy_support(p, q)) for p, q in ver_targets[:5]))
    log()

    # ---- sample A: all a/b with b <= BMAX --------------------------------
    A = []
    for b in range(2, BMAX + 1):
        for a in range(1, b):
            A.append((a, b, greedy_support(a, b)))
    # ---- sample B: random rationals with large denominators --------------
    rnd = random.Random(SEED)
    B = []
    for _ in range(N_BIG):
        b = rnd.randint(BIG_LO, BIG_HI)
        a = rnd.randint(1, b - 1)
        B.append((a, b, greedy_support(a, b)))

    # ---- the Sylvester ladder: an EXACT support of every size k <= 20 ----
    # x_k = 1 - 1/(s_{k+1} - 1) = (s_{k+1} - 2)/(s_{k+1} - 1) has support
    # exactly {s_1, ..., s_k}.  This exhibits the |A| >= 20 class explicitly
    # (so the exclusion rule is not excluding an empty class) and shows what
    # its elements cost.
    LAD = []
    for k in range(1, min(EXCL, len(SYL) - 1) + 1):
        p, q = SYL[k] - 2, SYL[k] - 1
        s = greedy_support(p, q)
        LAD.append((k, s, s == SYL[:k]))
    ok_lad = all(ok for _, _, ok in LAD)
    lad20 = [t for t in LAD if t[0] == EXCL][0]
    CHK.check("S1.sylvester.ladder.exact", ok_lad,
              "the ladder x_k = (s_{k+1}-2)/(s_{k+1}-1), k = 1..%d, has support "
              "EXACTLY {s_1,...,s_k} in every case (verified against the "
              "Sylvester prefix): an |A| = %d support exists, with max element "
              "s_%d of %d decimal digits"
              % (len(LAD), EXCL, EXCL, len(str(lad20[1][-1]))))

    # ---- rigidity: m_{i+1} >= m_i(m_i - 1) + 1 ---------------------------
    viol = 0
    pairs = 0
    for _, _, s in A + B + [(0, 0, t[1]) for t in LAD]:
        for x, y in zip(s, s[1:]):
            pairs += 1
            if y < x * (x - 1) + 1:
                viol += 1
    CHK.check("S1.rigidity.no.violations", viol == 0,
              "m_{i+1} >= m_i(m_i-1)+1 holds at all %d consecutive pairs of "
              "the %d computed supports (0 violations); the proof is the "
              "residual bound r' < 1/(m(m-1)) after taking 1/m" %
              (pairs, len(A) + len(B) + len(LAD)))

    # ---- distribution ----------------------------------------------------
    histA = collections.Counter(len(s) for _, _, s in A)
    histB = collections.Counter(len(s) for _, _, s in B)
    histExt = collections.Counter(len(s) for _, _, s in A + B if s[-1] <= L_EXT)
    log()
    log("  SAMPLE A: all x = a/b with 2 <= b <= %d           (%d targets)"
        % (BMAX, len(A)))
    log("  SAMPLE B: %d random x = a/b with b in [1e6, 1e12]   (%d targets)"
        % (N_BIG, len(B)))
    log()
    log("  support-size distribution (k = #A(x); 'ladder' = the exact")
    log("  Sylvester-ladder support x_k = (s_{k+1}-2)/(s_{k+1}-1)):")
    log("     k     count in A    count in B    count with max A <= 1e13   "
        "min possible max A (digits)   ladder?")
    log("     " + "-" * 105)
    for k in range(1, max(max(histA), max(histB), max(t[0] for t in LAD)) + 1):
        dig = len(str(SYL[k - 1])) if k - 1 < len(SYL) else -1
        lad = any(t[0] == k for t in LAD)
        log("     %-5d %-13d %-13d %-28d %-29d %s"
            % (k, histA.get(k, 0), histB.get(k, 0), histExt.get(k, 0), dig,
               "yes" if lad else "-"))
    mA = max(histA)
    mB = max(histB)
    mAA = [len(s) for _, _, s in A]
    log()
    log("     sample A: max support size %d;  mean %.3f"
        % (mA, float(np.mean(mAA))))
    log("     sample B: max support size %d" % mB)
    CHK.check("S1.distribution.reported", True,
              "sample A max |A| = %d, sample B max |A| = %d; the exact "
              "per-size counts are tabulated above" % (mA, mB))

    # ---- the specification's exclusion rule ------------------------------
    n_excl_A = sum(1 for _, _, s in A if len(s) >= EXCL)
    n_excl_B = sum(1 for _, _, s in B if len(s) >= EXCL)
    n_ge4 = sum(1 for _, _, s in A if len(s) >= MIN_K)
    log()
    log("  THE EXCLUSION RULE (as specified): drop supports with |A| < %d."
        % EXCL)
    log("     supports with |A| >= %d in A: %d   (so %.1f%% of A is dropped)"
        % (EXCL, n_excl_A, 100.0 * (1 - n_excl_A / len(A))))
    log("     supports with |A| >= %d in B: %d" % (EXCL, n_excl_B))
    log("     supports with |A| >= %d in A: %d  (the relaxation used in SS2)"
        % (MIN_K, n_ge4))
    CHK.check("S1.exclusion.threshold.20", n_excl_A == 0,
              "the specified threshold |A| >= %d admits 0 of the %d targets "
              "of sample A (max |A| = %d): the exclusion removes 100%% of a "
              "natural exact sample" % (EXCL, len(A), mA))

    # ---- why: the Sylvester ceiling --------------------------------------
    dig20 = len(str(SYL[EXCL - 1]))
    log()
    log("  WHY, AND IT IS NOT A SAMPLING ARTEFACT.  By the rigidity lemma,")
    log("  |A(x)| >= k forces max A(x) >= s_k, where s_1 = 2 and")
    log("  s_{i+1} = s_i(s_i - 1) + 1 (Sylvester's sequence).  Hence")
    log("     |A| >= %d  ==>  max A >= s_%d , a number with %d decimal digits"
        % (EXCL, EXCL, dig20))
    log("     (s_6 = %d, s_7 = %d has %d digits; s_8 has %d digits)."
        % (SYL[5], SYL[6], len(str(SYL[6])), len(str(SYL[7]))))
    log("  Computing lambda at such an element means factoring a %d-digit"
        % dig20)
    log("  integer.  The class of targets the specification asks SS2 to use is")
    log("  therefore EMPTY of objects whose parity class exists for us.")
    CHK.check("S1.sylvester.ceiling", dig20 > 10 ** 5,
              "|A(x)| >= %d implies max A(x) >= s_%d > 10^%d, so no admissible "
              "target can be constructed, let alone factored: the domain of "
              "the specified SS2 test is provably empty" %
              (EXCL, EXCL, dig20 - 1))
    n_big_all = (sum(1 for _, _, s in A + B if len(s) >= EXCL)
                 + sum(1 for t in LAD if t[0] >= EXCL))
    n_lam_ext = (sum(1 for _, _, s in A + B if len(s) >= EXCL and s[-1] <= L_EXT)
                 + sum(1 for t in LAD if t[0] >= EXCL and t[1][-1] <= L_EXT))
    CHK.check("S1.empty.computable.domain", n_lam_ext == 0,
              "the |A| >= %d size class is NON-EMPTY and is exhibited exactly "
              "by the Sylvester ladder (%d support of size %d, max element "
              "s_%d with %d digits); but %d of the %d supports built here "
              "(samples A+B plus the ladder) have |A| >= %d, and %d of those "
              "have max A <= 1e13.  Targets with an admissible support AND a "
              "computable parity class: %d" %
              (EXCL, n_big_all, EXCL, EXCL, dig20, n_big_all,
               len(A) + len(B) + len(LAD), EXCL, n_lam_ext, n_lam_ext))

    # ---- why small supports are degenerate (the trap) --------------------
    k1 = [s for _, _, s in A if len(s) == 1]
    log()
    log("  WHY SMALL SUPPORTS ARE DEGENERATE (the trap that was already hit):")
    log("  for |A| = 1 the support is {m_1} and any 'agreement statistic' with")
    log("  lambda is literally the single value lambda(m_1) = +/-1 -- a coin")
    log("  flip, no statistic.  For |A| = k the size-matched random set in the")
    log("  same range has sign-mean standard deviation ~ 1/sqrt(k), i.e. 0.71")
    log("  at k = 2 and 0.50 at k = 4; a per-target 'agreement' at these sizes")
    log("  is pure noise, and the pooled statistic is dominated by the one or")
    log("  two positions that nearly every such support shares (SS2 measures")
    log("  this).  Sample A has %d supports of size 1 and %d of size <= 3."
        % (len(k1), sum(1 for _, _, s in A if len(s) <= 3)))
    CHK.check("S1.small.supports.degenerate", len(k1) > 0,
              "%d of %d sample-A targets have a single-element support, where "
              "the 'parity statistic' degenerates to lambda of one integer"
              % (len(k1), len(A)))
    log()
    return A, B


# ===========================================================================
# SS2 -- the parity-signal test (bridge B1)
# ===========================================================================
def section2(A, B, lam, pref, lam_at):
    log("=" * 78)
    log("SS2  Bridge B1: does the greedy support predict the parity class of")
    log("     lambda?  The specification's test, and what is left of it")
    log("=" * 78)
    log()
    log("  THE EXPECTED NULL, STATED FIRST.  A(x) is a deterministic function")
    log("  of x alone and carries NO arithmetic input; lambda is multiplicative")
    log("  and A(x) is not defined multiplicatively.  There is no a priori")
    log("  reason for a signal, so a null result is the expectation; a positive")
    log("  result must survive a size-matched control.  A target is ADMISSIBLE")
    log("  only if (a) |A| >= %d and (b) every element of A is small enough to" % EXCL)
    log("  factor (here <= 1e13).  By SS1 no target satisfies both.")
    log()

    # ---- the admissible set (specification) ------------------------------
    adm = [(a, b, s) for (a, b, s) in A + B if len(s) >= EXCL and s[-1] <= L_EXT]
    CHK.check("S2.admissible.set.empty", len(adm) == 0,
              "admissible targets for the specified test (|A| >= %d and every "
              "element factorable): %d.  The test as specified CANNOT BE RUN; "
              "this is a statement about the object (SS1 rigidity), not about "
              "lambda" % (EXCL, len(adm)))
    log("  => The specified test has an EMPTY domain.  What follows is the")
    log("     threshold-relaxed diagnostic: |A| >= %d and every element <= 1e13." % MIN_K)
    log("     It is labelled everywhere as below the specified threshold and as")
    log("     a WEAK diagnostic.  Controls: C0 = the specification's size- and")
    log("     range-matched random set (exact lambda mean mu0, Monte-Carlo,")
    log("     resolution 1/%d); C1 = positional (sign-permutation) pool; C2 =" % R_MC)
    log("     rank-matched slot pool.  All statistics are in lambda-mean units")
    log("     (mean of lambda over A), related to N+/|A| by x -> 2x-1.")
    log()

    tierA = [(a, b, s) for (a, b, s) in A if len(s) >= MIN_K and s[-1] <= L_LAM]
    tierB = [(a, b, s) for (a, b, s) in A + B
             if len(s) >= MIN_K and L_LAM < s[-1] <= L_EXT]
    allt = tierA + tierB
    sizes = collections.Counter(len(s) for _, _, s in allt)
    log("  RELAXED SAMPLE: %d targets  (tier A, max A <= 1e7 and lambda from"
        % len(allt))
    log("  the exact sieve: %d;  tier B, 1e7 < max A <= 1e13 and lambda from"
        % len(tierA))
    log("  exact factorisation: %d).  size histogram: %s"
        % (len(tierB), sorted(sizes.items())))
    log("  Excluded from SS2 by the factorability rule: %d supports of"
        % (sum(1 for _, _, s in A + B if len(s) >= MIN_K and s[-1] > L_EXT)))
    log("  samples A+B have |A| >= %d but max A > 1e13." % MIN_K)
    CHK.check("S2.relaxed.sample", len(allt) > 1000,
              "the relaxed admissible sample has %d targets (|A| >= %d, all "
              "elements factorable), the largest with |A| = %d"
              % (len(allt), MIN_K, max(len(s) for _, _, s in allt)))

    rec = []
    for (a, b, s) in allt:
        k, smean, nplus, signs = _sign_stats(s, lam_at)
        rec.append(dict(a=a, b=b, s=s, k=k, smean=smean, nplus=nplus,
                        mmax=s[-1], m1=s[0]))

    # C0: the specification's control (tier A only: for max A > 1e7 random
    # lambda values are not available).
    za_num = 0.0
    za_var = 0.0
    pv_range = []
    for r in rec:
        if r["mmax"] > L_LAM:
            continue
        M = r["mmax"] - 1
        # exact mean of lambda on [2, max A]  ( = 2*density(+1) - 1 )
        mu0 = (int(pref[r["mmax"]]) - 1) / M
        r["mu0"] = mu0
        r["d_range"] = r["smean"] - mu0
        za_num += r["smean"] - mu0
        za_var += (1.0 / r["k"]) * (1.0 - mu0 * mu0) * (M - r["k"]) / (M - 1)
        draws = rng_integers(2, r["mmax"] + 1, (R_MC, r["k"]))
        ctrl = lam[draws].astype(np.float64).mean(axis=1)
        d0 = abs(r["smean"] - mu0)
        pv_range.append(float(np.mean(np.abs(ctrl - mu0) >= d0 - 1e-12)))
    z_range = za_num / math.sqrt(za_var) if za_var > 0 else 0.0
    p_range = math.erfc(abs(z_range) / math.sqrt(2.0))

    # C1: positional pool -- all support positions, occurrence-weighted.
    pool = np.concatenate([np.asarray(r["s"], dtype=np.int64) for r in rec])
    pool_signs = np.array([lam_at(int(m)) for m in pool], dtype=np.float64)
    mu_pool = float(pool_signs.mean())
    popvar_pool = float(((pool_signs - mu_pool) ** 2).mean())
    Np = len(pool)

    # C2: rank-matched slot pools.
    maxk = max(r["k"] for r in rec)
    slot_mu, slot_var, slot_n = [], [], []
    for j in range(maxk):
        vals = np.array([lam_at(r["s"][j]) for r in rec if r["k"] > j],
                        dtype=np.float64)
        slot_mu.append(float(vals.mean()))
        slot_var.append(float(((vals - vals.mean()) ** 2).mean()))
        slot_n.append(len(vals))

    z_pool_num = z_slot_num = 0.0
    z_pool_var = z_slot_var = 0.0
    pv_slot = []
    for r in rec:
        k = r["k"]
        r["d_pool"] = r["smean"] - mu_pool
        r["e_slot"] = sum(slot_mu[:k]) / k
        r["d_slot"] = r["smean"] - r["e_slot"]
        z_pool_num += r["d_pool"]
        z_pool_var += (1.0 / k) * popvar_pool * (Np - k) / (Np - 1)
        z_slot_num += r["d_slot"]
        z_slot_var += sum(slot_var[:k]) / (k * k)
        sd = math.sqrt(sum(slot_var[:k]) / (k * k))
        r["e_slot_std"] = r["d_slot"] / sd if sd > 0 else 0.0
        pv_slot.append(math.erfc(abs(r["e_slot_std"]) / math.sqrt(2.0)))
    z_pool = z_pool_num / math.sqrt(z_pool_var)
    z_slot = z_slot_num / math.sqrt(z_slot_var)
    p_pool = math.erfc(abs(z_pool) / math.sqrt(2.0))
    p_slot = math.erfc(abs(z_slot) / math.sqrt(2.0))

    # ---- per-size table --------------------------------------------------
    log()
    log("  per-size statistics of the relaxed sample (lambda-mean units):")
    log("     |A|   n     mean mean(lambda)   mean N+/|A|   mean C0 baseline")
    log("     " + "-" * 66)
    for k in sorted(sizes):
        sub = [r for r in rec if r["k"] == k]
        base = [r["mu0"] for r in sub if "mu0" in r]
        log("     %-5d %-5d %-17s %-15s %s"
            % (k, len(sub), fmt(np.mean([r["smean"] for r in sub]), 5),
               fmt(np.mean([r["nplus"] / r["k"] for r in sub]), 5),
               fmt(np.mean(base), 5) if base else "n/a (max A > 1e7)"))

    # ---- report the nominal (specification) signal -----------------------
    log()
    log("  (a) C0, THE SPECIFICATION'S SIZE-MATCHED RANGE CONTROL (tier A, %d"
        % len(pv_range))
    log("      targets).  For each target, B is a random |A|-subset of")
    log("      [2, max A]; the baseline mu0 is the exact mean of lambda on")
    log("      that range (equivalently 2*density(+1) - 1).")
    log("      mean lambda over A(x)                     : %s"
        % fmt(float(np.mean([r["smean"] for r in rec if "mu0" in r])), 6))
    log("      mean C0 baseline mu0 (range-matched set)  : %s"
        % fmt(float(np.mean([r["mu0"] for r in rec if "mu0" in r])), 6))
    log("      pooled z against C0 : %s   (two-sided p = %s)"
        % (fmt(z_range, 4), fmt(p_range, 3)))
    log("      mean per-target deviation : %s"
        % fmt(float(np.mean([r["d_range"] for r in rec if "mu0" in r])), 6))
    frac05r = float(np.mean([p < 0.05 for p in pv_range]))
    log("      per-target p < 0.05 : %.3f (nominal 0.05)" % frac05r)
    log("      A nominal signal IS present: the support's lambda-mean sits far")
    log("      below a size-matched random subset of the same range.")
    CHK.check("S2.nominal.signal.under.spec.control", z_range < -20.0,
              "under the control the specification asks for, the pooled "
              "deviation is z = %s (p = %s): a large NOMINAL signal, which "
              "must now be killed" % (fmt(z_range, 4), fmt(p_range, 3)))

    # ---- kill 1: positional pool ----------------------------------------
    log()
    log("  (b) KILL 1 -- positional (sign-permutation) control C1.  Keep the")
    log("      positions, permute the signs: draw B as a |A|-subset of the")
    log("      empirical pool of support positions (%d occurrences, %d distinct)."
        % (Np, len(set(int(m) for m in pool))))
    log("      pool sign-mean mu = %s   (observed support mean = %s)"
        % (fmt(mu_pool, 6), fmt(float(np.mean([r["smean"] for r in rec])), 6)))
    log("      pooled z against C1 : %s  (p = %s)"
        % (fmt(z_pool, 4), fmt(p_pool, 3)))
    CHK.check("S2.kill.positional.control", abs(z_pool) < 3.0,
              "the same statistic against a size-matched random subset of the "
              "empirical position pool gives z = %s (p = %s): the nominal "
              "signal is a POSITION-FREQUENCY effect, not a parity-class "
              "prediction" % (fmt(z_pool, 4), fmt(p_pool, 3)))

    # ---- kill 2: rank-matched slots --------------------------------------
    log()
    log("  (c) KILL 2 -- rank-matched slot control C2.  The j-th element m_j")
    log("      of a support is drawn from the pool of j-th elements; this")
    log("      matches the forced early chain (m_1 <= 7 whenever |A| >= 4 and")
    log("      max A <= 1e7, by the rigidity lemma).")
    for j in range(maxk):
        log("      slot %d: %5d occurrences, sign-mean %s"
            % (j + 1, slot_n[j], fmt(slot_mu[j], 4)))
    log("      pooled z against C2 : %s  (p = %s)"
        % (fmt(z_slot, 4), fmt(p_slot, 3)))
    frac05s = float(np.mean([p < 0.05 for p in pv_slot]))
    log("      per-target p < 0.05: %.3f (nominal 0.05)" % frac05s)
    CHK.check("S2.kill.slot.control", abs(z_slot) < 3.0,
              "against the rank-matched slot control the pooled deviation is "
              "z = %s (p = %s), and the per-target 5%% rejection rate is "
              "%.3f: no signal survives" % (fmt(z_slot, 4), fmt(p_slot, 3),
                                            frac05s))

    # ---- effective sample size / the real content ------------------------
    cnt = collections.Counter()
    for r in rec:
        for m in r["s"]:
            cnt[m] += 1
    top = cnt.most_common(8)
    log()
    log("  (d) WHY THE NOMINAL z IS MEANINGLESS.  The %d supports share" % len(rec))
    log("      positions: the 8 most frequent carry %d of the %d occurrences,"
        % (sum(v for _, v in top), Np))
    log("      and the deviation is a statement about lambda at a handful of")
    log("      fixed small integers:")
    for m, v in top:
        log("        m = %-14d lambda = %+d   in %d/%d supports (%.1f%%)"
            % (m, lam_at(m), v, len(rec), 100.0 * v / len(rec)))
    log("      Distinct positions: %d; the effective number of independent"
        % len(cnt))
    log("      lambda queries is far smaller than %d (the supports share" % len(rec))
    log("      positions), so the nominal normal p-value of (a) is optimistic.")
    CHK.check("S2.effective.sample.reported", True,
              "%d supports are built from only %d distinct positions; the "
              "single position m = %d occurs in %.1f%% of them, so the pooled "
              "statistic has a far smaller effective sample than its nominal n"
              % (len(rec), len(cnt), top[0][0], 100.0 * top[0][1] / len(rec)))

    # ---- smallest counterexample to our own finding ----------------------
    worst = max(rec, key=lambda r: abs(r.get("e_slot_std", 0.0)))
    n_cand = sum(1 for r in rec if abs(r["e_slot_std"]) >= 3.0)
    log()
    log("  (e) SMALLEST COUNTEREXAMPLE TO OUR OWN FINDING.  Our finding is")
    log("      'no signal survives the positional controls'.  The strongest")
    log("      counterexample available is the target with the largest")
    log("      slot-controlled residual:")
    log("        x = %d/%d, A(x) = %s" % (worst["a"], worst["b"], worst["s"]))
    log("        |A| = %d, mean lambda = %s, C2 baseline = %s, residual/sd = %s"
        % (worst["k"], fmt(worst["smean"], 4), fmt(worst["e_slot"], 4),
           fmt(worst["e_slot_std"], 3)))
    log("      targets with |residual/sd| >= 3: %d of %d (chance ~%.0f)"
        % (n_cand, len(rec), 0.0027 * len(rec)))
    CHK.check("S2.counterexample.reported", n_cand <= 0.01 * len(rec) + 5,
              "only %d of %d targets exceed 3 slot-controlled sd (chance "
              "expectation ~%.0f); the largest is x = %d/%d with residual/sd "
              "= %s, so the nominal signal is not rescued by any single target"
              % (n_cand, len(rec), 0.0027 * len(rec), worst["a"], worst["b"],
                 fmt(worst["e_slot_std"], 3)))

    log()
    log("  VERDICT B1: NO parity signal in the sense the bridge needs.  The")
    log("  large nominal deviation from the specification's range control is a")
    log("  position-frequency artifact (the rigidity forces tiny early chain")
    log("  elements), it is fully reproduced by the positional and rank-matched")
    log("  controls, and the only regime in which B1 could be tested")
    log("  non-trivially (|A| >= %d) contains no computable target." % EXCL)
    return dict(z_range=z_range, z_pool=z_pool, z_slot=z_slot,
                n_rec=len(rec), n_distinct=len(cnt), mu_pool=mu_pool)


_RNG = np.random.default_rng(SEED)


def rng_integers(lo, hi, shape):
    return _RNG.integers(lo, hi, size=shape)


# ===========================================================================
# SS3 -- bridge B2: the zeta budgets are INDEX-parity objects
# ===========================================================================
def section3(lam, ompar, pref):
    mp.mp.dps = 40
    log("=" * 78)
    log("SS3  Bridge B2: the rh42 budgets P(p), N(p) are index-parity objects")
    log("     (even/odd denominators), not Omega-parity objects")
    log("=" * 78)
    log()
    log("  P(p) = 2^-p zeta(p)         = sum_{k>=1} (2k)^-p        (even m)")
    log("  N(p) = (1-2^-p) zeta(p) - 1 = sum_{k>=2} (2k+1)^-p      (odd m >= 3)")
    log("  Both budgets are sums of a function of the DENOMINATOR alone: the")
    log("  split they see is the index parity 1_{n even}, nothing else.")
    log()
    K = 10 ** 5
    rows = []
    for p in ("1.5", "2", "3"):
        pf = mp.mpf(p)
        P = mp.power(2, -pf) * mp.zeta(pf)
        N = (1 - mp.power(2, -pf)) * mp.zeta(pf) - 1
        pk = np.float64(p)
        ks = np.arange(1, K + 1, dtype=np.float64)
        Pe = float(np.sum(np.power(2 * ks, -pk)))
        Po = float(np.sum(np.power(2 * ks + 1, -pk)))
        tail = (2 * K) ** (1 - float(p)) / (2 * (float(p) - 1))
        rows.append((p, P, N, Pe, Po, tail))
    for p, P, N, Pe, Po, tail in rows:
        log("  p = %-4s P = %s   N = %s"
            % (p, mp.nstr(P, 20), mp.nstr(N, 20)))
        log("          even sum_{k<=1e5} %s  |diff| = %s  tail <= %s"
            % (fmt(Pe, 10), fmt(abs(Pe - float(P)), 3), fmt(tail, 3)))
        log("          odd  sum_{k<=1e5} %s  |diff| = %s  tail <= %s"
            % (fmt(Po, 10), fmt(abs(Po - float(N)), 3), fmt(tail, 3)))
    ok_sum = all(abs(Pe - float(P)) <= tail + 1e-9
                 and abs(Po - float(N)) <= tail + 1e-9
                 for p, P, N, Pe, Po, tail in rows)
    CHK.check("S3.budgets.are.index.sums", ok_sum,
              "at p = 1.5, 2, 3 the budgets equal the EVEN-index and ODD-index "
              "partial sums within the explicit tails (K = 1e5): P is the "
              "even-denominator sum, N the odd-denominator sum >= 3")

    p2 = mp.mpf(2)
    P2 = mp.power(2, -p2) * mp.zeta(p2)
    N2 = (1 - mp.power(2, -p2)) * mp.zeta(p2) - 1
    id1 = P2 + N2 - (mp.zeta(p2) - 1)
    id2 = P2 - N2 - (1 - mp.altzeta(p2))
    log()
    log("  Identities of rh42 (mpmath, 40 dps):  P+N - (zeta-1)    = %s"
        % mp.nstr(abs(id1), 5))
    log("                                     P-N - (1 - eta(p)) = %s"
        % mp.nstr(abs(id2), 5))
    CHK.check("S3.budget.identities", abs(id1) < mp.mpf("1e-30")
              and abs(id2) < mp.mpf("1e-30"),
              "P+N = zeta-1 and P-N = 1-eta to better than 1e-30: the budgets "
              "are the two halves of the alternating alphabet, i.e. a split "
              "by index parity")

    # ---- the even/odd split of {n<=N} vs {Omega even} ---------------------
    N3 = L_LAM
    n = np.arange(1, N3 + 1, dtype=np.int64)
    idx_even = (n % 2 == 0)
    om_even = (ompar[1:N3 + 1] == 0)
    a11 = int(np.count_nonzero(idx_even & om_even))
    a10 = int(np.count_nonzero(idx_even & ~om_even))
    a01 = int(np.count_nonzero(~idx_even & om_even))
    a00 = int(np.count_nonzero(~idx_even & ~om_even))
    tot = a11 + a10 + a01 + a00
    e11 = (a11 + a10) * (a11 + a01) / tot
    e10 = (a11 + a10) * (a10 + a00) / tot
    e01 = (a01 + a00) * (a11 + a01) / tot
    e00 = (a01 + a00) * (a10 + a00) / tot
    chi2 = sum((o - e) ** 2 / e for o, e in ((a11, e11), (a10, e10),
                                             (a01, e01), (a00, e00)))
    var11 = tot * (a11 / tot) * (1 - a11 / tot)
    z11 = (a11 - e11) / math.sqrt(var11)
    alt = int(np.dot(lam[1:N3 + 1].astype(np.int64), np.where(idx_even, 1, -1)))
    log()
    log("  THE OVERLAP STATISTICS (exact, N = %d):" % N3)
    log("                        Omega even      Omega odd        total")
    log("      n even          %-15d %-15d %d" % (a11, a10, a11 + a10))
    log("      n odd           %-15d %-15d %d" % (a01, a00, a01 + a00))
    log("      total           %-15d %-15d %d" % (a11 + a01, a10 + a00, tot))
    log("      independence expectation of (n even, Omega even): %.1f" % e11)
    log("      chi-square (1 dof) = %s ;  z of that cell = %s"
        % (fmt(chi2, 4), fmt(z11, 4)))
    log("      #{n <= N : index parity != Omega parity} = %d = %.4f N"
        % (a10 + a01, (a10 + a01) / tot))
    log("      smallest disagreement with n >= 2: n = 2 (even index, Omega = 1)")
    log("      sum_{n<=N} lambda(n)(-1)^n = %d   (|.|/N = %s)"
        % (alt, fmt(abs(alt) / tot, 6)))
    CHK.check("S3.overlap.chance.level", chi2 < 25 and abs(z11) < 5,
              "the 2x2 table of index parity against Omega parity has "
              "chi-square = %s (z = %s for the (even, Omega even) cell): the "
              "index-parity split that the budgets measure is statistically "
              "independent of the Omega-parity class"
              % (fmt(chi2, 4), fmt(z11, 4)))
    CHK.check("S3.sets.differ", (a10 + a01) > 0.4 * tot,
              "%.4f of n <= %d have index parity different from Omega parity, "
              "e.g. n = 2: the budgets and lambda measure different partitions"
              % ((a10 + a01) / tot, N3))
    log()
    log("  VERDICT B2: the budgets separate even from odd DENOMINATORS.  The")
    log("  even/odd split of {n <= N} and the split {Omega even/odd} are")
    log("  chance-level related (chi-square %s), so B2 cannot carry parity"
        % fmt(chi2, 3))
    log("  information about Omega.")
    return dict(chi2=chi2, z11=z11, disagree=(a10 + a01) / tot)


# ===========================================================================
# SS4 -- bridge B3: the correlation is not multiplicative (no Euler product)
# ===========================================================================
def section4(lam):
    N4 = 10 ** 6
    log("=" * 78)
    log("SS4  Bridge B3: f(n) = lambda(n)lambda(n+2) is not multiplicative and")
    log("     D(s) = sum f(n) n^-s has no Euler product")
    log("=" * 78)
    log()
    f = np.zeros(N4 + 3, dtype=np.int64)
    f[1:N4 + 1] = lam[1:N4 + 1].astype(np.int64) * lam[3:N4 + 3].astype(np.int64)
    log("  f(1) = lambda(1)lambda(3) = %+d.  Multiplicativity requires f(1)=1,"
        % int(f[1]))
    log("  so the failure is immediate; the coprime pairs below make it concrete.")
    ex = []
    for (a, b) in [(2, 11), (2, 13), (2, 17), (3, 5)]:
        lhs = int(f[a]) * int(f[b])
        rhs = int(f[a * b])
        ex.append((a, b, int(f[a]), int(f[b]), lhs, a * b, rhs))
        log("    f(%d)f(%d) = (%+d)(%+d) = %+d   vs   f(%d) = %+d   %s"
            % (a, b, int(f[a]), int(f[b]), lhs, a * b, rhs,
               "DIFFER" if lhs != rhs else "agree"))
    bad = []
    for a in range(2, 201):
        for b in range(2, 201):
            if math.gcd(a, b) == 1 and a * b <= N4 and f[a * b] != f[a] * f[b]:
                bad.append((a, b))
    sm = min(bad, key=lambda ab: ab[0] * ab[1])
    CHK.check("S4.not.multiplicative", int(f[1]) != 1 and len(bad) > 0
              and ex[0][4] != ex[0][6] and ex[1][4] != ex[1][6],
              "f(1) = -1 != 1; f(2)f(11) = %+d != f(22) = %+d; f(2)f(13) = %+d "
              "!= f(26) = %+d; %d coprime pairs a,b <= 200 with ab <= 1e6 "
              "violate multiplicativity (smallest: a=%d, b=%d, ab=%d)"
              % (ex[0][4], ex[0][6], ex[1][4], ex[1][6], len(bad),
                 sm[0], sm[1], sm[0] * sm[1]))

    # ---- the naive Euler product at s = 2 ---------------------------------
    idx = np.arange(1, N4 + 1, dtype=np.float64)
    D2 = math.fsum(f[1:N4 + 1] / (idx * idx))
    comp = np.zeros(N4 + 1, dtype=bool)
    comp[:2] = True
    for i in range(2, int(N4 ** 0.5) + 1):
        if not comp[i]:
            comp[i * i::i] = True
    primes = np.nonzero(~comp)[0]
    P4 = 10 ** 5
    prod = 1.0
    for p in primes:
        p = int(p)
        if p > P4:
            break
        acc = 1.0
        pk = p
        while pk <= N4:
            acc += int(f[pk]) / float(pk) ** 2
            pk *= p
        prod *= acc
    tail_n = 2.0 / N4                                  # sum_{n>N} n^-2 <= 2/N
    tail_p = float(mp.zeta(2)) * (math.exp(1.0 / P4 + 1e-12) - 1.0)
    tail_k = 1e-9
    tail_tot = tail_n + tail_p + tail_k
    disc = abs(D2 - prod)
    log()
    log("  The naive multiplicative model: if f were multiplicative then")
    log("  D(2) = prod_p (1 + sum_k f(p^k) p^{-2k}) exactly.  At s = 2 the")
    log("  series converges absolutely, so every truncation is bounded:")
    log("    D(2)  = sum_{n<=%d} f(n)/n^2            = %s" % (N4, fmt(D2, 10)))
    log("    prod_{p<=%d, p^k<=%d} (...)            = %s" % (P4, N4, fmt(prod, 10)))
    log("    |D(2) - product|                       = %s" % fmt(disc, 10))
    log("    n-tail   |sum_{n>N} f(n)n^-2| <= 2/N   = %s" % fmt(tail_n, 4))
    log("    p-tail   <= zeta(2)(e^{1/P}-1)         = %s" % fmt(tail_p, 4))
    log("    k-tail   (inner sums truncated at N)   <= %s" % fmt(tail_k, 4))
    log("    rigorous total tail bound              = %s" % fmt(tail_tot, 4))
    log("    rh46's looser product bound            = 1.80898647")
    log("  The discrepancy exceeds the rigorous tail by a factor %.0f."
        % (disc / tail_tot))
    CHK.check("S4.no.euler.product", disc > tail_tot,
              "|D(2) - naive Euler product| = %s, which exceeds the rigorous "
              "truncation bound %s by a factor %.0f (rh46 reported the same "
              "discrepancy 2.01440934 against its looser bound): f has no "
              "Euler product, so no zeta/Perron route reaches the correlation"
              % (fmt(disc, 6), fmt(tail_tot, 6), disc / tail_tot))
    log()
    log("  VERDICT B3: no Euler product; the correlation is not multiplicative")
    log("  and the zeta-based machinery does not apply to it.")
    return dict(D2=D2, prod=prod, disc=disc, tail=tail_tot)


# ===========================================================================
# SS5 -- the honest verdict
# ===========================================================================
def section5(r2, r3, r4):
    log("=" * 78)
    log("SS5  THE HONEST VERDICT -- one table")
    log("=" * 78)
    log()
    log("  BRIDGE                                              VERDICT")
    log("  " + "-" * 70)
    log("  B1  greedy support predicts lambda's parity class   NO SIGNAL")
    log("      specification's size-matched range control     nominal z = %s"
        % fmt(r2["z_range"], 3))
    log("      positional (sign-permutation) control           z = %s"
        % fmt(r2["z_pool"], 3))
    log("      rank-matched slot control                       z = %s"
        % fmt(r2["z_slot"], 3))
    log("      specified domain |A| >= %d                     EMPTY (SS1)"
        % EXCL)
    log("  " + "-" * 70)
    log("  B2  zeta budgets carry Omega-parity                CHANCE-LEVEL")
    log("      overlap chi-square %s ; budgets split INDEX parity"
        % fmt(r3["chi2"], 3))
    log("  " + "-" * 70)
    log("  B3  greedy balance forces the correlation          NO EULER PRODUCT")
    log("      |D(2) - naive product| = %s > tail %s"
        % (fmt(r4["disc"], 4), fmt(r4["tail"], 2)))
    log("      f(2)f(11) != f(22), f(2)f(13) != f(26), f(1) != 1")
    log("  " + "-" * 70)
    log()
    log("  WHAT A GREEDY-SINE ATTACK WOULD NEED.  Every object of rh41-rh45 is")
    log("  additive in log n (the word depends on sin(2 pi theta), the budgets")
    log("  on sum n^{-p}, the balance on sum n^{-it}), while lambda is")
    log("  multiplicative and the correlation n -> lambda(n)lambda(n+2) is not")
    log("  even multiplicative (SS4).  An attack would need a map from a word")
    log("  determined by x alone to positive-density multiplicative information")
    log("  about Omega(n) -- and the greedy support is in addition")
    log("  Sylvester-sparse (SS1), so it cannot even be tested in the regime")
    log("  where such information could live.  That missing map is supplied by")
    log("  nothing in this programme.")
    log()
    log("  HONEST LEDGER.  No progress is claimed on the twin prime conjecture,")
    log("  on the parity problem, or on (STAR) sum_{n<=x} lambda(n)lambda(n+2)")
    log("  = o(x).  Every number above is a finite check; SS1's Sylvester")
    log("  ceiling is the only logically exhaustive statement, and it is a")
    log("  statement about the greedy object, not about the primes.")
    log()
    CHK.check("S5.verdict.table.printed", True,
              "the B1/B2/B3 verdict table is printed above")
    CHK.check("S5.no.progress.claimed", True,
              "RECORDED: no claim of progress on the twin prime conjecture, "
              "the parity problem, or two-point Chowla")


# ===========================================================================
def main():
    log("rh47  the greedy harmonic sine against the twin-prime parity problem")
    log("started %s" % time.strftime("%Y-%m-%d %H:%M:%S"))
    log("python %s | numpy %s | mpmath %s"
        % (sys.version.split()[0], np.__version__, mp.__version__))
    log()
    log("#####################################################################")
    log("# The round's stated goal -- 'use the greedy harmonic sine to solve  #")
    log("# the parity problem for the twin prime conjecture' -- IS NOT        #")
    log("# ACHIEVED.  Nothing below is progress on it.  Every number is a     #")
    log("# FINITE CHECK; the only exhaustive statement is the negative        #")
    log("# Sylvester-sparsity ceiling on the greedy support in SS1.           #")
    log("#####################################################################")
    log()
    A, B = section1()
    log("Building the exact lambda / Omega-parity sieve to %d ..." % L_LAM)
    t0 = time.time()
    lam, ompar = sieve_lambda_omega(L_LAM)
    pref = np.cumsum(lam.astype(np.int64))          # pref[m] = sum_{n<=m} lam
    log("sieve built in %.1fs" % (time.time() - t0))
    lam_at = make_lam_at(lam)
    log()
    r2 = section2(A, B, lam, pref, lam_at)
    r3 = section3(lam, ompar, pref)
    r4 = section4(lam)
    section5(r2, r3, r4)
    ok = CHK.summary()
    log("log written to %s" % LOG_PATH)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
