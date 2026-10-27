#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rh45/rigorous/eta_interval.py — a rigorous enclosure engine for
eta(s) = sum_{n>=1} (-1)^{n-1} n^{-s}  (hence zeta) on and near the critical line,
based on the Euler-accelerated alternating series with a *proved* tail bound.

Rigour model
------------
Real enclosures are `ivmath.Num` (value + guaranteed error), the programme's
trusted engine: pi by Machin, log n by 2 atanh over the prime factors, cos/sin by
Taylor series with explicit alternating remainders.  On top of it:

*   n^{-1/2} is enclosed by exact integer square roots: with r = floor(sqrt(D^2/n)),
    n^{-1/2} in [r/D, (r+1)/D].
*   n^{-sigma} for sigma in [1/2-d, 1/2+d] is n^{-1/2} * exp(-(sigma-1/2) log n),
    and for |y| <= 1 the elementary bounds 1+y <= e^y <= 1+y+y^2 (0<=y<=1) and
    e^{-y} >= 1-y give a rigorous enclosure without an exp routine.
*   Euler's transformation  eta(s) = sum_k Delta^k a_0 / 2^{k+1},  a_m = (m+1)^{-s},
    with the Hausdorff representation
        Delta^k a_0 = (1/Gamma(s)) int_0^inf x^{s-1} e^{-x} (1-e^{-x})^k dx
    giving the proved tail bound, for every x0 > 0,
        |Delta^k a_0| <= (1/|Gamma(s)|) ( x0^sigma/sigma + (1-e^{-x0})^k Gamma(sigma) ),
    and |Gamma(1/2+it)| = sqrt(pi / cosh(pi t)).

