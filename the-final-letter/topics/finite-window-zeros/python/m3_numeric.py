"""Numerical exploration for the M3-finite window.

These routines are numerical evidence only, not certified enclosures.
"""
from __future__ import annotations

import mpmath as mp


def rect_boundary(x1: float, x2: float, y1: float, y2: float, n: int = 2000):
    """Sample the boundary of a rectangle, counter-clockwise."""
    pts = []
    for i in range(n):
        t = i / n
        if t < 0.25:
            z = x1 + (x2 - x1) * (4 * t) + 1j * y1
        elif t < 0.5:
            z = x2 + 1j * (y1 + (y2 - y1) * (4 * t - 1))
        elif t < 0.75:
            z = x1 + (x2 - x1) * (3 - 4 * t) + 1j * y2
        else:
            z = x1 + 1j * (y1 + (y2 - y1) * (4 - 4 * t))
        pts.append(z)
    return pts


def zeta_winding(x1: float, x2: float, y1: float, y2: float, n: int = 2000) -> int:
    """Numerical winding number of ζ around the rectangle boundary."""
    pts = rect_boundary(x1, x2, y1, y2, n)
    vals = [mp.zeta(z) for z in pts]
    total = mp.mpf(0)
    for a, b in zip(vals, vals[1:] + vals[:1]):
        total += mp.arg(b / a)
    return int(round(float(total / (2 * mp.pi))))


def zero_count_T(T: float, n: int = 2000) -> int:
    """Winding number minus the pole at s = 1 for the strip [-1,2]×[-T,T]."""
    w = zeta_winding(-1.0, 2.0, -T, T, n)
    # w = Z - P with P = 1 at s = 1, so Z = w + 1.
    return w + 1


def _tent(u):
    return max(mp.mpf(0), 1 - abs(2 * u))


def tent_arch_numeric(T: float, dps: int = 12):
    """Numerical value of tentArch T (not a certified enclosure)."""
    with mp.workdps(dps):
        def inner(u, y):
            return (mp.log(mp.pi) / 2 - mp.digamma((2 + 1j * y) / 2) / 2) * mp.e ** (-u * y)

        def outer(u):
            I = mp.quad(lambda y: inner(u, y), [-T, 0, T])
            return _tent(u) * mp.e ** (1j * mp.mpf(3) / 2 * u) * I

        return mp.quad(outer, [-1, -0.5, 0, 0.5, 1])


def tent_prime_numeric(T: float, dps: int = 12):
    """Numerical value of tentPrime T (not a certified enclosure)."""
    with mp.workdps(dps):
        def inner(u, y):
            s = 2 + 1j * y
            return (-mp.zeta(s, derivative=1) / mp.zeta(s)) * mp.e ** (-u * y)

        def outer(u):
            I = mp.quad(lambda y: inner(u, y), [-T, 0, T])
            return _tent(u) * mp.e ** (1j * mp.mpf(3) / 2 * u) * I

        return mp.quad(outer, [-1, -0.5, 0, 0.5, 1])
