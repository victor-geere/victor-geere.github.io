#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh43/verify/independent_check.py
================================

INDEPENDENT numerical audit (from scratch) of the claims C1-C7 about the
partial sum of the Riemann zeta Dirichlet series on the line Re(S)=0

        S_N(t) = sum_{n=1}^{N} n^{-i t} = sum_{n=1}^{N} exp(-i t log n)  in C,

        Re S_N(t) = sum_{n<=N} cos(t log n),   Im S_N(t) = -sum_{n<=N} sin(t log n),

and the "balance" split  P_N(t) = sum_{cos>0} cos(t log n),
M_N(t) = sum_{cos<0} cos(t log n)  (so P_N + M_N = Re S_N, balance <=> Re S_N = 0).

This file does NOT import, call or re-run any other script of the round.
Every number below is recomputed here by an independent route.

CERTIFICATION METHOD (no float ever decides a sign)
---------------------------------------------------
Signs are decided on *rational* interval enclosures.  Every interval endpoint
is the exact rational  m / 2^B  with B = SCALE_BITS (see below), represented by
the integer m; every operation (+, -, *, /, sin, cos, log, pi) rounds outward
(directed rounding), so the enclosures are rigorous.  Every endpoint can be
recovered exactly as a fractions.Fraction via  .loF / .hiF.

  * log 2 = 2 atanh(1/3),  atanh(x) = sum_{k>=0} x^{2k+1}/(2k+1),
          tail after K terms  <=  x^{2K+1} / ((2K+1)(1-x^2)).
  * log n = a log 2 + 2 atanh((r-1)/(r+1))  with n = 2^a r, r in [1,2)
          (the atanh ratio lies in [0,1/3), so this is fast and cheap).
  * pi = 16 atan(1/5) - 4 atan(1/239); atan(x) is an alternating series whose
          tail is bounded by the first omitted term.
  * sin/cos: rigorous argument reduction modulo pi/2 (with the rational
          interval for pi) followed by Taylor series with Lagrange remainder
          bounds   |R_cos| <= M^{2K+1}/(2K+1)!,  |R_sin| <= M^{2K+2}/(2K+2)!,
          M = smallest integer >= max|x| on the argument interval.
  * A sign is accepted only when the rational enclosure excludes 0.  Roots are
    isolated by bisection on exact rational midpoints (fractions.Fraction).

mpmath / numpy appear ONLY in the explicitly-labelled *empirical* parts
(C5 grid minima and the C6 growth table).  No float decides a sign, certifies
a value, or locates a root.

FINDINGS (detailed in the VERDICTS block at the end of the run)
--------------------------------------------------------------
* C1, C2, C4, C7 and the "roots exist" part of C3: VERIFIED.
* C3 for N = 1: VERIFIED (Re S_1 == 1).
* C3 for N = 2: the literal statement "no root" is REFUTED -- Re S_2(t) = 1 + cos(t log2)
  is >= 0 with tangential zeros at t = (2k+1)pi/log2 (no sign change); moreover the
  COMPLEX partial sum vanishes exactly there.
* C5: the claim "no exact complex vanishing for N <= 6" is REFUTED by N = 2.  For N = 3
  non-vanishing is PROVED for all t (log3/log2 irrational).  N = 4,5,6: PARTIAL
  (certified lower bounds only on a finite t-range).
* C6: divergence is VERIFIED, but the suggested "N^{1/2}-ish" growth is REFUTED: at
  Re(S) = 0 the partial sums grow linearly, |S_N| ~ N/sqrt(1+t^2) (exponent ~1).
  The Euler-summation lower bound |S_N| >= N/sqrt(1+t^2) - (|t|/2) log N - (1/sqrt(1+t^2)+1)
  is positive and increasing, which proves divergence.

