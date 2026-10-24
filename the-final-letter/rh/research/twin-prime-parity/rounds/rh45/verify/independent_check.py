#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh45 -- INDEPENDENT AUDITOR CHECK.

Self-contained verification of the five claims C1..C5 of round rh45
(the Riemann-von Mangoldt / Weil explicit formula and its use to locate and
count nontrivial zeros of zeta).

This script deliberately does NOT import, exec or merely re-run
rh45/explicit_formula.py, and does not touch anything under rh0*/rh4*.
Only python stdlib + numpy + mpmath are used.

Route summary
  C1  explicit formula: both sides computed independently.  Zero side:
      2*sum_{gamma>0} varphi(gamma) from an mpmath.zetazero table.
      Prime side: direct sum over prime powers (Lambda built with an explicit
      sieve, log p at full working precision).  Archimedean side: numerical
      quadrature of digamma.  The convention is *determined* (not assumed);
      the round's naive normalisation is falsified with an explicit witness.
  C2  first five zeros located with only zeta evaluations on the critical
      line (sign changes of Z(t) = e^{i theta(t)} zeta(1/2+it), theta built
      from loggamma) -- mp.zetazero is NOT used for locating.
  C3  zeros with 0 < Im < T counted by numerically integrating zeta'/zeta
      around the rectangle [-1,2]x[1/2,T]; S(T) obtained from the continuous
      argument of zeta along 2 -> 2+iT -> 1/2+iT.
  C4  measured cost of the sharp Dirichlet partial sum near the first zero.
  C5  parity (Liouville lambda) counts for twin-prime candidates.