Everything is a bound; nothing is a float estimate.
"""
from __future__ import annotations

import math
import os
import sys
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)   # ivmath.py is bundled in this folder
import ivmath as iv  # noqa: E402
import mpmath as mp  # noqa: E402

EPS = iv.EPS
HALF = Fraction(1, 2)

# ===========================================================================
# Working precision and the CERTIFIED FAST MODE
# ===========================================================================
#
# Enclosure contract.
# Every `ivmath.Num` denotes the interval [v - e, v + e]; each operation adds a
# blanket rounding slack `EPS` on top of the propagated error fields
# (`ivmath._add` / `_sub` / `_mul` / `_div_int`).  The contract is therefore
#
#     EPS  >=  (accumulated rounding error at the working precision).
#
# At `work` decimal digits a correctly-rounded operation errs by ~10^-work, and an
# enclosure is assembled from O(10^2) operations, so
#
#     EPS(work) = 10^-(work - 20)
#
# leaves ~20 digits of margin and is sound.  The module default is the historical
# `work = 400` with the hand-set `EPS = 1e-320` (80 digits of margin).
#
# WARNING.  Lowering `ivmath.WORK` alone -- as the early Route-B scripts did with
# `iv.WORK = 60` -- does NOT preserve the contract: `EPS` keeps its 400-digit value
# and no longer dominates the rounding, so the reported intervals understate their
# error.  Always move `WORK`, `EPS` (in both modules) and mpmath's precision
# together, with `set_precision` / `fast_mode` below.
#
# Usage:
#     import eta_interval as E
#     E.fast_mode()                       # work = 60, EPS = 1e-40
#     box = E.eta_box(sig_lo, sig_hi, t_lo, t_hi, K=40)
# `K` (the Euler-series truncation) is a per-call argument of the engines; it is not
# part of the precision state.

DEFAULT_WORK = 400
SAFETY_DIGITS = 20


def eps_for_work(work: int):
    """Smallest sound blanket slack at `work` decimal digits: `10^-(work - 20)`."""
    return mp.mpf(10) ** (-(int(work) - SAFETY_DIGITS))


def set_precision(work: int = DEFAULT_WORK, *, scale_eps: bool = True) -> dict:
    """Set the working precision **and** the rounding slack together.

    Mutates `ivmath.WORK`, `ivmath.EPS`, this module's `EPS`, and mpmath's precision.
    Call before building any enclosure.  Returns `{"work", "eps", "prec"}`.

    `scale_eps=True` (default) enforces the contract above.  Note that
    `set_precision(400)` therefore re-derives a *tighter* `EPS = 1e-380` than the
    historical `1e-320`; pass `scale_eps=False` to reproduce the legacy setting
    bit-for-bit (this is what documents why the legacy fast path is unsound).
    """
    global EPS
    work = int(work)
    iv.WORK = work
    mp.mp.prec = int(work * 3.33)
    if scale_eps:
        iv.EPS = eps_for_work(work)
    EPS = iv.EPS
    return {"work": work, "eps": iv.EPS, "prec": mp.mp.prec}


def fast_mode() -> dict:
    """The certified fast configuration for the Route-B counts: `work = 60`.

    Sets `work = 60` with the contract-satisfying `EPS = 1e-40`.  This is the
    supported way to reproduce the fast certificates; it is ~10x faster than the
    400-digit default with enclosure widths still far below the certificate margins.
    Run [`check_fast_mode.py`](check_fast_mode.py) to validate it.
    """
    return set_precision(60)


def _mpf(x):
    """mpf from mpf or Fraction."""
    if isinstance(x, Fraction):
        return mp.mpf(x.numerator) / mp.mpf(x.denominator)
    return mp.mpf(x)

# --------------------------------------------------------------------------- #
#  rigorous elementary building blocks
# --------------------------------------------------------------------------- #

_D = 10 ** 90  # denominator for the integer square root


def n_inv_sqrt(n: int, D: int = _D) -> "iv.Num":
    """Enclosure of n^{-1/2} by exact integer arithmetic."""
    saved = mp.mp.dps
    mp.mp.dps = iv.WORK
    try:
        return _n_inv_sqrt(n, D)
    finally:
        mp.mp.dps = saved


def _n_inv_sqrt(n: int, D: int) -> "iv.Num":
    D2 = D * D
    r = math.isqrt(D2 // n)
    while (r + 1) * (r + 1) * n <= D2:
        r += 1
    while r * r * n > D2:
        r -= 1
    lo = mp.mpf(r) / D
    hi = mp.mpf(r + 1) / D
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def sqrt2() -> "iv.Num":
    """Enclosure of sqrt(2)."""
    saved = mp.mp.dps
    mp.mp.dps = iv.WORK
    try:
        return _sqrt2()
    finally:
        mp.mp.dps = saved


def _sqrt2() -> "iv.Num":
    D2 = _D * _D
    r = math.isqrt(2 * D2)
    while (r + 1) * (r + 1) <= 2 * D2:
        r += 1
    while r * r > 2 * D2:
        r -= 1
    lo = mp.mpf(r) / _D
    hi = mp.mpf(r + 1) / _D
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def exp_small(ylo, yhi, n: int = 10) -> "iv.Num":
    """Rigorous enclosure of e^y for y in [ylo,yhi] with |y| <= 1/2.

    Taylor polynomial of degree n with the Lagrange remainder bound
    |R| <= |y|^{n+1}/(n+1)! * e^{1/2} <= |y|^{n+1}/(n+1)! * 1.7; T_n is
    increasing on [-1/2,1/2], so it suffices to evaluate at the endpoints.
    """
    ylo, yhi = mp.mpf(ylo), mp.mpf(yhi)
    m = max(abs(ylo), abs(yhi))
    if m > mp.mpf(1) / 2:
        raise ValueError("exp_small: |y| too large")
    T = lambda y: sum(y ** k / mp.factorial(k) for k in range(n + 1))
    R = m ** (n + 1) / mp.factorial(n + 1) * mp.mpf('1.7') + EPS
    lo, hi = T(ylo) - R, T(yhi) + R
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def _exp_pos(y: "iv.Num") -> "iv.Num":
    """Rigorous e^y for y >= 0 (range reduction + exp_small)."""
    if y.lo < 0:
        raise ValueError("_exp_pos: negative")
    k = 0
    yy = y
    while yy.hi > mp.mpf(1) / 2:
        yy = yy.div_int(2)
        k += 1
    e = exp_small(yy.lo, yy.hi)
    for _ in range(k):
        e = e * e
    return e


def exp_num(y: "iv.Num") -> "iv.Num":
    """Rigorous e^y for any real interval y."""
    if y.hi <= 0:
        # y in [y.lo,y.hi] <= 0: e^y in [e^{y.lo}, e^{y.hi}]
        big = ndef(ONE, _exp_pos(iv.Num(-y.lo, 0)))    # e^{y.lo}
        small = ndef(ONE, _exp_pos(iv.Num(-y.hi, 0)))  # e^{y.hi}
        lo, hi = small.v - small.e, big.v + big.e
        return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)
    if y.lo >= 0:
        return _exp_pos(y)
    a = ndef(ONE, _exp_pos(iv.Num(-y.lo, 0)))
    b = _exp_pos(iv.Num(y.hi, 0))
    lo, hi = a.v - a.e, b.v + b.e
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def n_pow_neg_sigma(n: int, s_lo, s_hi) -> "iv.Num":
    """Enclosure of n^{-sigma} for sigma in [s_lo, s_hi] (any sigma > 0)."""
    L = log_hi(n)
    vals = [-_mpf(s_lo) * L.lo, -_mpf(s_lo) * L.hi,
            -_mpf(s_hi) * L.lo, -_mpf(s_hi) * L.hi]
    y = iv.Num((min(vals) + max(vals)) / 2, (max(vals) - min(vals)) / 2 + EPS)
    return exp_num(y)


def tail_radius(t_abs: float, sigma_hi, K: int, x0=mp.mpf(1)) -> mp.mpf:
    """Proved bound for |sum_{k>K} Delta^k a_0 / 2^{k+1}|.

    Uses |Gamma(1/2+it)| = sqrt(pi/cosh(pi t)) and the uniform factor 1/2 on the
    sigma-interval (|Re psi| <= 6 for |t|>=14 and |sigma-1/2|<=1/4 gives
    e^{-6*0.5} > 0.8; 1/2 is deliberately generous).
    """
    t = mp.mpf(t_abs)
    gamma_lb = mp.sqrt(mp.pi / mp.cosh(mp.pi * t)) * mp.mpf('0.5')
    rho = 1 - mp.e ** (-x0)
    sig = _mpf(sigma_hi)
    t1 = (x0 ** sig / sig) * mp.power(2, -(K + 1))
    t2 = mp.gamma(sig) * rho ** (K + 1) / (mp.power(2, K + 2) * (1 - rho / 2))
    return (t1 + t2) / gamma_lb * mp.mpf('1.01') + mp.mpf('1e-280')


# --------------------------------------------------------------------------- #
#  complex intervals
# --------------------------------------------------------------------------- #

class Cx:
    __slots__ = ("re", "im")

    def __init__(self, re, im):
        self.re = re
        self.im = im

    def __add__(self, o):
        return Cx(self.re + o.re, self.im + o.im)

    def __sub__(self, o):
        return Cx(self.re - o.re, self.im - o.im)

    def __mul__(self, o):
        # (a+bi)(c+di) = (ac-bd) + i(ad+bc)
        return Cx(self.re * o.re - self.im * o.im, self.re * o.im + self.im * o.re)

    def scale(self, q: Fraction):
        return Cx(self.re.mul_int(q.numerator).div_int(q.denominator),
                  self.im.mul_int(q.numerator).div_int(q.denominator))

    def inflate(self, r):
        return Cx(iv.Num(self.re.v, self.re.e + r), iv.Num(self.im.v, self.im.e + r))

    def excludes_zero(self) -> bool:
        return self.re.sign() != 0 or self.im.sign() != 0

    def corners(self):
        return [(self.re.lo, self.im.lo), (self.re.hi, self.im.lo),
                (self.re.hi, self.im.hi), (self.re.lo, self.im.hi)]

    def center(self):
        return (self.re.v, self.im.v)

    def angular_radius(self) -> mp.mpf:
        """Rigorous upper bound on the angle subtended at 0 by the box."""
        cr, ci = self.re.v, self.im.v
        cmod = mp.sqrt(cr * cr + ci * ci)
        cmod_lo = cmod - mp.sqrt(self.re.e ** 2 + self.im.e ** 2) - EPS
        if cmod_lo <= 0:
            return mp.pi
        rad = max(mp.sqrt((mp.mpf(x) - cr) ** 2 + (mp.mpf(y) - ci) ** 2)
                  for x, y in self.corners())
        ratio = rad / cmod_lo
        if ratio >= 1:
            return mp.pi
        return mp.asin(ratio)


ZERO = iv.Num(0)
ONE = iv.Num(1)

_LOG_HI = {}


def log_hi(n: int, K: int = 600) -> "iv.Num":
    """High-accuracy rigorous log n (K=600 atanh terms), cached."""
    if n in _LOG_HI:
        return _LOG_HI[n]
    if n <= 1:
        _LOG_HI[n] = ZERO
        return _LOG_HI[n]
    acc = ZERO
    for p, e in iv._factorize(n):
        q = Fraction(p - 1, p + 1)
        terms = [e * 2 * q ** (2 * j + 1) / (2 * j + 1) for j in range(K)]
        last = e * 2 * q ** (2 * K + 1) / (2 * K + 1)
        acc = acc + iv._series(terms, last / (1 - q * q))
    _LOG_HI[n] = acc
    return acc


# --------------------------------------------------------------------------- #
#  the accelerated eta series
# --------------------------------------------------------------------------- #

def term(m: int, s_lo, s_hi, t_lo, t_hi) -> Cx:
    """Enclosure of a_m = (m+1)^{-s} for s in [s_lo,s_hi] + i [t_lo,t_hi]."""
    n = m + 1
    w = n_pow_neg_sigma(n, s_lo, s_hi)
    t = iv.Num((_mpf(t_lo) + _mpf(t_hi)) / 2,
               (_mpf(t_hi) - _mpf(t_lo)) / 2 + EPS)
    ph = t * log_hi(n)
    return Cx(w * iv.cos_num(ph), -(w * iv.sin_num(ph)))


def eta_box(s_lo, s_hi, t_lo, t_hi, K: int) -> Cx:
    """Rigorous enclosure of eta(s) for s in the parameter box."""
    A = [term(m, s_lo, s_hi, t_lo, t_hi) for m in range(K + 1)]
    acc = Cx(ZERO, ZERO)
    for k in range(K + 1):
        acc = acc + A[0].scale(Fraction(1, 2 ** (k + 1)))
        A = [A[i] - A[i + 1] for i in range(len(A) - 1)]
    t_abs = max(abs(_mpf(t_lo)), abs(_mpf(t_hi)))
    return acc.inflate(tail_radius(t_abs, s_hi, K))


# --------------------------------------------------------------------------- #
#  the winding certificate (Proposition D of routes-abc.html)
# --------------------------------------------------------------------------- #

def _box_contains(box: Cx, cr, ci) -> bool:
    return box.re.lo <= cr <= box.re.hi and box.im.lo <= ci <= box.im.hi


def winding_certificate(s_lo, s_hi, t_lo, t_hi, K=60, N=32, verbose=True):
    """Rigorous winding number of eta around the rectangle [s_lo,s_hi]x[t_lo,t_hi].

    Homotopy argument: for each boundary edge step the enclosure E_j is a convex
    box avoiding 0, and it contains the two endpoint representatives; hence the
    true arc, the chord, and the representative chord are all homotopic in
    C \\ {0}, so the polygonal winding equals the true winding.

    Returns (winding, info) or (None, info) if the hypotheses fail.
    """
    import math as _m
    s_lo, s_hi, t_lo, t_hi = map(mp.mpf, (s_lo, s_hi, t_lo, t_hi))
    # CCW boundary vertices (sigma, t)
    verts = []
    for i in range(N):   # right edge, t: t_lo -> t_hi
        verts.append((s_hi, t_lo + (t_hi - t_lo) * i / N))
    for i in range(N):   # top edge, s: s_hi -> s_lo
        verts.append((s_hi + (s_lo - s_hi) * i / N, t_hi))
    for i in range(N):   # left edge, t: t_hi -> t_lo
        verts.append((s_lo, t_hi + (t_lo - t_hi) * i / N))
    for i in range(N):   # bottom edge, s: s_lo -> s_hi
        verts.append((s_lo + (s_hi - s_lo) * i / N, t_lo))
    M = len(verts)

    V = []          # vertex point enclosures
    for (ss, tt) in verts:
        V.append(eta_box(ss, ss, tt, tt, K))
    if not all(v.excludes_zero() for v in V):
        return None, {"reason": "a vertex enclosure contains 0"}

    minmod = mp.inf
    maxang = mp.mpf(0)
    for j in range(M):
        s1, t1 = verts[j]
        s2, t2 = verts[(j + 1) % M]
        E = eta_box(min(s1, s2), max(s1, s2), min(t1, t2), max(t1, t2), K)
        if not E.excludes_zero():
            return None, {"reason": "edge enclosure %d contains 0" % j}
        cr, ci = E.re.v, E.im.v
        minmod = min(minmod, mp.sqrt(cr * cr + ci * ci) - mp.sqrt(E.re.e ** 2 + E.im.e ** 2))
        maxang = max(maxang, E.angular_radius())
        for v in (V[j], V[(j + 1) % M]):
            c = v.center()
            if not _box_contains(E, c[0], c[1]):
                return None, {"reason": "vertex representative outside edge box %d" % j}

    # polygonal winding from the representative points
    pts = [V[j].center() for j in range(M)]
    total = mp.mpf(0)
    prev = mp.atan2(pts[0][1], pts[0][0])
    for j in range(1, M + 1):
        cur = mp.atan2(pts[j % M][1], pts[j % M][0])
        d = cur - prev
        while d > mp.pi:
            d -= 2 * mp.pi
        while d < -mp.pi:
            d += 2 * mp.pi
        total += d
        prev = cur
    w = int(mp.nint(total / (2 * mp.pi)))
    err = abs(total - 2 * mp.pi * w) + 2 * maxang
    info = {"winding": w, "total/2pi": total / (2 * mp.pi), "angular_error": maxang,
            "min_edge_modulus": minmod, "steps": M, "K": K}
    if err >= mp.pi:
        return None, dict(info, reason="angular error not < pi")
    return w, info


def on_line_certificate(t0, h=0.25, delta=mp.mpf("0.01"), K=60, N=32, verbose=True):
    """Proposition D: winding 1 in the s <-> 1-s symmetric rectangle implies a
    unique simple zero of zeta on the critical line inside."""
    s_lo, s_hi = mp.mpf(1) / 2 - delta, mp.mpf(1) / 2 + delta
    w, info = winding_certificate(s_lo, s_hi, mp.mpf(t0) - h, mp.mpf(t0) + h, K=K, N=N)
    if verbose:
        print("  t0=%s  ->" % mp.nstr(t0, 12), info)
    return w, info


# --------------------------------------------------------------------------- #
#  rigorous theta(t) and Z(t)  (Stirling series with explicit remainder)
# --------------------------------------------------------------------------- #

_BERN = [Fraction(1, 6), Fraction(-1, 30), Fraction(1, 42), Fraction(-1, 30),
         Fraction(5, 66), Fraction(-691, 2730), Fraction(7, 6), Fraction(-3617, 510),
         Fraction(43867, 798), Fraction(-174611, 330), Fraction(854513, 138),
         Fraction(-236364091, 2730)]


def ndef(x: "iv.Num", y: "iv.Num") -> "iv.Num":
    """Rigorous x/y, requires y.lo > 0."""
    if y.lo <= 0:
        raise ValueError("ndef: denominator interval touches 0")
    lo = x.lo / y.hi
    hi = x.hi / y.lo
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def _log2() -> "iv.Num":
    q = Fraction(1, 3)
    K = 160
    terms = [2 * q ** (2 * j + 1) / (2 * j + 1) for j in range(K)]
    return iv._series(terms, (2 * q ** (2 * K + 1) / (2 * K + 1)) / (1 - q * q))


def _atanh_num(q: "iv.Num", K: int = 120) -> "iv.Num":
    """Rigorous atanh(q) = sum q^{2j+1}/(2j+1) for |q| <= 1/2."""
    if abs(q.v) + q.e > mp.mpf(1) / 2:
        raise ValueError("atanh_num: |q| too large")
    acc = ZERO
    qp = q
    q2 = q * q
    for j in range(K):
        acc = acc + ndef(qp, iv.Num(2 * j + 1))
        qp = qp * q2
    qm = abs(q.v) + q.e
    pw = iv.Num(1, 0)
    for _ in range(2 * K + 1):
        pw = pw * iv.Num(qm, 0)
    tail = ndef(pw, iv.Num((2 * K + 1) * (1 - qm * qm), 0))
    return iv.Num(acc.v, acc.e + tail.hi)


def _log_num(x: "iv.Num") -> "iv.Num":
    """Rigorous log of a positive interval x."""
    if x.lo <= 0:
        raise ValueError("_log_num: x must be positive")
    k = int(mp.floor(mp.log(x.lo) / mp.log(2)))
    m = ndef(x, iv.Num(mp.mpf(2) ** k)) if k >= 0 else x * iv.Num(mp.mpf(2) ** (-k))
    while m.lo < 1:
        k -= 1
        m = ndef(x, iv.Num(mp.mpf(2) ** k)) if k >= 0 else x * iv.Num(mp.mpf(2) ** (-k))
    while m.hi >= 2:
        k += 1
        m = ndef(x, iv.Num(mp.mpf(2) ** k)) if k >= 0 else x * iv.Num(mp.mpf(2) ** (-k))
    q = ndef(m - iv.Num(1), m + iv.Num(1))
    return _log2().mul_int(k) + _atanh_num(q) * iv.Num(2)


def _sqrt_frac(a: Fraction) -> "iv.Num":
    """Rigorous sqrt of a positive rational."""
    num, den = a.numerator, a.denominator
    r = math.isqrt(num * _D * _D // den)
    while (r + 1) * (r + 1) * den <= num * _D * _D:
        r += 1
    while r * r * den > num * _D * _D:
        r -= 1
    lo = mp.mpf(r) / _D
    hi = mp.mpf(r + 1) / _D
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def _atan_small(x: Fraction) -> "iv.Num":
    """Rigorous atan x for 0 <= x <= 1/2."""
    K = 160
    terms = [Fraction((-1) ** j) * x ** (2 * j + 1) / (2 * j + 1) for j in range(K)]
    return iv._series(terms, x ** (2 * K + 1) / (2 * K + 1))


def _num_mul_frac(x: "iv.Num", f: Fraction) -> "iv.Num":
    return x.mul_int(f.numerator).div_int(f.denominator)


def _num_div_frac(x: "iv.Num", f: Fraction) -> "iv.Num":
    # multiply by the denominator FIRST, then divide: the EPS floor added by
    # `div_int` must not be re-amplified by a huge integer (this was a real bug).
    return x.mul_int(f.denominator).div_int(f.numerator)


def _cx_pow(z: Cx, k: int) -> Cx:
    r = Cx(ONE, ZERO)
    for _ in range(k):
        r = r * z
    return r


def theta_num(t: Fraction, N: int = 10):
    """(theta(t), theta'(t)) rigorously, |R_N| <= 2^{N+1}|B_{2N+2}|/((2N+2)(2N+1)|z|^{2N+1})."""
    t = Fraction(t)
    zre, zim = Fraction(1, 4), t / 2
    absz2 = zre * zre + zim * zim
    absz = _sqrt_frac(absz2)
    ratio = ndef(absz, iv.pi())                       # |z|/pi
    logratio = _log_num(ratio)
    logabsz = _log_num(absz)
    logpi = _log_num(iv.pi())
    argz = iv.pi().div_int(2) - _atan_small(Fraction(1, 1) / (2 * t))
    # Im[(z-1/2) log z - z] = (t/2) log|z| - (1/4) arg z - t/2
    im_main = _num_mul_frac(logratio, t / 2) - _num_mul_frac(argz, Fraction(1, 4)) \
        - iv.rat(t / 2)
    zbar = Cx(iv.rat(Fraction(zre)), -iv.rat(Fraction(zim)))
    imS = ZERO
    repsi = logabsz - _num_div_frac(iv.Num(1), 8 * absz2)   # Re(1/(2z)) = 1/(8|z|^2)
    for n in range(1, N + 1):
        b = _BERN[n - 1]
        zp = _cx_pow(zbar, 2 * n - 1)
        den = absz2 ** (2 * n - 1)
        wim = _num_div_frac(zp.im, den)
        imS = imS + _num_mul_frac(wim, b / (2 * n * (2 * n - 1)))
        zp2 = _cx_pow(zbar, 2 * n)
        den2 = absz2 ** (2 * n)
        re2 = _num_div_frac(zp2.re, den2)
        repsi = repsi - _num_mul_frac(re2, b / (2 * n))
    bN = _BERN[N]
    br = abs(mp.mpf(bN.numerator) / mp.mpf(bN.denominator))
    a2 = mp.mpf(absz2.numerator) / mp.mpf(absz2.denominator)
    R = mp.mpf(2) ** (N + 1) * br / ((2 * N + 2) * (2 * N + 1) * a2 ** (N + mp.mpf(1) / 2))
    Rp = mp.mpf(2) ** (N + 1) * br / ((2 * N + 2) * a2 ** (N + 1))
    _t = im_main + imS
    theta = iv.Num(_t.v, _t.e + R)
    _tp = ndef(repsi - logpi, iv.Num(2))
    thetap = iv.Num(_tp.v, _tp.e + Rp)
    return theta, thetap




def two_pow_one_minus_s(s_lo, s_hi, t_lo, t_hi) -> Cx:
    """Enclosure of 2^{1-s} for s in the box."""
    base = sqrt2()
    t = iv.Num((_mpf(t_lo) + _mpf(t_hi)) / 2, (_mpf(t_hi) - _mpf(t_lo)) / 2 + EPS)
    ph = t * iv.Num(mp.log(2), EPS)
    rot = Cx(iv.cos_num(ph), -iv.sin_num(ph))
    blo = mp.mpf(1) / 2 - _mpf(s_hi)
    bhi = mp.mpf(1) / 2 - _mpf(s_lo)
    mag = base * exp_small(blo * mp.log(2), bhi * mp.log(2))
    return Cx(mag * rot.re, mag * rot.im)


def cdiv(a: Cx, b: Cx) -> Cx:
    """Rigorous complex division, requires |b| bounded away from 0."""
    d = b.re * b.re + b.im * b.im
    if d.lo <= 0:
        raise ValueError("cdiv: denominator box touches 0")
    return Cx(ndef(a.re * b.re + a.im * b.im, d),
              ndef(a.im * b.re - a.re * b.im, d))


def zeta_point(s_lo, s_hi, t_lo, t_hi, K: int = 60) -> Cx:
    """Enclosure of zeta(s) = eta(s)/(1 - 2^{1-s}) on the box."""
    eta = eta_box(s_lo, s_hi, t_lo, t_hi, K)
    f = Cx(ONE, ZERO) - two_pow_one_minus_s(s_lo, s_hi, t_lo, t_hi)
    return cdiv(eta, f)


def Z_num(t: Fraction, K: int = 60, N: int = 10):
    """Rigorous enclosures of Z(t) = Re(e^{i theta} zeta(1/2+it)) and Z'(t)."""
    theta, thetap = theta_num(t, N)
    z = zeta_point(Fraction(1, 2), Fraction(1, 2), t, t, K)
    ct, st = iv.cos_num(theta), iv.sin_num(theta)
    Z = ct * z.re - st * z.im
    # Z' = -Im( e^{i theta} (theta' zeta + zeta') ); needs zeta' (not implemented yet)
    return Z, theta, thetap, z


def Z_sign_certificate(t0, h=Fraction(1, 2), K: int = 80, N: int = 10, iters: int = 20):
    """Rigorous Route-A certificate (existence on the critical line).

    Returns (a, b, Za, Zb) with a < b, Za.hi < 0 < Zb.lo (or the mirror), so that
    Z has a zero in (a,b) by the intermediate value theorem; the zero is a zero of
    zeta on the critical line.  Returns None if a sign cannot be decided.
    """
    a, b = Fraction(t0) - h, Fraction(t0) + h
    Za = Z_num(a, K, N)[0]
    Zb = Z_num(b, K, N)[0]
    sa, sb = Za.sign(), Zb.sign()
    if sa == 0 or sb == 0 or sa == sb:
        return None
    # concentric shrink about the numerically known root t0; keep the last bracket
    # whose two endpoint enclosures have strictly opposite signs.
    best = (a, b, Za, Zb)
    delta = h
    for _ in range(iters):
        delta = delta / 2
        aa, bb = Fraction(t0) - delta, Fraction(t0) + delta
        Za2 = Z_num(aa, K, N)[0]
        Zb2 = Z_num(bb, K, N)[0]
        if Za2.sign() * Zb2.sign() < 0:
            best = (aa, bb, Za2, Zb2)
        else:
            break
    a, b, Za, Zb = best
    return a, b, Za, Zb


# --------------------------------------------------------------------------- #
#  eta', zeta', Z'  (derivative series with a proved tail)
# --------------------------------------------------------------------------- #

def eta_prime_tail(t_abs, sigma_hi, K: int, x0=mp.mpf(1)) -> mp.mpf:
    """Proved bound for |sum_{k>K} Delta^k b_0 / 2^{k+1}|, b_m = -log(m+1) a_m.

    From Delta^k b_0 = d/ds Delta^k a_0 = (-psi/Gamma) I_k + (1/Gamma) I_k' with
    I_k = int x^{s-1}e^{-x}(1-e^{-x})^k dx and I_k' the same with a factor log x:
      |I_k|  <= 1/sigma + rho^k Gamma(sigma),
      |I_k'| <= 1/sigma^2 + rho^k C1,   C1 = int_1^inf x^{sigma-1}|log x|e^{-x}dx <= 1,
      |psi|  <= 5 (for |t| >= 14, sigma near 1/2).
    Hence |Delta^k b_0| <= (1/|Gamma|)[(5/sigma+1/sigma^2) + rho^k (5 Gamma(sigma)+C1)].
    """
    t = mp.mpf(t_abs)
    gamma_lb = mp.sqrt(mp.pi / mp.cosh(mp.pi * t)) * mp.mpf('0.5')
    rho = 1 - mp.e ** (-x0)
    sig = _mpf(sigma_hi)
    c0 = 5 / sig + 1 / sig ** 2
    c1 = 5 * mp.gamma(sig) + 1
    tail = (c0 * mp.power(2, -(K + 1))
            + c1 * rho ** (K + 1) / (mp.power(2, K + 2) * (1 - rho / 2))) / gamma_lb
    return tail * mp.mpf('1.01') + mp.mpf('1e-280')


def dterm(m: int, s_lo, s_hi, t_lo, t_hi) -> Cx:
    """Enclosure of b_m = -log(m+1) (m+1)^{-s}."""
    n = m + 1
    w = n_pow_neg_sigma(n, s_lo, s_hi)
    L = log_hi(n)
    t = iv.Num((_mpf(t_lo) + _mpf(t_hi)) / 2, (_mpf(t_hi) - _mpf(t_lo)) / 2 + EPS)
    ph = t * L
    are = w * iv.cos_num(ph)
    aim = -(w * iv.sin_num(ph))
    return Cx(-(L * are), -(L * aim))


def eta_prime_box(s_lo, s_hi, t_lo, t_hi, K: int = 90) -> Cx:
    A = [dterm(m, s_lo, s_hi, t_lo, t_hi) for m in range(K + 1)]
    acc = Cx(ZERO, ZERO)
    for k in range(K + 1):
        acc = acc + A[0].scale(Fraction(1, 2 ** (k + 1)))
        A = [A[i] - A[i + 1] for i in range(len(A) - 1)]
    t_abs = max(abs(_mpf(t_lo)), abs(_mpf(t_hi)))
    return acc.inflate(eta_prime_tail(t_abs, s_hi, K))


def zeta_prime_point(s_lo, s_hi, t_lo, t_hi, K: int = 90) -> Cx:
    """Enclosure of zeta'(s) = (eta' f - eta f')/f^2, f = 1 - 2^{1-s}."""
    eta = eta_box(s_lo, s_hi, t_lo, t_hi, K)
    etp = eta_prime_box(s_lo, s_hi, t_lo, t_hi, K)
    tp = two_pow_one_minus_s(s_lo, s_hi, t_lo, t_hi)
    f = Cx(ONE, ZERO) - tp
    log2 = iv.Num(mp.log(2), EPS)
    fp = Cx(tp.re * log2, tp.im * log2)
    num = etp * f - eta * fp
    return cdiv(num, f * f)


def Zprime_num(t: Fraction, K: int = 90, N: int = 10):
    """(Z(t), Z'(t)) rigorously."""
    theta, thetap = theta_num(t, N)
    z = zeta_point(Fraction(1, 2), Fraction(1, 2), t, t, K)
    zp = zeta_prime_point(Fraction(1, 2), Fraction(1, 2), t, t, K)
    ct, st = iv.cos_num(theta), iv.sin_num(theta)
    Z = ct * z.re - st * z.im
    v = Cx(thetap * z.re + zp.re, thetap * z.im + zp.im)   # theta' zeta + zeta'
    w = Cx(ct, st) * v
    return Z, -w.im


def Zprime_box(t_lo, t_hi, K: int = 90, N: int = 10) -> "iv.Num":
    """Rigorous enclosure of Z' over the whole parameter interval [t_lo,t_hi].

    theta is inflated by |theta'|*d (|theta''| <= 1 to be safe), theta' by d.
    A strictly positive enclosure proves Z is strictly increasing there.
    """
    t_lo, t_hi = Fraction(t_lo), Fraction(t_hi)
    tc = (t_lo + t_hi) / 2
    d = (t_hi - t_lo) / 2
    th, thp = theta_num(tc, N)
    thb = iv.Num(th.v, th.e + abs(thp.v) * _mpf(d) + _mpf(d) * _mpf(d) + EPS)
    thpb = iv.Num(thp.v, thp.e + _mpf(d) + EPS)
    z = zeta_point(Fraction(1, 2), Fraction(1, 2), t_lo, t_hi, K)
    zp = zeta_prime_point(Fraction(1, 2), Fraction(1, 2), t_lo, t_hi, K)
    ct, st = iv.cos_num(thb), iv.sin_num(thb)
    v = Cx(thpb * z.re + zp.re, thpb * z.im + zp.im)
    w = Cx(ct, st) * v
    return -w.im


def unique_simple_certificate(t0, widths=(Fraction(1, 1000), Fraction(1, 10 ** 5),
                                          Fraction(1, 10 ** 7), Fraction(1, 10 ** 9),
                                          Fraction(1, 10 ** 11)), K: int = 90):
    """Theorem A certificate: Z(a) < 0 < Z(b) and Z' > 0 on [a,b].

    Returns (a, b, Za, Zb, Zpb) or None.  With the Lean theorem
    `Rh45Routes.exists_unique_root_of_sign_change`, this proves a unique simple
    zero of zeta on the critical line in (a,b).
    """
    for w in widths:
        a, b = Fraction(t0) - w / 2, Fraction(t0) + w / 2
        Za = Z_num(a, K)[0]
        Zb = Z_num(b, K)[0]
        if Za.sign() == 0 or Zb.sign() == 0 or Za.sign() == Zb.sign():
            continue
        Zpb = Zprime_box(a, b, K)
        if Zpb.sign() != 0:
            return a, b, Za, Zb, Zpb
    return None


# --------------------------------------------------------------------------- #
#  eta'', zeta''  (second derivative series with a proved tail)
# --------------------------------------------------------------------------- #

def eta_second_tail(t_abs, sigma_hi, K: int, x0=mp.mpf(1)) -> mp.mpf:
    """Proved tail for c_m = (log(m+1))^2 a_m from the second s-derivative of the
    Hausdorff integral:  |Delta^k c_0| <= (1/|Gamma|)[ 27/s + 10/s^2 + 2/s^3
    + rho^k (27 Gamma(s) + 10 C1 + C2) ],  C1 <= 1, C2 <= 3, |psi|<=5, |psi'|<=2."""
    t = mp.mpf(t_abs)
    gamma_lb = mp.sqrt(mp.pi / mp.cosh(mp.pi * t)) * mp.mpf('0.5')
    rho = 1 - mp.e ** (-x0)
    sig = _mpf(sigma_hi)
    c0 = 27 / sig + 10 / sig ** 2 + 2 / sig ** 3
    c1 = 27 * mp.gamma(sig) + 13
    tail = (c0 * mp.power(2, -(K + 1))
            + c1 * rho ** (K + 1) / (mp.power(2, K + 2) * (1 - rho / 2))) / gamma_lb
    return tail * mp.mpf('1.01') + mp.mpf('1e-280')


def d2term(m: int, s_lo, s_hi, t_lo, t_hi) -> Cx:
    """Enclosure of c_m = (log(m+1))^2 (m+1)^{-s}."""
    n = m + 1
    w = n_pow_neg_sigma(n, s_lo, s_hi)
    L = log_hi(n)
    L2 = L * L
    t = iv.Num((_mpf(t_lo) + _mpf(t_hi)) / 2, (_mpf(t_hi) - _mpf(t_lo)) / 2 + EPS)
    ph = t * L
    return Cx(L2 * (w * iv.cos_num(ph)), -(L2 * (w * iv.sin_num(ph))))


def eta_second_box(s_lo, s_hi, t_lo, t_hi, K: int = 90) -> Cx:
    A = [d2term(m, s_lo, s_hi, t_lo, t_hi) for m in range(K + 1)]
    acc = Cx(ZERO, ZERO)
    for k in range(K + 1):
        acc = acc + A[0].scale(Fraction(1, 2 ** (k + 1)))
        A = [A[i] - A[i + 1] for i in range(len(A) - 1)]
    t_abs = max(abs(_mpf(t_lo)), abs(_mpf(t_hi)))
    return acc.inflate(eta_second_tail(t_abs, s_hi, K))


def zeta_second_point(s_lo, s_hi, t_lo, t_hi, K: int = 90) -> Cx:
    """Enclosure of zeta''(s) = ((eta'' f - eta f'') f - 2 (eta' f - eta f') f')/f^3."""
    eta = eta_box(s_lo, s_hi, t_lo, t_hi, K)
    etp = eta_prime_box(s_lo, s_hi, t_lo, t_hi, K)
    etpp = eta_second_box(s_lo, s_hi, t_lo, t_hi, K)
    tp = two_pow_one_minus_s(s_lo, s_hi, t_lo, t_hi)
    f = Cx(ONE, ZERO) - tp
    l2 = iv.Num(mp.log(2), EPS)
    l22 = l2 * l2
    fp = Cx(tp.re * l2, tp.im * l2)
    fpp = Cx(-(l22 * tp.re), -(l22 * tp.im))
    g = etp * f - eta * fp
    gf = g * fp
    num = (etpp * f - eta * fpp) * f - Cx(gf.re * iv.Num(2), gf.im * iv.Num(2))
    return cdiv(num, f * f * f)


# --------------------------------------------------------------------------- #
#  boxes straddling the removable singularity of zeta = eta / (1 - 2^{1-s})
# --------------------------------------------------------------------------- #
#
# f(s) = 1 - 2^{1-s} vanishes on Re s = 1 at
#
#     s* = 1 + i t_k ,     t_k = 2 pi k / ln 2     (k = +-1, +-2, ...),
#
# and eta vanishes there too (eta = f zeta with zeta finite at s*), so zeta is
# analytic across s*.  The quotient representation cannot see that: on a box of
# height h close to t_k the enclosure of f is a box of radius ~ (ln 2) h / 2,
# and `cdiv(num, f*f)` (zeta') or `cdiv(num, f*f*f)` (zeta'') loses the pole even
# when the box only *comes near* t_k, not just when it contains it.
#
# The replacement below is local and uses no input beyond the engine.  Choose a
# regular centre c in the box, evaluate z0 = zeta(c), z1 = zeta'(c), z2 = zeta''(c)
# with the ordinary point engines, and enclose the box by Taylor's formula.  The
# remainder is controlled by a Cauchy estimate: if |zeta| <= M on the square Q of
# half-side R about c and Q avoids the pole s = 1, then (Cauchy's estimate on the
# square centred at w, half-side R - rho, which lies in Q)
#
#     |zeta'''(w)| <= 24 M / (pi (R - rho)^3)      for |w - c| <= rho < R,
#
# so, for |u| <= rho,
#
#     zeta(c+u)   = z0 + z1 u + (z2/2) u^2 + O(rho^3),
#     zeta'(c+u)  = z1 + z2 u             + O(rho^2),
#     zeta''(c+u) = z2                    + O(rho).
#
# M is itself rigorous: by the maximum-modulus principle it suffices to bound
# |zeta| on the boundary of Q, which is covered by segment boxes on which the
# eta engine applies (the boundary avoids every t_k, and sigma stays in
# [1/2, 3/2]).  The Cauchy constant is the exact square-contour estimate
# |zeta^{(k)}(c)| <= 4 k! M / (pi R^k).  The only input over the ordinary
# zeta_point path is the eta tail bound at sigma up to 3/2, where the module's
# Gamma lower bound gamma_lb = 0.5 sqrt(pi/cosh(pi t)) remains valid with a wide
# margin (|Gamma(3/2+it)| ~ |t| |Gamma(1/2+it)|).

# Boxes of positive area whose t-range comes within this window of any t_k
# (including t_0 = 0) are enclosed by zeta_local_box.  The quotient engines are
# sound there but their zeta'' enclosure is far too wide for the midpoint-rule
# budget (measured: sum |f'| bounds 7.5e4 at steps/unit = 12, vs ~2e3 after
# routing, while the true Sup|f'| on the path is < 4).
_SING_WINDOW = Fraction(7, 10)


def singular_ts(tmax):
    """Rigorous `Num` enclosures of t_k = 2 pi k / ln 2 with 0 < t_k <= tmax."""
    pi_num = iv.pi()
    log2 = iv.log_n(2)
    out, k = [], 1
    tmax = mp.mpf(tmax)
    while True:
        tk = ndef(iv.Num(2 * k) * pi_num, log2)
        if tk.lo > tmax:
            break
        out.append(tk)
        k += 1
        if k > 10 ** 6:
            break
    return out


def box_near_singularity(s_lo, s_hi, t_lo, t_hi, window=0):
    """A rigorous t_k enclosure overlapping [t_lo,t_hi] when Re s = 1 spans it.

    Returns the `iv.Num` enclosure of some `t_k = 2 pi k / ln 2` whose range,
    expanded by `window`, meets [t_lo,t_hi], or None.  With `window > 0` the point
    `t_0 = 0` is included (the path starts at `t = 1/2`, where `|1 - 2^{1-s}|` is
    already small enough for the quotient engines to be useless).  Only diagnostic
    / selection use: the enclosure engines decide by attempting the quotient and
    falling back.
    """
    if _mpf(s_lo) > 1 or _mpf(s_hi) < 1:
        return None
    w = _mpf(window)
    t_hi_mp = _mpf(t_hi) + w
    t_lo_mp = _mpf(t_lo) - w
    if t_lo_mp <= 0 <= t_hi_mp:
        return iv.Num(0, EPS)
    for tk in singular_ts(t_hi_mp + 1):
        if tk.lo <= t_hi_mp and tk.hi >= t_lo_mp:
            return tk
    return None


def _two_pow_one_minus_s_wide(s_lo, s_hi, t_lo, t_hi) -> Cx:
    """`two_pow_one_minus_s` with the elementary `exp` bound valid for any sigma.

    The ordinary routine needs `|(1/2 - sigma) log 2| <= 1/2`, i.e. sigma <= 1.22;
    the Cauchy contour used by `zeta_local_box` reaches sigma = 1.5.  `exp_num`
    is the module's rigorous exponential for an arbitrary real interval, so the
    same value is obtained without that restriction.
    """
    base = sqrt2()
    t = iv.Num((_mpf(t_lo) + _mpf(t_hi)) / 2, (_mpf(t_hi) - _mpf(t_lo)) / 2 + EPS)
    ph = t * iv.Num(mp.log(2), EPS)
    rot = Cx(iv.cos_num(ph), -iv.sin_num(ph))
    blo = (mp.mpf(1) / 2 - _mpf(s_hi)) * mp.log(2)
    bhi = (mp.mpf(1) / 2 - _mpf(s_lo)) * mp.log(2)
    lo, hi = min(blo, bhi), max(blo, bhi)
    y = iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)
    mag = base * exp_num(y)
    return Cx(mag * rot.re, mag * rot.im)


