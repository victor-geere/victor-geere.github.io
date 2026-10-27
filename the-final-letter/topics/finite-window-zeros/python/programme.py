"""Finite-window zero certificates (P3).

The grouped alternating (eta) series

    eta(s) = sum_{m>=0} ((2m+1)^(-s) - (2m+2)^(-s))

converges absolutely for Re s > 0 and satisfies
(1 - 2^(1-s)) zeta(s) = eta(s).  This module computes rigorous complex
rectangles for eta on a rational rectangle using mpmath's interval arithmetic,
adds the explicit pair tail bound, and divides by an interval for
1 - 2^(1-s) when that interval excludes zero.

Importing this module has no side effects.
"""
from __future__ import annotations

import math
from dataclasses import dataclass

import mpmath as mp

DEFAULT_DPS = 40


@dataclass(frozen=True)
class Box:
    """A complex rectangle with float endpoints (for reporting and tests)."""

    re_lo: float
    re_hi: float
    im_lo: float
    im_hi: float

    def contains(self, z: complex, tol: float = 0.0) -> bool:
        return (
            self.re_lo - tol <= z.real <= self.re_hi + tol
            and self.im_lo - tol <= z.imag <= self.im_hi + tol
        )

    def distance_to_zero(self) -> float:
        dx = max(0.0, self.re_lo, -self.re_hi)
        dy = max(0.0, self.im_lo, -self.im_hi)
        return math.hypot(dx, dy)

    def width(self) -> float:
        return max(self.re_hi - self.re_lo, self.im_hi - self.im_lo)


def _iv_box(z) -> Box:
    """Convert an mpmath.iv complex interval to a Box."""
    return Box(float(z.real.a), float(z.real.b), float(z.imag.a), float(z.imag.b))


def _pow_neg(base: int, s) -> complex:
    """base^(-s) with mpmath precision."""
    return mp.exp(-s * mp.log(mp.mpf(base)))


def pair_term(s: complex, m: int) -> complex:
    """The m-th adjacent odd/even pair (2m+1)^(-s) - (2m+2)^(-s)."""
    if m < 0:
        raise ValueError("m must be non-negative")
    return _pow_neg(2 * m + 1, s) - _pow_neg(2 * m + 2, s)


def pair_partial(s: complex, M: int) -> complex:
    """Sum of the first M pairs, the grouped eta partial sum."""
    if M < 0:
        raise ValueError("M must be non-negative")
    return sum((pair_term(s, m) for m in range(M)), mp.mpc(0))


def alt_partial(s: complex, N: int) -> complex:
    """The alternating partial sum sum_{n=1}^{N} (-1)^(n-1) n^(-s)."""
    if N < 0:
        raise ValueError("N must be non-negative")
    return sum((((-1) ** (n - 1)) * _pow_neg(n, s) for n in range(1, N + 1)), mp.mpc(0))


def pair_tail_bound(sigma: float, s_abs: float, M: int) -> float:
    r"""Rigorous bound for |sum_{m>=M} pair_m(s)|.

    With p = sigma + 1 > 1, the pair estimate gives
        |pair_m(s)| <= |s| (2m+1)^(-p),
    and the decreasing-sum/integral comparison gives
        sum_{m>=M} (2m+1)^(-p)
            <= (2M+1)^(-p) + (2M+1)^(1-p) / (2(p-1)).
    """
    if sigma <= 0:
        raise ValueError("the pair tail bound needs sigma > 0")
    if M < 0:
        raise ValueError("M must be non-negative")
    p = sigma + 1.0
    base = 2.0 * M + 1.0
    majorant = base ** (-p) + base ** (1.0 - p) / (2.0 * (p - 1.0))
    return s_abs * majorant


def _cpow_iv(base, s_re, s_im):
    """Interval for base^(-s), base a positive real interval."""
    return mp.iv.exp((s_re + 1j * s_im) * (-mp.iv.log(base)))


def eta_enclosure(
    s_re_lo: float,
    s_re_hi: float,
    s_im_lo: float,
    s_im_hi: float,
    M: int,
    dps: int = DEFAULT_DPS,
) -> tuple[Box, float]:
    """Return (box containing eta(s), pair tail radius) on the rectangle."""
    if M <= 0:
        raise ValueError("M must be positive")
    if s_re_lo <= 0:
        raise ValueError("the grouped eta enclosure needs Re s > 0")
    mp.mp.dps = dps
    s_re = mp.iv.mpf([s_re_lo, s_re_hi])
    s_im = mp.iv.mpf([s_im_lo, s_im_hi])
    acc = mp.iv.mpc(0, 0)
    for m in range(M):
        acc += _cpow_iv(mp.iv.mpf(2 * m + 1), s_re, s_im)
        acc -= _cpow_iv(mp.iv.mpf(2 * m + 2), s_re, s_im)
    s_abs = math.hypot(max(abs(s_re_lo), abs(s_re_hi)), max(abs(s_im_lo), abs(s_im_hi)))
    tail = pair_tail_bound(s_re_lo, s_abs, M)
    return _iv_box(acc), tail


def factor_enclosure(
    s_re_lo: float,
    s_re_hi: float,
    s_im_lo: float,
    s_im_hi: float,
    dps: int = DEFAULT_DPS,
) -> Box:
    """Return a box for 1 - 2^(1-s)."""
    mp.mp.dps = dps
    s_re = mp.iv.mpf([s_re_lo, s_re_hi])
    s_im = mp.iv.mpf([s_im_lo, s_im_hi])
    z = mp.iv.mpf(1) - mp.iv.exp((1 - (s_re + 1j * s_im)) * mp.iv.log(mp.iv.mpf(2)))
    return _iv_box(z)


def zeta_enclosure(
    s_re_lo: float,
    s_re_hi: float,
    s_im_lo: float,
    s_im_hi: float,
    M: int,
    dps: int = DEFAULT_DPS,
) -> tuple[Box, float]:
    """Certified box for zeta on the rectangle, plus its radius.

    If eta in E and 1 - 2^(1-s) in F with dist(F, 0) = fl > 0, then
        |zeta(s) - E/F| <= tail / fl,
    so the returned box is E/F inflated by tail/fl.
    """
    eta_box, tail = eta_enclosure(s_re_lo, s_re_hi, s_im_lo, s_im_hi, M, dps)
    f_box = factor_enclosure(s_re_lo, s_re_hi, s_im_lo, s_im_hi, dps)
    fl = f_box.distance_to_zero()
    if fl == 0.0:
        raise ValueError("the factor interval contains zero")
    # Report E/F as a float box, then inflate; the true bound is tail/fl.
    mp.mp.dps = dps
    s_re = mp.iv.mpf([s_re_lo, s_re_hi])
    s_im = mp.iv.mpf([s_im_lo, s_im_hi])
    acc = mp.iv.mpc(0, 0)
    for m in range(M):
        acc += _cpow_iv(mp.iv.mpf(2 * m + 1), s_re, s_im)
        acc -= _cpow_iv(mp.iv.mpf(2 * m + 2), s_re, s_im)
    f = mp.iv.mpf(1) - mp.iv.exp((1 - (s_re + 1j * s_im)) * mp.iv.log(mp.iv.mpf(2)))
    q = _iv_box(acc / f)
    radius = tail / fl
    inflated = Box(q.re_lo - radius, q.re_hi + radius, q.im_lo - radius, q.im_hi + radius)
    return inflated, radius