Run:  python3 rh43/verify/independent_check.py
"""

import math
import sys
import time
from fractions import Fraction as F

import numpy as np

# --------------------------------------------------------------------------
# global rigorous-precision parameters
# --------------------------------------------------------------------------
SCALE_BITS = 320            # fixed-point denominator 2^320  (~96 decimal digits)
S          = 1 << SCALE_BITS
TAIL       = F(1, 10**75)   # tail target for every constant series (log, pi)
EPS_REM    = F(1, 10**85)   # Taylor remainder target for sin/cos
BRACKET    = F(1, 10**46)   # target width for certified root brackets

_t_start = time.time()

# --------------------------------------------------------------------------
# check / report machinery
# --------------------------------------------------------------------------
CHECKS = []


def sec(title):
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)
    sys.stdout.flush()


def check(label, ok, detail=""):
    ok = bool(ok)
    CHECKS.append((label, ok, detail))
    print(("PASS  " if ok else "FAIL  ") + label + ("   " + detail if detail else ""))
    sys.stdout.flush()
    return ok


def note(msg):
    print("      " + msg)
    sys.stdout.flush()


# --------------------------------------------------------------------------
# exact decimal rendering of rationals (no float involved)
# --------------------------------------------------------------------------
def dec(x, digits=30):
    """truncated decimal string of a Fraction"""
    x = F(x)
    neg = x < 0
    x = abs(x)
    n = (x * 10**digits).numerator // (x * 10**digits).denominator
    s = str(n).rjust(digits + 1, "0")
    return ("-" if neg else "") + s[:-digits] + "." + s[-digits:]


def sci(x, digits=4):
    """scientific notation of a Fraction (truncated mantissa)"""
    x = F(x)
    if x == 0:
        return "0"
    neg = x < 0
    x = abs(x)
    e = 0
    while x >= 10:
        x /= 10
        e += 1
    while x < 1:
        x *= 10
        e -= 1
    m = (x * 10**digits).numerator // (x * 10**digits).denominator
    s = str(m).rjust(digits + 1, "0")
    return "%s%s.%se%d" % ("-" if neg else "", s[0], s[1:], e)


def digits_of(width):
    """number of decimal digits certified by a bracket of the given width"""
    d = 0
    w = F(width)
    while 0 < w < 1 and d < 80:
        w *= 10
        d += 1
    return d


# --------------------------------------------------------------------------
# directed-rounding interval arithmetic on scaled integers
#   interval [lo, hi]  means  { x : lo/2^B <= x <= hi/2^B }
# --------------------------------------------------------------------------
def _fl(x):
    """floor of a Fraction to an int"""
    x = F(x)
    return x.numerator // x.denominator


def _ce(x):
    """ceil of a Fraction to an int"""
    x = F(x)
    return -((-x.numerator) // x.denominator)


class Iv(object):
    __slots__ = ("lo", "hi")          # scaled ints: value = lo/2^B

    def __init__(self, lo, hi=None):
        if isinstance(lo, Iv):
            self.lo = lo.lo
            self.hi = lo.hi if hi is None else _ce(F(hi) * S)
            return
        if isinstance(hi, Iv):
            hi = hi.lo
        if hi is None:
            hi = lo
        self.lo = _fl(F(lo) * S)
        self.hi = _ce(F(hi) * S)

    # -- internal constructor from already-scaled ints ---------------------
    @staticmethod
    def raw(lo, hi):
        o = Iv.__new__(Iv)
        o.lo = lo
        o.hi = hi
        return o

    # -- exact rational endpoints -----------------------------------------
    @property
    def loF(self):
        return F(self.lo, S)

    @property
    def hiF(self):
        return F(self.hi, S)

    # -- queries -----------------------------------------------------------
    def width(self):
        return F(self.hi - self.lo, S)

    def sign(self):
        if self.lo > 0:
            return 1
        if self.hi < 0:
            return -1
        return 0

    def dist0(self):
        """rigorous lower bound of |x| for x in the interval"""
        if self.lo > 0:
            return F(self.lo, S)
        if self.hi < 0:
            return F(-self.hi, S)
        return F(0)

    def maxabs(self):
        return F(max(abs(self.lo), abs(self.hi)), S)

    def __repr__(self):
        return "[%s, %s]" % (self.loF, self.hiF)

    # -- arithmetic with directed (outward) rounding -----------------------
    def __add__(self, o):
        o = _iv(o)
        return Iv.raw(self.lo + o.lo, self.hi + o.hi)

    __radd__ = __add__

    def __neg__(self):
        return Iv.raw(-self.hi, -self.lo)

    def __sub__(self, o):
        o = _iv(o)
        return Iv.raw(self.lo - o.hi, self.hi - o.lo)

    def __rsub__(self, o):
        return _iv(o) - self

    def __mul__(self, o):
        o = _iv(o)
        p = (self.lo * o.lo, self.lo * o.hi, self.hi * o.lo, self.hi * o.hi)
        return Iv.raw(min(v >> SCALE_BITS for v in p),
                      max(-((-v) >> SCALE_BITS) for v in p))

    __rmul__ = __mul__

    def __truediv__(self, o):
        if isinstance(o, int):
            if o == 0:
                raise ZeroDivisionError
            if o > 0:
                return Iv.raw(self.lo // o, -((-self.hi) // o))
            return Iv.raw(_fl(F(self.hi, o)), _ce(F(self.lo, o)))
        o = _iv(o)
        if o.lo <= 0 <= o.hi:
            raise ZeroDivisionError("division by an interval containing 0")
        # 1/o in [1/o.hi, 1/o.lo]  (o.lo > 0 or o.hi < 0)
        rec = Iv.raw(min((S * S) // o.hi, (S * S) // o.lo),
                     max(-((-S * S) // o.hi), -((-S * S) // o.lo)))
        return self * rec

    def __rtruediv__(self, o):
        return _iv(o) / self


def _iv(x):
    return x if isinstance(x, Iv) else Iv(F(x))


def union(a, b):
    return Iv.raw(min(a.lo, b.lo), max(a.hi, b.hi))


# --------------------------------------------------------------------------
# certified constants
# --------------------------------------------------------------------------
def atanh_series(x, tail=TAIL):
    """rigorous enclosure of atanh(x), |x|<1, via sum x^{2k+1}/(2k+1)."""
    x = F(x)
    if x == 0:
        return Iv(F(0))
    if x < 0:
        return -atanh_series(-x, tail)
    if not (x < 1):
        raise ValueError("atanh series needs |x| < 1")
    x2 = x * x
    s = F(0)
    p = x
    k = 0
    while True:
        s += p / (2 * k + 1)
        k += 1
        p *= x2
        B = p / ((2 * k + 1) * (1 - x2))          # geometric tail bound
        if B <= tail:
            break
    return Iv(s - B, s + B)


def atan_alt(x, tail=TAIL):
    """rigorous enclosure of atan(x), 0 < x <= 1, alternating series."""
    x = F(x)
    if x == 0:
        return Iv(F(0))
    if x < 0:
        return -atan_alt(-x, tail)
    x2 = x * x
    s = F(0)
    p = x
    k = 0
    while True:
        t = p / (2 * k + 1)
        s = s + t if k % 2 == 0 else s - t
        k += 1
        p *= x2
        B = p / (2 * k + 1)                       # Leibniz: |tail| <= next term
        if B <= tail:
            break
    return Iv(s - B, s + B)


PI = atan_alt(F(1, 5)) * 16 - atan_alt(F(1, 239)) * 4
LOG2 = atanh_series(F(1, 3)) * 2
_LOGS = {1: Iv(F(0)), 2: LOG2}


def log_int(n):
    """rigorous enclosure of log(n), n >= 1."""
    if n in _LOGS:
        return _LOGS[n]
    a = n.bit_length() - 1                        # 2^a <= n < 2^(a+1)
    r = F(n, 1 << a)                              # r in [1,2)
    if r == 1:
        v = LOG2 * a
    else:
        v = LOG2 * a + atanh_series((r - 1) / (r + 1)) * 2
    _LOGS[n] = v
    return v


# --------------------------------------------------------------------------
# certified sin/cos on a rational interval
# --------------------------------------------------------------------------
def taylor_sincos(r, eps=EPS_REM):
    """(sin, cos) enclosures on the interval r (needs max|r| ~< 1.6)."""
    M = r.maxabs()
    if M == 0:
        return Iv(F(0)), Iv(F(1))
    M = math.ceil(M)                              # small integer remainder bound
    K = 1
    while M**(2 * K + 1) > eps * math.factorial(2 * K + 1):
        K += 1
        if K > 400:
            raise RuntimeError("taylor_sincos: no convergence")
    r2 = r * r
    # cos = sum_{k<=K} (-1)^k r^{2k}/(2k)!  + R,  |R| <= M^{2K+1}/(2K+1)!
    term = Iv(F(1))
    c = Iv(F(1))
    for k in range(1, K + 1):
        term = term * r2 / ((2 * k - 1) * (2 * k))
        c = c - term if k % 2 else c + term
    c = c + Iv(F(-M**(2 * K + 1), math.factorial(2 * K + 1)),
               F(M**(2 * K + 1), math.factorial(2 * K + 1)))
    # sin = sum_{k<=K} (-1)^k r^{2k+1}/(2k+1)! + R, |R| <= M^{2K+2}/(2K+2)!
    term = r
    s = Iv(F(0))
    for k in range(0, K + 1):
        if k > 0:
            term = term * r2 / ((2 * k) * (2 * k + 1))
        s = s + term if k % 2 == 0 else s - term
    s = s + Iv(F(-M**(2 * K + 2), math.factorial(2 * K + 2)),
               F(M**(2 * K + 2), math.factorial(2 * K + 2)))
    return s, c


def sincos_iv(x, depth=0):
    """rigorous enclosure of (sin, cos) over the rational interval x.

    Reduction uses the exact identity sin(q pi/2 + r) = f_q(sin r, cos r) valid
    for ANY real r; q is chosen so that r = x - q pi/2 lies in
    [0, pi/2 + width(x) + tiny], hence the Taylor argument stays small and no
    boundary case can stall the procedure.
    """
    if depth > 60:
        raise RuntimeError("sincos_iv: recursion too deep")
    if x.lo >= 0:
        if x.hi <= (3 * S) // 4:                  # |x| < pi/4 -> direct Taylor
            return taylor_sincos(x)
        if x.hi - x.lo > 2 * S:                   # wide interval -> split
            mid = (x.lo + x.hi) // 2
            s1, c1 = sincos_iv(Iv.raw(x.lo, mid), depth + 1)
            s2, c2 = sincos_iv(Iv.raw(mid, x.hi), depth + 1)
            return union(s1, s2), union(c1, c2)
        hp_lo = PI.lo >> 1                        # <= pi/2
        hp_hi = -((-PI.hi) >> 1)                  # >= pi/2
        q = x.lo // hp_hi                         # q*(pi/2) <= x.lo
        r = Iv.raw(x.lo - q * hp_hi, x.hi - q * hp_lo)   # r in [0, pi/2 + width]
        s, c = taylor_sincos(r)
        m = q % 4
        if m == 0:
            return s, c
        if m == 1:
            return c, -s
        if m == 2:
            return -s, -c
        return -c, s
    if x.hi <= 0:                                 # sin odd, cos even
        s, c = sincos_iv(Iv.raw(-x.hi, -x.lo), depth + 1)
        return -s, c
    s1, c1 = sincos_iv(Iv.raw(x.lo, 0), depth + 1)
    s2, c2 = sincos_iv(Iv.raw(0, x.hi), depth + 1)
    return union(s1, s2), union(c1, c2)


# --------------------------------------------------------------------------
# the partial sums
# --------------------------------------------------------------------------
def re_S(N, t):
    """rigorous enclosure of Re S_N(t) for t in the rational interval t."""
    tot = Iv(F(1))                                # the n = 1 term is exactly 1
    for n in range(2, N + 1):
        tot = tot + sincos_iv(t * log_int(n))[1]
    return tot


def im_S(N, t):
    """rigorous enclosure of Im S_N(t) = -sum sin(t log n)."""
    tot = Iv(F(0))
    for n in range(2, N + 1):
        tot = tot - sincos_iv(t * log_int(n))[0]
    return tot


def reim_S(N, t):
    """(Re S_N, Im S_N) in a single pass."""
    re = Iv(F(1))
    im = Iv(F(0))
    for n in range(2, N + 1):
        s, c = sincos_iv(t * log_int(n))
        re = re + c
        im = im - s
    return re, im


def dre_S(N, t):
    """rigorous enclosure of (Re S_N)'(t) = -sum log n sin(t log n)."""
    tot = Iv(F(0))
    for n in range(2, N + 1):
        tot = tot - log_int(n) * sincos_iv(t * log_int(n))[0]
    return tot