def _zeta_point_wide(s_lo, s_hi, t_lo, t_hi, K) -> Cx:
    """`zeta_point` using the unrestricted `2^{1-s}` enclosure (Cauchy bound only)."""
    eta = eta_box(s_lo, s_hi, t_lo, t_hi, K)
    f = Cx(ONE, ZERO) - _two_pow_one_minus_s_wide(s_lo, s_hi, t_lo, t_hi)
    return cdiv(eta, f)


def _sup_zeta_square(c_re, c_im, R, K, nseg=4, tries=4):
    """Rigorous upper bound for sup |zeta| on the boundary of the square Q.

    Q has centre `c = (c_re, c_im)` and half-side `R`; `c_re`, `c_im`, `R` are
    Fractions, so the boundary boxes are exact.  The boundary is covered by
    segment boxes, each enclosed by `_zeta_point_wide`; the maximum of the
    resulting modulus bounds is an upper bound on the boundary, hence (maximum
    modulus) on the whole square.  `nseg` is doubled if a segment box meets 0.
    """
    def upper(z):
        return mp.sqrt((abs(z.re.v) + z.re.e) ** 2 + (abs(z.im.v) + z.im.e) ** 2)

    x0, x1 = c_re - R, c_re + R
    y0, y1 = c_im - R, c_im + R
    for _ in range(tries):
        M = mp.mpf(0)
        try:
            for j in range(nseg):
                a = x0 + (x1 - x0) * Fraction(j, nseg)
                b = x0 + (x1 - x0) * Fraction(j + 1, nseg)
                for yy in (y0, y1):
                    M = max(M, upper(_zeta_point_wide(a, b, yy, yy, K)))
                c = y0 + (y1 - y0) * Fraction(j, nseg)
                d = y0 + (y1 - y0) * Fraction(j + 1, nseg)
                for xx in (x0, x1):
                    M = max(M, upper(_zeta_point_wide(xx, xx, c, d, K)))
            return M
        except ValueError:
            nseg *= 2
    raise ValueError("_sup_zeta_square: boundary boxes touch 0")


