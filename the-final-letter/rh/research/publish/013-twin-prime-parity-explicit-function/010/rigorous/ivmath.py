#!/usr/bin/env python3
"""
Bundled copy of rh43/ivmath.py for 010: rigorous real arithmetic (value + guaranteed error).

A `Num` is a real number known to lie in the interval

    [ v - e , v + e ]        with  v, e  mpf at WORK decimal places,  e >= 0.

Every operation returns a `Num` whose error dominates *all* roundings: mpmath
arithmetic at WORK dps is correctly rounded, and the blanket slack `EPS` is many
orders of magnitude larger than the accumulated rounding (WORK = 400 dps, EPS =
1e-320, O(10^2) operations), so a sign decided from a `Num` is a proof.  The
transcendental quantities are not taken from mpmath's `cos`/`log`:

  * pi   : Machin, pi = 16 atan(1/5) - 4 atan(1/239), alternating series with an
           explicit alternating-remainder bound;
  * log n: log n = 2 atanh((n-1)/(n+1)) over the prime factors of n, geometric tail;
  * cos  : reduction mod 2 pi (with pi enclosed as above) + Taylor series with the
           alternating-series remainder bound;
  * sin  : sin x = cos(x - pi/2).

`empirical_*`-style use of mpmath is for reporting only; nothing rigorous is built
from mpmath's own `cos`/`log`/`pi`.
"""
from __future__ import annotations

from fractions import Fraction

import mpmath as mp

WORK = 400                       # decimal digits for every rigorous computation
# make mpmath arithmetically honest: rounding is charged explicitly through EPS, so
# the comparisons used by the sign decisions see a single, reproducible value
mp.mp.prec = int(WORK * 3.33)
mp.mpf.round_floor = 'floor'
mp.mpf.round_ceiling = 'floor'
EPS = mp.mpf('1e-320')           # blanket rounding slack per operation
ZERO = mp.mpf(0)
ONE = mp.mpf(1)



def _at_work(fn):
    """Evaluate fn at the module working precision (used by the Num operators)."""
    saved = mp.mp.dps
    mp.mp.dps = WORK
    try:
        return fn()
    finally:
        mp.mp.dps = saved


def _add(v1, e1, v2, e2):
    return mp.mpf(v1) + mp.mpf(v2), mp.mpf(e1) + mp.mpf(e2) + EPS


def _sub(v1, e1, v2, e2):
    return mp.mpf(v1) - mp.mpf(v2), mp.mpf(e1) + mp.mpf(e2) + EPS


def _mul(v1, e1, v2, e2):
    v1, e1, v2, e2 = mp.mpf(v1), mp.mpf(e1), mp.mpf(v2), mp.mpf(e2)
    return v1 * v2, abs(v1) * e2 + abs(v2) * e1 + e1 * e2 + EPS


def _div_int(v, e, m):
    v, e, m = mp.mpf(v), mp.mpf(e), mp.mpf(m)
    return v / m, e / m + EPS


class Num:
    """A rigorous real number: the true value lies in [v - e, v + e]."""

    __slots__ = ("v", "e")

    def __init__(self, v, e=ZERO):
        self.v = mp.mpf(v)
        e = mp.mpf(e)
        self.e = e if e >= 0 else ZERO

    # -- arithmetic --------------------------------------------------------- #
    def __add__(self, o):
        o = _num(o)
        return Num(*_at_work(lambda: _add(self.v, self.e, o.v, o.e)))

    __radd__ = __add__

    def __sub__(self, o):
        o = _num(o)
        return Num(*_at_work(lambda: _sub(self.v, self.e, o.v, o.e)))

    def __neg__(self):
        return Num(-self.v, self.e)

    def __mul__(self, o):
        o = _num(o)
        return Num(*_at_work(lambda: _mul(self.v, self.e, o.v, o.e)))

    __rmul__ = __mul__

    def div_int(self, m: int):
        return Num(*_at_work(lambda: _div_int(self.v, self.e, m)))

    def mul_int(self, m: int):
        return Num(*_at_work(lambda: _mul(self.v, self.e, mp.mpf(m), ZERO)))

    # -- reading ------------------------------------------------------------ #
    @property
    def lo(self):
        return self.v - self.e

    @property
    def hi(self):
        return self.v + self.e

    def sign(self) -> int:
        """+1 / -1 when the enclosure excludes 0, else 0."""
        if self.hi < 0:
            return -1
        if self.lo > 0:
            return 1
        return 0

    def contains(self, x) -> bool:
        x = mp.mpf(x)
        return self.lo <= x <= self.hi

    def __repr__(self):
        return f"Num({mp.nstr(self.v, 20)} +- {mp.nstr(self.e, 3)})"


def _num(o) -> Num:
    return o if isinstance(o, Num) else Num(o)