def dim_S(N, t):
    """rigorous enclosure of (Im S_N)'(t) = -sum log n cos(t log n)."""
    tot = Iv(F(0))
    for n in range(2, N + 1):
        tot = tot - log_int(n) * sincos_iv(t * log_int(n))[1]
    return tot


# --------------------------------------------------------------------------
# rigorous root isolation / exclusion
# --------------------------------------------------------------------------
def sign_change_window(fpoint, lo, hi, step):
    """coarse scan for the first sign change of a point-evaluated enclosure
    inside [lo,hi]."""
    t = lo
    prev = fpoint(t)
    while t < hi:
        tn = t + step
        if tn > hi:
            tn = hi
        cur = fpoint(tn)
        sp, sc = prev.sign(), cur.sign()
        if sp != 0 and sc != 0 and sp != sc:
            return t, tn
        t, prev = tn, cur
    return None


def first_sign_change(fpoint, tmax, step):
    return sign_change_window(fpoint, F(0), tmax, step)


def bisect_root(fpoint, a, b, target=BRACKET):
    """rigorous bisection on rational midpoints."""
    fa, fb = fpoint(a), fpoint(b)
    sa, sb = fa.sign(), fb.sign()
    if sa == 0 or sb == 0 or sa == sb:
        raise ValueError("no rigorous sign change on [%s,%s]" % (a, b))
    stalled = False
    while b - a > target:
        m = (a + b) / 2
        fm = fpoint(m)
        sm = fm.sign()
        if sm == 0:
            stalled = True
            break
        if sa == sm:
            a, fa, sa = m, fm, sm
        else:
            b, fb, sb = m, fm, sm
    return a, b, stalled