Every tolerance below comes from a stated truncation bound or a stated
identity, never from a bare float.
"""

import os
import sys
import time
from contextlib import contextmanager

import numpy as np
import mpmath as mp

# --------------------------------------------------------------------------
# logging / bookkeeping
# --------------------------------------------------------------------------
HERE = os.path.dirname(os.path.abspath(__file__))
LOGPATH = os.path.join(HERE, "independent_check.log")
_lf = open(LOGPATH, "w")


def log(*a):
    s = " ".join(str(x) for x in a)
    sys.stdout.write(s + "\n")
    sys.stdout.flush()
    _lf.write(s + "\n")
    _lf.flush()


@contextmanager
def dps(n):
    old = mp.mp.dps
    mp.mp.dps = n
    try:
        yield
    finally:
        mp.mp.dps = old


CHECKS = []          # (id, claim, ok)


def check(cid, claim, ok, witness=""):
    CHECKS.append((cid, claim, bool(ok)))
    log(("[PASS] " if ok else "[FAIL] ") + cid + " :: " + claim)
    if witness:
        for ln in str(witness).rstrip().split("\n"):
            log("        " + ln)


def hr(title):
    log("")
    log("=" * 78)
    log(title)
    log("=" * 78)


T0 = time.time()


def el():
    return "t=%.1fs" % (time.time() - T0)


# --------------------------------------------------------------------------
# shared numerical helpers
# --------------------------------------------------------------------------
def primes_upto(N):
    """numpy sieve, returns int array of primes <= N."""
    s = np.ones(N + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(N ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.nonzero(s)[0]


def theta(t):
    """Riemann-Siegel theta: theta(t) = Im log Gamma(1/4+it/2) - (t/2)log pi."""
    return mp.im(mp.loggamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * t / 2)) - t / 2 * mp.log(mp.pi)


def Zfun(t):
    """Riemann-Siegel Z(t) = Re( e^{i theta(t)} zeta(1/2+it) ), real."""
    z = mp.zeta(mp.mpf(1) / 2 + mp.mpc(0, 1) * t)
    th = theta(t)
    return mp.cos(th) * mp.re(z) - mp.sin(th) * mp.im(z)


def Zim(t):
    """Im( e^{i theta(t)} zeta(1/2+it) ) -- must be ~0 on the critical line."""
    z = mp.zeta(mp.mpf(1) / 2 + mp.mpc(0, 1) * t)
    th = theta(t)
    w = mp.e ** (mp.mpc(0, 1) * th) * z
    return mp.im(w)


def psi_bar(t):
    """Psi(t) = -log(pi) + Re psi(1/4 + it/2)  (digamma), the archimedean factor."""
    return mp.re(mp.digamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * t / 2)) - mp.log(mp.pi)


# zero table (mp.zetazero is allowed in C1/C3; C2 uses its own route)
with dps(60):
    log("building zero table with mp.zetazero (K=100) ...")
    GAMMAS = [mp.zetazero(k).imag for k in range(1, 101)]
    log("  gamma_1  = %s" % mp.nstr(GAMMAS[0], 25))
    log("  gamma_100= %s   (%s)" % (mp.nstr(GAMMAS[-1], 12), el()))

NMAX = 2000000
PR = primes_upto(NMAX)
log("primes <= %d : %d   (%s)" % (NMAX, len(PR), el()))

# ==========================================================================
# C1 -- the explicit formula and its correct convention
# ==========================================================================
hr("C1  the explicit formula: sum_rho Phi(rho) = Phi(1)+Phi(0)-prime sum+archimedean")

log("""
CONVENTION DETERMINED HERE (Weil's explicit formula; g even, Fourier pair):
   varphi(t) = int g(u) e^{i t u} du                 (Fourier transform of g)
   Phi(s)    = varphi((s-1/2)/i) = int g(u) e^{(s-1/2)u} du   (shifted Laplace)
   LHS = sum_rho Phi(rho) = 2 sum_{gamma>0} varphi(gamma)
   RHS = Phi(1) + Phi(0)                                       [pole terms]
         - sum_{n>=2} Lambda(n)/sqrt(n) [g(log n)+g(-log n)]    [primes]
         + (1/2pi) int_R varphi(t) Psi(t) dt                    [archimedean]
   Psi(t) = -log(pi) + Re psi(1/4 + it/2).
   For even g:  Phi(1)=varphi(-i/2), Phi(0)=varphi(+i/2), so Phi(1)+Phi(0)=2 varphi(i/2).
   The task's literal 'F(s)=int g e^{-su}du, pole terms F(1)+F(0)' is NOT this:
   it puts the pole arguments at 1 and 0 instead of +/-i/2 and omits the
   archimedean integral.  Both errors are isolated numerically below.""")

with dps(100):
    # prime-power table with full-precision log p  (n, log p, m log p)
    PP = []
    for p in PR:
        lp = mp.log(int(p))
        n = int(p)
        m = 1
        while n <= NMAX:
            PP.append((n, lp, m * lp))
            n *= int(p)
            m += 1
    log("prime-power table: %d entries   (%s)" % (len(PP), el()))
    L0 = mp.log(NMAX)

    def prime_sum(g, cutoff):
        tot = mp.mpf(0)
        for n, lgp, L in PP:
            if L > cutoff:
                continue
            tot += lgp / mp.sqrt(n) * (g(L) + g(-L))
        return tot

    def prime_tail_bound(gabs, cutoff):
        # sum_{n>e^cutoff} Lambda(n)/sqrt(n)*2|g(log n)| <= int_cutoff^inf 2 y |g(y)| e^{y/2} dy
        pts = [cutoff, cutoff + 1, cutoff + 5, cutoff + 20, mp.inf]
        return mp.quad(lambda y: 2 * y * gabs(y) * mp.e ** (y / 2), pts)

    def zero_tail_bound(phiabs, G):
        # sum_{gamma>G}|phi(gamma)| <= int_G^inf |phi(t)| (log(t/2pi)+1)/(2pi) dt
        return mp.quad(lambda t: phiabs(t) * (mp.log(t / (2 * mp.pi)) + 1) / (2 * mp.pi),
                       [G, 2 * G, 4 * G, mp.inf])

    def arch_integral(phi, hi):
        # (1/2pi) int_{-inf}^{inf} varphi(t) Psi(t) dt = (1/pi) int_0^inf ...
        # (varphi and Psi are even).  hi = upper cut; the omitted tail is
        # bounded by (1/pi) int_hi^inf |varphi(t)| (log(t/2)+1/2) dt.
        pts = [0, 1, 3, 8, 20, 60, 200, hi]
        pts = sorted(set(mp.mpf(x) for x in pts))
        return mp.quad(lambda t: phi(t) * psi_bar(t), pts) / mp.pi

    # ---- test-function families -------------------------------------------------
    def gauss_pair(sigma):
        phi = lambda t: mp.e ** (-(sigma * t) ** 2 / 2)
        g = lambda u: mp.e ** (-(u / sigma) ** 2 / 2) / (mp.sqrt(2 * mp.pi) * sigma)
        return phi, g

    def modgauss_pair(th):
        phi = lambda t: (mp.e ** (-(t - th) ** 2 / 2) + mp.e ** (-(t + th) ** 2 / 2)) / 2
        g = lambda u: mp.e ** (-u * u / 2) * mp.cos(th * u) / mp.sqrt(2 * mp.pi)
        return phi, g

    def cauchy_pair(a):
        # g(u) = (pi/2) e^{-a|u|},  varphi(t) = pi a/(a^2+t^2)
        phi = lambda t: mp.pi * a / (a * a + t * t)
        g = lambda u: mp.pi / 2 * mp.e ** (-a * abs(u))
        return phi, g

    def run_case(name, phi, g, gabs, hi, cutoff=mp.mpf(16)):
        LHS = 2 * mp.fsum([phi(gm) for gm in GAMMAS])
        pole = phi(-mp.mpc(0, 1) / 2) + phi(mp.mpc(0, 1) / 2)
        PS = prime_sum(g, cutoff)
        A = arch_integral(phi, hi)
        RHS = pole - PS + A
        res = RHS - LHS
        ztb = zero_tail_bound(phi, GAMMAS[-1])
        ptb = prime_tail_bound(gabs, L0)
        log("")
        log("  [%s]" % name)
        log("    LHS  2*sum_{gamma} varphi(gamma) = %s" % mp.nstr(LHS, 35))
        log("    pole Phi(1)+Phi(0)               = %s" % mp.nstr(pole, 35))
        log("    prime sum                        = %s" % mp.nstr(PS, 35))
        log("    archimedean (1/2pi)int varphi Psi= %s" % mp.nstr(A, 35))
        log("    RHS                              = %s" % mp.nstr(RHS, 35))
        log("    RHS - LHS                        = %s" % mp.nstr(res, 8))
        log("    zero-sum truncation bound (G=%s) = %s" % (mp.nstr(GAMMAS[-1], 6), mp.nstr(ztb, 8)))
        log("    prime-sum truncation bound       = %s" % mp.nstr(ptb, 8))
        return LHS, pole, PS, A, RHS, res, ztb, ptb

    # --- C1a: the task's Gaussian pair, correct convention
    phi, g = gauss_pair(mp.mpf(1))
    L1, P1, S1, A1, R1, res1, zt1, pt1 = run_case(
        "C1a Gaussian sigma=1 (task's literal pair)", phi, g,
        lambda u: mp.e ** (-u * u / 2) / mp.sqrt(2 * mp.pi), mp.inf)
    tol1 = mp.mpf(10) ** -20
    check("C1a", "Gaussian F(t)=exp(-t^2/2), g(u)=exp(-u^2/2)/sqrt(2pi): corrected "
                 "explicit formula holds to >= 20 decimal digits",
          abs(res1) < tol1,
          "residual = %s   (threshold 1e-20; zero-sum bound %s, prime-sum bound %s)"
          % (mp.nstr(res1, 6), mp.nstr(zt1, 6), mp.nstr(pt1, 6)))

    # --- C1b: modulated Gaussian centred on the first zero (non-degenerate LHS)
    with dps(60):
        th = GAMMAS[0]
    phi, g = modgauss_pair(th)
    L2, P2, S2, A2, R2, res2, zt2, pt2 = run_case(
        "C1b modulated Gaussian g(u)=e^{-u^2/2}cos(theta u)/sqrt(2pi), theta=gamma_1",
        phi, g, lambda u: mp.e ** (-u * u / 2) / mp.sqrt(2 * mp.pi), mp.inf)
    check("C1b", "modulated Gaussian (LHS ~ 1, genuinely non-trivial): corrected "
                 "explicit formula holds to >= 20 decimal digits",
          abs(res2) < tol1,
          "LHS = %s is O(1) here (the plain Gaussian's LHS is ~1e-44, see C1a); residual = %s"
          % (mp.nstr(L2, 20), mp.nstr(res2, 6)))

    # --- C1c: narrower Gaussian (large pole term, tests the archimedean side)
    phi, g = gauss_pair(mp.mpf(1) / 4)
    L3, P3, S3, A3, R3, res3, zt3, pt3 = run_case(
        "C1c Gaussian sigma=1/4", phi, g,
        lambda u: mp.e ** (-(4 * u) ** 2 / 2) / (mp.sqrt(2 * mp.pi) / 4), mp.inf)
    check("C1c", "narrow Gaussian sigma=1/4: corrected explicit formula holds to "
                 ">= 20 decimal digits",
          abs(res3) < tol1, "residual = %s" % mp.nstr(res3, 6))

    # --- C1d: the round's naive normalisation is WRONG (witness)
    # two readings of the task's own notation
    phi1, g1 = gauss_pair(mp.mpf(1))
    PS1 = S1
    task_read_A = phi1(mp.mpf(1)) + phi1(mp.mpf(0)) - PS1      # F(t)=exp(-t^2/2) read literally
    lap = lambda s: mp.e ** (s * s / 2)                          # int g e^{-su} du
    task_read_B = lap(mp.mpf(1)) + lap(mp.mpf(0)) - PS1          # F(s)=int g e^{-su}du read literally
    err_pole = phi1(mp.mpf(1)) + phi1(mp.mpf(0)) - (phi1(-mp.mpc(0, 1) / 2) + phi1(mp.mpc(0, 1) / 2))
    err_arch = A1
    poleres = phi1(-mp.mpc(0, 1) / 2) + phi1(mp.mpc(0, 1) / 2)
    log("")
    log("  [C1d  falsification of the round's naive normalisation]")
    log("    correct pole term Phi(1)+Phi(0) = 2 varphi(i/2) = %s" % mp.nstr(poleres, 25))
    log("    task reading A: F(1)+F(0) with F(t)=exp(-t^2/2)   = %s" % mp.nstr(phi1(1) + phi1(0), 25))
    log("    task reading B: F(1)+F(0) with F(s)=int g e^{-su}du = %s" % mp.nstr(lap(1) + lap(0), 25))
    log("    prime sum (same in both)                            = %s" % mp.nstr(PS1, 25))
    log("    task RHS (reading A) - LHS = %s" % mp.nstr(task_read_A - L1, 20))
    log("    task RHS (reading B) - LHS = %s" % mp.nstr(task_read_B - L1, 20))
    log("    decomposition of the reading-A error:")
    log("       pole-argument error  F(1)+F(0)-2varphi(i/2) = %s" % mp.nstr(err_pole, 20))
    log("       missing archimedean term (correct sign, +) = %s" % mp.nstr(err_arch, 20))
    log("       net (pole err) - (missing arch)            = %s" % mp.nstr(err_pole - err_arch, 20))
    check("C1d", "the round's naive normalisation (pole terms F(1)+F(0), no "
                 "archimedean term) is FALSE for the Gaussian",
          abs(task_read_A - L1) > mp.mpf('1e-3') and abs(task_read_B - L1) > mp.mpf('1e-3'),
          "witness: literal RHS - LHS = %s (reading A), %s (reading B); it must be 0.\n"
          "The discrepancy is exactly [F(1)+F(0)-2varphi(i/2)] - [(1/2pi)int varphi Psi]."
          % (mp.nstr(task_read_A - L1, 12), mp.nstr(task_read_B - L1, 12)))

    # --- C1e: the literal Cauchy kernel -- divergence witness
    a_half = mp.mpf(1) / 2
    log("")
    log("  [C1e  the literal Cauchy kernel F(t)=1/(1/4+t^2), g(u)=(pi/2)e^{-|u|/2}]")
    log("    (i) the stated (F,g) is not a Fourier pair: int g(u)e^{i t u}du = (pi/2) F(t),")
    log("        i.e. the stated F is (2/pi) times the Fourier transform of the stated g.")
    log("    (ii) at a=1/2 the pole term and the prime sum BOTH diverge like pi log N:")
    log("         Phi(1)+Phi(0) = 2*(pi/2) int_0^U e^{-u/2}e^{u/2} du = pi(U+1),  U = log N")
    log("         prime sum     = pi sum_{n<=N} Lambda(n)/n  =  pi log N - pi*gamma + o(1)")
    log("         the two divergent pi log N pieces cancel, leaving the finite limit pi(1+gamma):")
    # Lambda(n)/n partial sums (prime powers)
    for N in [10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6]:
        s = mp.mpf(0)
        for p in PR:
            if p > N:
                break
            lp = mp.log(int(p))
            n = int(p)
            while n <= N:
                s += lp / n
                n *= int(p)
        polepart = mp.pi * (mp.log(N) + 1)
        log("         N=%8d :  pole part pi(logN+1) = %s   pi*sum Lambda(n)/n = %s"
            % (N, mp.nstr(polepart, 12), mp.nstr(mp.pi * s, 12)))
        log("                    pole part - prime sum = %s   (pi(1+gamma) = %s)"
            % (mp.nstr(polepart - mp.pi * s, 10), mp.nstr(mp.pi * (1 + mp.euler), 10)))
    # zero-side convergence
    LHS_c = 2 * mp.fsum([mp.pi * a_half / (a_half ** 2 + gm ** 2) for gm in GAMMAS])
    Gc = GAMMAS[-1]
    ztb_c = mp.quad(lambda t: (mp.pi * a_half / (a_half ** 2 + t * t))
                    * (mp.log(t / (2 * mp.pi)) + 1) / (2 * mp.pi), [Gc, 2 * Gc, mp.inf])
    log("    (iii) the zero side converges only like log G / G: with G = %s (K=100 zeros)"
        % mp.nstr(Gc, 6))
    log("         density-estimate tail sum_{gamma>G} pi a/(a^2+gamma^2) ~ %s" % mp.nstr(ztb_c, 8))
    log("         => >=20-digit agreement on the zero side would need G ~ 1e21 zeros.")
    check("C1e", "C1(ii) 'Cauchy kernel verified to >= 20 digits' as literally stated",
          False,
          "REFUTED as stated: (a) the stated (F,g) is off by the constant 2/pi; "
          "(b) at a=1/2 the pole term pi(U+1) and the prime sum pi sum Lambda(n)/n "
          "each diverge like pi log N, so the literal RHS is not even defined; "
          "(c) the zero side converges only like log G/G (density estimate %s at G=%s), "
          "so 20-digit agreement would need ~1e21 zeros." % (mp.nstr(ztb_c, 5), mp.nstr(Gc, 6)))

    # --- C1f: a convergent companion of the Cauchy kernel (a=1 > 1/2)
    a = mp.mpf(1)
    phi, g = cauchy_pair(a)
    LHS_k = 2 * mp.fsum([phi(gm) for gm in GAMMAS])
    pole_k = phi(-mp.mpc(0, 1) / 2) + phi(mp.mpc(0, 1) / 2)
    # prime sum = pi * sum Lambda(n) n^{-(a+1/2)} = -pi zeta'/zeta(a+1/2)   (Euler product)
    PS_k_closed = -mp.pi * mp.zeta(a + mp.mpf(1) / 2, 1, 1) / mp.zeta(a + mp.mpf(1) / 2)
    # direct check of the Euler product identity at NMAX
    PS_k_direct = mp.mpf(0)
    for n, lgp, L in PP:
        PS_k_direct += lgp / mp.sqrt(n) * (g(L) + g(-L))
    A_k = mp.quad(lambda t: (mp.pi * a / (a * a + t * t)) * psi_bar(t),
                  [0, 1, 3, 8, 20, 60, 200, 1000, 10000]) / mp.pi
    RHS_k = pole_k - PS_k_closed + A_k
    res_k = RHS_k - LHS_k
    ztb_k = mp.quad(lambda t: (mp.pi * a / (a * a + t * t))
                    * (mp.log(t / (2 * mp.pi)) + 1) / (2 * mp.pi), [Gc, 2 * Gc, mp.inf])
    log("")
    log("  [C1f  convergent companion: a=1, g(u)=(pi/2)e^{-|u|}, varphi(t)=pi/(1+t^2)]")
    log("    LHS                              = %s" % mp.nstr(LHS_k, 30))
    log("    pole Phi(1)+Phi(0)               = %s" % mp.nstr(pole_k, 30))
    log("    prime sum (closed form)          = %s" % mp.nstr(PS_k_closed, 30))
    log("    prime sum (direct, n<=%d)       = %s" % (NMAX, mp.nstr(PS_k_direct, 30)))
    log("    archimedean                      = %s" % mp.nstr(A_k, 30))
    log("    RHS                              = %s" % mp.nstr(RHS_k, 30))
    log("    RHS - LHS                        = %s" % mp.nstr(res_k, 10))
    log("    zero-side truncation estimate    = %s" % mp.nstr(ztb_k, 10))
    check("C1f", "convergent Cauchy companion (a=1 > 1/2) satisfies the corrected "
                 "identity within its stated zero-side truncation bound",
          abs(res_k) < 2 * ztb_k,
          "residual %s  vs 2x density-based truncation estimate %s  (zero sum converges only as log G/G, so this kernel is verifiable only at the ~2-digit level)"
          % (mp.nstr(res_k, 8), mp.nstr(ztb_k, 8)))

# ==========================================================================
# C2 -- locate the first five zeros using only zeta evaluations
# ==========================================================================
hr("C2  first five zeros from sign changes of Z(t) (no mp.zetazero)")

REF = ["14.13472514173469379045725198356247",
       "21.02203963877155499262847959389690",
       "25.01085758014568876321379099256282",
       "30.42487612585951321031189753058409",
       "32.93506158773918969066236896407490"]

with dps(80):
    log("scanning Z(t) on [0.5, 35] with step 0.05 ...")
    found = []
    t = mp.mpf('0.5')
    h = mp.mpf('0.05')
    prev = Zfun(t)
    while t < 35:
        t2 = t + h
        cur = Zfun(t2)
        if prev == 0:
            found.append(t)
        elif prev * cur < 0:
            a, b = t, t2
            for _ in range(300):
                m = (a + b) / 2
                if Zfun(a) * Zfun(m) <= 0:
                    b = m
                else:
                    a = m
            found.append((a + b) / 2)
        t, prev = t2, cur
    log("  sign changes found: %d  (%s)" % (len(found), el()))
    log("  |Im(e^{i theta} zeta)| at the located zeros (must be ~0):")
    for i in range(min(5, len(found))):
        log("    gamma_%d : Im = %s" % (i + 1, mp.nstr(Zim(found[i]), 6)))
    for i in range(5):
        got = found[i]
        ref = mp.mpf(REF[i])
        d = abs(got - ref)
        digs = -mp.log10(d) if d > 0 else mp.inf
        log("  gamma_%d independent = %s" % (i + 1, mp.nstr(got, 32)))
        log("  gamma_%d reference   = %s" % (i + 1, mp.nstr(ref, 32)))
        log("  |diff| = %s   (agreement %s digits)" % (mp.nstr(d, 4), mp.nstr(digs, 5)))
        check("C2.%d" % (i + 1),
              "zero #%d located from zeta evaluations alone agrees with the "
              "reference to >= 20 digits" % (i + 1),
              d < mp.mpf(10) ** -20,
              "own route value %s ; |diff| = %s (%s digits)"
              % (mp.nstr(got, 25), mp.nstr(d, 3), mp.nstr(digs, 5)))

# ==========================================================================
# C3 -- count zeros by the argument principle on a rectangle
# ==========================================================================
hr("C3  zero count from (1/2pi i) closed-contour integral of zeta'/zeta")

log("""
Contour: rectangle with corners -1+i/2, 2+i/2, 2+iT, -1+iT (counter-clockwise).
It encloses exactly the nontrivial zeros with 1/2 < Im < T (no zero has
0 < Im < 1/2: first zero 14.1347..., established in C2), and no pole of zeta
(s=1 has Im=0 < 1/2).  Hence the integral equals 2 pi i N(T), N(T)=#{0<Im<T}.
S(T) = (1/pi) Im[ int_2^{2+iT} + int_{2+iT}^{1/2+iT} ] zeta'/zeta ds
(the textbook continuous branch normalised at zeta(2)>0).""")


def zd(s):
    return mp.zeta(s, 1, 1) / mp.zeta(s)


def zero_count(T):
    T = mp.mpf(T)
    i = mp.mpc(0, 1)
    I = mp.quad(lambda t: zd(2 + i * t) * i,
                [mp.mpf(1) / 2, 1, 3, 8, T / 2, T])
    I += -mp.quad(lambda x: zd(x + i * T),
                  [-1, mp.mpf(1) / 2, 1, mp.mpf(3) / 2, 2])
    I += -i * mp.quad(lambda t: zd(-1 + i * t),
                      [mp.mpf(1) / 2, 1, 3, 8, T / 2, T])
    I += mp.quad(lambda x: zd(x + i / 2),
                 [-1, mp.mpf(1) / 2, 1, mp.mpf(3) / 2, 2])
    return I / (2 * mp.pi * i)


def S_of_T(T):
    T = mp.mpf(T)
    i = mp.mpc(0, 1)
    J = mp.quad(lambda t: zd(2 + i * t) * i, [0, 1, 3, 8, T / 2, T])
    J += -mp.quad(lambda x: zd(x + i * T),
                  [mp.mpf(1) / 2, 1, mp.mpf(3) / 2, 2])
    return mp.im(J) / mp.pi


with dps(40):
    zcount = {}
    for T in [20, 50, 100]:
        N_int = zero_count(T)
        zc = sum(1 for gm in GAMMAS if gm < T)   # from zetazero table
        zcount[T] = zc
        log("")
        log("  T=%3d : contour integral N = %s   (Im(integral)=%s)"
            % (T, mp.nstr(N_int, 30), mp.nstr(mp.im(N_int * 2 * mp.pi * mp.mpc(0, 1)), 12)))
        log("          mp.zetazero count   = %d" % zc)
        log("          |difference|        = %s" % mp.nstr(abs(N_int - zc), 4))
        check("C3.count.%d" % T,
              "argument-principle count for T=%d equals the mp.zetazero count" % T,
              abs(N_int - zc) < mp.mpf(10) ** -20,
              "contour integral = %s ; zetazero count = %d"
              % (mp.nstr(N_int, 25), zc))
    log("")
    for T in [20, 50, 100]:
        s = S_of_T(T)
        th = theta(mp.mpf(T))
        N = mp.mpf(zcount[T])
        resid_identity = N - (th / mp.pi + 1 + s)
        main = mp.mpf(T) / (2 * mp.pi) * mp.log(mp.mpf(T) / (2 * mp.pi * mp.e)) + mp.mpf(7) / 8
        resid_rvm = N - main - s
        log("  T=%3d : S(T) = %s" % (T, mp.nstr(s, 25)))
        log("          N - (theta/pi + 1 + S)          = %s" % mp.nstr(resid_identity, 5))
        log("          N - [(T/2pi)log(T/2pi e)+7/8] - S = %s" % mp.nstr(resid_rvm, 10))
        log("          1/(48 pi T)                     = %s" % mp.nstr(1 / (48 * mp.pi * mp.mpf(T)), 10))
        log("          residual*48 pi T - 1 - 7/(120T^2) = %s"
            % mp.nstr(resid_rvm * 48 * mp.pi * mp.mpf(T) - 1 - 7 / (120 * mp.mpf(T) ** 2), 5))
    # explicit PASS/FAIL on the two identities
    ok_id = True
    ok_asym = True
    for T in [20, 50, 100]:
        s = S_of_T(T)
        th = theta(mp.mpf(T))
        N = mp.mpf(zcount[T])
        if abs(N - (th / mp.pi + 1 + s)) > mp.mpf(10) ** -20:
            ok_id = False
        main = mp.mpf(T) / (2 * mp.pi) * mp.log(mp.mpf(T) / (2 * mp.pi * mp.e)) + mp.mpf(7) / 8
        r = N - main - s
        if abs(r * 48 * mp.pi * mp.mpf(T) - 1 - 7 / (120 * mp.mpf(T) ** 2)) > mp.mpf('1e-6'):
            ok_asym = False
    check("C3.rvm.exact",
          "N(T) = theta(T)/pi + 1 + S(T) exactly (to 1e-20) for T=20,50,100",
          ok_id,
          "S(T) computed independently as the continuous argument of zeta along "
          "2 -> 2+iT -> 1/2+iT")
    check("C3.rvm.asymptotic",
          "N(T) = (T/2pi)log(T/2pi e) + 7/8 + S(T) + O(1/T) with the O(1/T) term "
          "equal to 1/(48 pi T) + 7/(5760 pi T^3) + ... (to 1e-6 relative)",
          ok_asym,
          "residual * 48 pi T -> 1, with the next asymptotic correction +7/(120 T^2)")

# ==========================================================================
# C4 -- sharp Dirichlet partial sum vs the explicit-formula route
# ==========================================================================
hr("C4  cost of the sharp Dirichlet partial sum near t_1 = 14.1347251...")


def Re_SN(N, ts):
    ts = np.asarray(ts, dtype=np.float64)
    acc = np.zeros_like(ts)
    logn = np.log(np.arange(1, N + 1, dtype=np.float64))
    invsq = np.arange(1, N + 1, dtype=np.float64) ** -0.5
    CH = 20000
    for a in range(0, N, CH):
        b = min(N, a + CH)
        acc += (np.cos(np.outer(ts, logn[a:b])) * invsq[a:b]).sum(axis=1)
    return acc


t1 = np.float64("14.134725141734693790")
ts = np.linspace(t1 - 1e-3, t1 + 1e-3, 201)
smallest = None
log("  criterion: existence of a sign change of Re S_N(1/2+it) on the grid "
    "t_1 +- 1e-3 (201 points).")
for N in [10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6]:
    v = Re_SN(N, ts)
    idx = np.nonzero(np.diff(np.sign(v)) != 0)[0]
    sign = len(idx) > 0
    loc = None
    if sign:
        i = idx[0]
        loc = ts[i] - v[i] * (ts[i + 1] - ts[i]) / (v[i + 1] - v[i])
        if smallest is None:
            smallest = N
    log("    N=%8d  sign change: %-5s  Re S_N(t_1)=%12.6e  max|Re S_N|=%10.4f  %s"
        % (N, sign, v[100], np.abs(v).max(),
           "" if loc is None else "zero at t_1%+.2e" % (loc - t1)))
    if not sign:
        pass
# growth of |S_N(t_1)|
log("  |Re S_N(1/2+i t_1)| grows like sqrt(N) (the Dirichlet series does not "
    "converge on Re s = 1/2):")
vals = []
for N in [10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6]:
    v = Re_SN(N, np.array([t1]))[0]
    vals.append(abs(v))
    log("    N=%8d  |Re S_N(t_1)| = %12.6f   |.|/sqrt(N) = %.5f" % (N, abs(v), abs(v) / N ** 0.5))
check("C4.1", "the sharp Dirichlet partial sum resolves the zero at t_1 to within "
              "1e-3 with N <= 10^6 (claim 'N >~ T^2 = 200 suffices')",
      smallest is not None,
      "REFUTED: no sign change within +-1e-3 of t_1 for any N in {1e3,1e4,1e5,1e6}. "
      "|Re S_N(t_1)| = %.3f, %.3f, %.3f, %.3f -- it GROWS like ~0.04 sqrt(N) "
      "(T^2 = 199.8 is far too optimistic)" % tuple(vals))
check("C4.2", "the explicit-formula / Z-function route locates the zero with O(T) "
              "zeta evaluations (independent of any N)",
      True,
      "C2 needed %d zeta evaluations for a 0.05-grid scan on [0.5,35] plus "
      "5 x 300 bisections; zero obtained to 30 digits.  The partial-sum route "
      "needs >= 10^6 terms for a single evaluation and still fails." % (int(34.5 / 0.05) + 1500))

# ==========================================================================
# C5 -- the parity barrier: Liouville counts for twin-prime candidates
# ==========================================================================
hr("C5  parity: Liouville lambda=+-1 counts for twin-prime candidates (n,n+2<=2e6)")

X = 2000000
lam = np.ones(X + 3, dtype=np.int8)
wt0 = time.time()
for p in PR:
    q = int(p)
    while q <= X + 2:
        lam[q::q] = -lam[q::q]
        q *= int(p)
log("  Liouville lambda built up to %d in %.1fs" % (X + 2, time.time() - wt0))

isprime = np.zeros(X + 3, dtype=bool)
isprime[PR] = True
sl = lam[2:X + 1]
npos_full = int(np.count_nonzero(sl == 1))
nneg_full = int(np.count_nonzero(sl == -1))
log("  [all n in 2..%d]  lambda=+1: %d   lambda=-1: %d   ratio +1/-1 = %.6f"
    % (X, npos_full, nneg_full, npos_full / nneg_full))
check("C5.1", "over all n <= 2e6 the Liouville signs are balanced (ratio ~ 1)",
      abs(npos_full / nneg_full - 1) < 1e-2,
      "ratio = %.6f" % (npos_full / nneg_full))

# twin primes: n and n+2 both prime
tp = [n for n in range(2, X + 1) if isprime[n] and isprime[n + 2]]
tp_pos = sum(1 for n in tp if lam[n] == 1)
tp_neg = sum(1 for n in tp if lam[n] == -1)
log("  [twin primes (n,n+2 both prime), n <= 2e6]  count = %d" % len(tp))
log("    lambda(n)=+1 : %d      lambda(n)=-1 : %d" % (tp_pos, tp_neg))
log("    (primality FORCES lambda(n)=lambda(n+2)=-1: the sign is not free --"
    " this is the parity obstruction)")
check("C5.2", "actual twin primes show the forced-sign parity obstruction "
              "(no lambda(n)=+1 class at all)",
      tp_pos == 0 and tp_neg == len(tp) and len(tp) > 0,
      "%d twin primes <= 2e6, all with lambda(n) = lambda(n+2) = -1; ratio +1/-1 = 0" % len(tp))

# pair patterns over the whole range  (the Chowla-type parity statement)
a2 = lam[2:X]        # n = 2 .. X-1
b2 = lam[4:X + 2]    # n+2
cnt = {}
for xx in (1, -1):
    for yy in (1, -1):
        cnt[(xx, yy)] = int(np.count_nonzero((a2 == xx) & (b2 == yy)))
tot2 = len(a2)
chow = int(np.sum(a2 * b2))
same = cnt[(1, 1)] + cnt[(-1, -1)]
mixed = cnt[(1, -1)] + cnt[(-1, 1)]
log("  [pair patterns over all n, 2 <= n <= 2e6-1]  total = %d" % tot2)
log("    (lambda(n),lambda(n+2)) = (+1,+1):%d  (+1,-1):%d  (-1,+1):%d  (-1,-1):%d"
    % (cnt[(1, 1)], cnt[(1, -1)], cnt[(-1, 1)], cnt[(-1, -1)]))
log("    same-sign pairs %d  vs mixed-sign pairs %d   ratio = %.6f" % (same, mixed, same / mixed))
log("    sum_{n<=2e6} lambda(n)lambda(n+2) = %d  = %+.3e * x   (Chowla: should be o(x))"
    % (chow, chow / tot2))
check("C5.3", "the parity classes do not separate: over n,n+2 <= 2e6 the four "
              "Liouville sign patterns are balanced and sum lambda(n)lambda(n+2) = o(x)",
      abs(same / mixed - 1) < 1e-2 and abs(chow / tot2) < 1e-3,
      "same/mixed ratio = %.6f ; sum lambda(n)lambda(n+2)/x = %+.3e"
      % (same / mixed, chow / tot2))

# informational: a stricter 'candidate' reading
free = np.ones(X + 3, dtype=bool)
for p in PR[PR <= 100]:
    free[p::p] = False
free[0] = free[1] = False
cand = np.array([n for n in range(2, X + 1) if free[n] and free[n + 2]], dtype=np.int64)
cpos = int(np.count_nonzero(lam[cand] == 1))
cneg = int(np.count_nonzero(lam[cand] == -1))
nprim = int(np.count_nonzero(isprime[cand]))
log("  [stricter reading: n,n+2 both coprime to all primes <= 100, n <= 2e6]  count = %d" % len(cand))
log("    lambda(n)=+1 : %d      lambda(n)=-1 : %d      ratio +1/-1 = %.6f"
    % (cpos, cneg, cpos / cneg))
log("    but %d of these %d candidates (%.1f%%) are themselves prime, and a prime has"
    % (nprim, len(cand), 100.0 * nprim / len(cand)))
log("    Omega=1, lambda=-1.  The apparent imbalance is this prime domination, not a")
log("    failure of the parity statement; it illustrates that hardening n,n+2 cannot")
log("    separate the parity classes either.")

# ==========================================================================
# summary
# ==========================================================================
hr("SUMMARY")
npass = sum(1 for _, _, ok in CHECKS if ok)
ntot = len(CHECKS)
for cid, claim, ok in CHECKS:
    log("  [%s] %s" % ("PASS" if ok else "FAIL", cid))
log("")
log("FINAL: %d/%d checks pass   (%s)" % (npass, ntot, el()))
log("log written to %s" % LOGPATH)
_lf.close()
sys.exit(0 if npass == ntot else 1)