def _pin(fn):
    """Run `fn` at the module working precision.

    The rigorous objects must be built at WORK dps whatever the empirical code around
    them has set `mp.mp.dps` to; otherwise a value could be rounded to the caller's
    much lower precision while still claiming the WORK-dps error bound.  Re-entrant:
    only the outermost pinned call sets and restores the precision.
    """
    import functools
    depth = {"n": 0}

    @functools.wraps(fn)
    def wrapper(*args, **kwargs):
        outer = depth["n"] == 0
        saved = mp.mp.dps
        if outer:
            mp.mp.dps = WORK
        depth["n"] += 1
        try:
            return fn(*args, **kwargs)
        finally:
            depth["n"] -= 1
            if outer:
                mp.mp.dps = saved
    return wrapper



def rat(f: Fraction) -> Num:
    """The exact rational f, with only the blanket slack."""
    saved = mp.mp.dps
    mp.mp.dps = WORK
    try:
        return Num(mp.mpf(f.numerator) / mp.mpf(f.denominator), EPS)
    finally:
        mp.mp.dps = saved


def _sum_rational_terms(terms) -> Num:
    """Sum of exact rational terms; the summation rounding is covered by the slack."""
    acc = ZERO
    e = EPS
    for t in terms:
        acc += mp.mpf(t.numerator) / mp.mpf(t.denominator)
        e += EPS                      # one correctly-rounded addition per term
    return Num(acc, e)


def _series(terms, tail_abs: Fraction) -> Num:
    """A series whose remainder after `terms` is at most `tail_abs` in absolute value."""
    s = _sum_rational_terms(terms)
    return Num(s.v, s.e + mp.mpf(tail_abs.numerator) / mp.mpf(tail_abs.denominator) + EPS)


# --------------------------------------------------------------------------- #
# pi
# --------------------------------------------------------------------------- #

_PI: Num | None = None
_LOG: dict[int, Num] = {}


@_pin
def pi() -> Num:
    """Machin's formula with the alternating arctan remainders."""
    global _PI
    if _PI is None:
        K = 420

        def atan_inv(n: int) -> Num:
            terms = [Fraction((-1) ** (k - 1), n ** (2 * k - 1) * (2 * k - 1))
                     for k in range(1, K + 1)]
            return _series(terms, Fraction(1, n ** (2 * K + 1) * (2 * K + 1)))

        a = atan_inv(5)
        b = atan_inv(239)
        _PI = Num(16 * a.v - 4 * b.v, 16 * a.e + 4 * b.e + EPS)
    return _PI


# --------------------------------------------------------------------------- #
# log
# --------------------------------------------------------------------------- #

def _factorize(n: int):
    out = []
    m, d = n, 2
    while d * d <= m:
        if m % d == 0:
            e = 0
            while m % d == 0:
                m //= d
                e += 1
            out.append((d, e))
        d += 1
    if m > 1:
        out.append((m, 1))
    return out


@_pin
def log_prime(p: int, e: int = 1) -> Num:
    """log p = 2 atanh((p-1)/(p+1)): a positive series with a geometric tail.

    Returns an enclosure of `e * log p` (the products of the same prime are grouped
    so that the tail bound scales with the exponent `e`).
    """
    K = 120
    q = Fraction(p - 1, p + 1)
    terms = [e * 2 * q ** (2 * k + 1) / (2 * k + 1) for k in range(K)]
    last = e * 2 * q ** (2 * K + 1) / (2 * K + 1)
    return _series(terms, last / (1 - q * q))


@_pin
def log_mpf(n: int):
    """The centre of the rigorous enclosure of log n (reporting/empirical use only)."""
    return log_n(n).v


@_pin
def log_n(n: int) -> Num:
    """log n from the prime factorization of n."""
    if n in _LOG:
        return _LOG[n]
    if n <= 1:
        _LOG[n] = Num(ZERO, ZERO)
        return _LOG[n]
    acc = Num(ZERO, ZERO)
    for p, e in _factorize(n):
        acc = acc + log_prime(p, e)
    _LOG[n] = acc
    return acc


# --------------------------------------------------------------------------- #
# cos / sin
# --------------------------------------------------------------------------- #

def _factorial(m: int) -> int:
    r = 1
    for i in range(2, m + 1):
        r *= i
    return r


@_pin
def cos_series(x: Num, K: int = 90) -> Num:
    """cos x, rigorously.

    The Taylor series is applied only to arguments of modulus <= pi/4 (where the
    remainder after 2K terms is far below the working precision); larger arguments
    are halved, using `cos 2u = 2 (cos u)^2 - 1`, as often as needed.
    """
    return _cos_small(x, K)