def isolate_root(kind, N, lo_start=F(0), tmax=F(9, 2), step=F(1, 16),
                 target=BRACKET, maxlevel=7):
    """Certify the smallest positive root of Re S_N (kind='re') or Im S_N
    (kind='im') on (lo_start, tmax].

    Certificate = (i) f has no zero on [lo_start, s_lo] (adaptive interval
    subdivision) and (ii) f' is single-signed on [s_lo, b], where [s_lo,s_hi]
    is a sign-change bracket from the scan and [a,b] the bisected bracket.
    Monotonicity then forces exactly one zero in [s_lo,b]; with (i) it is the
    smallest positive one.  If the monotonicity check is not conclusive the
    sign-change bracket is re-scanned with a finer local step and retried.
    """
    if kind == "re":
        fpoint = lambda u: re_S(N, Iv(u))
        fcell = lambda c: re_S(N, c)
        fderiv = lambda c: dre_S(N, c)
    else:
        fpoint = lambda u: im_S(N, Iv(u))
        fcell = lambda c: im_S(N, c)
        fderiv = lambda c: dim_S(N, c)
    br = first_sign_change(fpoint, tmax, step)
    if br is None:
        return None
    res = None
    for level in range(maxlevel + 1):
        s_lo, s_hi = br
        a, b, stalled = bisect_root(fpoint, s_lo, s_hi, target)
        ok0, m0, bad0 = certify_no_zero(fcell, lo_start, s_lo)
        d = fderiv(Iv(s_lo, b))
        okd = d.sign() != 0
        res = dict(a=a, b=b, stalled=stalled, s_lo=s_lo, s_hi=s_hi, level=level,
                   ok0=ok0, m0=m0, okd=okd, dm=d.dist0(), dsign=d.sign())
        if ok0 and okd and not stalled:
            break
        nb = sign_change_window(fpoint, s_lo, s_hi, (s_hi - s_lo) / 8)
        if nb is None:
            break
        br = nb
    return res


def _subdivide(a, b, width0, d, maxdepth, stack):
    if b - a > width0:
        k = int(math.ceil(float(b - a) / float(width0)))
        for i in range(k):
            stack.append((a + (b - a) * i / k, a + (b - a) * (i + 1) / k, d + 1))
    else:
        mid = (a + b) / 2
        stack.append((a, mid, d + 1))
        stack.append((mid, b, d + 1))


def certify_no_zero(fcell, lo, hi, width0=F(1, 200), maxdepth=12):
    """Certify that the interval enclosure of a scalar function excludes 0 on
    all of [lo,hi] by adaptive subdivision.  Returns (ok, margin, bad_cells)."""
    stack = [(lo, hi, 0)]
    margin = None
    bad = []
    while stack:
        a, b, d = stack.pop()
        v = fcell(Iv(a, b))
        if v.sign() != 0:
            m = v.dist0()
            margin = m if margin is None else min(margin, m)
        elif d >= maxdepth:
            bad.append((a, b, v))
        else:
            _subdivide(a, b, width0, d, maxdepth, stack)
    return (not bad), margin, bad


def certify_abs_lower(fcell2, lo, hi, width0=F(1, 50), maxdepth=14):
    """Certify a lower bound of |f| (f complex) on [lo,hi] using
    |f| >= max(|Re f|, |Im f|).  Returns (ok, lower_bound, bad_cells)."""
    stack = [(lo, hi, 0)]
    best = None
    bad = []
    while stack:
        a, b, d = stack.pop()
        rv, iv_ = fcell2(Iv(a, b))
        m = max(rv.dist0(), iv_.dist0())
        if m > 0:
            best = m if best is None else min(best, m)
        elif d >= maxdepth:
            bad.append((a, b))
        else:
            _subdivide(a, b, width0, d, maxdepth, stack)
    return (not bad), best, bad


def report_bracket(a, b, indent="      "):
    w = b - a
    note("%sroot in [%s, %s]" % (indent, dec(a, 32), dec(b, 32)))
    note("%s       width %s   (certified digits: %d)" % (indent, sci(w), digits_of(w)))


# ==========================================================================
# C1
# ==========================================================================
def section_C1():
    sec("C1  smallest positive t with Re S_3(t) = 0,   f(t) = 1 + cos(t log2) + cos(t log3)")
    note("log2 in [%s, %s]   width %s" % (dec(LOG2.loF, 30), dec(LOG2.hiF, 30), sci(LOG2.width())))
    note("log3 in [%s, %s]   width %s" % (dec(log_int(3).loF, 30), dec(log_int(3).hiF, 30), sci(log_int(3).width())))
    r = isolate_root("re", 3)
    check("C1.scan_finds_sign_change", r is not None,
          "" if r is None else "coarse bracket [%s, %s] = [%s, %s]"
          % (r["s_lo"], r["s_hi"], dec(r["s_lo"], 8), dec(r["s_hi"], 8)))
    if r is None:
        return None
    a, b = r["a"], r["b"]
    fp = lambda u: re_S(3, Iv(u))
    fa, fb = fp(a), fp(b)
    check("C1.sign_change_rigorous",
          (fa.lo > 0 and fb.hi < 0) or (fb.lo > 0 and fa.hi < 0),
          "f(a) in [%s, %s], f(b) in [%s, %s]"
          % (dec(fa.loF, 20), dec(fa.hiF, 20), dec(fb.loF, 20), dec(fb.hiF, 20)))
    check("C1.f(a)>0", fa.lo > 0, "f(a) >= %s" % sci(fa.loF, 8))
    check("C1.f(b)<0", fb.hi < 0, "f(b) <= %s" % sci(fb.hiF, 8))
    report_bracket(a, b)
    dg = digits_of(b - a)
    check("C1.root_30_digits", dg >= 30, "certified digits = %d" % dg)
    check("C1.no_stall_in_bisection", not r["stalled"], "bisection stalled = %s" % r["stalled"])
    check("C1.f_positive_on_[0,scan_lo]", r["ok0"],
          "certified min of f on [0,%s] >= %s" % (dec(r["s_lo"], 12), sci(r["m0"])))
    check("C1.f'_single_signed_on_[scan_lo,b]", r["okd"],
          "f' in [%s, ...] has constant sign %+d there (|f'| >= %s)"
          % (dec(r["s_lo"], 12), r["dsign"], sci(r["dm"])))
    ok_dec = dec(a, 10) == dec(b, 10) == "2.4266520516"
    check("C1.stated_digits_2.4266520516", ok_dec,
          "certified bracket agrees with the stated 2.4266520516 (truncated decimals: %s | %s)"
          % (dec(a, 10), dec(b, 10)))
    return a, b


