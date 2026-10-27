"""Euler--Maclaurin enclosure for zeta on a rectangle with Re s > 0.

The formula used is the standard Euler--Maclaurin continuation

    zeta(s) = sum_{n=1}^N n^{-s} + N^{1-s}/(s-1) - N^{-s}/2
              + sum_{k=1}^K B_{2k}/(2k)! * (s)_{2k-1} N^{-s-2k+1} + R,

with the rigorous remainder bound

    |R| <= |(s)_{2K+1}| * 2*zeta(2K+1)/(2*pi)^(2K+1)
             * N^(-sigma-2K)/(sigma+2K),

where sigma = Re s > 0 and zeta(2K+1) <= 2 for K >= 1.  This is a *numerical*
interval enclosure; the Lean formalisation of the remainder theorem is future
work.
"""

import math

import mpmath as mp
from mpmath import iv

DPS = 50
iv.dps = DPS


def _cpow(n, s):
    """Interval for n^{-s}, n positive integer, s an interval complex."""
    return iv.exp(-s * iv.log(iv.mpf(n)))


def _rf_interval(s, m):
    """Rising factorial (s)_m for an interval complex s."""
    z = iv.mpc(1, 0)
    for j in range(m):
        z *= s + j
    return z


def _abs_upper(z):
    """Upper bound for |z| over an interval complex box."""
    vals = [
        abs(complex(float(x), float(y)))
        for x in (z.real.a, z.real.b)
        for y in (z.imag.a, z.imag.b)
    ]
    return max(vals)


def zeta_em_iv(re_lo, re_hi, im_lo, im_hi, N=20, K=20):
    """Rigorous interval box for zeta(s) on the rectangle.

    Requires ``re_lo > 0`` and ``s = 1`` outside the rectangle.
    Returns an ``iv.mpc`` box.
    """
    if re_lo <= 0:
        raise ValueError("Euler--Maclaurin enclosure needs Re s > 0")
    if re_lo <= 1 <= re_hi and im_lo <= 0 <= im_hi:
        raise ValueError("rectangle must avoid s = 1")
    s = iv.mpc([re_lo, re_hi], [im_lo, im_hi])
    total = iv.mpc(0, 0)
    for n in range(1, N + 1):
        total += _cpow(n, s)
    total += _cpow(N, s - 1) / (s - 1)
    total -= _cpow(N, s) / 2
    for k in range(1, K + 1):
        B = iv.mpf(mp.bernoulli(2 * k))
        rf = _rf_interval(s, 2 * k - 1)
        total += B / mp.factorial(2 * k) * rf * _cpow(N, s + 2 * k - 1)
    # remainder bound
    rf2 = _rf_interval(s, 2 * K + 1)
    rem = (_abs_upper(rf2) * 2.0 * 2.0 / float((2 * mp.pi) ** (2 * K + 1))
           * float(N) ** (-re_lo - 2 * K) / (re_lo + 2 * K))
    total += iv.mpc([-rem, rem], [-rem, rem])
    return total


def _arg_box(z):
    """Argument interval for an interval complex box avoiding zero.

    Returns (lo, hi, mid) in radians, unwrapped around the box midpoint.
    """
    xs = (z.real.a, z.real.b)
    ys = (z.imag.a, z.imag.b)
    mid = math.atan2((float(z.imag.a) + float(z.imag.b)) / 2.0,
                     (float(z.real.a) + float(z.real.b)) / 2.0)
    angles = []
    for x in xs:
        for y in ys:
            a = math.atan2(float(y), float(x))
            while a - mid > math.pi:
                a -= 2 * math.pi
            while a - mid < -math.pi:
                a += 2 * math.pi
            angles.append(a)
    return min(angles), max(angles), mid


def _dist_zero(z):
    dx = max(0.0, float(z.real.a), -float(z.real.b))
    dy = max(0.0, float(z.imag.a), -float(z.imag.b))
    return math.hypot(dx, dy)


def winding_em(re_lo, re_hi, im_lo, im_hi, N=20, K=20, nseg=100):
    """Certified winding number interval of zeta around the rectangle.

    Returns (lo, hi, min_dist), where [lo, hi] contains the total argument
    change divided by 2*pi and min_dist is the minimum boundary distance to 0.
    This trusts the Euler--Maclaurin remainder bound implemented in
    ``zeta_em_iv``.
    """
    edges = [
        (re_lo, re_hi, im_lo, im_lo, True),
        (re_hi, re_hi, im_lo, im_hi, False),
        (re_hi, re_lo, im_hi, im_hi, True),
        (re_lo, re_lo, im_hi, im_lo, False),
    ]
    total_lo = 0.0
    total_hi = 0.0
    prev_lo = prev_hi = None
    min_dist = float("inf")
    for (a, b, c, d, horiz) in edges:
        for i in range(nseg):
            t0 = i / nseg
            t1 = (i + 1) / nseg
            if horiz:
                x0 = a + (b - a) * t0
                x1 = a + (b - a) * t1
                z = zeta_em_iv(min(x0, x1), max(x0, x1), c, c, N, K)
            else:
                y0 = c + (d - c) * t0
                y1 = c + (d - c) * t1
                z = zeta_em_iv(a, a, min(y0, y1), max(y0, y1), N, K)
            dist = _dist_zero(z)
            if dist <= 0:
                raise ValueError("boundary box contains zero")
            min_dist = min(min_dist, dist)
            lo, hi, mid = _arg_box(z)
            if prev_lo is None:
                prev_lo, prev_hi = lo, hi
            else:
                total_lo += lo - prev_hi
                total_hi += hi - prev_lo
                prev_lo, prev_hi = lo, hi
    return total_lo / (2 * math.pi), total_hi / (2 * math.pi), min_dist