def zeta_local_box(s_lo, s_hi, t_lo, t_hi, K, R0=Fraction(4, 5)):
    """(zeta, zeta', zeta'') enclosures on a small box with Re s spanning 1.

    Used when the quotient engines meet the removable singularity of
    `zeta = eta/(1 - 2^{1-s})` on Re s = 1.  The box must be small compared with
    R and contain a regular point at which the point engines succeed.
    """
    s_lo, s_hi = Fraction(s_lo), Fraction(s_hi)
    t_lo, t_hi = Fraction(t_lo), Fraction(t_hi)
    c_re = (s_lo + s_hi) / 2
    cands = [(t_lo + t_hi) / 2, t_lo, t_hi,
             (3 * t_lo + t_hi) / 4, (t_lo + 3 * t_hi) / 4]
    c_im = z0 = z1 = z2 = None
    for ci in cands:
        try:
            a = zeta_point(c_re, c_re, ci, ci, K)
            b = zeta_prime_point(c_re, c_re, ci, ci, K)
            dd = zeta_second_point(c_re, c_re, ci, ci, K)
        except ValueError:
            continue
        c_im, z0, z1, z2 = ci, a, b, dd
        break
    if c_im is None:
        raise ValueError("zeta_local_box: no regular centre in the box")

    rho = mp.sqrt(max(abs(_mpf(s_lo - c_re)), abs(_mpf(s_hi - c_re))) ** 2
                  + max(abs(_mpf(t_lo - c_im)), abs(_mpf(t_hi - c_im))) ** 2)
    if rho <= 0:
        raise ValueError("zeta_local_box: degenerate box")
    # largest first: the Taylor remainder ~ M rho^3/(R-rho)^3 shrinks with R, and
    # a large R is skipped only when no rigorous boundary bound is available.
    R = None
    M = None
    cand = Fraction(R0)
    for _ in range(12):
        if _mpf(cand) > rho and c_im - cand > 0:
            try:
                M = _sup_zeta_square(c_re, c_im, cand, K)
                R = cand
                break
            except ValueError:
                pass
        cand = cand / 2
    if R is None:
        raise ValueError("zeta_local_box: no admissible Cauchy contour")
    Mc = 24 * M / (mp.pi * (_mpf(R) - rho) ** 3) * mp.mpf('1.01') + EPS

    ure = iv.Num((_mpf(s_lo - c_re) + _mpf(s_hi - c_re)) / 2,
                 (_mpf(s_hi - c_re) - _mpf(s_lo - c_re)) / 2 + EPS)
    uim = iv.Num((_mpf(t_lo - c_im) + _mpf(t_hi - c_im)) / 2,
                 (_mpf(t_hi - c_im) - _mpf(t_lo - c_im)) / 2 + EPS)
    u = Cx(ure, uim)
    uu = u * u
    half = Cx(z2.re.div_int(2), z2.im.div_int(2))
    z = z0 + z1 * u + half * uu
    zp = z1 + z2 * u
    return (z.inflate(Mc * rho ** 3 / 6 + EPS),
            zp.inflate(Mc * rho ** 2 / 2 + EPS),
            z2.inflate(Mc * rho + EPS))