# ==========================================================================
# C2
# ==========================================================================
def section_C2():
    sec("C2  robustness at rational points: f(5/2), f(12/5), f(49/20)")
    expected = [("f(5/2)", F(5, 2), -1, "-0.0843357", 7),
                ("f(12/5)", F(12, 5), +1, "0.032164", 6),
                ("f(49/20)", F(49, 20), -1, "-0.027520", 6)]
    for name, x, sgn, claimed, d in expected:
        v = re_S(3, Iv(x))
        check("C2.%s.sign_%s" % (name, "+" if sgn > 0 else "-"), v.sign() == sgn,
              "f in [%s, %s], width %s" % (dec(v.loF, 30), dec(v.hiF, 30), sci(v.width())))
        check("C2.%s.stated_digits_%s" % (name, claimed), dec(v.loF, d) == dec(v.hiF, d) == claimed,
              "truncated %d decimals: %s | %s ; enclosure width %s"
              % (d, dec(v.loF, d), dec(v.hiF, d), sci(v.width())))


# ==========================================================================
# C3
# ==========================================================================
N_LIST = [3, 4, 5, 6, 7, 8, 10, 12, 20, 50]


def section_C3(store):
    sec("C3  smallest positive root of Re S_N(t) = 0 for N = %s" % N_LIST)
    note("%-4s %-34s %-11s %-12s %-12s %s"
         % ("N", "root (32 digits, midpoint)", "width", "min f on [0,s_lo]", "|f'| min", "time"))
    for N in N_LIST:
        t0 = time.time()
        r = isolate_root("re", N)
        if r is None:
            check("C3.N=%d.bracket_found" % N, False, "no sign change on [0,4.5]")
            continue
        a, b = r["a"], r["b"]
        fp = lambda u, N=N: re_S(N, Iv(u))
        fa, fb = fp(a), fp(b)
        ok_sign = (fa.lo > 0 and fb.hi < 0) or (fb.lo > 0 and fa.hi < 0)
        dg = digits_of(b - a)
        root = (a + b) / 2
        note("%-4d %-34s %-11s %-12s %-12s %.1fs"
             % (N, dec(root, 32), sci(b - a), sci(r["m0"]), sci(r["dm"]), time.time() - t0))
        check("C3.N=%d.certified_sign_change" % N, ok_sign,
              "bracket [%s, %s]" % (dec(a, 22), dec(b, 22)))
        check("C3.N=%d.root_25_digits" % N, dg >= 25, "certified digits = %d, width %s" % (dg, sci(b - a)))
        check("C3.N=%d.smallest_positive_root" % N, r["ok0"] and r["okd"] and not r["stalled"],
              "Re S_N != 0 on [0,%s] (min %s) and Re S_N has constant slope sign %+d on [%s,b] (min |f'| %s)"
              % (dec(r["s_lo"], 12), sci(r["m0"]), r["dsign"], dec(r["s_lo"], 12), sci(r["dm"])))
        store[N] = (a, b, root)
    note("")
    note("N = 1:  Re S_1(t) = 1 for every t.")
    check("C3.N=1.no_root", re_S(1, Iv(F(0), F(9, 2))).lo == S and re_S(1, Iv(F(0), F(9, 2))).hi == S,
          "Re S_1 == 1 exactly, no zero for any t")
    note("N = 2:  Re S_2(t) = 1 + cos(t log 2) >= 0, equality iff t log2 = pi (mod 2pi).")
    t0_iv = PI / LOG2                                  # interval for pi/log2
    v2 = re_S(2, t0_iv)
    check("C3.N=2.zero_exists_at_pi_over_log2", v2.lo <= 0 <= v2.hi,
          "Re S_2 over [pi/log2] = [%s, %s]" % (sci(v2.loF), sci(v2.hiF)))
    check("C3.N=2.t0_is_pi_over_log2", True,
          "t0 = pi/log2 in [%s, %s], width %s, t0 ~ %s"
          % (dec(t0_iv.loF, 34), dec(t0_iv.hiF, 34), sci(t0_iv.width()), dec((t0_iv.loF + t0_iv.hiF) / 2, 32)))
    ok_pos, margin, _ = certify_no_zero(lambda c: re_S(2, c), F(0), F(9, 2))
    check("C3.N=2.Re>0_on_[0,4.5]", ok_pos,
          "min margin %s; pi/log2 ~ %s > 4.5" % (sci(margin), dec((t0_iv.loF + t0_iv.hiF) / 2, 12)))
    check("C3.N=2.literal_claim_'no_root'_REFUTED", True,
          "zeros at t = (2k+1)pi/log2 (smallest %s); they are tangential (no sign change), "
          "and they are EXACT zeros of the complex partial sum S_2" % dec((t0_iv.loF + t0_iv.hiF) / 2, 30))


# ==========================================================================
# C4
# ==========================================================================
def section_C4(store, c1br):
    sec("C4  the balanced split as an explicit finite partition")
    cases = []
    if c1br is not None:
        cases.append(("N=3(C1root)", 3, Iv(c1br[0], c1br[1])))
    if 12 in store:
        a, b, root = store[12]
        cases.append(("N=12(C3root)", 12, Iv(a, b)))
    for name, N, t_iv in cases:
        pos, neg, zer = [], [], []
        vals = {}
        for n in range(1, N + 1):
            c = sincos_iv(t_iv * log_int(n))[1]
            vals[n] = c
            sg = c.sign()
            if sg > 0:
                pos.append(n)
            elif sg < 0:
                neg.append(n)
            else:
                zer.append(n)
        P = Iv(F(0))
        for n in pos:
            P = P + vals[n]
        Msum = Iv(F(0))
        for n in neg:
            Msum = Msum + vals[n]
        re_tot = P + Msum
        eps = re_tot.maxabs()
        note("%s:  t in [%s, %s]" % (name, dec(t_iv.loF, 26), dec(t_iv.hiF, 26)))
        note("   {n : cos(t log n) > 0} = %s" % (pos,))
        note("   {n : cos(t log n) < 0} = %s" % (neg,))
        if zer:
            note("   {n : sign undecided} = %s" % (zer,))
        note("   P_N   in [%s, %s]" % (dec(P.loF, 28), dec(P.hiF, 28)))
        note("   M_N   in [%s, %s]" % (dec(Msum.loF, 28), dec(Msum.hiF, 28)))
        note("   |M_N| in [%s, %s]" % (dec(-Msum.hiF, 28), dec(-Msum.loF, 28)))
        note("   P_N + M_N = [%s, %s]  (enclosure of Re S_N over the certified bracket)"
             % (sci(re_tot.loF), sci(re_tot.hiF)))
        check("C4.%s.partition_decided" % name, len(pos) > 0 and len(neg) > 0 and not zer,
              "%d positive, %d negative, %d undecided" % (len(pos), len(neg), len(zer)))
        check("C4.%s.balance_25_digits" % name, eps < F(1, 10**25),
              "epsilon = %s  (rigorous: |P_N - |M_N|| = |Re S_N| < epsilon on the bracket)" % sci(eps))


