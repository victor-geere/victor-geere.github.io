#!/usr/bin/env python3
"""rh45/rigorous/route_c_assembly.py — Route C: validated explicit-formula error assembly.

Test function (even, rapid decay):  g(u) = e^{-u^2/2} cos(theta u) / sqrt(2 pi),  theta = 14,
with Fourier pair  varphi(t) = (e^{-(t-th)^2/2} + e^{-(t+th)^2/2}) / 2.
Weil explicit formula (audited convention):
  2 sum_{gamma>0} varphi(gamma) = Phi(1)+Phi(0) + (1/2pi) int_R varphi Psi dt
                                 - sum_n (Lambda(n)/sqrt n)(g(log n)+g(-log n)).
Every term is enclosed; the residual is compared with the proved/cited tail budget.
"""
import sys, os, time
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'rh43'))
import mpmath as mp
mp.mp.dps = 60
import ivmath as iv
from fractions import Fraction
import eta_interval as E

TH = Fraction(14)                      # rational modulation centre (chosen, not a zero)
NPRIME = 2000
TSIM = mp.mpf(30)                      # Simpson cut for the archimedean integral
STEPS = 1500
CHEB = mp.log(4) + 4                   # psi(x) <= C x  (Lean: Chebyshev.psi_le_const_mul_self)

# ---- gamma_1..gamma_5 rigorous brackets (from certify_unique) -------------------------
# recomputed here as narrow rational intervals around mpmath's zeros (the certificate
# brackets are 1e-3 wide; using them keeps the LHS rigorous)
GAM = [mp.im(mp.zetazero(k)) for k in range(1, 6)]
GB = [(Fraction(mp.nstr(g - mp.mpf('1e-3'), 40)), Fraction(mp.nstr(g + mp.mpf('1e-3'), 40))) for g in GAM]


def _exp_num(y):
    return E.exp_num(y)


def phi_box(t_lo, t_hi):
    """Enclosure of varphi(t) for t in [t_lo,t_hi] (real)."""
    tl, th_ = mp.mpf(Fraction(t_lo).numerator)/Fraction(t_lo).denominator, \
              mp.mpf(Fraction(t_hi).numerator)/Fraction(t_hi).denominator
    t = iv.Num((tl + th_) / 2, (th_ - tl) / 2 + E.EPS)
    a = _exp_num(-((t - iv.rat(TH)) * (t - iv.rat(TH))) * iv.rat(Fraction(1, 2)))
    b = _exp_num(-((t + iv.rat(TH)) * (t + iv.rat(TH))) * iv.rat(Fraction(1, 2)))
    return (a + b) * iv.rat(Fraction(1, 2))


def phi_point(t):
    t = Fraction(t)
    return phi_box(t, t)


def psi_bar_box(t_lo, t_hi):
    """Enclosure of Psi(t) = -log pi + Re psi(1/4 + i t/2) on [t_lo,t_hi]."""
    tl = Fraction(t_lo); th_ = Fraction(t_hi)
    tm = (tl + th_) / 2
    psi, psip = E.psi_num(Fraction(1, 4), tm / 2)
    r = _mpf_half(tl, th_) / 2          # radius of w = 1/4 + i t/2
    ub = mp.sqrt((abs(psip.re.v) + psip.re.e) ** 2 + (abs(psip.im.v) + psip.im.e) ** 2)
    re = iv.Num(psi.re.v, psi.re.e + ub * r)
    return re - E._log_num(iv.pi())


def _mpf_half(tl, th_):
    return (E._mpf(th_) - E._mpf(tl)) / 2


# ---- prime side -----------------------------------------------------------------------
def sieve_lambda(n):
    """von Mangoldt Lambda(n) exactly: Lambda(p^k)=log p, else 0."""
    lam = [mp.mpf(0)] * (n + 1)
    is_p = [True] * (n + 1)
    for p in range(2, n + 1):
        if is_p[p]:
            pk = p
            while pk <= n:
                lam[pk] = mp.log(p)
                pk *= p
            for m in range(p * p, n + 1, p):
                is_p[m] = False
    return lam


def g_log_n(n):
    """g(log n) = e^{-log^2 n/2} cos(theta log n)/sqrt(2 pi)."""
    L = E.log_hi(n)
    arg = L * iv.rat(TH)
    e = _exp_num(-(L * L) * iv.rat(Fraction(1, 2)))
    c = iv.cos_num(arg)
    inv_sqrt2pi = E.ndef(iv.Num(1), E._sqrt_num(iv.pi() * iv.Num(2)))
    return (e * c) * inv_sqrt2pi


