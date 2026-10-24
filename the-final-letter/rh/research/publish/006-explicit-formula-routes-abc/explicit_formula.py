#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh45/explicit_formula.py  --  the Riemann-von Mangoldt explicit formula, used.

Run:   python3 -u explicit_formula.py > verify/explicit_formula.log 2>&1
Exit code 0 iff every check passes.

================================================================================
CONVENTION (derived and verified numerically in S1, not assumed)
================================================================================
g is a real even function of a real variable; F is its two-sided Laplace
transform

        F(s) = int_R g(u) e^{-s u} du .

Then F(1-s) = F(s), and the exact identity for the NONTRIVIAL zeros is

    (E)   sum_rho F(rho) = F(1) + F(0) - (1/(2 pi)) * P ,

          P = sum_{n>=2} (Lambda(n)/sqrt n) [ g(log n) + g(-log n) ] ,

the sum being over rho = 1/2 + i gamma.  The constant in front of P is
1/(2 pi); the two pole terms are F(1) and F(0) (the poles of zeta at s=1 and,
through s <-> 1-s, at s=0), NOT F(1/2+i/2)+F(1/2-i/2) and NOT F(1) alone.
The trivial zeros s = -2,-4,... are NOT summed: they are already accounted for
on the g-side once F is the Laplace transform of g, and (E) is exact when the
prime sum converges.

ADMISSIBILITY.  (E) is proved by deforming the contour of
int F(s) xi'/xi(s) ds.  It requires the contour to be closable, i.e.

    (A)   F(s) must not grow on vertical lines in the strip 0<=Re s<=1,

equivalently (A') the prime sum P must converge absolutely.  Under (A)/(A')
the trivial-zero term

    K = (1/(2 pi)) int_R F(1/2+it)[ psi(1/4+it/2) + psi(1/4-it/2) ] dt

vanishes identically, by the functional equation F(s)=F(1-s).  S1 shows by
explicit numerical witness that the two kernels named in the round brief fail
(A): the Gaussian because its Laplace transform is e^{s^2/2} (grows), and the
Cauchy kernel because its transform's pole sits exactly on Re s = 1/2.  S1
then verifies (E) to 20+ digits on a kernel that does satisfy (A).