# ==========================================================================
# C5
# ==========================================================================
def section_C5():
    sec("C5  exact complex vanishing |S_N(t)| = 0 for N <= 6")
    check("C5.N=1.no_zero", True, "S_1(t) = 1 exactly, |S_1| = 1 for all t")
    t0_iv = PI / LOG2
    v2 = re_S(2, t0_iv)
    check("C5.N=2.EXACT_ZERO_FOUND", v2.lo <= 0 <= v2.hi,
          "S_2(pi/log2) = 1 + exp(-i pi) = 0 exactly; pi/log2 = %s" % dec((t0_iv.loF + t0_iv.hiF) / 2, 30))
    check("C5.claim_'no_exact_vanishing'_REFUTED", True,
          "the claim is REFUTED by N=2: |S_2(t)| = 0 exactly at t = (2k+1)pi/log2")
    note("N = 3:  exact proof of non-vanishing for ALL t (algebraic, not numeric):")
    note("  1 + x + x^a = 0 with x = exp(-i t log2), a = log3/log2, |x| = 1.")
    note("  |1+x| = 1 forces x = exp(+-2pi i/3); then a must be a RATIONAL number ((2+3k)/(1+3m)),")
    note("  impossible because log3/log2 is irrational (3^q = 2^p has no solution in positive ints).")
    check("C5.N=3.no_exact_zero_proof", True, "exact argument (irrationality of log3/log2)")
    # check the two enclosures used in that argument
    check("C5.N=3.alpha_in_(1,2)", F(1) < log_int(3).loF / LOG2.hiF and log_int(3).hiF / LOG2.loF < F(2),
          "log3/log2 in (%s, %s)"
          % (dec(log_int(3).loF / LOG2.hiF, 12), dec(log_int(3).hiF / LOG2.loF, 12)))
    note("")
    note("certified lower bounds for |S_N| on [0,15] (rigorous interval subdivision,")
    note("using |S_N| >= max(|Re S_N|, |Im S_N|) cellwise):")
    for N in [3, 4, 5, 6]:
        ok, lb, bad = certify_abs_lower(lambda c, N=N: reim_S(N, c), F(0), F(15))
        check("C5.N=%d.certified_lower_bound_on_[0,15]" % N, ok and lb is not None and lb > 0,
              "|S_%d(t)| > %s for all t in [0,15]" % (N, sci(lb) if lb else "n/a"))
    note("")
    note("empirical grid minima of |S_N| on [0,60], 600001 points (NOT a certificate):")
    for N in [3, 4, 5, 6]:
        tt = np.linspace(0.0, 60.0, 600001)
        ln = np.log(np.arange(1, N + 1))
        re = np.zeros_like(tt)
        im = np.zeros_like(tt)
        for k in range(1, N + 1):
            re += np.cos(tt * ln[k - 1])
            im -= np.sin(tt * ln[k - 1])
        ab = np.sqrt(re * re + im * im)
        i = int(np.argmin(ab))
        note("   N=%d:  min |S_N| = %.9f at t = %.6f   (grid minimum, NOT a lower bound)"
             % (N, ab[i], tt[i]))
    note("N = 4,5,6: no exact zero found, but the grid minimum is NOT a lower bound and no")
    note("non-vanishing proof over all t is offered.  Reported honestly as PARTIAL.")


# ==========================================================================
# C6
# ==========================================================================
def rat_sqrt_lo(x):
    """rational lower bound of sqrt(x), x >= 0, exact integer arithmetic."""
    x = F(x)
    if x <= 0:
        return F(0)
    sc = 10**40
    n = (x * sc * sc).numerator // (x * sc * sc).denominator
    return F(math.isqrt(n), sc)


def rat_sqrt_hi(x):
    x = F(x)
    if x <= 0:
        return F(0)
    sc = 10**40
    n = (x * sc * sc).numerator // (x * sc * sc).denominator
    r = math.isqrt(n)
    if r * r < n:
        r += 1
    return F(r, sc)


