#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
012/rigorous/rativ.py — exact-rational interval arithmetic with rigorous
transcendental enclosures.

Everything in this module is computed with Python's `fractions.Fraction`: there
is **no floating point anywhere**, so every enclosure is a pair of exact
rationals whose correctness rests only on

  * exact rational arithmetic,
  * explicit truncation bounds for the series used for `pi`, `log`, `exp`,
    `sin`, `cos` (each series carries its own remainder bound in the code and
    in the comments), and
  * interval-arithmetic inclusion lemmas (`x in A and y in B => x*y in A.mul B`).

The module is deliberately fancier than necessary: it exists so that a
*certificate* produced by `partial_tail.py` can be replayed by an independent
checker, and so that the rational cell of the computation can be kernel-checked
in Lean (`012/lean/IBox.lean` + `Replay.lean`).
"""
from __future__ import annotations

import sys as _sys
from fractions import Fraction as F
from functools import lru_cache
from math import factorial as _ifact
from math import floor as _floor
from math import ceil as _ceil

# exact rational endpoints routinely have thousands of digits
try:
    _sys.set_int_max_str_digits(2_000_000)
except Exception:  # pragma: no cover
    pass

__all__ = [
    "Iv", "Cx", "q", "pi_iv", "log_iv", "log_point", "exp_iv", "exp_point",
    "sin_cos_iv", "sin_iv", "cos_iv", "cexp", "Cx_real", "Cx_zero", "Cx_one",
]


def q(x) -> F:
    """Exact rational from int / str / Fraction (never from float)."""
    if isinstance(x, F):
        return x
    if isinstance(x, int):
        return F(x)
    if isinstance(x, str):
        return F(x)
    raise TypeError(f"q: refusing to convert {type(x).__name__} to Fraction")


# --------------------------------------------------------------------------- #
#  real intervals
# --------------------------------------------------------------------------- #

class Iv:
    """A closed interval [lo, hi] with exact rational endpoints."""

    __slots__ = ("lo", "hi")

    def __init__(self, lo, hi):
        lo = q(lo)
        hi = q(hi)
        if lo > hi:
            raise ValueError(f"Iv: empty interval [{lo}, {hi}]")
        self.lo = lo
        self.hi = hi

    # -- basic predicates -------------------------------------------------- #

    @staticmethod
    def pt(x) -> "Iv":
        x = q(x)
        return Iv(x, x)

    def contains(self, x) -> bool:
        x = q(x)
        return self.lo <= x <= self.hi

    def contains_zero(self) -> bool:
        return self.lo <= 0 <= self.hi

    @property
    def width(self) -> F:
        return self.hi - self.lo

    @property
    def mid(self) -> F:
        return (self.lo + self.hi) / 2

    def abs_ub(self) -> F:
        """Upper bound for |x|, x in self."""
        return max(abs(self.lo), abs(self.hi))

    def __repr__(self) -> str:
        if self.lo == self.hi:
            return f"Iv({self.lo})"
        return f"Iv({self.lo}, {self.hi})"

    # -- arithmetic -------------------------------------------------------- #

    def add(self, o: "Iv") -> "Iv":
        return Iv(self.lo + o.lo, self.hi + o.hi)

    def neg(self) -> "Iv":
        return Iv(-self.hi, -self.lo)

    def sub(self, o: "Iv") -> "Iv":
        return Iv(self.lo - o.hi, self.hi - o.lo)

    def scale(self, c) -> "Iv":
        """Multiply by a rational scalar, ordering the endpoints by sign."""
        c = q(c)
        if c >= 0:
            return Iv(c * self.lo, c * self.hi)
        return Iv(c * self.hi, c * self.lo)

    @staticmethod
    def _min4(a, b, c, d):
        return min(min(a, b), min(c, d))

    @staticmethod
    def _max4(a, b, c, d):
        return max(max(a, b), max(c, d))

    def mul(self, o: "Iv") -> "Iv":
        """Inclusion-sound product: the range of x*y over the rectangle."""
        corners = (self.lo * o.lo, self.lo * o.hi, self.hi * o.lo, self.hi * o.hi)
        return Iv(self._min4(*corners), self._max4(*corners))

    def inv(self) -> "Iv":
        """Reciprocal; raises if 0 is not excluded."""
        if self.contains_zero():
            raise ZeroDivisionError(f"Iv.inv: {self} contains 0")
        return Iv(1 / self.hi, 1 / self.lo)

    def div(self, o: "Iv") -> "Iv":
        return self.mul(o.inv())

    def pow_int(self, n: int) -> "Iv":
        if n < 0:
            return self.inv().pow_int(-n)
        r = Iv.pt(1)
        b = self
        while n:
            if n & 1:
                r = r.mul(b)
            b = b.mul(b)
            n >>= 1
        return r

    def inflate(self, r) -> "Iv":
        r = q(r)
        if r < 0:
            raise ValueError("Iv.inflate: negative radius")
        return Iv(self.lo - r, self.hi + r)

    def round_out(self, bits: int) -> "Iv":
        """Outward rounding of both endpoints to the dyadic grid 2**-bits.

        Sound (the result contains self) and keeps denominators bounded so that
        repeated interval multiplication does not blow up in size.
        """
        scale = 1 << bits
        return Iv(F(_floor(self.lo * scale), scale), F(_ceil(self.hi * scale), scale))

    @staticmethod
    def union(a: "Iv", b: "Iv") -> "Iv":
        return Iv(min(a.lo, b.lo), max(a.hi, b.hi))


# --------------------------------------------------------------------------- #
#  rigorous transcendentals (series with explicit remainder bounds)
# --------------------------------------------------------------------------- #

def _eps(bits: int) -> F:
    return F(1, 1 << bits)


@lru_cache(maxsize=None)
def _atan_inv_iv(n: int, bits: int) -> Iv:
    """Enclosure of atan(1/n) for integer n >= 2.

    atan(1/n) = sum_{k>=0} (-1)^k / ((2k+1) n^(2k+1)), an alternating series
    with strictly decreasing terms, so after term k the error is at most the
    magnitude of the next term.
    """
    eps = _eps(bits)
    u = F(1, n)
    total = F(0)
    k = 0
    while True:
        expo = 2 * k + 1
        term = F(1, expo * n ** expo)
        total += term if k % 2 == 0 else -term
        nxt = F(1, (expo + 2) * n ** (expo + 2))
        if nxt <= eps:
            return Iv(total - nxt, total + nxt)
        k += 1
        if k > 400:
            raise RuntimeError("_atan_inv_iv: no convergence")


@lru_cache(maxsize=None)
def pi_iv(bits: int) -> Iv:
    """Machin: pi = 16*atan(1/5) - 4*atan(1/239)."""
    b = bits + 32
    a = _atan_inv_iv(5, b)
    c = _atan_inv_iv(239, b)
    pi = a.scale(16).sub(c.scale(4))
    return pi


def _atanh_series_iv(u: F, bits: int) -> Iv:
    """atanh(u) = sum u^(2k+1)/(2k+1) for 0 <= u < 1 (all terms positive).

    Tail after term k=0..N-1 is at most t_N/(1-u^2) because the term ratio is
    u^2 (2k+1)/(2k+3) <= u^2.
    """
    eps = _eps(bits)
    if u == 0:
        return Iv.pt(0)
    assert 0 <= u < 1
    u2 = u * u
    up = u                     # u^(2k+1), k = 0
    total = F(0)
    k = 0
    while True:
        expo = 2 * k + 1
        total += up / expo
        nxt = up * u2          # u^(2k+3)
        tail = (nxt / (expo + 2)) / (1 - u2)
        if tail <= eps:
            return Iv(total, total + tail)
        up = nxt
        k += 1
        if k > 20000:
            raise RuntimeError("_atanh_series_iv: no convergence")


@lru_cache(maxsize=None)
def _log2_iv(bits: int) -> Iv:
    # log 2 = 2 atanh(1/3)
    return _atanh_series_iv(F(1, 3), bits).scale(2)


@lru_cache(maxsize=None)
def log_point(x, bits: int) -> Iv:
    """Enclosure of log(x) for an exact rational x > 0.

    Reduces x = 2^m * y with y in [1,2), then log y = 2 atanh((y-1)/(y+1)).
    """
    x = q(x)
    if x <= 0:
        raise ValueError("log_point: x must be positive")
    if x == 1:
        return Iv.pt(0)
    m = 0
    y = x
    while y >= 2:
        y /= 2
        m += 1
    while y < 1:
        y *= 2
        m -= 1
    u = (y - 1) / (y + 1)
    ly = _atanh_series_iv(u, bits).scale(2)
    return _log2_iv(bits).scale(m).add(ly)


def log_iv(X: Iv, bits: int) -> Iv:
    if X.lo <= 0:
        raise ValueError("log_iv: interval must be strictly positive")
    lo = log_point(X.lo, bits)
    hi = log_point(X.hi, bits)
    return Iv(lo.lo, hi.hi)


@lru_cache(maxsize=None)
def exp_point(x, bits: int) -> Iv:
    """Enclosure of exp(x) for exact rational x.

    Argument reduction exp(x) = exp(x/2^m)^(2^m) with |x/2^m| <= 1/2, then the
    Taylor sum with |remainder| <= 2 |t|^N / N!  (valid since
    prod_{j>=1} (1 - |t|/(N+j))^{-1} <= 1/(1-|t|/(N+1)) <= 4/3 < 2).
    """
    x = q(x)
    if x == 0:
        return Iv.pt(1)
    m = 0
    t = x
    half = F(1, 2)
    while abs(t) > half:
        t /= 2
        m += 1
    eps = _eps(bits)
    N = 0
    while True:
        rem = 2 * abs(t) ** N / _ifact(N)
        if rem <= eps and N >= 1:
            break
        N += 1
        if N > 400:
            raise RuntimeError("exp_point: no convergence")
    # exact partial sum
    s = F(0)
    p = F(1)
    for k in range(N):
        s += p
        p = p * t / (k + 1)
    r = Iv(s - rem, s + rem).round_out(bits + 32)
    for _ in range(m):
        r = r.mul(r).round_out(bits + 32)
    return r


def exp_iv(X: Iv, bits: int) -> Iv:
    lo = exp_point(X.lo, bits)
    hi = exp_point(X.hi, bits)
    return Iv(lo.lo, hi.hi)


def _sin_cos_taylor(y: Iv, bits: int) -> tuple[Iv, Iv]:
    """sin/cos on an interval with |y| moderate, Taylor + factorial bound."""
    eps = _eps(bits)
    yub = y.abs_ub()
    if yub == 0:
        return Iv.pt(0), Iv.pt(1)
    y2 = y.mul(y)
    sin_s = Iv.pt(0)
    cos_s = Iv.pt(0)
    p_sin = y            # y^(2k+1), k = 0
    p_cos = Iv.pt(1)     # y^(2k),   k = 0
    yub2 = yub * yub
    pow_sin = yub        # yub^(2k+1)
    pow_cos = F(1)       # yub^(2k)
    k = 0
    while True:
        ts = p_sin.scale(F(1, _ifact(2 * k + 1)))
        sin_s = sin_s.add(ts) if k % 2 == 0 else sin_s.sub(ts)
        tc = p_cos.scale(F(1, _ifact(2 * k)))
        cos_s = cos_s.add(tc) if k % 2 == 0 else cos_s.sub(tc)
        rem_sin = pow_sin * yub2 / _ifact(2 * k + 3)
        rem_cos = pow_cos * yub2 / _ifact(2 * k + 2)
        if rem_sin <= eps and rem_cos <= eps:
            return sin_s.inflate(rem_sin), cos_s.inflate(rem_cos)
        p_sin = p_sin.mul(y2).round_out(bits + 32)
        p_cos = p_cos.mul(y2).round_out(bits + 32)
        pow_sin *= yub2
        pow_cos *= yub2
        k += 1
        if k > 400:
            raise RuntimeError("_sin_cos_taylor: no convergence")


def sin_cos_iv(X: Iv, bits: int) -> tuple[Iv, Iv]:
    """Enclosure of (sin, cos) on an interval.

    Reduces modulo 2*pi (using a high-precision pi enclosure) and recurses on
    halves when the interval is wide.
    """
    if X.width > F(1, 2):
        m = X.mid
        left, right = Iv(X.lo, m), Iv(m, X.hi)
        sl, cl = sin_cos_iv(left, bits)
        sr, cr = sin_cos_iv(right, bits)
        return Iv.union(sl, sr), Iv.union(cl, cr)
    two_pi = pi_iv(bits + 64).scale(2)
    ratio = X.mid / two_pi.mid
    k = int(ratio + F(1, 2)) if ratio >= 0 else -int(-ratio + F(1, 2))
    Y = X.sub(two_pi.scale(F(k)))
    return _sin_cos_taylor(Y, bits)


def sin_iv(X: Iv, bits: int) -> Iv:
    return sin_cos_iv(X, bits)[0]


def cos_iv(X: Iv, bits: int) -> Iv:
    return sin_cos_iv(X, bits)[1]


# --------------------------------------------------------------------------- #
#  complex boxes
# --------------------------------------------------------------------------- #

class Cx:
    """A complex rectangle: re is an Iv, im is an Iv."""

    __slots__ = ("re", "im")

    def __init__(self, re, im):
        self.re = re if isinstance(re, Iv) else Iv.pt(re)
        self.im = im if isinstance(im, Iv) else Iv.pt(im)

    @staticmethod
    def zero() -> "Cx":
        return Cx(Iv.pt(0), Iv.pt(0))

    @staticmethod
    def one() -> "Cx":
        return Cx(Iv.pt(1), Iv.pt(0))

    def contains_pt(self, re, im) -> bool:  # testing only, exact rational inputs
        return self.re.contains(q(re)) and self.im.contains(q(im))

    def add(self, o: "Cx") -> "Cx":
        return Cx(self.re.add(o.re), self.im.add(o.im))

    def neg(self) -> "Cx":
        return Cx(self.re.neg(), self.im.neg())

    def sub(self, o: "Cx") -> "Cx":
        return Cx(self.re.sub(o.re), self.im.sub(o.im))

    def scale(self, c) -> "Cx":
        return Cx(self.re.scale(c), self.im.scale(c))

    def mul(self, o: "Cx") -> "Cx":
        re = self.re.mul(o.re).sub(self.im.mul(o.im))
        im = self.re.mul(o.im).add(self.im.mul(o.re))
        return Cx(re, im)

    def conj(self) -> "Cx":
        return Cx(self.re, self.im.neg())

    def div(self, o: "Cx") -> "Cx":
        den = o.re.mul(o.re).add(o.im.mul(o.im))   # |o|^2, needs > 0
        if den.lo <= 0:
            raise ZeroDivisionError(f"Cx.div: denominator box {o} contains 0")
        num = self.mul(o.conj())
        return Cx(num.re.div(den), num.im.div(den))

    def inflate(self, r) -> "Cx":
        return Cx(self.re.inflate(r), self.im.inflate(r))

    def __repr__(self) -> str:
        return f"Cx(re={self.re!r}, im={self.im!r})"


def Cx_real(x) -> Cx:
    return Cx(Iv.pt(x), Iv.pt(0))


def Cx_zero() -> Cx:
    return Cx.zero()


def Cx_one() -> Cx:
    return Cx.one()


def cexp(Z: Cx, bits: int) -> Cx:
    """Enclosure of exp(z) = exp(Re z) (cos Im z + i sin Im z)."""
    e = exp_iv(Z.re, bits)
    s, c = sin_cos_iv(Z.im, bits)
    return Cx(e.mul(c), e.mul(s))
