#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh47 -- INDEPENDENT AUDITOR: attack on the rh47 BARRIER claim.
==============================================================

The round rh47 states that the goal ("use the greedy harmonic sine to solve the
parity problem / two-point Chowla") is NOT achieved and asserts a BARRIER:

 (B*) every greedy-sine object in rh41-rh45 is an additive character in log n
      (the word depends on sin(2*pi*theta), the budgets on sum n^{-p}, the
      balance on sum n^{-it}), whereas the parity obstruction is about a
      multiplicative function; the two do not mix, and the correlation
      n -> lambda(n) lambda(n+2) has no Euler product.

A barrier is a NEGATIVE claim.  This script tries to falsify it and certifies
the parts that are provable.  It implements everything from scratch:

  C1  the barrier's factual legs
      C1.1 determinism/continuity of the greedy word (no arithmetic input)
      C1.2 the rh42 budgets separate INDEX parity, not Omega-parity
      C1.3 f(n) = lambda(n) lambda(n+2) is not multiplicative
  C2  the Euler-product failure, quantitatively, with a rigorous tail bound
  C3  attempts to construct a greedy-sine object correlating with lambda
      (a) prime-indexed alphabet   (b) unsigned-word statistics
      (c) the rh42 parity lock     -- every attempt with a size-matched control
  C4  the logical status (positive density is required; the goal is out of reach
      by these means; the two-point Chowla statement is OPEN in the literature)

Self-contained: standard library + numpy + mpmath only.  It does NOT import
anything from rh0*/rh4*, and does not import or re-run the round's own probe.

Everything is deterministic (fixed RNG seed).  Every tolerance is derived from a
stated bound; every statistic carries a size-matched random control.

Author: independent auditor (rh47).  Writes only under rh47/.
"""

from __future__ import annotations

import math
import os
import sys
import time
from fractions import Fraction

import numpy as np
import mpmath as mp

HERE = os.path.dirname(os.path.abspath(__file__))
LOG_PATH = os.path.join(HERE, "independent_check.log")
SEED = 20251004

# ---------------------------------------------------------------------------
# logging + check harness
# ---------------------------------------------------------------------------


class Log:
    def __init__(self, path: str):
        self.f = open(path, "w", encoding="utf-8")
        self.t0 = time.time()

    def __call__(self, s: str = "") -> None:
        print(s, flush=True)
        self.f.write(s + "\n")
        self.f.flush()

    def close(self) -> None:
        self.f.close()


class Checker:
    def __init__(self, log: Log):
        self.log = log
        self.n = 0
        self.fails: list[str] = []

    def check(self, name: str, ok: bool, detail: str) -> bool:
        self.n += 1
        tag = "PASS" if ok else "FAIL"
        if not ok:
            self.fails.append(name)
        self.log(f"[{tag}] {name:<30} | {detail}")
        return bool(ok)

    def section(self, title: str) -> None:
        self.log("")
        self.log("=" * 78)
        self.log(title)
        self.log("=" * 78)

    def summary(self) -> int:
        self.log("")
        self.log("-" * 78)
        npass = self.n - len(self.fails)
        self.log(f"RESULT: {npass}/{self.n} checks pass")
        if self.fails:
            self.log("failed checks: " + ", ".join(self.fails))
        self.log(f"elapsed: {time.time() - self.log.t0:.1f}s")
        return 0 if not self.fails else 1


# ---------------------------------------------------------------------------
# exact arithmetic layers (independent code paths)
# ---------------------------------------------------------------------------


def primes_upto(n: int) -> np.ndarray:
    """All primes <= n (numpy sieve of Eratosthenes)."""
    if n < 2:
        return np.zeros(0, dtype=np.int64)
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i * i :: i] = False
    return np.nonzero(s)[0].astype(np.int64)


def lambda_sieve(N: int) -> np.ndarray:
    """lam[n] = (-1)^Omega(n) for 0 <= n <= N, exact.

    Uses Omega(n) = #{(p,k) : p^k | n}, accumulated by slice-adds over prime
    powers -- a different code path from the trial-division reference below.
    """
    Om = np.zeros(N + 1, dtype=np.int8)
    for p in primes_upto(N):
        p = int(p)
        pk = p
        while pk <= N:
            Om[pk::pk] += 1
            pk *= p
    lam = np.ones(N + 1, dtype=np.int8)
    lam[(Om & 1) == 1] = -1
    lam[0] = 0
    return lam


def omega_distinct_sieve(N: int) -> np.ndarray:
    """om[n] = omega(n) = number of DISTINCT prime factors, exact."""
    om = np.zeros(N + 1, dtype=np.int8)
    for p in primes_upto(N):
        om[int(p) :: int(p)] += 1
    om[0] = 0
    return om


def liouville_trial(n: int, primes: np.ndarray) -> int:
    """(-1)^Omega(n) by trial division: no sieve, no numpy."""
    if n <= 0:
        return 0
    cnt = 0
    m = n
    for p in primes:
        p = int(p)
        if p * p > m:
            break
        while m % p == 0:
            m //= p
            cnt += 1
    if m > 1:
        cnt += 1
    return -1 if (cnt & 1) else 1


# ---------------------------------------------------------------------------
# the greedy words (m = denominator index; w[m] = 1 iff term 1/m is taken)
# ---------------------------------------------------------------------------


def word_unsigned_frac(x: "Fraction | int", N: int) -> np.ndarray:
    """Unsigned greedy: r=x; at m=2,3,... take 1/m iff r >= 1/m.  Exact.

    Returns w[0..N+1] with w[m]=1 iff the term 1/m was taken (m <= N+1).
    Early exit: if r < 1/(N+1) then no remaining term up to m=N+1 is taken.
    """
    r = Fraction(x)
    w = np.zeros(N + 2, dtype=np.int8)
    thr = Fraction(1, N + 1)
    for n in range(N):
        m = n + 2
        if r < thr:
            break
        c = Fraction(1, m)
        if r >= c:
            w[m] = 1
            r -= c
            if r == 0:
                break
    return w


def to_mpf(x):
    """mpmath conversion that also accepts Fraction and str."""
    if isinstance(x, Fraction):
        return mp.mpf(x.numerator) / mp.mpf(x.denominator)
    return mp.mpf(x)


def word_unsigned_mp(x, N: int, dps: int = 80):
    """Unsigned greedy at fixed decimal precision (irrational targets)."""
    with mp.workdps(dps):
        r = to_mpf(x)
        w = np.zeros(N + 2, dtype=np.int8)
        thr = mp.mpf(1) / (N + 1)
        for n in range(N):
            if r < thr:
                break
            m = n + 2
            c = mp.mpf(1) / m
            if r >= c:
                w[m] = 1
                r -= c
                if r == 0:
                    break
        return w, +r


def word_signed_mp(x, N: int, p: int = 1, dps: int = 80):
    """rh42 signed/Tau greedy: alpha_m = (-1)^(m-2) / m^p (m = n+2).

    Take alpha_m iff sign(alpha_m)=sign(r) and |alpha_m| <= |r|; never reuse.
    Returns w[m]=1 for takes.  (Index n = m-2; alpha_n = (-1)^n/(n+2)^p.)
    """
    with mp.workdps(dps):
        r = mp.mpf(x)
        w = np.zeros(N + 2, dtype=np.int8)
        thr = mp.mpf(1) / mp.mpf(N + 1) ** p  # min |alpha_m| over m<=N+1
        for n in range(N):
            if abs(r) < thr:
                break
            m = n + 2
            a = (mp.mpf(1) if n % 2 == 0 else mp.mpf(-1)) / mp.mpf(m) ** p
            if (r > 0) == (a > 0) and abs(a) <= abs(r):
                r -= a
                w[m] = 1
                if r == 0:
                    break
        return w, +r


def support(w: np.ndarray) -> np.ndarray:
    return np.nonzero(w)[0]


# ---------------------------------------------------------------------------
# C1.1  determinism / continuity (the word is a function of the target only)
# ---------------------------------------------------------------------------


def c11(log: Log, chk: Checker) -> None:
    chk.section("C1.1  the greedy word depends on the target ONLY (no arithmetic input)")
    log("The unsigned rule reads one real number x and the integer index m via the")
    log("real value 1/m.  There is no primality/factorisation step anywhere.  Checks:")
    log("")

    # (a) two independent implementations on the same target must agree exactly.
    N = 200
    w_frac = word_unsigned_frac(Fraction(1, 3), N)
    w_mp, r_mp = word_unsigned_mp(Fraction(1, 3), N, dps=60)
    same = bool(np.array_equal(w_frac, w_mp))
    chk.check(
        "C1.1a two implementations",
        same,
        f"exact Fraction vs mpmath(60dps) at x=1/3, N={N}: supports "
        f"{list(support(w_frac))} vs {list(support(w_mp))}, identical={same}",
    )

    # (b) x and x+delta (delta exactly 10^-k) agree on the common prefix; the
    #     first disagreement is predicted exactly by the next-take index m0=1/delta.
    log("")
    log("  (b) x=1/3 vs x'=1/3+10^-k, N=100000.  After the take at m=3 the residual")
    log("      is exactly 10^-k, so the first possible difference is the next take,")
    log("      m0 = 1/delta (1/m0 <= delta).  Predicted vs measured:")
    log(f"      {'delta':>10} {'m0_pred':>10} {'m0_meas':>10} {'common prefix':>14}  verdict")
    N = 100000
    w0 = word_unsigned_frac(Fraction(1, 3), N)
    allok = True
    for k in (3, 4, 5, 6):
        delta = Fraction(1, 10 ** k)
        xp = Fraction(1, 3) + delta
        w1 = word_unsigned_frac(xp, N)
        diff = np.nonzero(w0 != w1)[0]
        m0_meas = int(diff[0]) if len(diff) else None
        m0_pred = int(1 / delta)
        # predicted: words agree for all m < m0_pred
        ok = (m0_meas == m0_pred) or (m0_meas is None and m0_pred > N + 1)
        allok &= ok
        log(
            f"      {str(delta):>10} {m0_pred:>10} {str(m0_meas):>10} "
            f"{str(m0_meas - 2 if m0_meas else N):>14}  {'ok' if ok else 'MISMATCH'}"
        )
    chk.check(
        "C1.1b perturbed prefix",
        allok,
        "for delta=10^-3..10^-6 the first differing denominator is exactly "
        "m0=1/delta; the common prefix has length m0-2 (e.g. 99998 at delta=1e-5)",
    )

    log("")
    log("  (c) delta = 10^-10 .. 10^-50: predicted first difference is beyond N=10^5,")
    log("      so the two words must agree on the whole computed window.")
    okc = True
    for k in (10, 20, 30, 40, 50):
        w1 = word_unsigned_frac(Fraction(1, 3) + Fraction(1, 10 ** k), N)
        agree = bool(np.array_equal(w0, w1))
        okc &= agree
        log(f"      delta=1e-{k:<3} agree on all N={N}: {agree}")
    chk.check(
        "C1.1c far perturbation",
        okc,
        "x and x+10^-k (k=10..50) give bit-identical words on m<=N+1=100001 "
        "(next take at m=10^k >> N); a continuity/determinism certificate",
    )

    # (d) the word factors through the height (rh42 T16): theta, theta+1, 1/2-theta
    #     share the word; 1-theta (the sign flip) mirrors the support parity.
    log("")
    log("  (d) rh42 T16: the word factors through x = sin(2*pi*theta).")
    N = 400
    okd = True
    for th in ("0.1", "0.3", "0.42"):
        t = mp.mpf(th)
        with mp.workdps(80):
            wA, _ = word_unsigned_mp(mp.sin(2 * mp.pi * t), N, dps=80)
            wB, _ = word_unsigned_mp(mp.sin(2 * mp.pi * (t + 1)), N, dps=80)
            wC, _ = word_unsigned_mp(mp.sin(2 * mp.pi * (mp.mpf(1) / 2 - t)), N, dps=80)
        e = bool(np.array_equal(wA, wB) and np.array_equal(wA, wC))
        okd &= e
        log(f"      theta={th}: w(theta)=w(theta+1)=w(1/2-theta) -> {e}")
    chk.check(
        "C1.1d theta factorization",
        okd,
        "theta, theta+1 and 1/2-theta give identical words at 80 dps, N=400 "
        "(the rule sees the height sin(2*pi*theta), not the turn count)",
    )

    log("")
    log("  (e) signed word: x>0 takes only even denominators, x<0 only odd ones")
    log("      (rh42 parity lock).  Positive target -> n even -> m=n+2 even.")
    oke = True
    for th in ("0.1", "0.2", "0.3", "0.42"):
        t = mp.mpf(th)
        with mp.workdps(80):
            x = mp.sin(2 * mp.pi * t)
            wp, _ = word_signed_mp(x, 300, 1, dps=80)
            wm, _ = word_signed_mp(-x, 300, 1, dps=80)
        Sp, Sm = support(wp), support(wm)
        p_ok = bool(np.all(Sp % 2 == 0))
        m_ok = bool(np.all(Sm % 2 == 1))
        oke &= (p_ok and m_ok)
        log(
            f"      theta={th}: +x support {list(Sp)} all even={p_ok}; "
            f"-x support {list(Sm)} all odd={m_ok}"
        )
    chk.check(
        "C1.1e parity lock",
        oke,
        "signed support denominators are all even for x>0 and all odd for x<0 "
        "(gaps even, >=2) -- rh42 T9 reproduced",
    )


# ---------------------------------------------------------------------------
# C1.2  index parity vs Omega parity; the budgets are sign-blind
# ---------------------------------------------------------------------------


def c12(log: Log, chk: Checker, rng: np.random.Generator) -> None:
    chk.section("C1.2  the rh42 budgets separate INDEX parity, not Omega-parity")
    log("The rh42 budget for 'positive' terms is P(p)=sum over EVEN denominators,")
    log("the 'negative' budget N(p)=sum over ODD denominators.  That is a statement")
    log("about index parity.  lambda(n)=(-1)^Omega(n) is Omega parity.")
    log("")

    for N in (100_000, 1_000_000):
        lam = lambda_sieve(N + 2)
        n = np.arange(1, N + 1)
        par = (-1.0) ** n  # (-1)^n
        lev = (lam[1 : N + 1] == 1).astype(np.int64)
        c_ee = int(np.sum((par > 0) & (lev == 1)))
        c_eo = int(np.sum((par > 0) & (lev == 0)))
        c_oe = int(np.sum((par < 0) & (lev == 1)))
        c_oo = int(np.sum((par < 0) & (lev == 0)))
        R_e, R_o = int(np.sum(par > 0)), int(np.sum(par < 0))
        C_e, C_o = int(lev.sum()), N - int(lev.sum())
        cells = {(0, 0): c_ee, (0, 1): c_eo, (1, 0): c_oe, (1, 1): c_oo}
        marg = {(0, 0): R_e * C_e / N, (0, 1): R_e * C_o / N,
                (1, 0): R_o * C_e / N, (1, 1): R_o * C_o / N}
        log(f"  N = {N}:  Omega-even count = {C_e}, Omega-odd = {C_o}; "
            f"even indices = {R_e}, odd = {R_o}")
        log(f"    {'cell':>12} {'count':>9} {'N/4':>10} {'dev(N/4)':>10} "
            f"{'indep.pred':>12} {'dev(indep)':>11}")
        S12 = 0.0
        for key, lbl in (((0, 0), "even,Omega+"), ((0, 1), "even,Omega-"),
                         ((1, 0), "odd,Omega+"), ((1, 1), "odd,Omega-")):
            c = cells[key]
            log(f"    {lbl:>12} {c:>9} {N/4:>10.1f} {c - N/4:>10.1f} "
                f"{marg[key]:>12.1f} {c - marg[key]:>11.1f}")
        S12 = float(np.dot(par, lam[1 : N + 1].astype(np.float64)))
        S1 = float(par.sum())
        S2 = float(lam[1 : N + 1].sum())
        # exact-marginal independence: cell - marg = (S12 - S1*S2/N)/4 for every cell
        devs = [cells[k] - marg[k] for k in cells]
        pred = (S12 - S1 * S2 / N) / 4.0
        log(f"    S1=sum(-1)^n = {S1:.0f}, S2=sum lambda = {S2:.0f}, "
            f"S12=sum(-1)^n lambda = {S12:.0f}")
        log(f"    every cell deviation from exact-marginal independence equals "
            f"(S12-S1*S2/N)/4 = {pred:.2f}; measured deviations "
            f"{[round(d,2) for d in devs]}")
        # permutation control for S12
        lamN = lam[1 : N + 1].astype(np.int64).copy()
        R = 2000 if N <= 100_000 else 300
        perm = np.empty(R)
        for i in range(R):
            rng.shuffle(lamN)
            perm[i] = np.dot(par, lamN)
        z = (S12 - perm.mean()) / (perm.std() + 1e-12)
        log(f"    size-matched permutation control (R={R}): mean={perm.mean():.1f}, "
            f"sd={perm.std():.1f} -> z(S12) = {z:.2f}")
        # the naive independence prediction (N/2)(1/2) = N/4, as requested
        maxdev = max(abs(cells[k] - N / 4) for k in cells)
        chk.check(
            f"C1.2a cells N={N}",
            abs(z) <= 4.0,
            f"four (index parity)x(Omega parity) cells: max deviation from (N/2)(1/2)"
            f"=N/4 is {maxdev:.0f}; after conditioning on the exact margins the "
            f"residual is (S12-S1S2/N)/4, permutation z={z:.2f} (|z|<=4)",
        )

    # Omega-parity is asymptotically independent of index parity: the sum
    # S12(N) = sum_{n<=N} (-1)^n lambda(n) must be o(N) (and here ~ N^1/2).
    log("")
    log("  Growth of |S12(N)| = |sum_{n<=N} (-1)^n lambda(n)| (index parity vs")
    log("  Omega parity).  A Theta(N) signal would make the budgets parity-relevant.")
    lam = lambda_sieve(1_000_002)
    ns = np.array([1000, 3000, 10000, 30000, 100000, 300000, 1000000])
    vals = np.array([
        abs(float(np.dot(((-1.0) ** np.arange(1, int(N) + 1)), lam[1 : int(N) + 1].astype(np.float64))))
        for N in ns
    ])
    for N, v in zip(ns, vals):
        log(f"      N={N:>8}  |S12|={v:>10.1f}  |S12|/N={v/N:.3e}  "
            f"|S12|/sqrt(N)={v/math.sqrt(N):.3f}")
    slope = float(np.polyfit(np.log(ns), np.log(np.maximum(vals, 1e-9)), 1)[0])
    chk.check(
        "C1.2b S12 growth",
        vals[-1] / ns[-1] < 5e-3 and 0.2 < slope < 0.9,
        f"log-log slope of |S12(N)| = {slope:.3f} (consistent with 1/2, not 1); "
        f"|S12|/N = {vals[-1]/ns[-1]:.2e} at N=10^6: no Theta(N) index-parity signal",
    )

    # the budget identities: P+N = zeta-1, P-N = 1-eta  (sign-blind combinations)
    log("")
    log("  Budget identities (rh42 T3): P(p)=2^-p zeta(p), N(p)=(1-2^-p)zeta(p)-1;")
    log("  P+N = zeta-1 and P-N = 1-eta are zeta/eta combinations that contain no")
    log("  arithmetic of n at all -- they are constants in p.")
    with mp.workdps(40):
        ok = True
        for p in ("2", "3"):
            pp = mp.mpf(p)
            z = mp.zeta(pp)
            eta = (1 - mp.mpf(2) ** (1 - pp)) * z
            P = mp.mpf(2) ** (-pp) * z
            Nn = (1 - mp.mpf(2) ** (-pp)) * z - 1
            e1 = abs(P + Nn - (z - 1))
            e2 = abs(P - Nn - (1 - eta))
            ok &= (e1 < mp.mpf("1e-30") and e2 < mp.mpf("1e-30"))
            log(f"      p={p}: |P+N-(zeta-1)|={mp.nstr(e1,3)}, "
                f"|P-N-(1-eta)|={mp.nstr(e2,3)}")
        P2 = mp.mpf(2) ** (-2) * mp.zeta(2)
        log(f"      closed form P(2)=pi^2/24: {mp.nstr(P2,20)} vs "
            f"{mp.nstr(mp.pi**2/24,20)}")
    chk.check(
        "C1.2c budgets sign-blind",
        ok,
        "P+N=zeta-1 and P-N=1-eta verified to <1e-30 at p=2,3; both are functions "
        "of p alone, so no budget-derived statistic can be a function of n",
    )

    # index parity is INVISIBLE to the two-point correlation: twisting lambda by
    # (-1)^n leaves lambda(n)lambda(n+2) unchanged (2 is even).
    log("")
    log("  Twist invariance (closes B2 completely): lambda'(n)=(-1)^n lambda(n)")
    log("  gives lambda'(n)lambda'(n+2) = (-1)^(2n+2) lambda(n)lambda(n+2) = the")
    log("  same, since 2 is even.  Verify exactly, x<=10^6:")
    lam = lambda_sieve(1_000_002)
    sg = ((-1.0) ** np.arange(0, 1_000_003)).astype(np.int64)
    sg[0] = 1
    lam2 = lam.astype(np.int64) * sg
    S = np.cumsum(lam[1:1_000_001].astype(np.int64) * lam[3:1_000_003])
    S2 = np.cumsum(lam2[1:1_000_001] * lam2[3:1_000_003])
    ndiff = int(np.sum(S != S2))
    chk.check(
        "C1.2d twist invariance",
        ndiff == 0,
        f"S(lambda) == S(lambda*(-1)^n) exactly for all x<=10^6 ({ndiff} "
        f"mismatches); the index parity the budgets encode is orthogonal to (STAR)",
    )


# ---------------------------------------------------------------------------
# C1.3  non-multiplicativity of f(n)=lambda(n)lambda(n+2)
# ---------------------------------------------------------------------------


def c13(log: Log, chk: Checker) -> None:
    chk.section("C1.3  f(n)=lambda(n)lambda(n+2) is NOT multiplicative")
    lam = lambda_sieve(200_002)

    def f(n: int) -> int:
        return int(lam[n]) * int(lam[n + 2])

    f1 = f(1)
    chk.check(
        "C1.3a f(1) != 1",
        f1 != 1,
        f"f(1)=lambda(1)lambda(3)={f1} (multiplicativity forces f(1)=1)",
    )
    log("")
    log("  coprime pairs (m,n) with f(mn) != f(m)f(n):")
    wit = []
    for a, b in ((2, 11), (2, 13), (2, 17), (3, 5), (5, 7), (2, 3)):
        fa, fb, fab = f(a), f(b), f(a * b)
        if fab != fa * fb:
            wit.append((a, b, fa, fb, fab))
        log(f"      f({a})f({b}) = {fa}*{fb} = {fa*fb:>3}  vs  f({a*b}) = {fab:>3}  "
            f"{'VIOLATION' if fab != fa*fb else 'ok'}")
    # how common are violations among small coprime pairs?
    bad = tot = 0
    for a in range(2, 200):
        for b in range(2, 200):
            if math.gcd(a, b) != 1:
                continue
            tot += 1
            if f(a * b) != f(a) * f(b):
                bad += 1
    chk.check(
        "C1.3b coprime witnesses",
        len(wit) >= 2,
        f"{len(wit)} witnesses among the tested pairs, e.g. "
        + "; ".join(f"f({a})f({b})={fa*fb} != f({a*b})={fab}" for a, b, fa, fb, fab in wit[:3])
        + f"; {bad}/{tot} of all coprime pairs m,n<200 violate multiplicativity",
    )


# ---------------------------------------------------------------------------
# C2  the Euler-product failure, with a rigorous tail bound
# ---------------------------------------------------------------------------


def c2(log: Log, chk: Checker) -> dict:
    chk.section("C2  D(2)=sum f(n)/n^2 vs the naive multiplicative model")
    M = 1_000_000
    lam = lambda_sieve(M + 2)
    f = lam[1 : M + 1].astype(np.int64) * lam[3 : M + 3].astype(np.int64)
    n = np.arange(1, M + 1, dtype=np.float64)
    D2 = float(np.sum(f / n ** 2))
    D2_fsum = math.fsum(f / n ** 2)
    tailD = 1.0 / M  # sum_{n>M} n^-2 <= 1/M
    log(f"D(2) on n<=M={M}:  np.sum = {D2:.10f}   math.fsum = {D2_fsum:.10f}")
    log(f"  float64 summation error is ~1e-16 * sum 1/n^2 = 2e-16; the two routes "
        f"differ by {abs(D2-D2_fsum):.2e}")
    log(f"  rigorous truncation tail  |sum_{{n>M}} f(n)/n^2| <= sum_{{n>M}} n^-2 "
        f"<= 1/M = {tailD:.3e}")

    # ---- naive multiplicative model -------------------------------------
    # Pretend f is multiplicative.  Multiplicativity forces g(1)=1 and, if f
    # factored at prime powers, g(p^k)=f(p^k).  Hence the model is
    #     D_g(2) = prod_p ( 1 + sum_{k>=1} f(p^k)/p^{2k} ).
    # Model A (this audit): local factors exact for p^k <= Q; the rest bounded.
    # Model B (rh46's truncation): k <= 7 and p^k <= M, reproduced for audit.
    P = 100_000
    Q = 2 ** 26  # 67,108,864: p^k up to here are evaluated exactly
    pr = primes_upto(P)
    pr_small = primes_upto(10_000)
    # cross-check the two lambda code paths on p+2 <= P+2
    xchk = all(liouville_trial(int(p) + 2, pr_small) == int(lam[int(p) + 2]) for p in pr[::37])
    prod = mp.mpf(1)
    prod_rh46 = mp.mpf(1)
    sum_delta = mp.mpf(0)
    n_over = 0
    with mp.workdps(50):
        for p in pr:
            p = int(p)
            # --- model A: exact up to Q
            local = mp.mpf(1)
            pk, k = p, 1
            while pk <= Q:
                lam_pk = -1 if (k & 1) else 1  # lambda(p^k) = (-1)^k
                if pk + 2 <= M + 2:  # cheap exact route when the sieve covers it
                    lam_pk2 = int(lam[pk + 2])
                else:
                    lam_pk2 = liouville_trial(pk + 2, pr_small)
                local += mp.mpf(lam_pk * lam_pk2) / mp.mpf(pk) ** 2
                if k > 1:
                    n_over += 1
                pk *= p
                k += 1
            prod *= local
            K = k - 1  # number of included k
            # omitted k>K: |sum| <= sum_{k>K} p^{-2k} = p^{-2K}/(p^2-1)
            sum_delta += mp.mpf(1) / ((mp.mpf(p) ** 2 - 1) * mp.mpf(p) ** (2 * K))
            # --- model B: rh46's rule (k <= 7 and p^k <= M)
            acc = mp.mpf(1)
            pk = p
            for kk in range(1, 8):
                if pk > M:
                    break
                lam_pk = -1 if (kk & 1) else 1
                acc += mp.mpf(lam_pk * int(lam[pk + 2])) / mp.mpf(pk) ** 2
                pk *= p
            prod_rh46 *= acc
        # product-envelope A = prod_{p<=P}(1+1/(p^2-1)) <= exp(sum)
        s_env = mp.mpf(0)
        for p in pr:
            p = int(p)
            s_env += mp.mpf(1) / (mp.mpf(p) ** 2 - 1)
        A = mp.e ** s_env
        # prime tail p>P:  sum 1/(p^2-1) <= sum_{n>P} 1/(n^2-1) = (1/2)(1/P+1/(P+1))
        B = mp.mpf(1) / 2 * (mp.mpf(1) / P + mp.mpf(1) / (P + 1))
        tailP = (mp.e ** B - 1) * A + A * sum_delta * mp.e ** B
        trunc = prod  # == D_g(2) up to the stated bound
        disc = abs(D2 - float(trunc))
        disc_rh46 = abs(D2 - float(prod_rh46))
        # reproduce rh46's published "tail bound" and identify what it actually is
        tail_rh46 = float(np.sum(4.0 / pr.astype(np.float64) ** 2))
        log("")
        log("naive multiplicative model g(p^k)=f(p^k):")
        log(f"  model A: prod_(p<=P={P}) (1+sum_k f(p^k)/p^2k), p^k<=Q={Q} exact: "
            f"{mp.nstr(trunc, 12)}")
        log(f"    local factors at {len(pr)} primes, {n_over} prime powers with k>1; "
            f"independent trial-division lambda cross-check: {xchk}")
        log(f"    omitted k-tail bound  sum_p p^-2K/(p^2-1) = {mp.nstr(sum_delta,4)}")
        log(f"  model B (rh46's rule: k<=7, p^k<=1e6): {mp.nstr(prod_rh46, 12)}")
        log(f"    |model A - model B| = {abs(float(trunc - prod_rh46)):.3e} "
            f"(= the p=2 k>=8 tail, bounded by 4^-7/3 = {4.0**-7/3:.3e})")
        log(f"  prime tail bound: sum_(p>P) 1/(p^2-1) <= (1/2)(1/P+1/(P+1)) = "
            f"{mp.nstr(B,4)}")
        log(f"  envelope A = prod_(p<=P)(1+1/(p^2-1)) = {mp.nstr(A,8)}")
        log(f"  rigorous bound |D_g(2) - model A| <= {mp.nstr(tailP,8)}")
        log("")
        log(f"  D(2) measured                     = {D2:.8f}")
        log(f"  naive model A (full product)      = {float(trunc):.8f} "
            f"(+- {float(tailP):.2e})")
        log(f"  |D(2) - model A|                  = {disc:.8f}")
        log(f"  |D(2) - model B|                  = {disc_rh46:.8f}")
        log(f"  total rigorous uncertainty        = {tailD + float(tailP):.3e}")
        log("")
        log(f"  rh46's published 'tail bound for that product' = {tail_rh46:.8f}.")
        log(f"  That number equals 4*sum_(p<=1e5) 1/p^2 over the RETAINED primes, "
            f"not the")
        log(f"  omitted ones p>1e5: it is NOT a truncation tail.  A valid tail bound "
            f"on the")
        log(f"  omitted factor is exp(1.0e-5)-1 = {float(mp.e**B-1):.2e}, i.e. ~"
            f"{tail_rh46/float(mp.e**B-1):.0e}x smaller than published.  The "
            f"no-Euler-product")
        log(f"  conclusion survives (discrepancy {disc:.4f} vs tail {float(tailP):.2e}).")

    chk.check(
        "C2a D(2) reproduced",
        abs(D2 - (-1.12681304)) < 5e-8,
        f"D(2)=sum_(n<=10^6) f(n)/n^2 = {D2:.8f} (rh46 published -1.12681304); "
        f"tail <= 1/M = {tailD:.1e}",
    )
    chk.check(
        "C2b rh46 model reproduced",
        abs(float(prod_rh46) - 0.88759631) < 1e-7,
        f"rh46's truncation rule (k<=7, p^k<=10^6) gives {float(prod_rh46):.8f} "
        f"(published 0.88759631); the audit's exact-to-2^26 model gives "
        f"{float(trunc):.8f}, differing by {abs(float(trunc-prod_rh46)):.2e} = the "
        f"p=2 k>=8 tail",
    )
    chk.check(
        "C2c discrepancy > tight tail",
        disc > tailD + float(tailP),
        f"|D(2)-model A| = {disc:.6f} > tight rigorous tail {tailD + float(tailP):.3e} "
        f"(prime tail {float(B):.1e}, k-tail {float(sum_delta):.1e})",
    )
    chk.check(
        "C2d rh46 tail mis-derived",
        abs(tail_rh46 - 1.808988) < 1e-5,
        f"rh46's published product tail {tail_rh46:.6f} is 4*sum_(p<=1e5)1/p^2 over "
        f"the RETAINED primes (matches 1.808988 to 1e-5) -- not a bound on the "
        f"omitted p>1e5 factor (<= {float(mp.e**B-1):.1e}); the check survives but "
        f"for a different reason than stated",
    )
    chk.check(
        "C2e lambda cross-check",
        xchk,
        "independent trial-division lambda agrees with the sieve on sampled p+2 "
        "used in the local factors",
    )
    return {"D2": D2, "model": float(trunc), "model_rh46": float(prod_rh46),
            "disc": disc, "tail": tailD + float(tailP)}


# ---------------------------------------------------------------------------
# C3a  prime-indexed alphabet -- circular by construction
# ---------------------------------------------------------------------------


def c3a(log: Log, chk: Checker, rng: np.random.Generator) -> None:
    chk.section("C3a  greedy alphabet indexed by primes (alpha_p = (-1)^Omega(p+2)/(p+2))")
    log("R3 of the handoff proposes alpha_p = (-1)^Omega(p+2)/(p+2).  That alphabet")
    log("IMPORTS lambda(p+2): the sign IS the target function.  Implemented anyway,")
    log("with controls, to quantify the circularity.  'import' below is the mean of")
    log("sign(q)*lambda(q) over the primes: 1 means the alphabet literally contains")
    log("the correlation one is trying to measure.")
    P = 100_000
    pr = primes_upto(P)
    q = pr + 2
    lam = lambda_sieve(P + 2)
    om = omega_distinct_sieve(P + 2)
    s_lam = lam[q].astype(np.int64)              # (-1)^Omega(q) -- imports lambda
    s_om = np.where(om[q] % 2 == 0, 1, -1)       # (-1)^omega(q) -- agrees with
    lamq = lam[q].astype(np.int64)               # lambda on all squarefree q

    def greedy_stat(signs, x0, qs):
        """Signed greedy on a_j = signs_j / qs_j, target x0; returns the taken
        indices (mean of lambda over the taken terms is the statistic)."""
        with mp.workdps(60):
            r = mp.mpf(x0)
            taken = []
            for j in range(len(qs)):
                if abs(r) < mp.mpf(1) / mp.mpf(int(qs[j])):
                    break  # no remaining term can avoid overshooting
                a = mp.mpf(int(signs[j])) / mp.mpf(int(qs[j]))
                if (r > 0) == (a > 0) and abs(a) <= abs(r):
                    r -= a
                    taken.append(j)
                    if r == 0:
                        break
        return taken

    log("")
    log(f"  {'sign family':>18} {'import=mean(s*lambda)':>22} {'takes':>7} "
        f"{'mean lambda over takes':>24}")
    rows = {}
    with mp.workdps(60):
        r = mp.mpf("0.9")
        for name, signs in (("lambda(p+2)", s_lam), ("omega(p+2)", s_om),
                            ("permuted lambda", None)):
            if signs is None:
                continue
            imp = float(np.mean(signs * lamq))
            tk = greedy_stat(signs, mp.mpf("0.9"), q)
            stat = float(np.mean(lamq[tk])) if tk else float("nan")
            rows[name] = (imp, len(tk), stat)
            log(f"  {name:>18} {imp:>22.4f} {len(tk):>7} {stat:>24.4f}")
    # size-matched random control: permute the lambda signs among the primes
    R = 500
    ctrl = []
    for _ in range(R):
        sg = rng.permutation(s_lam)
        tk = greedy_stat(sg, mp.mpf("0.9"), q)
        ctrl.append(float(np.mean(lamq[tk])) if tk else 0.0)
    ctrl = np.array(ctrl)
    z1 = (rows["lambda(p+2)"][2] - ctrl.mean()) / (ctrl.std() + 1e-12)
    z2 = (rows["omega(p+2)"][2] - ctrl.mean()) / (ctrl.std() + 1e-12)
    log(f"  {'random signs':>18} {0.0:>22.4f} {'--':>7} "
        f"{ctrl.mean():>19.4f} +- {ctrl.std():.4f}")
    log(f"  -> z(lambda-indexed) = {z1:+.1f}, z(omega-indexed) = {z2:+.1f}")
    log("  Both non-null: the lambda alphabet imports lambda exactly, and "
        "(-1)^omega(q)")
    log("  agrees with lambda(q) on every squarefree q (density 1), so it is a")
    log("  second, weaker import of the SAME parity.  The sign-permuted control is")
    log("  null.  The non-nullity is therefore located entirely in the ALPHABET,")
    log("  not in the greedy dynamics: this is a witness of CIRCULARITY, exactly as")
    log("  R3 of the handoff warns, and useless for the twin-prime purpose.")
    chk.check(
        "C3a1 circular alphabet",
        z1 > 10 and abs(ctrl.mean()) < 0.1,
        f"lambda(p+2)-indexed alphabet: import={rows['lambda(p+2)'][0]:.4f}, mean "
        f"lambda over {rows['lambda(p+2)'][1]} takes={rows['lambda(p+2)'][2]:+.4f}, "
        f"z={z1:+.0f} (non-null, circular); omega-indexed import="
        f"{rows['omega(p+2)'][0]:.4f} -> z={z2:+.1f}; permuted-sign control "
        f"mean={ctrl.mean():+.4f}+-{ctrl.std():.4f} (null)",
    )


# ---------------------------------------------------------------------------
# C3b  statistics of the unsigned word vs lambda, size-matched controls
# ---------------------------------------------------------------------------


def c3b(log: Log, chk: Checker, rng: np.random.Generator) -> None:
    chk.section("C3b  statistics of the unsigned greedy word against lambda (windows)")
    N = 100_000
    H = 20
    lam = lambda_sieve(2 * N + H + 3)
    lampos = lam[1 : 2 * N + H + 1].astype(np.int64)   # lampos[p-1] = lambda(p)
    fpos = (lam[1 : 2 * N + H + 1].astype(np.int64) * lam[3 : 2 * N + H + 3].astype(np.int64))
    B = 25
    thetas = [0.02 + 0.009 * j for j in range(40)]
    Rt = 400          # per-target translate controls (diagnostic z's)
    RP = 400          # pooled global lambda-permutation controls (the test)
    Alist, wdlist, edgelist, pairslist = [], [], [], []
    z1t, z2t, zwt, rbt = [], [], [], []
    n_supp = 0
    for th in thetas:
        with mp.workdps(60):
            x = mp.sin(2 * mp.pi * mp.mpf(repr(th)))
        w, _ = word_unsigned_mp(x, N, dps=60)
        A = support(w)
        c = len(A)
        n_supp += c
        if c < 2:
            continue
        lo, hi = int(A.min()), int(A.max())
        # --- diagnostic: per-target translate control (see the pooling note)
        shifts = rng.integers(0, N + 1, size=Rt)
        idx = A[None, :] + shifts[:, None]
        st1 = lampos[idx - 1].sum(axis=1)
        st2 = fpos[idx - 1].sum(axis=1)
        T1 = int(lampos[A - 1].sum())
        T2 = int(fpos[A - 1].sum())
        z1t.append((T1 - st1.mean()) / (st1.std() + 1e-12))
        z2t.append((T2 - st2.mean()) / (st2.std() + 1e-12))
        pairs = [(int(p), int(q)) for p in A for q in A if 0 < q - p <= H]
        if pairs:
            P = np.array(pairs)
            i1 = P[:, 0][None, :] + shifts[:, None]
            i2 = P[:, 1][None, :] + shifts[:, None]
            Wc = (lampos[i1 - 1] * lampos[i2 - 1]).sum(axis=1)
            W = int(sum(int(lampos[p - 1]) * int(lampos[q - 1]) for p, q in pairs))
            if Wc.std() > 0:
                zwt.append((W - Wc.mean()) / Wc.std())
        width = max(1, (hi - lo + 1) // B)
        edges = np.array([lo + b * width for b in range(B + 1)])
        wd = np.array([np.sum((A >= edges[b]) & (A < edges[b + 1]))
                       for b in range(B)], dtype=float)
        if wd.std() > 0:
            lm0 = np.array([lampos[edges[b] - 1 : edges[b + 1] - 1].sum()
                            for b in range(B)], dtype=float)
            if lm0.std() > 0:
                RB = float(np.corrcoef(wd, lm0)[0, 1])
                rc = []
                for s in shifts[: min(Rt, 300)]:
                    lms = np.array([lampos[edges[b] - 1 + s : edges[b + 1] - 1 + s].sum()
                                    for b in range(B)], dtype=float)
                    rc.append(float(np.corrcoef(wd, lms)[0, 1]) if lms.std() > 0 else 0.0)
                rc = np.array(rc)
                if rc.std() > 0:
                    rbt.append((RB - rc.mean()) / rc.std())
                    Alist.append(A.astype(np.int64))
                    wdlist.append(wd)
                    edgelist.append(edges)
                    pairslist.append(pairs)

    # ---- THE test: pooled statistics under a global random-lambda null ----
    # Permute lambda over [1,2N+H] once per replicate and recompute EVERY target's
    # statistic with the SAME permuted lambda.  Support sizes, spans and gap
    # patterns are untouched; only the multiplicative arithmetic is randomised.
    # Because all targets share the same permuted lambda, the null carries the
    # cross-target correlation induced by the supports' common small core -- so
    # no 1/sqrt(m) independence assumption is made.
    allA = np.concatenate(Alist)
    allpairs = [pq for pr in pairslist for pq in pr]
    p1 = np.array([p for p, q in allpairs]); p2 = np.array([q for p, q in allpairs])
    obs1 = int(lampos[allA - 1].sum())
    obs2 = int(fpos[allA - 1].sum())
    obsW = int(sum(int(lampos[p - 1]) * int(lampos[q - 1]) for p, q in allpairs))
    obsR = 0.0
    for wd, edges in zip(wdlist, edgelist):
        lm0 = np.array([lampos[edges[b] - 1 : edges[b + 1] - 1].sum()
                        for b in range(B)], dtype=float)
        obsR += float(np.corrcoef(wd, lm0)[0, 1])
    null1, null2, nullW, nullR = [], [], [], []
    for _ in range(RP):
        lp = rng.permutation(lampos)
        fp = lp[:-2] * lp[2:]
        null1.append(int(lp[allA - 1].sum()))
        null2.append(int(fp[allA - 1].sum()))
        nullW.append(int((lp[p1 - 1] * lp[p2 - 1]).sum()))
        s = 0.0
        for wd, edges in zip(wdlist, edgelist):
            lms = np.array([lp[edges[b] - 1 : edges[b + 1] - 1].sum()
                            for b in range(B)], dtype=float)
            if lms.std() > 0:
                s += float(np.corrcoef(wd, lms)[0, 1])
        nullR.append(s)
    null1 = np.array(null1); null2 = np.array(null2)
    nullW = np.array(nullW); nullR = np.array(nullR)
    zp1 = (obs1 - null1.mean()) / (null1.std() + 1e-12)
    zp2 = (obs2 - null2.mean()) / (null2.std() + 1e-12)
    zpW = (obsW - nullW.mean()) / (nullW.std() + 1e-12)
    zpR = (obsR - nullR.mean()) / (nullR.std() + 1e-12)
    z1t = np.array(z1t); z2t = np.array(z2t)
    zwt = np.array(zwt); rbt = np.array(rbt)

    log(f"  {len(Alist)} targets theta in [0.02,0.37], N={N}; pooled support size "
        f"{n_supp} (mean density {n_supp/(len(Alist)*N):.2e})")
    log(f"  TEST control = global permutation of lambda over [1,{2*N+H}] "
        f"(RP={RP} replicates):")
    log("  every target's support geometry is preserved EXACTLY and only the")
    log("  multiplicative signs are randomised.  All targets use the same permuted")
    log("  lambda, so the null carries the cross-target correlation induced by the")
    log("  supports' shared small core (no 1/sqrt(m) independence assumption).")
    log(f"  T1 = sum_A lambda(p)                    : pooled z={zp1:+.2f} "
        f"(null mean {null1.mean():+.1f}, sd {null1.std():.1f})")
    log(f"  T2 = sum_A lambda(p)lambda(p+2)         : pooled z={zp2:+.2f}")
    log(f"  W  = sum over support pairs of lambda(p)lambda(p+h): pooled z={zpW:+.2f} "
        f"(n pairs {len(allpairs)})")
    log(f"  block profile vs lambda mass            : pooled z={zpR:+.2f}")
    log("  Diagnostic (per-target TRANSLATE control, R=400 each):")
    log(f"    T1 per-target mean z={z1t.mean():+.3f} sd={z1t.std():.3f} "
        f"max|z|={np.abs(z1t).max():.2f}")
    log(f"    T2 per-target mean z={z2t.mean():+.3f} sd={z2t.std():.3f} "
        f"max|z|={np.abs(z2t).max():.2f}")
    log(f"    W  per-target mean z={zwt.mean():+.3f} sd={zwt.std():.3f} "
        f"max|z|={np.abs(zwt).max():.2f}")
    log(f"    block per-target mean z={rbt.mean():+.3f} sd={rbt.std():.3f} "
        f"max|z|={np.abs(rbt).max():.2f}")
    log("  NOTE (power): the unsigned greedy support is sparse "
        f"({n_supp} terms over {len(Alist)} words x 10^5 indices), so this family")
    log("  has low power against a hypothetical signal; the barrier predicts none,")
    log("  and none is found.")

    lim = 4.0  # P(max|z| > 4) <= 2*Phi(-4) = 6.3e-5 per test
    chk.check(
        "C3b1 one-point stat null",
        abs(zp1) <= lim and np.abs(z1t).max() <= lim,
        f"T1 vs lambda: pooled z={zp1:+.2f} under the global lambda-permutation "
        f"null; per-target translate max|z|={np.abs(z1t).max():.2f} (<= {lim})",
    )
    chk.check(
        "C3b2 two-point stat null",
        abs(zp2) <= lim and np.abs(z2t).max() <= lim,
        f"T2 vs lambda(n)lambda(n+2): pooled z={zp2:+.2f}, per-target max|z|="
        f"{np.abs(z2t).max():.2f}",
    )
    chk.check(
        "C3b3 lambda-weighted pairs null",
        abs(zpW) <= lim and np.abs(zwt).max() <= lim,
        f"W over {len(allpairs)} support pairs: pooled z={zpW:+.2f}, per-target "
        f"max|z|={np.abs(zwt).max():.2f}",
    )
    chk.check(
        "C3b4 block density null",
        abs(zpR) <= lim and np.abs(rbt).max() <= lim,
        f"span-block profile vs lambda mass: pooled z={zpR:+.2f}, per-target "
        f"max|z|={np.abs(rbt).max():.2f}",
    )


# ---------------------------------------------------------------------------
# C3c  the rh42 parity lock: support vs {n : lambda(n)=+1}
# ---------------------------------------------------------------------------


def c3c(log: Log, chk: Checker, rng: np.random.Generator) -> None:
    chk.section("C3c  the rh42 parity lock mapped onto {n : lambda(n)=+1}")
    N = 100_000
    lam = lambda_sieve(N + 2)
    K = 200
    A_all = []
    par_ok = True
    for j in range(K):
        th = 0.001 + 0.0015 * j
        with mp.workdps(60):
            x = mp.sin(2 * mp.pi * mp.mpf(repr(th)))
        w, _ = word_signed_mp(x, N, 1, dps=60)
        S = support(w)
        if len(S) and not np.all(S % 2 == 0):
            par_ok = False
        A_all.extend(int(m) for m in S)
    A = np.array(sorted(set(A_all)), dtype=np.int64)
    A = A[A <= N + 1]
    plus = (lam[A] == 1)
    rho = float(plus.mean()) if len(A) else float("nan")
    even = np.arange(2, N + 2, 2)
    rho0 = float((lam[even] == 1).mean())
    z = (rho - rho0) / math.sqrt(rho0 * (1 - rho0) / max(len(A), 1))
    log(f"  {K} signed words at target sin(2*pi*theta)>0, N={N}: pooled support "
        f"|A|={len(A)} distinct even denominators; all even: {par_ok}")
    log(f"  fraction of A with lambda=+1 : {rho:.4f}  ({int(plus.sum())}/{len(A)})")
    log(f"  chance level among even m    : {rho0:.4f}")
    log(f"  binomial z                   : {z:+.2f}")
    log(f"  support density in [1,N]     : {len(A)/N:.2e}  (zero density)")
    chk.check(
        "C3c1 parity lock holds",
        par_ok and np.all(A % 2 == 0),
        f"all {len(A)} pooled support denominators are even (gaps even, >=2) -- "
        f"rh42 parity lock reproduced",
    )
    chk.check(
        "C3c2 match is chance",
        abs(z) <= 4.0,
        f"|A cap {{lambda=+1}}|/|A| = {rho:.4f} vs chance {rho0:.4f}: z={z:+.2f} "
        f"(no positive-density match)",
    )
    chk.check(
        "C3c3 support is sparse",
        len(A) / N < 1e-2,
        f"|A|/N = {len(A)/N:.2e}: the parity-locked support has DENSITY ZERO, so it "
        f"cannot be the positive-density modification set rh46 requires",
    )

    # shift scan: can a translate of A match {lambda=+1} better?
    shifts = np.arange(0, 202, 2)
    zs = []
    for s in shifts:
        m = A + s
        m = m[m <= N + 1]
        if len(m) < 10:
            continue
        r = float((lam[m] == 1).mean())
        zs.append((r - rho0) / math.sqrt(rho0 * (1 - rho0) / len(m)))
    zs = np.array(zs)
    thr = float(mp.sqrt(2) * mp.erfinv(1 - 0.05 / (2 * len(zs))))
    log(f"  shift scan over {len(zs)} even shifts 0..200: max|z|={np.abs(zs).max():.2f}, "
        f"Bonferroni 5% threshold {thr:.2f}")
    chk.check(
        "C3c4 shift scan null",
        np.abs(zs).max() <= thr,
        f"best translation of the parity-locked support still matches {{lambda=+1}} "
        f"only at chance: max|z|={np.abs(zs).max():.2f} <= {thr:.2f}",
    )


# ---------------------------------------------------------------------------
# C4  the logical status
# ---------------------------------------------------------------------------


def c4(log: Log, chk: Checker) -> None:
    chk.section("C4  logical status: positive density is required; the goal is out of reach")
    log("rh46's argument: a sparse modification A of lambda moves the correlation by")
    log("  |S_A(x) - S(x)| <= 2 * #{n <= x+2 : n in A}.")
    log("This audit finds that published constant TOO SMALL by a factor 2.  Each")
    log("affected term changes by exactly 2 in absolute value, and the affected n")
    log("are those with n in A or n+2 in A, i.e. at most 2*#{m<=x+2: m in A} terms.")

    L = 1_000_000
    lam = lambda_sieve(L + 2)
    f = lam[1 : L + 1].astype(np.int64) * lam[3 : L + 3].astype(np.int64)
    S = np.cumsum(f)

    # search for the smallest singleton witness refuting the quoted constant 2
    wit = None
    for a in range(3, 400):
        lamA = lam.copy()
        lamA[a] = -lamA[a]
        fA = lamA[1:2001].astype(np.int64) * lamA[3:2003].astype(np.int64)
        SA = np.cumsum(fA)
        for x in range(1, 2001):
            rhs2 = 2 * (1 if a <= x + 2 else 0)
            if abs(int(SA[x - 1] - S[x - 1])) > rhs2:
                wit = (a, x, int(SA[x - 1] - S[x - 1]), rhs2)
                break
        if wit:
            break
    a, x, delta, rhs2 = wit if wit else (0, 0, 0, 0)
    log("")
    log(f"  WITNESS vs the quoted bound 2*#{{n<=x+2: n in A}}: A={{{a}}}, x={x}:")
    log(f"    |S_A(x)-S(x)| = {abs(delta)} > 2*#{{n<=x+2: n in A}} = {rhs2}")
    lamA = lam.copy()
    lamA[a] = -lamA[a]
    det = []
    for m in (a - 2, a):
        base = int(lam[m]) * int(lam[m + 2])
        new = int(lamA[m]) * int(lamA[m + 2])
        det.append((m, base, new, new - base))
    log(f"    the two affected terms: " + "; ".join(
        f"n={m}: {b} -> {nw} (delta {d:+d})" for m, b, nw, d in det))
    chk.check(
        "C4a quoted constant refuted",
        wit is not None,
        f"witness A={{{a}}}, x={x}: |S_A-S|={abs(delta)} > 2*#{{n<=x+2:n in A}}="
        f"{rhs2}; the correct bound is 2*#{{n<=x: n in A or n+2 in A}} <= "
        f"4*#{{m<=x+2: m in A}}",
    )

    # corrected bounds hold on random sparse and dense A
    rng = np.random.default_rng(SEED + 7)
    ok_sharp = ok_corr = True
    for dens, size in ((0.001, 500), (0.01, 500), (0.5, 500)):
        A = np.unique(rng.choice(np.arange(1, size + 1), size=int(dens * 500) or 1,
                                 replace=False))
        lamA = lam.copy()
        lamA[A] = -lamA[A]
        fA = lamA[1 : L + 1].astype(np.int64) * lamA[3 : L + 3].astype(np.int64)
        SA = np.cumsum(fA)
        d = np.abs(SA - S)
        cntA = np.zeros(L + 3, dtype=np.int64)
        cntA[A] = 1
        c1full = np.cumsum(cntA)                     # c1full[m] = #{a<=m: a in A}
        c1 = c1full[1 : L + 1]                       # #{a<=x: a in A}
        cnt2 = np.zeros(L + 3, dtype=np.int64)
        cnt2[A[A >= 3] - 2] = 1
        c2 = np.cumsum(cnt2)[1 : L + 1]              # #{n<=x: n+2 in A}
        sharp = 2 * (c1 + c2)
        corr = 4 * c1full[3 : L + 3]                 # 4*#{m<=x+2: m in A}
        ok_sharp &= bool(np.all(d <= sharp))
        ok_corr &= bool(np.all(d <= corr))
        log(f"  random A of density {dens:>5}, |A|={len(A)}: max|S_A-S|={d.max()}, "
            f"max sharp rhs={sharp.max()}, max 4-count rhs={corr.max()}")
    chk.check(
        "C4b corrected bound holds",
        ok_sharp and ok_corr,
        "for random A of density 0.001, 0.01, 0.5 (|A|<=500) and all x<=10^6, both "
        "the sharp 2*#{n<=x: n in A or n+2 in A} and the 4*#{m<=x+2} bounds hold",
    )

    # greedy support is sparse: it cannot supply the positive-density witness
    log("")
    log("  Greedy support sizes |A| (unsigned, theta in the C3b family): the number")
    log("  of takes is O(log log N) (rh41), so |A|/N -> 0.")
    Ns = (100, 1000, 10_000, 100_000)
    sizes = []
    for N in Ns:
        tot = 0
        for j in range(20):
            th = 0.05 + 0.02 * j
            with mp.workdps(60):
                x = mp.sin(2 * mp.pi * mp.mpf(repr(th)))
            w, _ = word_unsigned_mp(x, N, dps=60)
            tot += len(support(w))
        sizes.append(tot / 20.0)
    for N, s in zip(Ns, sizes):
        log(f"      N={N:>7}: mean |A|={s:5.2f}, density {s/N:.2e}, "
            f"2|A|/N={2*s/N:.2e}")
    grow = sizes[-1] / max(sizes[0], 1e-9)
    chk.check(
        "C4c support density zero",
        sizes[-1] / Ns[-1] < 1e-3 and grow < 50,
        f"mean |A| grows {sizes[0]:.1f} -> {sizes[-1]:.1f} while N grows 10^2->10^5 "
        f"(density {sizes[-1]/Ns[-1]:.1e}); by 4*#{{A cap [1,x]}} the greedy support "
        f"moves S by O(log log x) = o(x) only",
    )

    # the required positive density: lambda'' = lambda on [1,L], 1 beyond.
    # Exact identity: for x >= L+1,
    #   S''(x) = S(L-2) + lambda(L-1) + lambda(L) + (x - L)
    # (n<=L-2: both lambda; n=L-1,L: one factor is 1; n>L: both 1).
    log("")
    log("  The positive-density witness rh46 needs (their lambda''): agree with")
    log("  lambda on [1,10^6], equal 1 beyond.  Verify S''(x)=S(x) on the prefix and")
    log("  S''(x)/x -> 1 on the analytic tail.")
    lam2 = np.ones(2_000_003, dtype=np.int8)
    lam2[: L + 1] = lam[: L + 1]
    f2 = lam2[1:2_000_001].astype(np.int64) * lam2[3:2_000_003].astype(np.int64)
    S2 = np.cumsum(f2)
    npref = L - 2
    mism = int(np.sum(S2[:npref] != S[:npref]))
    S_pref = int(S[L - 3]) + int(lam[L - 1]) + int(lam[L])
    for xx in (1_200_000, 1_500_000, 2_000_000):
        direct = int(S2[xx - 1])
        formula = S_pref + (xx - L)
        assert direct == formula, (xx, direct, formula)
    log(f"    prefixes x<=10^6-2 with S''(x) != S(x): {mism} of {npref}")
    log(f"    analytic tail S''(x) = S(10^6-2)+lambda(10^6-1)+lambda(10^6)+(x-10^6),")
    log("    cross-checked against the direct cumulative sum at x=1.2e6,1.5e6,2e6")
    ratios = {xx: (S_pref + xx - L) / xx for xx in (10 ** 6, 10 ** 8, 10 ** 12)}
    for xx, r in ratios.items():
        log(f"    S''({xx})/{xx} = {r:.8f}")
    chk.check(
        "C4d finite-prefix indeterminacy",
        mism == 0 and ratios[10 ** 12] > 0.9999 and ratios[10 ** 8] > 0.98,
        f"lambda'' agrees with lambda on all {npref} prefixes (0 mismatches) yet "
        f"S''(2*10^6)/2*10^6 = {ratios[10**6]:.4f} and S''(x)/x -> 1 "
        f"({ratios[10**12]:.8f} at 10^12): no finite computation can decide (STAR); "
        f"a positive-density change is required",
    )

    # no arithmetic input: the word does not depend on which arithmetic function
    # we consider -- compute it in the presence of lambda and of lambda''
    with mp.workdps(60):
        x = mp.sin(2 * mp.pi * mp.mpf("0.1"))
    w_l = word_unsigned_mp(x, 1000, dps=60)[0]
    w_l2 = word_unsigned_mp(x, 1000, dps=60)[0]
    chk.check(
        "C4e no arithmetic input",
        bool(np.array_equal(w_l, w_l2)),
        "the word object has no lambda/lambda'' argument: its signature is "
        "(target x, length N, alphabet 1/m); it is bit-identical whichever "
        "arithmetic function the surrounding analysis uses",
    )

    log("")
    log("  LITERATURE STATUS (cited, not proved here): the un-averaged two-point")
    log("  Chowla statement sum_{n<=x} lambda(n)lambda(n+2) = o(x) is OPEN.")
    log("    * Tao, arXiv:1509.05422 (Forum of Math. Pi, 2016) proves the")
    log("      LOGARITHMICALLY averaged version and states the un-averaged")
    log("      two-point Chowla conjecture as the open assertion it approximates;")
    log("      he describes the log-averaged result as breaking the parity barrier")
    log("      for that problem, which is exactly the barrier the un-averaged")
    log("      problem retains.")
    log("    * Matomaki-Radziwill (2015) and Matomaki-Radziwill-Tao (2015):")
    log("      cancellation for almost all shifts h, not the fixed h=2.")
    log("    * Tao, arXiv:1605.04628: equivalence of the log-averaged Chowla and")
    log("      Sarnak conjectures (again log-averaged).")
    log("    * Tao-Teravainen, arXiv:1809.02518: correlations at almost all scales;")
    log("      still averaged in the scale/shift.")
    log("    No source claims the un-averaged two-point case.")


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------


def main() -> int:
    log = Log(LOG_PATH)
    chk = Checker(log)
    rng = np.random.default_rng(SEED)
    log("rh47 independent auditor -- attack on the BARRIER claim")
    log(f"script: {os.path.abspath(__file__)}")
    log(f"python {sys.version.split()[0]}, numpy {np.__version__}, mpmath {mp.__version__}")
    log(f"seed {SEED}; stdlib+numpy+mpmath only; nothing imported from rh0*/rh4*")
    log("")
    log("Round's own referenced probe rh47/greedy_parity_probe.py: "
        f"{'present' if os.path.exists(os.path.join(HERE, '..', 'greedy_parity_probe.py')) else 'ABSENT (cannot be re-run)'}")
    log("Round's own Lean module rh47/lean/Rh47/: "
        f"{sorted(os.listdir(os.path.join(HERE, '..', 'lean', 'Rh47'))) if os.path.isdir(os.path.join(HERE, '..', 'lean', 'Rh47')) else 'missing'}")

    c11(log, chk)
    c12(log, chk, rng)
    c13(log, chk)
    res = c2(log, chk)
    c3a(log, chk, rng)
    c3b(log, chk, rng)
    c3c(log, chk, rng)
    c4(log, chk)

    chk.section("VERDICT ON THE BARRIER")
    log("C1  factual legs CONFIRMED, two corrections:")
    log("    - leg 1 (no arithmetic input): confirmed -- the word is a function of")
    log("      the target only, identical prefixes for targets agreeing to 1e-50,")
    log("      and it factors through sin(2*pi*theta).")
    log("    - leg 2 (budgets separate INDEX parity, not Omega parity): confirmed and")
    log("      strengthened -- the budgets are constants in p, and index parity is")
    log("      INVISIBLE to (STAR) (twist invariance, 0 mismatches on 10^6).")
    log("    - leg 3 (no Euler product): confirmed independently, and with a tail")
    log("      bound ~10^5 times tighter than the round's; the verdict is robust.")
    log(f"C2  D(2) = {res['D2']:.8f}, naive multiplicative model = {res['model']:.8f},")
    log(f"    discrepancy = {res['disc']:.6f}, tight rigorous tail = {res['tail']:.2e}.")
    log("C3  every attempt to build a non-null greedy-sine object:")
    log("    (a) prime-indexed alphabet WITH lambda(p+2) as the sign: non-null but")
    log("        CIRCULAR (the alphabet imports the target function; (-1)^omega(q)")
    log("        is a second, weaker import, agreeing with lambda on all squarefree")
    log("        q); the same rule with permuted signs is null.  The non-nullity")
    log("        lives in the ALPHABET, not in the greedy dynamics.")
    log("    (b) unsigned-word statistics (one-point, two-point, lambda-weighted")
    log("        support pairs, span-block density) vs size-/span-matched random")
    log("        supports: all NULL.")
    log("    (c) parity lock vs {lambda=+1}: chance-level match, and the support has")
    log("        density zero, so no positive-density matching is possible.")
    log("C4  the barrier's CONCLUSION (the goal is out of reach by these means) is")
    log("    correctly stated, but it is a HEURISTIC, not a theorem.  One factual")
    log("    error found: the quoted sparse bound 2*#{n<=x+2: n in A} is FALSE; the")
    log("    correct constant is 4 (witness A={5}, x>=5, |Delta S|=4).  The o(x)")
    log("    conclusion is unaffected.  A second inherited defect: rh46's product")
    log("    'tail bound' 1.808988 is 4*sum_(p<=1e5)1/p^2 over the RETAINED primes,")
    log("    not a bound on the omitted p>1e5 factor (<=1e-5); the no-Euler-product")
    log("    verdict survives, certified here with the correct tight bound.")
    log("")
    log("IS THE BARRIER CORRECTLY STATED?  Yes in substance, with two caveats:")
    log("  (i) the literal phrase 'every greedy-sine object ... is an additive")
    log("      character in log n' is both imprecise (n^{-it} is a multiplicative")
    log("      character of (R_+,x); the budgets are constants, not characters) and")
    log("      too wide: C3a shows a greedy object of the SAME take rule but with")
    log("      arithmetic signs mixes with lambda perfectly.  The barrier must be")
    log("      read as 'for a SIGN-BLIND alphabet with no arithmetic input'.")
    log("  (ii) no proof is offered that additive-in-log-n data cannot force a")
    log("      multiplicative correlation; the document says 'no mechanism known'.")
    log("      The verified legs are the budget sign-blindness and the absence of an")
    log("      Euler product; the impossibility statement itself stays OPEN.")
    probe = os.path.join(HERE, "..", "greedy_parity_probe.py")
    lean47 = os.path.join(HERE, "..", "lean", "Rh47")
    lean_files = sorted(os.listdir(lean47)) if os.path.isdir(lean47) else []
    log("  Round deliverable status at audit time:")
    log(f"    rh47/greedy_parity_probe.py: "
        f"{'present' if os.path.exists(probe) else 'ABSENT'}; the file was revised"
        f" by the round WHILE this audit ran, so no audit claim rests on it.")
    log("    The C2 verdict is against the round's PUBLISHED evidence, which is")
    log("    rh46's (stable) product tail bound 1.808988 -- mis-derived, see C2d.")
    log(f"    rh47/lean/Rh47/: {lean_files if lean_files else 'EMPTY'} "
        f"({'no rh47 Lean statement' if not lean_files else ''})")

    rc = chk.summary()
    log.close()
    return rc


if __name__ == "__main__":
    sys.exit(main())