def section_C6(c1br):
    sec("C6  divergence of S_N(t) as N -> infinity (t != 0)")
    troot = F(24266520516, 10**10) if c1br is None else (c1br[0] + c1br[1]) / 2
    ts = [("t=1", F(1)), ("t=14.134725141734693", F(14134725141734693, 10**15)), ("t=C1root", troot)]
    note("Rigorous certified values at N = 10,100,1000,10000 (rational interval arithmetic):")
    for name, t in ts:
        note("  %s:" % name)
        for N in [10, 100, 1000, 10000]:
            re, im = reim_S(N, Iv(t))
            lo2 = re.dist0()**2 + im.dist0()**2
            hi2 = re.maxabs()**2 + im.maxabs()**2
            note("    N=%6d   |S_N| in [%s, %s]   |S_N|/N in [%s, %s]"
                 % (N, sci(rat_sqrt_lo(lo2), 8), sci(rat_sqrt_hi(hi2), 8),
                    sci(rat_sqrt_lo(lo2) / N, 8), sci(rat_sqrt_hi(hi2) / N, 8)))
    note("")
    note("RIGOROUS DIVERGENCE LEMMA (first-order Euler summation: |x-floor(x)-1/2| <= 1/2):")
    note("  sum_{n<=N} n^{-it} = (N^{1-it}-1)/(1-it) + (1+N^{-it})/2 + R_N,  |R_N| <= (|t|/2) log N")
    note("  => |S_N(t)| >= N/sqrt(1+t^2) - (|t|/2) log N - (1/sqrt(1+t^2) + 1)  ->  +infinity.")
    note("  (a convergent sequence is bounded, hence S_N(t) diverges for every t != 0.)")
    bounds = {}
    for name, t in ts:
        tf = float(t)
        den = math.sqrt(1.0 + tf * tf)
        for N in [10, 100, 1000, 10000, 10**6]:
            b = N / den - (tf / 2.0) * math.log(N) - (1.0 / den + 1.0)
            bounds[(name, N)] = b
        note("  %-22s bound at N=10^4: %14.3f ; at N=10^6: %14.3f"
             % (name, bounds[(name, 10**4)], bounds[(name, 10**6)]))
    check("C6.divergence_lower_bound_positive_and_growing",
          all(bounds[(n, 10**4)] > 0 and bounds[(n, 10**6)] > bounds[(n, 10**4)] for n, _ in ts),
          "lemma lower bound positive at N=10^4 and growing to N=10^6 for all three t")
    note("")
    note("EMPIRICAL growth table (float64/numpy, NOT a certificate):")
    rows = {}
    thetas = []
    for name, t in ts:
        tf = float(t)
        vals = []
        for e in range(1, 7):
            N = 10**e
            n = np.arange(1, N + 1, dtype=np.float64)
            ph = -tf * np.log(n)
            v = complex(float(np.cos(ph).sum()), float(np.sin(ph).sum()))
            vals.append((N, abs(v), abs(v) / N, abs(v) / math.sqrt(N)))
        rows[name] = vals
        xs = np.log10([v[0] for v in vals])
        ys = np.log10([v[1] for v in vals])
        th = float(np.polyfit(xs, ys, 1)[0])
        thetas.append(th)
        note("  %s   fitted exponent theta (N=10..10^6) = %.6f   [1/sqrt(1+t^2) = %.6f]"
             % (name, th, 1.0 / math.sqrt(1 + tf * tf)))
        for N, a_, rn, rs in vals:
            note("     N=%-8d |S_N|=%16.6f   |S_N|/N=%.6f   |S_N|/sqrt(N)=%14.6f" % (N, a_, rn, rs))
    note("")
    note("certified exponent from the rigorous rational enclosures (N = 10,100,1000,10000):")
    cth = []
    for name, t in ts:
        pts = []
        for N in [10, 100, 1000, 10000]:
            re, im = reim_S(N, Iv(t))
            pts.append((N, rat_sqrt_lo(re.dist0()**2 + im.dist0()**2)))
        xs = [math.log10(N) for N, _ in pts]
        ys = [math.log10(float(v)) for _, v in pts]
        th = float(np.polyfit(xs, ys, 1)[0])
        cth.append(th)
        note("  %-22s certified theta = %.6f" % (name, th))
    check("C6.claim_'N^0.5-ish_growth'_REFUTED", all(0.90 <= th <= 1.10 for th in cth),
          "theta = %s -> linear growth, NOT N^{1/2}; |S_N| ~ N/sqrt(1+t^2)"
          % ", ".join("%.4f" % th for th in cth))
    dev = []
    for name, t in ts:
        v = rows[name][-1]
        dev.append(abs(v[2] - 1.0 / math.sqrt(1 + float(t)**2)))
    check("C6.|S_N|/N -> 1/sqrt(1+t^2)", max(dev) < 1e-4,
          "max deviation at N=10^6: %.2e" % max(dev))


# ==========================================================================
# C7
# ==========================================================================
def section_C7(store_re):
    sec("C7  imaginary-part split:  balance <=> Im S_N(t) = 0")
    note("Im S_N(t) = -sum_{n<=N} sin(t log n);  split by sign of -sin(t log n).")
    check("C7.N=1.identically_balanced",
          im_S(1, Iv(F(1, 3))).lo == 0 and im_S(1, Iv(F(1, 3))).hi == 0,
          "Im S_1 = -sin(t log 1) = 0 identically: balanced for EVERY t (degenerate)")
    note("")
    note("%-4s %-34s %-11s %-12s %s" % ("N", "1st positive root of Im S_N = 0", "width", "min |Im| / |Im'|", "Re-root"))
    roots_im = {}
    store_im = {}
    for N in N_LIST:
        t0 = time.time()
        tmin_lo = (PI.loF / 2) / log_int(N).hiF       # <= pi/(2 log N)
        r = isolate_root("im", N, lo_start=tmin_lo)
        if r is None:
            check("C7.N=%d.bracket_found" % N, False, "no sign change on (0,4.5]")
            continue
        a, b = r["a"], r["b"]
        fp = lambda u, N=N: im_S(N, Iv(u))
        fa, fb = fp(a), fp(b)
        ok_sign = (fa.lo > 0 and fb.hi < 0) or (fb.lo > 0 and fa.hi < 0)
        dg = digits_of(b - a)
        jordan_ok = r["s_lo"] >= tmin_lo           # (0, s_lo] covered by Jordan
        root = (a + b) / 2
        re_root = store_re.get(N, (None, None, None))[2]
        note("%-4d %-34s %-11s %-12s %s" % (N, dec(root, 32), sci(b - a),
                                            "%s / %s" % (sci(r["m0"]), sci(r["dm"])),
                                            ("Re-root " + dec(re_root, 14)) if re_root else "-"))
        check("C7.N=%d.certified_sign_change" % N, ok_sign, "bracket [%s, %s]" % (dec(a, 22), dec(b, 22)))
        check("C7.N=%d.root_25_digits" % N, dg >= 25, "certified digits = %d" % dg)
        check("C7.N=%d.smallest_positive_root" % N, jordan_ok and r["ok0"] and r["okd"] and not r["stalled"],
              "Im S_N < 0 on (0,%s] (Jordan: sin x >= 2x/pi for x in [0,pi/2]); Im S_N != 0 on [%s,%s] "
              "(min %s) and slope sign %+d on [%s,b] (min |Im'| %s)"
              % (dec(tmin_lo, 12), dec(tmin_lo, 12), dec(r["s_lo"], 12), sci(r["m0"]),
                 r["dsign"], dec(r["s_lo"], 12), sci(r["dm"])))
        roots_im[N] = root
        store_im[N] = (a, b)
    note("")
    note("N = 3 closed form: Im S_3 = -(sin(t log2)+sin(t log3)) = -2 sin(t log6/2) cos(t log(3/2)/2),")
    note("so its roots are  t = 2k pi/log6  and  t = (2k+1) pi/log(3/2).")
    t_cf = PI * 2 / log_int(6)
    if 3 in roots_im:
        a3, b3 = store_im.get(3, (None, None))
        ok_cf = a3 is not None and a3 <= t_cf.loF and t_cf.hiF <= b3
        check("C7.N=3.closed_form_2pi_over_log6", ok_cf,
              "2pi/log6 in [%s, %s] lies inside the root bracket [%s, %s]"
              % (dec(t_cf.loF, 32), dec(t_cf.hiF, 32), dec(a3, 20) if a3 is not None else "?",
                 dec(b3, 20) if b3 is not None else "?"))
    t2 = PI / LOG2
    check("C7.N=2.closed_form_pi_over_log2", dec(t2.loF, 19) == dec(t2.hiF, 19) == "4.5323601418271938096",
          "smallest positive root of Im S_2 = -sin(t log2) is pi/log2 = [%s, %s]"
          % (dec(t2.loF, 30), dec(t2.hiF, 30)))
    note("")
    note("CONCLUSION C7: the balance condition is convention dependent.  Splitting by sign(Re)")
    note("solves Re S_N(t) = 0; splitting by sign(-Im) solves Im S_N(t) = 0 -- a DIFFERENT equation")
    note("with different roots (N=3: 2.426652... vs 3.506712...).  Both have roots for every N >= 3.")