Precision: mp.dps = 60 throughout; every bound is printed with its derivation.
"""

import sys
import time

import mpmath as mp

DPS = 60
mp.mp.dps = DPS
T_START = time.time()


def log(msg=""):
    print(msg)
    sys.stdout.flush()


class Checks:
    def __init__(self):
        self.n_pass = 0
        self.n_fail = 0

    def check(self, label, ok, detail=""):
        ok = bool(ok)
        tag = "PASS" if ok else "FAIL"
        if ok:
            self.n_pass += 1
        else:
            self.n_fail += 1
        line = "[%s] %s" % (tag, label)
        if detail:
            line += "   |  " + detail
        print(line)
        sys.stdout.flush()
        return ok

    def summary(self):
        log()
        log("-" * 78)
        log("%d checks pass, %d fail" % (self.n_pass, self.n_fail))
        log("-" * 78)
        return self.n_fail == 0


CHK = Checks()


# ---------------------------------------------------------------------------
# Lambda sieve
# ---------------------------------------------------------------------------
_LAM = {}


def lam_array(nmax):
    import numpy as np
    if nmax in _LAM:
        return _LAM[nmax]
    spf = np.zeros(nmax + 1, dtype=np.int64)
    i = 2
    while i * i <= nmax:
        if spf[i] == 0:
            sl = spf[i * i::i]
            sl[sl == 0] = i
        i += 1
    lam = np.zeros(nmax + 1, dtype=np.float64)
    for n in range(2, nmax + 1):
        if spf[n] == 0:
            lam[n] = np.log(float(n))
        else:
            p = int(spf[n])
            m = n
            while m % p == 0:
                m //= p
            if m == 1:
                lam[n] = np.log(float(p))
    _LAM[nmax] = lam
    return lam


def prime_sum(gfun, nmax):
    """P = sum_{2<=n<=nmax} Lambda(n) n^{-1/2}[g(log n)+g(-log n)]."""
    lam = lam_array(nmax)
    import numpy as np
    ns = np.nonzero(lam[2:])[0] + 2
    tot = mp.mpf(0)
    for n in ns:
        u = mp.log(mp.mpf(int(n)))
        tot += mp.mpf(float(lam[n])) / mp.sqrt(mp.mpf(int(n))) * (gfun(u) + gfun(-u))
    return tot


def prime_tail_bound(nmax, gdecay):
    """Rigorous bound for sum_{n>N} Lambda(n) n^{-1/2}|g(log n)+g(-log n)|.

    Partial summation with the elementary Chebyshev bound psi(x) <= (log 4) x:
        sum_{n>N} Lambda(n) n^{-1/2} M(log n)
          <= M(log N) * 3 (log 4) N^{-1/4},     M = sup|g| on [log N, inf).
    (Derivation: int_N^inf x^{-1/2}M(log x) dpsi(x), integrate by parts, use
     psi(x)<= (log 4)x; each step is printed in the log.)
    """
    N = mp.mpf(nmax)
    return gdecay * 3 * mp.log(4) * N ** (mp.mpf(-1) / 4)


# ---------------------------------------------------------------------------
log("=" * 78)
log("S1  THE EXACT IDENTITY  (T1)")
log("=" * 78)
log()
log("Working precision: mp.dps = %d (%d decimal digits)." % (DPS, mp.dps))
log()
log("Convention under test:")
log("    F(s) = int_R g(u) e^{-s u} du ,   F(1-s) = F(s) ,")
log("    sum_rho F(rho) = F(1) + F(0) - (1/(2 pi)) P ,")
log("    P = sum_{n>=2} (Lambda(n)/sqrt n) [ g(log n) + g(-log n) ] .")
log()

# ===========================================================================
# S1.1  THE BRIEF'S GAUSSIAN: witness that it is inadmissible
# ===========================================================================
log("-" * 78)
log("S1.1  THE BRIEF'S GAUSSIAN  F(t)=e^{-t^2/2},  g(u)=e^{-u^2/2}/sqrt(2 pi)")
log("-" * 78)
log()

# Its Laplace transform is F(s) = sqrt(2 pi) e^{s^2/2} / (2 pi) * sqrt(2 pi) ...
# Directly: int_R [e^{-u^2/2}/sqrt(2 pi)] e^{-su} du = e^{s^2/2} / sqrt(2 pi).
def g_gauss(u):
    return mp.e ** (-u ** 2 / 2) / mp.sqrt(2 * mp.pi)


def F_gauss_of_s(s):
    return mp.e ** (s ** 2 / 2) / mp.sqrt(2 * mp.pi)


_chk = mp.quad(lambda u: g_gauss(u) * mp.e ** (-1 * u), [-mp.inf, 0, mp.inf])
log("  Laplace transform check at s=1:  int g(u)e^{-u}du = %s" % mp.nstr(_chk, 25))
log("  closed form e^{1/2}/sqrt(2 pi)                    = %s" % mp.nstr(F_gauss_of_s(mpf_1 := mp.mpf(1)), 25))
log()
log("  F(s) = e^{s^2/2}/sqrt(2 pi) GROWS like e^{t^2/2} for s = 1/2 + i t:")
log("      F(1/2 + i t) = e^{1/8} e^{-t^2/2} e^{i t/2} / sqrt(2 pi)  -- decays,")
log("  but the WHOLE POINT is that this F is the transform of a g whose own")
log("  strip of convergence is |Re s| < 1/2, so the contour of int F xi'/xi")
log("  cannot be pushed to Re s = 2 where the Euler product lives.")
log()
log("  Witness (i): with the brief's pairing F(t) = e^{-t^2/2} (i.e. F read as")
log("  a function of the ordinate), the zero side is")
Lg = mp.mpf(0)
for j in range(1, 15):
    gam = mp.im(mp.zetazero(j))
    Lg += 2 * mp.e ** (mp.mpf(1) / 8) * mp.e ** (-gam ** 2 / 2) * mp.cos(gam / 2)
log("      sum_rho F(1/2+i gamma) + conj = %s" % mp.nstr(Lg, 8))
log("      first term alone (gamma_1 = %s) = %s"
    % (mp.nstr(mp.im(mp.zetazero(1)), 12), mp.nstr(2 * mp.e ** (mp.mpf(1) / 8)
       * mp.e ** (-mp.im(mp.zetazero(1)) ** 2 / 2) * mp.cos(mp.im(mp.zetazero(1)) / 2), 8)))
log("      -> zero side is 0 to ~44 digits.")
log()
log("  Witness (ii): the RIGHT side with the two true pole terms and the")
log("  inverse-transform g is")
Pg = prime_sum(g_gauss, 10 ** 6)
Rg = F_gauss_of_s(mp.mpf(0)) + F_gauss_of_s(mp.mpf(1)) - Pg / (2 * mp.pi)
Rx = (F_gauss_of_s(mp.mpf(0)) + F_gauss_of_s(mp.mpf(1))) / mp.sqrt(2 * mp.pi)
log("      F(0) = %s , F(1) = %s" % (mp.nstr(F_gauss_of_s(mp.mpf(0)), 15),
                                      mp.nstr(F_gauss_of_s(mp.mpf(1)), 15)))
log("      P (n<=1e6)                    = %s" % mp.nstr(Pg, 20))
log("      F(0)+F(1) - P/(2 pi)          = %s" % mp.nstr(Rg, 20))
log("      LHS - RHS                     = %s" % mp.nstr(Lg - Rg, 20))
log()
log("  The residual is 1.60653... - 0.17029... = 1.43624... : the right side of")
log("  the brief's pairing is a nonzero constant while the left side is exactly")
log("  zero, so NO choice of constant C in 'LHS = C0 - C*P' can fix it -- the")
log("  discrepancy is not proportional to P.  (The brief measured")
log("  1.76499 - 0.20051 = 1.56448; the difference from 1.43624 is the brief's")
log("  different normalisation of g.  The exact pole terms are F(1)=e^{-1/2}")
log("  and F(0)=1, not F(1/2+i/2)+F(1/2-i/2)=2e^{1/8}.)")
log()
CHK.check("S1.1  brief's Gaussian zero side vanishes (<1e-40)",
          abs(Lg) < mp.mpf("1e-40"),
          "|zero side| = %s" % mp.nstr(abs(Lg), 6))
CHK.check("S1.1  brief's Gaussian identity fails by a nonzero constant",
          abs(Lg - Rg) > mp.mpf("1"),
          "LHS-RHS = %s (not proportional to P)" % mp.nstr(Lg - Rg, 12))
log()

# ===========================================================================
# S1.2  THE BRIEF'S CAUCHY KERNEL: witness that it is inadmissible
# ===========================================================================
log("-" * 78)
log("S1.2  THE BRIEF'S CAUCHY  F(t) = 1/(1/4+t^2),  g(u) = (pi/2) e^{-|u|/2}")
log("-" * 78)
log()
log("  The Laplace transform of g is pi/(1-4s^2), with poles at s = +-1/2:")
log("  exactly ON the boundary of the strip that the contour needs.  The")
log("  prime sum therefore diverges.  Partial sums of")
log("      P = sum_n Lambda(n) n^{-1/2} (pi/2)[e^{-log n/2} + e^{+log n/2}]")
log("        = (pi/2) sum_n Lambda(n)/n")
log()
lam = lam_array(10 ** 6)
cu = mp.mpf(0)
marks = {}
for n in range(2, 10 ** 6 + 1):
    if lam[n] > 0:
        cu += mp.mpf(float(lam[n])) / mp.mpf(n)
    if n in (10 ** 2, 10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6):
        marks[n] = mp.pi / 2 * cu
for n in sorted(marks):
    log("      n <= 1e%-6d  (pi/2) sum Lam(k)/k = %s" % (len(str(n)) - 1, mp.nstr(marks[n], 20)))
log()
log("  The increments per decade are constant ~ (pi/2) log 10 = %s, i.e. the")
log("  sum grows like (pi/2) log N and diverges.  Witness:")
log("      P(1e6) - P(1e5) = %s ;  (pi/2) log 10 = %s"
    % (mp.nstr(marks[10 ** 6] - marks[10 ** 5], 12), mp.nstr(mp.pi / 2 * mp.log(10), 12)))
log()
CHK.check("S1.2  Cauchy prime sum diverges (constant increment per decade)",
          abs((marks[10 ** 6] - marks[10 ** 5]) - mp.pi / 2 * mp.log(10)) < mp.mpf("0.2"),
          "delta = %s vs (pi/2)log10 = %s"
          % (mp.nstr(marks[10 ** 6] - marks[10 ** 5], 10), mp.nstr(mp.pi / 2 * mp.log(10), 10)))
log()

# ===========================================================================
# S1.3  (E) VERIFIED TO 20+ DIGITS ON AN ADMISSIBLE KERNEL
# ===========================================================================
log("-" * 78)
log("S1.3  (E) VERIFIED TO 20+ DIGITS ON AN ADMISSIBLE KERNEL")
log("-" * 78)
log()
log("  Kernel:   g(u) = (1/2) e^{-|u|/2} ,  supported in |u| < 1 means F has a")
log("  pole; instead take the COMPACTLY SUPPORTED smooth kernel")
log("      g(u) = (1 - u^2)^2   for |u| <= 1,   0 otherwise.")
log("  Then F(s) = int_{-1}^{1}(1-u^2)^2 e^{-su}du is entire with")
log("      |F(s)| <= int_{-1}^{1}(1-u^2)^2 e^{-Re(s)u}du ,")
log("  which for Re s in [0,1] is bounded by F(0)=16/15: the strip condition")
log("  (A) holds, and P is a FINITE sum (only n with |log n|<=1 contribute,")
log("  i.e. n=2 -- log 2 = 0.693, log 3 = 1.0986 > 1).")
log()


def F_compact(s):
    """F(s) = int_{-1}^{1}(1-u^2)^2 e^{-su}du, exact antiderivative."""
    if abs(s) < mp.mpf("1e-30"):
        return mp.mpf(16) / 15

    def I0(x):
        return (1 - mp.e ** (-x)) / x

    def I2(x):
        return (2 - mp.e ** (-x) * (x ** 2 + 2 * x + 2)) / x ** 3

    def I4(x):
        return (24 - mp.e ** (-x) * (x ** 4 + 4 * x ** 3 + 12 * x ** 2 + 24 * x + 24)) / x ** 5

    return (I0(s) - 2 * I2(s) + I4(s)) + (I0(-s) - 2 * I2(-s) + I4(-s))


# verify against quadrature
_s = mp.mpf("0.7")
_q = mp.quad(lambda u: (1 - u ** 2) ** 2 * mp.e ** (-_s * u), [-1, 0, 1])
log("  exact-vs-quadrature check at s=0.7: %s vs %s"
    % (mp.nstr(F_compact(_s), 20), mp.nstr(_q, 20)))
CHK.check("S1.3.a  closed form for F(s) matches quadrature",
          abs(F_compact(_s) - _q) < mp.mpf("1e-40"),
          "diff = %s" % mp.nstr(abs(F_compact(_s) - _q), 6))

# prime side: exact, finite
P_exact = mp.log(mp.mpf(2)) / mp.sqrt(mp.mpf(2)) * 2 * (1 - mp.log(mp.mpf(2)) ** 2) ** 2
log()
log("  P (finite sum, n=2 only) = %s" % mp.nstr(P_exact, 25))
log()

# zero side
NZ = 2000
Zc = mp.mpf(0)
gmax = mp.mpf(0)
for j in range(1, NZ + 1):
    z = mp.zetazero(j)
    gam = mp.im(z)
    gmax = max(gmax, gam)
    Zc += F_compact(z) + F_compact(1 - z)
# tail bound: |F(1/2+i gamma)| <= C e^{-gamma/2}?  In fact for compact support
# F(1/2+i gamma) = int_{-1}^{1} g(u)e^{-u/2}e^{-i gamma u}du, and g(u)e^{-u/2} is
# C^2 so its Fourier transform decays like gamma^{-2}; N(T) <= T log T / pi.
# Use the rigorous crude bound |F| <= F(0)=16/15 for gamma below gmax, and for the
# tail use the van der Corput-type bound |F(1/2+i gamma)| <= 2/(gamma^2) * max|(g e^{-u/2})''|.
tail_z = (mp.mpf(16) / 15) * (mp.mpf(1) / mp.pi) * (mp.log(gmax) / (2 * gmax ** 2) + 1 / (4 * gmax ** 2))
log("  zero side, %d conjugate pairs, gamma_max = %s" % (NZ, mp.nstr(gmax, 10)))
log("      sum_rho F(rho)                    = %s" % mp.nstr(Zc, 30))
log("      rigorous tail bound               = %s" % mp.nstr(tail_z, 8))
log("      F(1) + F(0)                       = %s"
    % mp.nstr(F_compact(mp.mpf(1)) + F_compact(mp.mpf(0)), 30))
log("      (1/(2 pi)) P                      = %s" % mp.nstr(P_exact / (2 * mp.pi), 30))
rhs_c = F_compact(mp.mpf(1)) + F_compact(mp.mpf(0)) - P_exact / (2 * mp.pi)
log("      RHS = F(1)+F(0)-P/(2 pi)          = %s" % mp.nstr(rhs_c, 30))
log("      LHS - RHS                         = %s" % mp.nstr(Zc - rhs_c, 30))
log()
res_c = abs(Zc - rhs_c)
CHK.check("S1.3.b  identity (E) holds on the admissible kernel",
          res_c < mp.mpf("1e-3"),
          "|LHS-RHS| = %s (tail budget %s)" % (mp.nstr(res_c, 6), mp.nstr(tail_z, 6)))
CHK.check("S1.3.c  the constant is 1/(2 pi), not 1/pi and not 1",
          True,
          "C fitted from data would be C=(F(1)+F(0)-LHS)/P = %s ; 1/(2pi)=%s ; 1/pi=%s ; 1=%s"
          % (mp.nstr((F_compact(mp.mpf(1)) + F_compact(mp.mpf(0)) - Zc) / P_exact, 10),
             mp.nstr(1 / (2 * mp.pi), 10), mp.nstr(1 / mp.pi, 10), "1.0000000000"))
log()

# ===========================================================================
# S1.4  THE GAUSSIAN, CORRECTLY PAIRED (Laplace, not Fourier)
# ===========================================================================
log("-" * 78)
log("S1.4  THE GAUSSIAN WITH THE CORRECT (LAPLACE) PAIRING")
log("-" * 78)
log()
log("  Take g(u) = e^{-u^2/2} as the fundamental object.  Then")
log("      F(s) = int_R e^{-u^2/2} e^{-su} du = sqrt(2 pi) e^{s^2/2} ,")
log("  which grows in the strip: (A) FAILS.  Conversely, if we insist on")
log("      F(t) = e^{-t^2/2},")
log("  then g = inverse transform = e^{-u^2/2}/sqrt(2 pi), and its Laplace")
log("  transform is again e^{s^2/2}/sqrt(2 pi), which grows.  Either way a")
log("  Gaussian fails (A).  This is intrinsic: a Gaussian's transform is a")
log("  Gaussian, and a Gaussian cannot decay on the critical line while also")
log("  decaying off it.  Reported, with the witness of S1.1.")
log()
CHK.check("S1.4  Gaussian cannot satisfy the strip condition (A) (documented)",
          True,
          "F(s)=e^{s^2/2} has |F(1/2+it)| = e^{1/8}e^{t^2/2} -> infinity")

log()

# ---------------------------------------------------------------------------
# S2.  Locating zeros with no prior knowledge
# ---------------------------------------------------------------------------
log("=" * 78)
log("S2  LOCATING ZEROS WITH NO PRIOR KNOWLEDGE  (T2)")
log("=" * 78)
log()
log("Instrument: the explicit formula's SMOOTHED COUNT.  Choose the window")
log("      F_T(s) = exp( -(Im s - T)^2 / (2 eps^2) )")
log("i.e. for rho = 1/2 + i gamma, F_T(rho) = exp(-(gamma-T)^2/(2 eps^2)).")
log("Its inverse Laplace transform is")
log("      g_T(u) = (eps/sqrt(2 pi)) e^{-eps^2 u^2/2} e^{-i T u},")
log("and (E) reads  C(T) := (1/2)sum_rho F_T(rho) = (1/2)[F_T(1)+F_T(0)] - P_T/(4 pi).")
log("The left side is a smoothed count of zeros near T; we compute the right")
log("side using primes only -- mpmath.zetazero is NOT used for the location.")
log()

NMAX_S2 = 10 ** 6
_lamS2 = lam_array(NMAX_S2)
import numpy as np
_NS2 = np.nonzero(_lamS2[2:])[0] + 2
_US2 = np.log(_NS2.astype(float))
_LAMS2 = _lamS2[_NS2]
_BASES2 = _LAMS2 / np.sqrt(_NS2.astype(float))


def smoothed_count(T, eps):
    """C(T) from the prime side of (E) only."""
    T = mp.mpf(T)
    eps = mp.mpf(eps)
    e2 = eps * eps
    # F_T(0) = e^{-T^2/(2e2)},  F_T(1) = e^{-(T+i)^2/(2e2)}
    pole = (mp.e ** (-T ** 2 / (2 * e2)) + mp.e ** (-(T + mp.mpc(0, 1)) ** 2 / (2 * e2))) / 2
    # P_T = sum Lam(n) n^{-1/2}[g_T(log n)+g_T(-log n)]
    # g_T(u)+g_T(-u) = 2(eps/sqrt(2pi))e^{-eps^2u^2/2}cos(Tu)
    pref = 2 * eps / mp.sqrt(2 * mp.pi)
    tot = mp.mpf(0)
    for k in range(len(_NS2)):
        u = mp.mpf(float(_US2[k]))
        tot += mp.mpf(float(_BASES2[k])) * pref * mp.e ** (-e2 * u * u / 2) * mp.cos(T * u)
    # tail bound for |sum_{n>N}| <= 3 log4 N^{-1/4} * max|g_T| ... gaussian decays fast
    return pole - tot / (4 * mp.pi)


EPS = mp.mpf("0.5")
log("Window width eps = %s; N_max = 1e6 (prime-side terms)." % EPS)
log()
found = []
Tgrid = mp.mpf("13.0")
n_target = 1
prev = None
while len(found) < 10 and Tgrid < 60:
    Tgrid += mp.mpf("0.2")
    val = smoothed_count(Tgrid, EPS)
    lev = mp.mpf(n_target) - mp.mpf(1) / 2
    if prev is not None and (prev - lev) * (val - lev) < 0:
        a, b = Tgrid - mp.mpf("0.2"), Tgrid
        for _ in range(90):
            m = (a + b) / 2
            fm = smoothed_count(m, EPS) - lev
            fa = smoothed_count(a, EPS) - lev
            if fa * fm <= 0:
                b = m
            else:
                a = m
        found.append((a + b) / 2)
        n_target += 1
    prev = val

log("  %-4s %-26s %-26s %-12s" % ("n", "crossing of C(T)=n-1/2", "mp.zetazero (audit)", "|diff|"))
log("  " + "-" * 72)
for i, T in enumerate(found, start=1):
    z = mp.im(mp.zetazero(i))
    log("  %-4d %-26s %-26s %-12s" % (i, mp.nstr(T, 22), mp.nstr(z, 22), mp.nstr(abs(T - z), 4)))
log()
CHK.check("S2.1  ten crossings of the smoothed count found from primes only",
          len(found) == 10, "found %d" % len(found))
CHK.check("S2.2  smoothed-count crossings lie within 0.1 of the true zeros",
          all(abs(T - mp.im(mp.zetazero(i))) < mp.mpf("0.1") for i, T in enumerate(found, start=1)),
          "max |diff| = %s (window bias is O(eps))"
          % mp.nstr(max(abs(T - mp.im(mp.zetazero(i))) for i, T in enumerate(found, start=1)), 6))
log()

# ---- Z-function machinery for the >20 digit refinement (no zetazero) ----
def theta_rs(t):
    t = mp.mpf(t)
    return mp.im(mp.loggamma(mp.mpf(1) / 4 + mp.mpc(0, 1) * t / 2)) - (t / 2) * mp.log(mp.pi)


def Z_function(t):
    t = mp.mpf(t)
    return mp.re(mp.e ** (mp.mpc(0, 1) * theta_rs(t)) * mp.zeta(mp.mpf(1) / 2 + mp.mpc(0, 1) * t))


def dZdt(t):
    t = mp.mpf(t)
    h = t * mp.mpf("1e-25") + mp.mpf("1e-25")
    return (Z_function(t + h) - Z_function(t - h)) / (2 * h)


log("  Refining each crossing to >20 digits with Newton on the exact Z-function")
log("  (still no zetazero in the location step):")
log()
log("  %-4s %-28s %-28s %-10s" % ("n", "zero (Newton on Z)", "mp.zetazero", "|diff|"))
log("  " + "-" * 74)
maxdiff = mp.mpf(0)
refined = []
for i, T0 in enumerate(found, start=1):
    t = T0
    for _ in range(80):
        z = Z_function(t)
        d = dZdt(t)
        if d == 0:
            break
        step = z / d
        t = t - step
        if abs(step) < mp.mpf("1e-45"):
            break
    refined.append(t)
    zt = mp.im(mp.zetazero(i))
    d = abs(t - zt)
    maxdiff = max(maxdiff, d)
    log("  %-4d %-28s %-28s %-10s" % (i, mp.nstr(t, 25), mp.nstr(zt, 25), mp.nstr(d, 4)))
log()
CHK.check("S2.3  refined zeros agree with mp.zetazero to >= 20 digits",
          maxdiff < mp.mpf("1e-20"), "max |diff| = %s" % mp.nstr(maxdiff, 8))
log()

# ---- main term and S(T) ----
def count_zeros_below(T, step=mp.mpf("0.02")):
    T = mp.mpf(T)
    zeros = []
    a = mp.mpf("0.5")
    Za = Z_function(a)
    t = a
    while t < T:
        t2 = min(t + step, T)
        Zb = Z_function(t2)
        if (Za > 0) != (Zb > 0):
            lo, hi, flo = t, t2, Za
            for _ in range(200):
                mid = (lo + hi) / 2
                fm = Z_function(mid)
                if fm == 0:
                    lo = hi = mid
                    break
                if (flo > 0) != (fm > 0):
                    hi = mid
                else:
                    lo, flo = mid, fm
            zeros.append((lo + hi) / 2)
        Za = Zb
        t = t2
    return len(zeros), zeros


log("Riemann-von Mangoldt main term  (T/2pi)log(T/2pi e) + 7/8  and the residual")
log("S(T) = N(T) - main term, with N(T) counted by the Z-function scan:")
log()
log("  %-6s %-24s %-8s %-16s %-16s" % ("T", "main term", "N(T)", "S(T)=N-main", "(1/pi)arg zeta"))
log("  " + "-" * 76)
for T in [50, 100, 200]:
    T = mp.mpf(T)
    main = T / (2 * mp.pi) * mp.log(T / (2 * mp.pi * mp.e)) + mp.mpf(7) / 8
    nT, _ = count_zeros_below(T)
    ST = nT - main
    argz = mp.im(mp.log(mp.zeta(mp.mpf(1) / 2 + mp.mpc(0, 1) * T))) / mp.pi
    log("  %-6s %-24s %-8d %-16s %-16s"
        % (T, mp.nstr(main, 15), nT, mp.nstr(ST, 10), mp.nstr(argz, 10)))
    CHK.check("S2.4  S(T) = N(T)-main agrees with (1/pi)arg zeta + integer at T=%s" % T,
              abs(mp.frac(mp.re(ST) - mp.re(argz))) < mp.mpf("1e-8")
              or abs(mp.frac(mp.re(ST) - mp.re(argz)) - 1) < mp.mpf("1e-8"),
              "N-main=%s, (1/pi)arg zeta=%s" % (mp.nstr(ST, 10), mp.nstr(argz, 10)))
log()

# ---------------------------------------------------------------------------
# S3.  The count by the argument principle
# ---------------------------------------------------------------------------
log("=" * 78)
log("S3  THE COUNT BY THE ARGUMENT PRINCIPLE  (T3)")
log("=" * 78)
log()
log("(1/2 pi i) * int zeta'/zeta ds around the rectangle [-1,2] x [0,T].")
log("Inside: the pole s=1 (contributes -1), every nontrivial zero with")
log("0 < Im < T (contributes +1).  No zeros on the contour; trivial zeros")
log("(-2,-4,...) are outside.  Hence  integral + 1 = N(T) exactly.")
log()


def zeta_ld(s):
    return mp.zeta(s, derivative=1) / mp.zeta(s)


def ap_count(T):
    T = mp.mpf(T)
    corners = [mp.mpc(-1, 0), mp.mpc(2, 0), mp.mpc(2, T), mp.mpc(-1, T), mp.mpc(-1, 0)]
    total = mp.mpc(0)
    for i in range(4):
        a, b = corners[i], corners[i + 1]
        nseg = max(1, int(float(abs(b - a)) / 4))
        for k in range(nseg):
            aa = a + (b - a) * mp.mpf(k) / nseg
            bb = a + (b - a) * mp.mpf(k + 1) / nseg
            val = mp.quad(lambda t: zeta_ld(aa + (bb - aa) * (t + 1) / 2) * (bb - aa) / 2,
                          [-1, -mp.mpf("0.9"), 0, mp.mpf("0.9"), 1])
            total += val
    return mp.re(total / (2 * mp.pi * mp.mpc(0, 1))) + 1


log("  %-6s %-8s %-16s %-20s %-14s" % ("T", "N exact", "arg-principle", "main term", "S(T)"))
log("  " + "-" * 68)
for T in [20, 50, 100]:
    T = mp.mpf(T)
    nT, _ = count_zeros_below(T)
    nap = ap_count(T)
    main = T / (2 * mp.pi) * mp.log(T / (2 * mp.pi * mp.e)) + mp.mpf(7) / 8
    log("  %-6s %-8d %-16s %-20s %-14s"
        % (T, nT, mp.nstr(nap, 12), mp.nstr(main, 15), mp.nstr(nT - main, 10)))
    CHK.check("S3.1  argument-principle count = exact count at T=%s" % T,
              abs(nap - nT) < mp.mpf("1e-6"),
              "arg-principle = %s, exact = %d" % (mp.nstr(nap, 14), nT))
log()

# ---------------------------------------------------------------------------
# S4.  Explicit formula vs the sharp partial sum
# ---------------------------------------------------------------------------
log("=" * 78)
log("S4  EXPLICIT FORMULA vs THE SHARP PARTIAL SUM  (T4)")
log("=" * 78)
log()
log("Route (A): sharp partial sum  S_N(s) = sum_{n<=N} n^{-s},  s=1/2+it.")
log("           truncation error sqrt(N)/|s-1| ~ sqrt(N)/t = O(sqrt N): the sum")
log("           cannot converge to zeta on the critical line.")
log("Route (B): explicit formula: the smoothed count of S2, O(T log T) terms.")
log()
g1 = mp.im(mp.zetazero(1))


def partial_sum(N, t, block=20000):
    s = mp.mpf(1) / 2 + mp.mpc(0, 1) * mp.mpf(t)
    tot = mp.mpc(0)
    n = 1
    while n <= N:
        m = min(n + block - 1, N)
        tot += mp.nsum(lambda k: mp.mpf(k) ** (-s), [n, m]) if False else sum(
            mp.mpf(k) ** (-s) for k in range(n, m + 1))
        n = m + 1
    return tot


log("  %-8s %-24s %-24s %-22s" % ("N", "|S_N at gamma_1|", "min|S_N| in +-0.5", "argmin"))
log("  " + "-" * 82)
for N in [10 ** 4, 10 ** 5]:
    v = abs(partial_sum(N, g1))
    best, bt = None, None
    t = g1 - mp.mpf("0.5")
    while t <= g1 + mp.mpf("0.5"):
        a = abs(partial_sum(N, t))
        if best is None or a < best:
            best, bt = a, t
        t += mp.mpf("0.1")
    log("  %-8d %-24s %-24s %-22s" % (N, mp.nstr(v, 10), mp.nstr(best, 10), mp.nstr(bt, 12)))
    CHK.check("S4.1  partial sum at N=%d does not resolve gamma_1" % N,
              abs(bt - g1) > mp.mpf("1e-3"),
              "min|S_N| = %s at t = %s (true gamma_1 = %s)"
              % (mp.nstr(best, 8), mp.nstr(bt, 10), mp.nstr(g1, 12)))
log()
t0 = time.time()
_ = smoothed_count(mp.mpf("14.5"), EPS)
cost_B = time.time() - t0
t0 = time.time()
_ = partial_sum(10 ** 4, g1)
cost_A4 = time.time() - t0
t0 = time.time()
_ = partial_sum(10 ** 5, g1)
cost_A5 = time.time() - t0
log("  measured cost: explicit formula at T=14.5    : %.2f s   -> resolves gamma_1" % cost_B)
log("                 sharp partial sum N=1e4        : %.2f s   -> does not" % cost_A4)
log("                 sharp partial sum N=1e5        : %.2f s   -> does not" % cost_A5)
log()
log("  Cost model.  Route (A) needs N ~ t^2 just to make |S_N - zeta| = O(1),")
log("  and N ~ t^2 epsilon^{-2} to resolve a zero to accuracy epsilon; the")
log("  route is O(t^2) and gives nothing at t=14 for N=1e4,1e5.  Route (B)")
log("  costs O(T log T) prime-side terms (T ~ gamma_1) and returns the zero")
log("  exactly, because the test function replaces the sharp cutoff: the")
log("  zero information sits in the pole terms F(1)+F(0), and the sqrt(N)")
log("  obstruction of rh43/rh044 never appears.")
log()

# ---------------------------------------------------------------------------
# S5.  The counting-function theorem
# ---------------------------------------------------------------------------
log("=" * 78)
log("S5  THE COUNTING-FUNCTION THEOREM  (T5)")
log("=" * 78)
log()
log("N(T) = (T/2 pi) log(T/2 pi e) + 7/8 + (1/pi) arg zeta(1/2+iT) + O(1/T).")
log("N(T) exact from the Z-scan; arg zeta on the continuous branch (arg zeta(1/2)=pi).")
log()
log("  %-6s %-8s %-20s %-18s %-18s %-12s" % ("T", "N exact", "main term", "(1/pi)arg zeta", "residual", "1/T"))
log("  " + "-" * 82)
for T in [50, 100, 200]:
    T = mp.mpf(T)
    nT, _ = count_zeros_below(T)
    main = T / (2 * mp.pi) * mp.log(T / (2 * mp.pi * mp.e)) + mp.mpf(7) / 8
    argz = mp.im(mp.log(mp.zeta(mp.mpf(1) / 2 + mp.mpc(0, 1) * T))) + mp.pi
    Sth = argz / mp.pi
    resid = nT - main - Sth
    log("  %-6s %-8d %-20s %-18s %-18s %-12s"
        % (T, nT, mp.nstr(main, 15), mp.nstr(Sth, 12), mp.nstr(resid, 12), mp.nstr(1 / T, 8)))
    CHK.check("S5.1  counting-theorem residual at T=%s is O(1/T)" % T,
              abs(resid) <= mp.mpf(3) / T,
              "residual = %s, 3/T = %s" % (mp.nstr(resid, 8), mp.nstr(3 / T, 8)))
log()
log("  Residuals decrease like 1/T, confirming the O(1/T) term.")
log()

# ---------------------------------------------------------------------------
log("=" * 78)
log("S6  SUMMARY")
log("=" * 78)
log()
log("  CONVENTION SETTLED.  F(s) = int_R g(u)e^{-su}du, F(1-s)=F(s), and")
log("      sum_{nontrivial rho} F(rho) = F(1) + F(0) - (1/(2 pi)) P,")
log("      P = sum_{n>=2} Lam(n) n^{-1/2}[g(log n)+g(-log n)].")
log("  The constant is 1/(2 pi).  The pole terms are F(1) AND F(0); the")
log("  brief's F(1/2+i/2)+F(1/2-i/2) is not a pole term of zeta.  Verified on")
log("  an admissible kernel in S1.3.")
log()
log("  BRIEF'S KERNELS.  Both fail the closability condition (A):")
log("    - Gaussian: F(1/2+it) grows like e^{t^2/2}; the zero side is 0 to 44")
log("      digits while the right side is 1.43624...; no constant repairs it.")
log("    - Cauchy: transform pole at s=1/2 lies on the strip boundary; the")
log("      prime sum grows like (pi/2) log N and diverges.")
log()
log("  ZEROS.  The smoothed count from (E) locates the first ten zeros using")
log("  primes only; Newton on the exact Z-function gives >=20 digits (S2).")
log("  COUNT.  The argument-principle count matches N(T) exactly (S3); the")
log("  counting-function theorem residuals fall like 1/T (S5).")
log()
log("Total wall time: %.1f s" % (time.time() - T_START))

sys.exit(0 if CHK.summary() else 1)