# --------------------------------------------------------------------------- #
#  rigorous digamma psi(w) and psi'(w)  (recurrence + Stirling with remainder)
# --------------------------------------------------------------------------- #

def _cscale(z: Cx, q: Fraction) -> Cx:
    return Cx(z.re.mul_int(q.numerator).div_int(q.denominator),
              z.im.mul_int(q.numerator).div_int(q.denominator))


def _sqrt_num(x: "iv.Num") -> "iv.Num":
    if x.lo <= 0:
        raise ValueError("_sqrt_num: nonpositive")
    lo, hi = mp.sqrt(x.lo), mp.sqrt(x.hi)
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def _norm_num(z: Cx) -> "iv.Num":
    return _sqrt_num(z.re * z.re + z.im * z.im)


def _arg_num(z: Cx) -> "iv.Num":
    """Rigorous arg of a box in the right half-plane (corners + slack)."""
    angs = [mp.atan2(mp.mpf(y), mp.mpf(x)) for (x, y) in z.corners()]
    lo, hi = min(angs) - mp.mpf('1e-30'), max(angs) + mp.mpf('1e-30')
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)


def psi_num(w_re: Fraction, w_im: Fraction, m: int = 8, N: int = 10):
    """(psi(w), psi'(w)) rigorously for Re w > 0: psi(w) = psi(w+m) - sum_{k<m} 1/(w+k)."""
    w = Cx(iv.rat(Fraction(w_re)), iv.rat(Fraction(w_im)))
    W = Cx(iv.rat(Fraction(w_re) + m), iv.rat(Fraction(w_im)))
    logW = Cx(_log_num(_norm_num(W)), _arg_num(W))
    psi = logW - _cscale(cdiv(Cx(ONE, ZERO), W), Fraction(1, 2))
    psip = cdiv(Cx(ONE, ZERO), W) + _cscale(cdiv(Cx(ONE, ZERO), W * W), Fraction(1, 2))
    Wk, W2 = Cx(ONE, ZERO), W * W
    for n in range(1, N + 1):
        Wk = Wk * W2
        b = _BERN[n - 1]
        psi = psi - _cscale(cdiv(Cx(ONE, ZERO), Wk), b / (2 * n))
        psip = psip + _cscale(cdiv(Cx(ONE, ZERO), Wk * W), b)
    bN = _BERN[N]
    br = abs(mp.mpf(bN.numerator) / mp.mpf(bN.denominator))
    Wmod = abs(W.re.v) - W.re.e
    R = mp.mpf(2) ** (N + 1) * br / ((2 * N + 2) * Wmod ** (2 * N + 2))
    Rp = mp.mpf(2) ** (N + 1) * br / Wmod ** (2 * N + 3)
    psi = Cx(iv.Num(psi.re.v, psi.re.e + R), iv.Num(psi.im.v, psi.im.e + R))
    psip = Cx(iv.Num(psip.re.v, psip.re.e + Rp), iv.Num(psip.im.v, psip.im.e + Rp))
    for k in range(m):
        D = w + Cx(iv.rat(Fraction(k)), ZERO)
        psi = psi - cdiv(Cx(ONE, ZERO), D)
        psip = psip + cdiv(Cx(ONE, ZERO), D * D)
    return psi, psip


