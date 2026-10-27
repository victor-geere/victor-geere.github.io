"""Feasibility probe for zero isolation around the first nontrivial zero.

This is a *probe*, not a certificate: it uses complex floating point and a
finite grouped eta sum.  It records the winding number of eta around the
rectangle Re in [0.4,0.6], Im in [14.0,14.3] and the minimum boundary modulus.

The probe also documents the obstruction found when trying to reuse the P3
rational enclosure directly: the grouped-eta tail bound at sigma ~ 0.5 is
O(|s|/sqrt(M)), so the P3 certificate would need M ~ 10^8 terms to resolve a
neighbourhood of the zero.  An accelerated representation (Euler transform or
Riemann-Siegel) is required before a Lean zero-isolation certificate.
"""

import cmath
import math

import mpmath as mp


def eta(s, M=4000):
    """Floating grouped eta partial sum."""
    z = 0j
    for m in range(M):
        z += (2 * m + 1) ** (-s) - (2 * m + 2) ** (-s)
    return z


def boundary_points(re_lo, re_hi, im_lo, im_hi, N=200):
    pts = []
    for i in range(N):
        t = i / N
        pts.append(complex(re_lo + (re_hi - re_lo) * t, im_lo))
    for i in range(N):
        t = i / N
        pts.append(complex(re_hi, im_lo + (im_hi - im_lo) * t))
    for i in range(N):
        t = i / N
        pts.append(complex(re_hi - (re_hi - re_lo) * t, im_hi))
    for i in range(N):
        t = i / N
        pts.append(complex(re_lo, im_hi - (im_hi - im_lo) * t))
    return pts


def winding(re_lo=0.4, re_hi=0.6, im_lo=14.0, im_hi=14.3, N=200, M=4000):
    pts = boundary_points(re_lo, re_hi, im_lo, im_hi, N)
    vals = [eta(s, M) for s in pts]
    angles = [cmath.phase(v) for v in vals]
    total = 0.0
    for a, b in zip(angles, angles[1:] + angles[:1]):
        d = b - a
        while d > math.pi:
            d -= 2 * math.pi
        while d < -math.pi:
            d += 2 * math.pi
        total += d
    return total / (2 * math.pi), min(abs(v) for v in vals)


def first_zero_ordinate(dps=50):
    """High-precision numerical ordinate of the first nontrivial zero.

    This uses mpmath.zeta and findroot; it is a numerical datum, not a
    certificate.  The imaginary part of the zero is returned.
    """
    mp.mp.dps = dps
    f = lambda t: mp.re(mp.zeta(mp.mpc(mp.mpf(1) / 2, t)))
    return mp.findroot(f, mp.mpf("14.1347"))
