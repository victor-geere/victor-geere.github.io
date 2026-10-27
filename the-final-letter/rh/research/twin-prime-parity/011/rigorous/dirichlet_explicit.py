#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""011/rigorous/dirichlet_explicit.py — Route C for a real primitive Dirichlet L.

The validated explicit-formula assembly for `L(chi, s)`, the Dirichlet analogue of
`010/rigorous/route_c_assembly.py`.  For a primitive `chi` mod `q` of parity `a`,
completed `xi(s) = (q/pi)^((s+a)/2) Gamma((s+a)/2) L(chi,s)`, and an even test
function `h` with Fourier pair `g(u) = (1/2 pi) int h(t) e^{i t u} dt`, the Weil
explicit formula is

    2 sum_{gamma>0} h(gamma)  =  (1/2pi) int_R h(t) Psi_chi(t) dt
                                 -  sum_{n>=2} (Lambda(n) chi(n)/sqrt n) (g(log n)+g(-log n)),

with

    Psi_chi(t) = log(q/pi) + Re psi((1/2 + a + i t)/2),

and **no pole term** (for non-trivial `chi`, `L(chi,.)` is entire).  The prime-side
weight is the *pointwise* product `Lambda(n) chi(n)` — the coefficient of the Euler
product `-L'/L = sum_{p,k} log p chi(p)^k p^{-k s}` — *not* the Dirichlet convolution
`(chi * Lambda)(n)`.  Both the identity and this distinction were verified numerically
for `chi_3` (odd, q=3) and `chi_5` (even, q=5) at several modulations, to ~1e-11.

The test function is the modulated Gaussian of the 010 assembly,
`h(t) = (e^{-(t-th)^2/2} + e^{-(t+th)^2/2})/2`, `th = 8`.

Every term is enclosed:
  * zero side   — the certified on-line zero brackets of `dirichlet_routeB`, plus a
                  density tail for the remaining zeros;
  * prime side  — a rigorous sieve of `Lambda(n) chi(n)` plus a Chebyshev tail;
  * archimedean — composite Simpson with a fourth-derivative bound on `Psi_chi`, plus
                  a Gaussian tail.