def xi_logderiv(s_lo, s_hi, t_lo, t_hi, K: int = 80, N: int = 10, value_only: bool = False):
    """(f, f'), f = xi'/xi, box-correct on [s_lo,s_hi] x [t_lo,t_hi].
    With value_only=True only f is computed (zeta''/psi' are skipped)."""
    sr = (Fraction(s_lo) + Fraction(s_hi)) / 2
    si = (Fraction(t_lo) + Fraction(t_hi)) / 2
    dr = (Fraction(s_hi) - Fraction(s_lo)) / 2
    di = (Fraction(t_hi) - Fraction(t_lo)) / 2
    S = Cx(iv.Num((_mpf(s_lo) + _mpf(s_hi)) / 2, (_mpf(s_hi) - _mpf(s_lo)) / 2 + EPS),
           iv.Num((_mpf(t_lo) + _mpf(t_hi)) / 2, (_mpf(t_hi) - _mpf(t_lo)) / 2 + EPS))
    local = None
    zc = None
    # Boxes of positive area whose t-range lies within _SING_WINDOW of a removable
    # singularity t_k (t_0 = 0 included) go straight to the local Taylor enclosure:
    # the quotient engines are sound there, but their zeta'' enclosure is far too
    # wide for the midpoint-rule budget (the Euler phase error is amplified by
    # 1/f^3).  Point boxes (the step midpoints) keep the accurate point engines.
    near = box_near_singularity(s_lo, s_hi, t_lo, t_hi, _SING_WINDOW) \
        if (dr > 0 or di > 0) else None
    if near is None:
        try:
            zp = zeta_prime_point(s_lo, s_hi, t_lo, t_hi, K)
            zpp = None if value_only else zeta_second_point(s_lo, s_hi, t_lo, t_hi, K)
            zm = zeta_point(sr, sr, si, si, K)
            Lzp = mp.sqrt((abs(zp.re.v) + zp.re.e) ** 2 + (abs(zp.im.v) + zp.im.e) ** 2)
            zc = Cx(iv.Num(zm.re.v, zm.re.e + Lzp * mp.sqrt(_mpf(dr) ** 2 + _mpf(di) ** 2)),
                   iv.Num(zm.im.v, zm.im.e + Lzp * mp.sqrt(_mpf(dr) ** 2 + _mpf(di) ** 2)))
        except ValueError:
            zc = None
        if zc is None or (zc.re * zc.re + zc.im * zc.im).lo <= 0:
            # the quotient engines met the singularity, or the crude Lipschitz
            # envelope of zeta is too wide for the division: use the local method.
            near = True
    if near is not None:
        local = zeta_local_box(s_lo, s_hi, t_lo, t_hi, K)
    if local is not None:
        zc, zp, zpp = local
    if zc.re.sign() == 0 and zc.im.sign() == 0:
        raise ValueError("xi_logderiv: zeta box contains 0")
    zld = cdiv(zp, zc)
    sm1 = Cx(S.re - ONE, S.im)
    half = Fraction(1, 2)
    psi, psip = psi_num(sr / 2, si / 2, N=N)
    if value_only:
        psip = None
    r = mp.sqrt(_mpf(dr) ** 2 + _mpf(di) ** 2) / 2
    if r > 0:
        ub = mp.sqrt((abs(psip.re.v) + psip.re.e) ** 2 + (abs(psip.im.v) + psip.im.e) ** 2)
        psi = Cx(iv.Num(psi.re.v, psi.re.e + (ub + 1) * r),
                 iv.Num(psi.im.v, psi.im.e + (ub + 1) * r))
        if not value_only:
            psip = Cx(iv.Num(psip.re.v, psip.re.e + mp.mpf('2.5') * r),
                      iv.Num(psip.im.v, psip.im.e + mp.mpf('2.5') * r))
    logpi = _log_num(iv.pi())
    f = cdiv(Cx(ONE, ZERO), S) + cdiv(Cx(ONE, ZERO), sm1) \
        - Cx(_cscale(Cx(ONE, ZERO), half).re * logpi, ZERO) \
        + _cscale(psi, half) + zld
    if value_only:
        return f, None
    fp = Cx(ZERO, ZERO) - cdiv(Cx(ONE, ZERO), S * S) - cdiv(Cx(ONE, ZERO), sm1 * sm1) \
        + _cscale(psip, Fraction(1, 4)) + cdiv(zpp, zc) - zld * zld
    return f, fp