def _abs_upper_box(z):
    return max(
        math.hypot(float(x), float(y))
        for x in (z.real.a, z.real.b)
        for y in (z.imag.a, z.imag.b)
    )


def zeta_sup_bound(re_lo, re_hi, im_lo, im_hi, N=20, K=20, nsub=4):
    """Rigorous upper bound for |zeta| on the rectangle.

    Subdivides the rectangle and takes the maximum corner magnitude of each
    Euler--Maclaurin image box.
    """
    M = 0.0
    for i in range(nsub):
        for j in range(nsub):
            a = re_lo + (re_hi - re_lo) * i / nsub
            b = re_lo + (re_hi - re_lo) * (i + 1) / nsub
            c = im_lo + (im_hi - im_lo) * j / nsub
            d = im_lo + (im_hi - im_lo) * (j + 1) / nsub
            z = zeta_em_iv(a, b, c, d, N, K)
            M = max(M, _abs_upper_box(z))
    return M


def zeta_deriv_bound(re_lo, re_hi, im_lo, im_hi, pad=0.01, N=20, K=20):
    """Cauchy bound for |zeta'| on the inner rectangle.

    Uses a disk of radius ``pad`` inside the padded rectangle and
    ``|zeta'| <= M/pad``.
    """
    M = zeta_sup_bound(re_lo - pad, re_hi + pad, im_lo - pad, im_hi + pad, N, K)
    return M / pad, M


def _rf_deriv_interval(s, m):
    """Derivative of the rising factorial (s)_m, as an interval complex."""
    total = iv.mpc(0, 0)
    for r in range(m):
        prod = iv.mpc(1, 0)
        for j in range(m):
            if j != r:
                prod *= s + j
        total += prod
    return total


def _abs_upper_iv(z):
    return max(
        math.hypot(float(x), float(y))
        for x in (z.real.a, z.real.b)
        for y in (z.imag.a, z.imag.b)
    )


def zeta_em_deriv_iv(re_lo, re_hi, im_lo, im_hi, N=20, K=20):
    """Interval enclosure of zeta'(s) on a rectangle with Re s > 0.

    Differentiates the Euler--Maclaurin formula term by term and adds a
    conservative remainder-derivative bound.  Numerical enclosure, not yet a
    Lean theorem.
    """
    if re_lo <= 0:
        raise ValueError("Euler--Maclaurin derivative needs Re s > 0")
    s = iv.mpc([re_lo, re_hi], [im_lo, im_hi])
    total = iv.mpc(0, 0)
    # partial sum derivative
    for n in range(1, N + 1):
        total -= iv.log(iv.mpf(n)) * _cpow(n, s)
    # N^{1-s}/(s-1) derivative
    A = _cpow(N, s - 1)
    total += A * (-iv.log(iv.mpf(N)) / (s - 1) - 1 / (s - 1) ** 2)
    # -N^{-s}/2 derivative
    total += iv.log(iv.mpf(N)) * _cpow(N, s) / 2
    # Bernoulli terms
    for k in range(1, K + 1):
        m = 2 * k - 1
        B = iv.mpf(mp.bernoulli(2 * k)) / mp.factorial(2 * k)
        rf = _rf_interval(s, m)
        drf = _rf_deriv_interval(s, m)
        base = _cpow(N, s + 2 * k - 1)
        total += B * (drf * base + rf * base * (-iv.log(iv.mpf(N))))
    # remainder-derivative bound
    M = 2 * K + 1
    rf = _rf_interval(s, M)
    drf = _rf_deriv_interval(s, M)
    abs_rf = _abs_upper_iv(rf)
    abs_drf = _abs_upper_iv(drf)
    zeta_up = 2.0
    coef = 2.0 * zeta_up / float((2 * mp.pi) ** M) / float(mp.factorial(M))
    sigma = re_lo
    I0 = float(N) ** (-sigma - M + 1) / (sigma + M - 1)
    I1 = float(N) ** (-sigma - M + 1) * (
        math.log(N) / (sigma + M - 1) + 1.0 / (sigma + M - 1) ** 2
    )
    rem = abs_drf * coef * I0 + abs_rf * coef * I1
    total += iv.mpc([-rem, rem], [-rem, rem])
    return total


def krawczyk_box(re_lo, re_hi, im_lo, im_hi, N=20, K=20):
    """One Krawczyk step for zeta on the rectangle.

    Returns (K, X, ok) with K the Krawczyk image box and ok the strict
    inclusion K ⊂ interior(X).
    """
    X = iv.mpc([re_lo, re_hi], [im_lo, im_hi])
    x0 = iv.mpc((re_lo + re_hi) / 2, (im_lo + im_hi) / 2)
    f0 = zeta_em_iv(float(x0.real.a), float(x0.real.b),
                    float(x0.imag.a), float(x0.imag.b), N, K)
    D0 = zeta_em_deriv_iv(float(x0.real.a), float(x0.real.b),
                          float(x0.imag.a), float(x0.imag.b), N, K)
    DX = zeta_em_deriv_iv(re_lo, re_hi, im_lo, im_hi, N, K)
    Y = 1 / D0
    Kbox = x0 - Y * f0 + (1 - Y * DX) * (X - x0)
    ok = (Kbox.real.a > X.real.a and Kbox.real.b < X.real.b and
          Kbox.imag.a > X.imag.a and Kbox.imag.b < X.imag.b)
    return Kbox, X, ok