def _cos_small(x: Num, K: int) -> Num:
    p = pi()
    if abs(x.v) + x.e > p.v / 4:
        half = Num(x.v / 2, x.e / 2 + EPS)
        c = _cos_small(half, K)
        return Num(2 * c.v * c.v - 1,
                   (4 * abs(c.v) + 2 * c.e) * c.e + 4 * EPS)
    acc = Num(ZERO, ZERO)
    xp = Num(ONE, ZERO)
    for k in range(0, K + 1):
        if k > 0:
            xp = xp * x * x
        m = mp.mpf(_factorial(2 * k))
        term = Num(xp.v / m, xp.e / m + EPS)
        acc = acc + (term if k % 2 == 0 else -term)
    ax = Num(abs(x.v) + x.e, ZERO)
    pw = Num(ONE, ZERO)
    for _ in range(2 * K + 2):
        pw = pw * ax
    m2 = mp.mpf(_factorial(2 * K + 2))
    tail = Num(pw.v / m2, pw.e / m2 + EPS)
    return Num(acc.v, acc.e + tail.hi + EPS)


def _cos_monotone(a: mpf, b: mpf, K: int) -> tuple:
    """cos on a tiny interval [a, b] with 0 <= a <= b <= pi/2 (monotone decreasing)."""
    ca = cos_series(Num(a, EPS), K)
    cb = cos_series(Num(b, EPS), K)
    return (ca.lo if ca.lo < cb.lo else cb.lo), (ca.hi if ca.hi > cb.hi else cb.hi)


def _cos_quadrant(a: mpf, b: mpf, q: int, p: Num, K: int) -> tuple:
    """cos on a tiny interval [a, b] (a <= b) inside quadrant q of [0, 2 pi].

    q = 0: [0, pi/2]    cos in [cos b, cos a]
    q = 1: [pi/2, pi]   cos y = -cos(pi - y),  pi - y in [0, pi/2]
    q = 2: [pi, 3pi/2]  cos y = -cos(y - pi),  y - pi in [0, pi/2]
    q = 3: [3pi/2, 2pi] cos y =  cos(2pi - y), 2pi - y in [0, pi/2]
    """
    if q == 0:
        return _cos_monotone(a, b, K)
    if q == 1:
        lo, hi = _cos_monotone(p.v - b, p.v - a, K)
        return -hi, -lo
    if q == 2:
        lo, hi = _cos_monotone(a - p.v, b - p.v, K)
        return -hi, -lo
    lo, hi = _cos_monotone(2 * p.v - b, 2 * p.v - a, K)
    return lo, hi


@_pin
def cos_num(x: Num, K: int = 100) -> Num:
    """cos of a rigorous x of modest size, by reduction mod 2 pi + Taylor."""
    p = pi()
    u = reduce_mod_two_pi(x)
    period = 2 * p.v
    two_lo = 2 * p.lo
    windows = [(u.v - u.e, u.v + u.e)]
    # place the window inside [0, 2 pi_lo); split it if it crosses the seam
    w = windows[0]
    while w[1] < 0:
        w = (w[0] + two_lo, w[1] + two_lo)
    while w[0] >= two_lo:
        w = (w[0] - two_lo, w[1] - two_lo)
    if w[1] > two_lo:
        rest = w[1] - two_lo
        windows = [(w[0], two_lo), (mp.mpf(0), rest)]
    else:
        windows = [w]
    half = p.v / 2
    bounds = [p.v / 2, p.v, 3 * p.v / 2, two_lo]
    out_lo = None
    out_hi = None
    for a0, b0 in windows:
        for qi in range(4):
            qa = bounds[qi - 1] if qi > 0 else mp.mpf(0)
            qb = bounds[qi]
            a = a0 if a0 > qa else qa
            b = b0 if b0 < qb else qb
            if b < a:
                continue
            plo, phi = _cos_quadrant(a, b, qi, p, K)
            out_lo = plo if out_lo is None else min(out_lo, plo)
            out_hi = phi if out_hi is None else max(out_hi, phi)
    if out_lo is None or out_hi is None:
        return Num(ZERO, 2 * ONE)
    return Num((out_lo + out_hi) / 2, (out_hi - out_lo) / 2 + EPS)


@_pin
def reduce_mod_two_pi(x: Num) -> Num:
    """Reduce a rigorous x modulo 2 pi, preserving rigor."""
    p = pi()
    two_v = 2 * p.v
    k = mp.floor(x.v / two_v)
    if abs(k) > 10 ** 7:                   # absurd: do not trust the subtraction
        return Num(ZERO, 2 * (x.hi + p.hi) + ONE)
    red = Num(x.v - k * two_v,
              x.e + abs(k) * 2 * p.e + EPS)
    return red


@_pin
def sin_num(x: Num, K: int = 100) -> Num:
    """sin x = cos(x - pi/2)."""
    p = pi()
    return cos_num(Num(x.v - p.v / 2, x.e + p.e / 2 + EPS), K)