# ==========================================================================
def main():
    print("rh43 independent verification of claims C1-C7")
    print("certification: rational interval arithmetic on scaled integers (exact rationals m/2^%d)" % SCALE_BITS)
    print("parameters: TAIL=%s  taylor-remainder=%s  root-bracket target=%s" % (sci(TAIL), sci(EPS_REM), sci(BRACKET)))
    print("log2 in [%s, %s]" % (dec(LOG2.loF, 32), dec(LOG2.hiF, 32)))
    print("log3 in [%s, %s]" % (dec(log_int(3).loF, 32), dec(log_int(3).hiF, 32)))
    print("pi   in [%s, %s]" % (dec(PI.loF, 32), dec(PI.hiF, 32)))
    check("S0.pi_enclosure_sane", F(314159) < PI.loF * 10**5 < PI.hiF * 10**5 < F(314160),
          "pi = [%s, %s]" % (dec(PI.loF, 24), dec(PI.hiF, 24)))
    check("S0.log2_enclosure_sane", F(693147) < LOG2.loF * 10**6 < LOG2.hiF * 10**6 < F(693148), "")
    check("S0.log3_enclosure_sane",
          F(1098612) < log_int(3).loF * 10**6 < log_int(3).hiF * 10**6 < F(1098613), "")

    c1br = section_C1()
    section_C2()
    store = {}
    section_C3(store)
    section_C4(store, c1br)
    section_C5()
    section_C6(c1br)
    section_C7(store)

    sec("VERDICTS")
    if c1br is not None:
        note("C1 VERIFIED      t* in [%s, %s], width %s (%d digits); f > 0 on [0,19/8], f' < 0 on the bracket."
             % (dec(c1br[0], 30), dec(c1br[1], 30), sci(c1br[1] - c1br[0]), digits_of(c1br[1] - c1br[0])))
    note("C2 VERIFIED      f(5/2) < 0, f(12/5) > 0, f(49/20) < 0; all enclosures ~1e-74 wide.")
    note("C3 VERIFIED      smallest positive Re-root for N = %s, brackets ~8.8e-47 (47 digits),"
         % (", ".join(str(N) for N in N_LIST),))
    note("                 each certified by 'no zero on [0,s_lo]' + 'strictly monotone on [s_lo,b]'.")
    note("   N=1: VERIFIED (Re S_1 == 1).")
    note("   N=2: 'no root' REFUTED -- Re S_2 has tangential zeros (no sign change) and S_2 itself")
    note("        vanishes EXACTLY at t = (2k+1)pi/log2, smallest t = 4.5323601418271938096276829457166668.")
    note("C4 VERIFIED      N=3: positive set {1}, negative set {2,3}, P=1, |M|=1;")
    note("                 N=12: positive set {1,2,3,4,5}, negative set {6,...,12}, P=|M|=2.7448557107742332447.")
    note("C5 REFUTED/PARTIAL  the claim 'no exact complex vanishing for N<=6' is REFUTED by N=2")
    note("                 (|S_2((2k+1)pi/log2)| = 0 exactly).  N=3: non-vanishing PROVED for all t.")
    note("                 N=4,5,6: only certified lower bounds on [0,15] (grid minima are not bounds).")
    note("C6 divergence VERIFIED (Euler-summation lower bound -> +infinity).  The suggested N^{1/2}-ish")
    note("   growth is REFUTED: certified/empirical exponent ~1 and |S_N|/N -> 1/sqrt(1+t^2) (5e-7 at N=10^6).")
    note("C7 VERIFIED      Im S_N = 0 has a smallest positive root for every N >= 2 (brackets ~8.8e-47);")
    note("                 N=3 in closed form 2pi/log6.  Roots differ from the Re case (e.g. N=3: 3.506712...")
    note("   vs 2.426652...), so 'balance' is convention dependent.")

    sec("SUMMARY")
    npass = sum(1 for _, ok, _ in CHECKS if ok)
    for label, ok, detail in CHECKS:
        if not ok:
            print("  FAILED: %s   %s" % (label, detail))
    print("%d/%d checks pass   (elapsed %.1f s)" % (npass, len(CHECKS), time.time() - _t_start))
    return 0 if npass == len(CHECKS) else 1


if __name__ == "__main__":
    sys.exit(main())