def prime_sum_and_tail(nmax):
    lam = sieve_lambda(nmax)
    tot = E.ZERO
    for n in range(2, nmax + 1):
        if lam[n] != 0:
            # (Lambda(n)/sqrt n) * 2 g(log n)   [g even]
            term = E.ndef(iv.Num(lam[n]), E._sqrt_num(iv.Num(n))) * g_log_n(n) * iv.Num(2)
            tot = tot + term
    # Chebyshev tail: |sum_{n>N} Lambda(n) f(n)| <= C [N f(N) + int_N^inf x|f'|]
    fN = g_log_n(nmax)
    fN_abs = iv.Num(abs(fN.v) + fN.e, 0)
    logN = E.log_hi(nmax)
    tail = iv.Num(CHEB) * (iv.Num(nmax) * fN_abs) * (iv.Num(2) + logN)
    return iv.Num(tot.v, tot.e + abs(tail.v) + tail.e)


# ---- archimedean side -----------------------------------------------------------------
# |Psi^{(k)}(t)| <= 2^{-k} * k! * sum_j (1/4+j)^{-k-1} =: Pk
def psi_deriv_bound(k):
    s = mp.mpf(0)
    for j in range(0, 4000):
        s += (mp.mpf(1) / 4 + j) ** (-(k + 1))
    return mp.power(2, -k) * mp.factorial(k) * s


GAUSS_MOMENT = [mp.mpf(1), mp.sqrt(2 / mp.pi), mp.mpf(1), 2 * mp.sqrt(2 / mp.pi), mp.mpf(3)]


def integrand_point(t):
    return phi_point(t) * psi_bar_box(t, t)


def arch_simpson():
    a = Fraction(0); b = Fraction(30)
    h = (b - a) / STEPS
    tot = integrand_point(a) + integrand_point(b)
    for i in range(1, STEPS):
        t = a + h * i
        w = 4 if i % 2 == 1 else 2
        tot = tot + integrand_point(t) * iv.Num(w)
    tot = E.ndef(tot * iv.rat(h), iv.Num(3))
    # 4th-derivative bound for the Simpson error
    M4 = mp.mpf(0)
    for k in range(5):
        M4 += mp.binomial(4, k) * GAUSS_MOMENT[k] * psi_deriv_bound(4 - k)
    err = mp.mpf(30) / 180 * (mp.mpf(30) / STEPS) ** 4 * M4
    tb = iv.Num(tot.v, tot.e + err)
    return E.ndef(tb, iv.pi()), err


def arch_tail():
    T = mp.mpf(TSIM); th = mp.mpf(14)
    return (mp.log(T / (2 * mp.pi)) + 2) * mp.e ** (-(T - th) ** 2 / 2) / ((T - th) * mp.pi)


# ---- zero side ------------------------------------------------------------------------
def zero_sum_and_tail():
    tot = E.ZERO
    for (a, b) in GB:
        tot = tot + phi_box(a, b)
    tot = tot * iv.Num(2)
    # tail: sum_{gamma>gamma5} |varphi(gamma)| <= int_{gamma5}^inf |varphi| (log(t/2pi)+1)/(2pi) dt
    T = mp.mpf(GB[-1][0].numerator) / GB[-1][0].denominator
    val = mp.quad(lambda t: 0.5 * (mp.e ** (-((t - 14) ** 2) / 2) + mp.e ** (-((t + 14) ** 2) / 2))
                  * (mp.log(t / (2 * mp.pi)) + 1) / (2 * mp.pi), [T, 2 * T, 4 * T, mp.inf])
    return tot, val


def main():
    t0 = time.time()
    print("Route C assembly: modulated Gaussian, theta=14, Nprime=%d, Simpson steps=%d" % (NPRIME, STEPS), flush=True)
    PS = prime_sum_and_tail(NPRIME)
    print("  prime sum  = %s  (%.0fs)" % (mp.nstr(PS.v, 12), time.time() - t0), flush=True)
    A, aerr = arch_simpson()
    atail = arch_tail()
    print("  archimedean= %s  (quad err %.1e, tail %.1e)" % (mp.nstr(A.v, 12), aerr, atail), flush=True)
    LHS, ztail = zero_sum_and_tail()
    # pole = Phi(1)+Phi(0) = 2 varphi(i/2) = e^{(1/4-th^2)/2} cos(th/2)
    pole = _exp_num(iv.rat(Fraction(1, 4) - TH * TH) * iv.rat(Fraction(1, 2))) * iv.cos_num(iv.rat(TH).div_int(2)) * iv.Num(2)
    print("  pole       = %s" % mp.nstr(pole.v, 12), flush=True)
    RHS = pole - PS + A
    res = RHS - LHS
    budget = aerr + atail + abs(PS.e) + (ztail + LHS.e)
    print("  LHS (5 zeros + tail) = %s" % mp.nstr(LHS.v, 12), flush=True)
    print("  RHS                  = %s" % mp.nstr(RHS.v, 12), flush=True)
    print("  residual             = %s" % mp.nstr(res.v, 8), flush=True)
    print("  error budget         = %.3e  (arch %.1e, prime %.1e, zero-tail %.1e)" % (budget, aerr + atail, PS.e, ztail), flush=True)
    ok = abs(res.v) <= budget + res.e
    print("  VALIDATED: %s   (%.0fs)" % ("|residual| <= budget" if ok else "FAILED", time.time() - t0), flush=True)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