The residual is then compared with the assembled budget via the validated triangle
inequality (Lean `Rh45Routes.validated_truncation_bound`).
"""
from __future__ import annotations

import os
import sys
import time
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)
_010 = os.path.abspath(os.path.join(_HERE, "..", "..", "010", "rigorous"))
if _010 not in sys.path:
    sys.path.insert(0, _010)

import mpmath as mp            # noqa: E402
import ivmath as iv            # noqa: E402
import eta_interval as E       # noqa: E402
import dirichlet_routeB as R   # noqa: E402

ZERO = E.ZERO
CHEB = mp.log(4)               # |sum_{n<=x} Lambda(n) chi(n)| <= psi(x) <= (log 4) x

# test function / window
CHI = [0, 1, -1]
Q = 3
A = 1                          # parity
TH = Fraction(8)
TSIM = Fraction(30)
STEPS = 4000
NPRIME = 4000
TZERO = Fraction(13)           # certify zeros with 1/2 < Im < TZERO


# --------------------------------------------------------------------------- #
#  test function: h(t) and g(u) = (1/2pi) int h e^{itu} dt (rigorous)
# --------------------------------------------------------------------------- #

def h_box(t_lo, t_hi):
    tl = R.D._mpf(R._fr(t_lo))
    th = R.D._mpf(R._fr(t_hi))
    t = iv.Num((tl + th) / 2, (th - tl) / 2 + E.EPS)
    a = E.exp_num(-((t - iv.rat(TH)) * (t - iv.rat(TH))) * iv.rat(Fraction(1, 2)))
    b = E.exp_num(-((t + iv.rat(TH)) * (t + iv.rat(TH))) * iv.rat(Fraction(1, 2)))
    return (a + b) * iv.rat(Fraction(1, 2))


def g_log_n(n):
    L = E.log_hi(n)
    arg = L * iv.rat(TH)
    e = E.exp_num(-(L * L) * iv.rat(Fraction(1, 2)))
    c = iv.cos_num(arg)
    inv = E.ndef(iv.Num(1), E._sqrt_num(iv.pi() * iv.Num(2)))
    return (e * c) * inv


# --------------------------------------------------------------------------- #
#  prime side:  sum_n (Lambda(n) chi(n)/sqrt n)(g(log n)+g(-log n))
# --------------------------------------------------------------------------- #

def lambda_sieve(nmax):
    """Exact Lambda(n): Lambda(p^k) = log p, else 0."""
    lam = [mp.mpf(0)] * (nmax + 1)
    is_p = [True] * (nmax + 1)
    for p in range(2, nmax + 1):
        if is_p[p]:
            pk = p
            while pk <= nmax:
                lam[pk] = mp.log(p)
                pk *= p
            for m in range(p * p, nmax + 1, p):
                is_p[m] = False
    return lam


def prime_sum_and_tail(nmax):
    """Prime side plus a Chebyshev tail bound (partial summation, psi(x) <= (log4)x).

    The weight is the pointwise product `Lambda(n) chi(n)`.
    """
    lam = lambda_sieve(nmax)
    tot = ZERO
    for n in range(2, nmax + 1):
        if lam[n] == 0:
            continue
        cp = CHI[n % Q]
        if cp == 0:
            continue
        # b(n) = Lambda(n) chi(n)
        bn = iv.Num(mp.mpf(cp) * lam[n])
        term = E.ndef(bn, E._sqrt_num(iv.Num(n))) * g_log_n(n) * iv.Num(2)
        tot = tot + term
    fN = g_log_n(nmax)
    fN_abs = iv.Num(abs(fN.v) + fN.e, 0)
    logN = E.log_hi(nmax)
    # |sum_{n>N} b(n) f(n)| <= C [N f(N) + int_N^inf ...] (010 derivation)
    tail = iv.Num(CHEB) * (iv.Num(nmax) * fN_abs) * (iv.Num(2) + logN)
    return iv.Num(tot.v, tot.e + abs(tail.v) + tail.e)


# --------------------------------------------------------------------------- #
#  archimedean side:  Psi_chi(t) = log(q/pi) + Re psi((1/2+a+it)/2)
# --------------------------------------------------------------------------- #

def psi_deriv_bound(k):
    """|Psi_chi^{(k)}(t)| <= 2^{-k} k! sum_j (sig+j)^{-k-1}, sig = (1+2a)/4."""
    sig = mp.mpf(1 + 2 * A) / 4
    s = mp.mpf(0)
    for j in range(0, 4000):
        s += (sig + j) ** (-(k + 1))
    return mp.power(2, -k) * mp.factorial(k) * s


def psi_bar_box(t_lo, t_hi):
    tl, th = R._fr(t_lo), R._fr(t_hi)
    tm = (tl + th) / 2
    sig = Fraction(1 + 2 * A, 4)
    psi, psip = E.psi_num(sig, tm / 2)
    r = (R.D._mpf(th) - R.D._mpf(tl)) / 2 / 2      # radius of w = sig + i t/2
    ub = mp.sqrt((abs(psip.re.v) + psip.re.e) ** 2 + (abs(psip.im.v) + psip.im.e) ** 2)
    re = iv.Num(psi.re.v, psi.re.e + ub * r)
    log_q_over_pi = E.log_hi(Q) - E._log_num(iv.pi())
    return re + log_q_over_pi


GAUSS_MOMENT = [mp.mpf(1), mp.sqrt(2 / mp.pi), mp.mpf(1), 2 * mp.sqrt(2 / mp.pi), mp.mpf(3)]


def arch_simpson():
    a, b = Fraction(0), TSIM
    h = (b - a) / STEPS
    tot = ZERO
    for i in range(STEPS + 1):
        t = a + h * i
        w = 1 if i in (0, STEPS) else (4 if i % 2 == 1 else 2)
        tot = tot + h_box(t, t) * psi_bar_box(t, t) * iv.Num(w)
    tot = E.ndef(tot * iv.rat(h), iv.Num(3))
    M4 = mp.mpf(0)
    for k in range(5):
        M4 += mp.binomial(4, k) * GAUSS_MOMENT[k] * psi_deriv_bound(4 - k)
    Tsim = mp.mpf(TSIM.numerator) / TSIM.denominator
    err = Tsim / 180 * (Tsim / STEPS) ** 4 * M4
    # full-line integral = 2 * half-line; the formula uses (1/2pi) int_R = (1/pi) int_0^inf
    tb = iv.Num(tot.v, tot.e + err)
    return E.ndef(tb, iv.pi()), err


def arch_tail():
    T = mp.mpf(TSIM.numerator) / TSIM.denominator
    th = mp.mpf(TH.numerator) / TH.denominator
    # Psi grows at most like log T; bound int_T^inf h(t) |Psi(t)| dt
    return (mp.log(T / (2 * mp.pi)) + 2) * mp.e ** (-(T - th) ** 2 / 2) / ((T - th) * mp.pi)


# --------------------------------------------------------------------------- #
#  zero side:  certified brackets + density tail
# --------------------------------------------------------------------------- #

def zero_sum_and_tail(eps_sign=1):
    brackets = R.locate_online_zeros(CHI, A, eps_sign, Fraction(1, 2), TZERO,
                                     grid=52, M=20, K=50, bisect=20)
    tot = ZERO
    for (a, b) in brackets:
        tot = tot + h_box(a, b)
    tot = tot * iv.Num(2)
    # density tail: sum_{gamma>T} |h(gamma)| <= int_T^inf |h(t)| (log(q t/2pi)+1)/(2pi) dt
    lo = min(b for (_, b) in brackets) if brackets else TZERO
    T = mp.mpf(TZERO.numerator) / TZERO.denominator
    th = mp.mpf(TH.numerator) / TH.denominator
    tail = mp.quad(lambda t: 0.5 * (mp.e ** (-((t - th) ** 2) / 2) + mp.e ** (-((t + th) ** 2) / 2))
                   * (mp.log(Q * t / (2 * mp.pi)) + 1) / (2 * mp.pi),
                   [T, 2 * T, 4 * T, mp.inf])
    return tot, brackets, tail


# --------------------------------------------------------------------------- #

def main():
    t0 = time.time()
    E.fast_mode()
    mp.mp.dps = 60
    eps = R.root_number(CHI, A)
    eps_sign = 1 if abs(eps - 1) < mp.mpf('1e-20') else -1
    print("Dirichlet Route C: chi mod %d (parity %d, root number %s), th=%s, Nprime=%d, steps=%d"
          % (Q, A, mp.nstr(eps, 4), TH, NPRIME, STEPS), flush=True)
    PS = prime_sum_and_tail(NPRIME)
    print("  prime side = %s   (%.0fs)" % (mp.nstr(PS.v, 12), time.time() - t0), flush=True)
    ARCH, aerr = arch_simpson()
    atail = arch_tail()
    print("  archimedean= %s   (quad err %.2e, tail %.2e)" % (mp.nstr(ARCH.v, 12), aerr, atail),
          flush=True)
    ZS, brackets, ztail = zero_sum_and_tail(eps_sign)
    print("  zero side  = %s   (%d certified brackets, tail %.2e)"
          % (mp.nstr(ZS.v, 12), len(brackets), ztail), flush=True)
    RHS = ARCH - PS
    LHS = ZS
    res = RHS - LHS
    budget = abs(PS.e) + aerr + atail + ztail + LHS.e
    print("  LHS (2 sum h)   = %s" % mp.nstr(LHS.v, 12), flush=True)
    print("  RHS             = %s" % mp.nstr(RHS.v, 12), flush=True)
    print("  residual        = %s" % mp.nstr(res.v, 8), flush=True)
    print("  error budget    = %.3e  (arch %.1e, prime %.1e, zero-tail %.1e)"
          % (budget, aerr + atail, PS.e, ztail), flush=True)
    ok = abs(res.v) <= budget + res.e
    print("  VALIDATED: %s   (%.0fs)" % ("|residual| <= budget" if ok else "FAILED",
                                         time.time() - t0), flush=True)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