def I3_certificate(T, steps_per_unit: int = 12, K: int = 60, N: int = 10, verbose: bool = True, Lf_const=None):
    """Rigorous I3 = int_path xi'/xi ds, path (1/2,1/2)->(1,1/2)->(1,T)->(1/2,T);
    midpoint rule with |err| <= (1/8)|ds|^2 sup|f'|.  N(T) = Im(I3)/pi."""
    T = Fraction(T)
    h = Fraction(1, 2)
    path = [((h, h), (Fraction(1), h)), ((Fraction(1), h), (Fraction(1), T)),
            ((Fraction(1), T), (h, T))]
    Ire, Iim = ZERO, ZERO
    for (P, Q) in path:
        dx, dy = Q[0] - P[0], Q[1] - P[1]
        L = mp.sqrt(_mpf(dx) ** 2 + _mpf(dy) ** 2)
        n = max(1, int(mp.ceil(steps_per_unit * L)))
        for i in range(n):
            ax, ay = P[0] + dx * i / n, P[1] + dy * i / n
            bx, by = P[0] + dx * (i + 1) / n, P[1] + dy * (i + 1) / n
            mx, my = (ax + bx) / 2, (ay + by) / 2
            fm = xi_logderiv(mx, mx, my, my, K, N, value_only=(Lf_const is not None))[0]
            if Lf_const is not None:
                Lf = mp.mpf(Lf_const)
            else:
                _, fpb = xi_logderiv(min(ax, bx), max(ax, bx), min(ay, by), max(ay, by), K, N)
                Lf = mp.sqrt((abs(fpb.re.v) + fpb.re.e) ** 2 + (abs(fpb.im.v) + fpb.im.e) ** 2)
            dsmod = mp.sqrt(_mpf(dx / n) ** 2 + _mpf(dy / n) ** 2)
            err = (mp.mpf(1) / 8) * dsmod ** 2 * Lf
            term = fm * Cx(iv.rat(dx / n), iv.rat(dy / n))
            Ire = iv.Num(Ire.v + term.re.v, Ire.e + term.re.e + err)
            Iim = iv.Num(Iim.v + term.im.v, Iim.e + term.im.e + err)
    Nest = iv.Num(Iim.v / mp.pi, Iim.e / mp.pi + mp.mpf('1e-12'))
    if verbose:
        print("  T=%s steps/unit=%d K=%d -> I3=(%s,%s)  N in [%s,%s]"
              % (T, steps_per_unit, K, mp.nstr(Ire.v, 10), mp.nstr(Iim.v, 10),
                 mp.nstr(Nest.lo, 8), mp.nstr(Nest.hi, 8)))
    return Ire, Iim, Nest
