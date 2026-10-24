#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
011/rigorous/dirichlet_routeB.py — the numerical zero data of Route B for a
Dirichlet L-function with a real primitive character chi.

Route B consumes a finite zero set `Z`, its orders `m`, and zero-freeness off `Z`
inside a Turing window.  For zeta those came from `010/rigorous/` (the I3 count)
and from Route A (sign changes of Z(t)).  This module supplies the same two
numerical certificates for the completed Dirichlet L-function

    H(s) = (N/pi)^((s+a)/2) Gamma((s+a)/2) L(chi, s),        a = parity in {0,1},

which is the engine's `Lambda_chi` of `dirichlet_interval.py`; it satisfies

    H(1-s) = eps * H(s),     H(conj s) = conj H(s),     eps = rootNumber chi in {+-1},

for a real primitive chi (the first is Mathlib's
`IsPrimitive.completedLFunction_one_sub` in the 011 normalisation, the second is
`DirichletCharacter.completedLFunction_conj`).  On the critical line s = 1/2 + it
this forces H to be real (eps = 1) or purely imaginary (eps = -1), so

    Xi(t) = Re H(1/2 + it)   if eps = 1,   Xi(t) = Im H(1/2 + it)   if eps = -1

is a real-analytic function whose zeros are exactly the on-line zeros of L.

Two rigorous numerical objects are provided:

  * `dirichlet_I3` — the half-contour integral
        I3 = int_path logDeriv H ds,
        path (1/2,1/2) -> (1,1/2) -> (1,T) -> (1/2,T),
    enclosed by the midpoint rule with the curvature budget
        |err| <= (1/4)|ds|^2 sup|(log H)''|;
    the identity 2 I3 = contour integral (reflection + reality) gives
        N_chi(T) = Im(I3)/pi = # zeros with 1/2 < Im s < T, counted with multiplicity.
    The reflection `logDeriv H(1-s) = -logDeriv H(s)` holds for every eps != 0
    (the root number cancels), so the formula is eps-independent.

  * `xi_enclose` — a rigorous enclosure of Xi(t), built from the engine's `L`
    enclosure times a rigorous Gamma evaluation.  A sign change of Xi between two
    points where the enclosure excludes 0 certifies an on-line zero (IVT), and
    the count N_chi(T) then upgrades "on-line" to "simple and on the line":
    if N_chi(T) disjoint sign-change brackets are found, the total multiplicity
    count forces each to be a simple zero and there is no other zero in the window.

Gamma evaluation
----------------
`Gamma(w)` is enclosed by the Stirling series after shifting by an integer `m`
(so Re(w+m) >= 24) plus the recurrence
    log Gamma(w) = log Gamma(w+m) - sum_{j=0}^{m-1} log(w+j),
with the remainder bound (Euler-Maclaurin; the periodic Bernoulli function obeys
|B~_{2K+2}| = |B_{2K+2}| and |w+x| >= Re(w) for x >= 0)

    |R_K(w)| <= |B_{2K+2}| / ((2K+2)(2K+1) Re(w)^{2K+1}).

No mpmath value enters a rigorous path anywhere.
"""
from __future__ import annotations

import os
import sys
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)
# the interval engine (ivmath, eta_interval) now lives alongside this module

import mpmath as mp            # noqa: E402  (working precision only)
import ivmath as iv            # noqa: E402
import eta_interval as E       # noqa: E402
import dirichlet_interval as D  # noqa: E402

ZERO = E.ZERO
ONE = E.ONE
Cx = E.Cx
_fr = D._frac
_fpf = D._mpf
_point = D._num


# --------------------------------------------------------------------------- #
#  exact Bernoulli numbers and factorials
# --------------------------------------------------------------------------- #

_FACT = [1]


def _fact(n: int) -> int:
    while len(_FACT) <= n:
        _FACT.append(_FACT[-1] * len(_FACT))
    return _FACT[n]


def _bern_frac(n: int) -> Fraction:
    num, den = mp.bernfrac(n)
    return Fraction(int(num), int(den))


# --------------------------------------------------------------------------- #
#  rigorous log Gamma (shift + Stirling, with an EM remainder)
# --------------------------------------------------------------------------- #

_LOG_GAMMA_SHIFT = 24
_LOG_GAMMA_K = 8


def _log_point(re, im) -> Cx:
    """Rigorous log(re + i im) for an exact positive rational part re > 0."""
    re, im = _fr(re), _fr(im)
    if re <= 0:
        raise ValueError("_log_point: Re must be positive")
    mod = E._sqrt_frac(re * re + im * im)
    lm = E._log_num(mod)
    arg = E._arg_num(Cx(_point(re, re), _point(im, im)))
    return Cx(lm, arg)


def _exp_cx(lg: Cx) -> Cx:
    """exp of a complex interval whose imaginary part is narrow (< pi)."""
    mag = D._exp_box(lg.re.lo, lg.re.hi)
    return Cx(mag * iv.cos_num(lg.im), mag * iv.sin_num(lg.im))


@iv._pin
def log_gamma_point(c, tau, shift: int = _LOG_GAMMA_SHIFT, K: int = _LOG_GAMMA_K) -> Cx:
    """Rigorous enclosure of `log Gamma(c + i tau)`, `c > 0`, `tau` exact rational."""
    c, tau = _fr(c), _fr(tau)
    if c <= 0:
        raise ValueError("log_gamma_point: Re w must be positive")
    m = int(shift)
    if c + m <= 0:
        raise ValueError("log_gamma_point: shift too small")
    w = Cx(_point(c, c), _point(tau, tau))
    W = Cx(_point(c + m, c + m), _point(tau, tau))
    lW = _log_point(c + m, tau)
    half = iv.Num(1).div_int(2)
    log2pi = E._log_num(iv.pi().mul_int(2))
    S = (W - Cx(half, iv.Num(0))) * lW - W + Cx(log2pi.div_int(2), iv.Num(0))

    invW = D._cdiv(Cx(ONE, ZERO), W)
    invW2 = invW * invW
    P = invW                                  # W^{-(2k-1)} for k = 1
    for k in range(1, K + 1):
        coef = _bern_frac(2 * k) / (2 * k * (2 * k - 1))
        S = S + E._cscale(P, coef)
        P = P * invW2                         # advance to W^{-(2k+1)}

    # Euler-Maclaurin remainder bound: |R_K| <= |B_{2K+2}|/((2K+2)(2K+1) Re(W)^{2K+1})
    Bnext = abs(_bern_frac(2 * K + 2))
    rem = (mp.mpf(Bnext.numerator) / mp.mpf(Bnext.denominator)
           / ((2 * K + 2) * (2 * K + 1)) / _fpf(c + m) ** (2 * K + 1))
    S = S.inflate(rem)

    sub = Cx(iv.Num(0), iv.Num(0))
    for j in range(m):
        sub = sub + _log_point(c + j, tau)
    return S - sub


@iv._pin
def gamma_point(c, tau, shift: int = _LOG_GAMMA_SHIFT, K: int = _LOG_GAMMA_K) -> Cx:
    """Rigorous enclosure of `Gamma(c + i tau)`, `c > 0`."""
    return _exp_cx(log_gamma_point(c, tau, shift, K))


# --------------------------------------------------------------------------- #
#  the completed Dirichlet L-function on the critical line
# --------------------------------------------------------------------------- #

def _check_chi(chi):
    return D._check_chi(chi)


def root_number(chi, parity):
    """The root number eps = tau(chi)/(i^a sqrt N) as an mpmath complex (diagnostic).

    For a real primitive chi this is +-1; the sign selects which component of
    H(1/2+it) is the real function Xi.
    """
    N = len(chi)
    a = int(_fr(parity))
    tau = mp.mpc(0)
    for n in range(1, N):
        tau += chi[n] * mp.e ** (2j * mp.pi * n / N)
    return tau / (1j ** a) / mp.sqrt(N)


@iv._pin
def completed_lambda_at(chi, parity, s_re, s_im, M: int = 20, K: int = 50,
                        shift: int = _LOG_GAMMA_SHIFT, KS: int = _LOG_GAMMA_K) -> Cx:
    """Enclosure of `H(s)` for `s = s_re + i s_im` (exact rationals), real `chi`."""
    N = _check_chi(chi)
    a = _fr(parity)
    s_re, s_im = _fr(s_re), _fr(s_im)
    wre = (s_re + a) / 2                   # Re((s+a)/2)
    wim = s_im / 2                         # Im((s+a)/2)
    G = gamma_point(wre, wim, shift, KS)
    Lv = D.dirichlet_L_box(chi, s_re, s_re, s_im, s_im, M, K)
    logb = D._log_frac(N, 1) - E._log_num(iv.pi())      # log(N/pi)
    base = iv.rat(wre) * logb
    mag = D._exp_box(base.lo, base.hi)
    ph = iv.rat(wim) * logb
    P = Cx(mag * iv.cos_num(ph), mag * iv.sin_num(ph))
    return P * G * Lv


@iv._pin
def completed_lambda_point(chi, parity, t, M: int = 20, K: int = 50,
                           shift: int = _LOG_GAMMA_SHIFT, KS: int = _LOG_GAMMA_K) -> Cx:
    """Enclosure of `H(1/2 + i t)` for the real character `chi`."""
    return completed_lambda_at(chi, parity, Fraction(1, 2), t, M, K, shift, KS)


def xi_enclose(chi, parity, t, eps_sign: int, M: int = 20, K: int = 50):
    """Rigorous enclosure of Xi(t) = Re H (eps_sign=+1) or Im H (eps_sign=-1)."""
    H = completed_lambda_point(chi, parity, t, M, K)
    return H.re if eps_sign > 0 else H.im


# --------------------------------------------------------------------------- #
#  the I3 count
# --------------------------------------------------------------------------- #

def _path_boxes(T, steps):
    T = _fr(T)
    h = Fraction(1, 2)
    path = [((h, h), (Fraction(1), h)),
            ((Fraction(1), h), (Fraction(1), T)),
            ((Fraction(1), T), (h, T))]
    out = []
    for (P, Q) in path:
        dx, dy = Q[0] - P[0], Q[1] - P[1]
        L = mp.sqrt(_fpf(dx) ** 2 + _fpf(dy) ** 2)
        n = max(1, int(mp.ceil(steps * L)))
        for i in range(n):
            ax, ay = P[0] + dx * i / n, P[1] + dy * i / n
            bx, by = P[0] + dx * (i + 1) / n, P[1] + dy * (i + 1) / n
            out.append((str(min(ax, bx)), str(max(ax, bx)),
                        str(min(ay, by)), str(max(ay, by)),
                        str(dx / n), str(dy / n)))
    return out


def one_box(task):
    """One I3 step -> (centre_re, centre_im, err_re, err_im) as floats.

    The step is evaluated by the midpoint rule with the curvature budget
    `factor * |ds|^2 * Lf`, `Lf` a rigorous bound on `|(log H)''|` over the step.

    The 011 engine's *box* enclosure of `L` is sound but loose near `Re s = 1/2`
    with small `|Im s|` (the Euler-Maclaurin pole term is large and the result is
    small, so the interval arithmetic does not cancel), so a step whose `L` box
    fails to be robustly bounded away from 0 is **subdivided** until it is.  This
    keeps the certificate rigorous and localises the cost.
    """
    box, chi, parity, M, K, factor = task
    import mpmath as mp
    mp.mp.dps = 40
    import dirichlet_interval as D
    D.fast_mode()
    sa, sb, sc, sd, sdx, sdy = box
    a, b, c, d = Fraction(sa), Fraction(sb), Fraction(sc), Fraction(sd)
    dx, dy = Fraction(sdx), Fraction(sdy)
    fnum = mp.mpf(factor.numerator) / mp.mpf(factor.denominator)

    def rec(a, b, c, d, dx, dy, depth):
        mx, my = (a + b) / 2, (c + d) / 2
        try:
            fm = D.lambda_logderiv(chi, parity, mx, mx, my, my, M, K)[0]
            _, fpb = D.lambda_logderiv(
                chi, parity, min(a, b), max(a, b), min(c, d), max(c, d), M, K)
            t = fm * D.Cx(D._num_frac(dx), D._num_frac(dy))
            Lf = mp.sqrt((abs(fpb.re.v) + fpb.re.e) ** 2
                         + (abs(fpb.im.v) + fpb.im.e) ** 2)
            dsmod = mp.sqrt(mp.mpf(float(dx)) ** 2 + mp.mpf(float(dy)) ** 2)
            err = fnum * dsmod ** 2 * Lf
            return (float(t.re.v), float(t.im.v),
                    float(t.re.e + err), float(t.im.e + err))
        except ValueError:
            if depth >= 8:
                raise
            if dx != 0:
                m = (a + b) / 2
                r1 = rec(a, m, c, d, dx / 2, dy, depth + 1)
                r2 = rec(m, b, c, d, dx / 2, dy, depth + 1)
            else:
                m = (c + d) / 2
                r1 = rec(a, b, c, m, dx, dy / 2, depth + 1)
                r2 = rec(a, b, m, d, dx, dy / 2, depth + 1)
            return (r1[0] + r2[0], r1[1] + r2[1], r1[2] + r2[2], r1[3] + r2[3])

    return rec(a, b, c, d, dx, dy, 0)


def dirichlet_I3(chi, parity, T, steps, M: int = 20, K: int = 50,
                 factor=Fraction(1, 4), verbose: bool = False):
    """Rigorous `(Ire, Iim, Nest)` for the half-contour `I3(T)`.

    `Nest` encloses `N_chi(T) = Im(I3)/pi`; `factor` is the midpoint-rule
    constant: 1/4 is unconditionally safe, 1/8 is the 010 convention.
    """
    T = _fr(T)
    factor = Fraction(factor)
    Ire, Iim = iv.Num(0), iv.Num(0)
    boxes = _path_boxes(T, steps)
    for i, box in enumerate(boxes):
        r = one_box((box, chi, parity, M, K, factor))
        Ire = iv.Num(Ire.v + r[0], Ire.e + r[2])
        Iim = iv.Num(Iim.v + r[1], Iim.e + r[3])
        if verbose and (i + 1) % 50 == 0:
            print("    %d/%d boxes" % (i + 1, len(boxes)), flush=True)
    Nest = iv.Num(Iim.v / mp.pi, Iim.e / mp.pi + mp.mpf('1e-12'))
    return Ire, Iim, Nest


def dirichlet_I3_par(chi, parity, T, steps, M: int = 20, K: int = 50,
                     factor=Fraction(1, 4), workers: int = 4):
    """Parallel `dirichlet_I3` (the accumulation is order-independent)."""
    from concurrent.futures import ProcessPoolExecutor
    T = _fr(T)
    factor = Fraction(factor)
    boxes = _path_boxes(T, steps)
    tasks = [(b, chi, parity, M, K, factor) for b in boxes]
    re_v = im_v = re_e = im_e = 0.0
    with ProcessPoolExecutor(max_workers=workers, max_tasks_per_child=1) as ex:
        for r in ex.map(one_box, tasks, chunksize=1):
            re_v += r[0]
            im_v += r[1]
            re_e += r[2]
            im_e += r[3]
    Nest = iv.Num(im_v / mp.pi, im_e / mp.pi + mp.mpf('1e-12'))
    return iv.Num(re_v, re_e), iv.Num(im_v, im_e), Nest


def certify_count(chi, parity, T, steps, M: int = 20, K: int = 50,
                  factor=Fraction(1, 4), workers: int = 0, verbose: bool = True):
    """Return `(k, Nest)` with `N_chi(T) = k` certified, or `(None, Nest)`."""
    if workers and workers > 1:
        Ire, Iim, Nest = dirichlet_I3_par(chi, parity, T, steps, M, K, factor, workers)
    else:
        Ire, Iim, Nest = dirichlet_I3(chi, parity, T, steps, M, K, factor, verbose)
    k = int(mp.nint(Nest.v))
    ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
    if verbose:
        print("  N_chi(%s) in [%s, %s] -> %s"
              % (T, mp.nstr(Nest.lo, 8), mp.nstr(Nest.hi, 8),
                 ("N=%d CERTIFIED" % k) if ok else "UNDECIDED"), flush=True)
    return (k if ok else None), Nest


# --------------------------------------------------------------------------- #
#  the I3 count by rigorous argument tracking (no curvature bound needed)
# --------------------------------------------------------------------------- #
#
# `I3 = int_path logDeriv H ds = Delta log H` along the path, so
#     Im(I3) = Delta arg H
# is the *continuous change of the argument* of H from (1/2,1/2) to (1/2,T).
# Tracking the argument sample by sample is exact (up to the widths of the arg
# enclosures) and needs no bound on `(log H)''`: it replaces the midpoint rule,
# whose curvature bound is unusable for the Dirichlet engine, where the *box*
# enclosure of `L` is dominated by Euler-Maclaurin cancellation.

def _arg_enclosure(z: Cx) -> iv.Num:
    """Rigorous `arg z` (mod 2 pi) for a box that excludes 0."""
    if not z.excludes_zero():
        raise ValueError("_arg_enclosure: the box contains 0")
    th = mp.atan2(z.im.v, z.re.v)
    return iv.Num(th, z.angular_radius() + iv.EPS)


def _unwrap(d: iv.Num) -> iv.Num:
    """The representative of the interval `d` in `(-pi, pi)` (requires width < pi)."""
    two_pi = 2 * iv.pi().v
    c = d.v - two_pi * mp.floor((d.v + mp.pi) / two_pi)
    return iv.Num(c, d.e)


def _track_arg(chi, parity, a, b, s_of, M, K, depth=0):
    """Rigorous change of `arg H` from `s_of(a)` to `s_of(b)` (1-D parameter)."""
    ra, ia = s_of(a)
    rb, ib = s_of(b)
    A = _arg_enclosure(completed_lambda_at(chi, parity, ra, ia, M, K))
    B = _arg_enclosure(completed_lambda_at(chi, parity, rb, ib, M, K))
    d = _unwrap(B - A)
    if abs(d.v) < mp.pi / 2 and d.e < mp.pi / 4:
        return d
    if depth >= 24:
        raise ValueError("_track_arg: failed to resolve the argument (a zero on the path?)")
    m = (a + b) / 2
    return _track_arg(chi, parity, a, m, s_of, M, K, depth + 1) \
        + _track_arg(chi, parity, m, b, s_of, M, K, depth + 1)


def _path_param(T):
    """Parameterise the I3 path by a single rational coordinate.

    Bottom (1/2,1/2) -> (1,1/2), right (1,1/2) -> (1,T), top (1,T) -> (1/2,T),
    each in the unit parameter interval [0,1].
    """
    T = _fr(T)
    h = Fraction(1, 2)
    segs = [((h, h), (Fraction(1), h)),
            ((Fraction(1), h), (Fraction(1), T)),
            ((Fraction(1), T), (h, T))]
    segs = [(P, Q) for (P, Q) in segs]
    return segs, lambda i, u: (segs[i][0][0] + (segs[i][1][0] - segs[i][0][0]) * u,
                               segs[i][0][1] + (segs[i][1][1] - segs[i][0][1]) * u)


@iv._pin
def dirichlet_I3_arg(chi, parity, T, samples_per_unit: int = 8,
                     M: int = 20, K: int = 50, verbose: bool = False):
    """`(Iim, Nest)`: the imaginary part of I3 and `N_chi(T) = Im(I3)/pi`.

    Computed by rigorous argument tracking along the three edges, subdivided
    adaptively when the argument step is not resolved.
    """
    T = _fr(T)
    segs, pt = _path_param(T)
    total = iv.Num(0)
    for i, (P, Q) in enumerate(segs):
        length = mp.sqrt(_fpf(Q[0] - P[0]) ** 2 + _fpf(Q[1] - P[1]) ** 2)
        n = max(1, int(mp.ceil(samples_per_unit * length)))
        for j in range(n):
            a, b = Fraction(j, n), Fraction(j + 1, n)
            d = _track_arg(chi, parity, a, b, lambda u: pt(i, u), M, K)
            total = total + d
        if verbose:
            print("    segment %d/%d done, running arg change %s"
                  % (i + 1, len(segs), mp.nstr(total.v, 12)), flush=True)
    Nest = iv.Num(total.v / mp.pi, total.e / mp.pi + mp.mpf('1e-12'))
    return total, Nest


def certify_count_arg(chi, parity, T, samples_per_unit: int = 8,
                      M: int = 20, K: int = 50, verbose: bool = True):
    """Rigorous `(k, Nest)` for `N_chi(T)` by argument tracking."""
    total, Nest = dirichlet_I3_arg(chi, parity, T, samples_per_unit, M, K, verbose)
    k = int(mp.nint(Nest.v))
    ok = Nest.lo > k - mp.mpf('0.5') and Nest.hi < k + mp.mpf('0.5')
    if verbose:
        print("  I3 count (arg tracking): N_chi(%s) in [%s, %s] -> %s"
              % (T, mp.nstr(Nest.lo, 8), mp.nstr(Nest.hi, 8),
                 ("N=%d CERTIFIED" % k) if ok else "UNDECIDED"), flush=True)
    return (k if ok else None), Nest


# --------------------------------------------------------------------------- #
#  on-line zeros: sign changes of Xi
# --------------------------------------------------------------------------- #

def _empty(v):
    return v[0] > v[1]


def _overlap(a, b):
    return not (a[1] < b[0] or b[1] < a[0])


def xi_sign(chi, parity, t, eps_sign, M: int = 20, K: int = 50):
    """Sign of Xi(t): +1, -1, or 0 when the enclosure straddles 0."""
    v = xi_enclose(chi, parity, t, eps_sign, M, K)
    return v.sign()


def xi_signs(chi, parity, ts, eps_sign, M: int = 20, K: int = 50):
    return [xi_sign(chi, parity, t, eps_sign, M, K) for t in ts]


def locate_online_zeros(chi, parity, eps_sign, t_lo, t_hi, grid: int = 64,
                        M: int = 20, K: int = 50, bisect: int = 60):
    """Disjoint sign-change brackets of Xi on (t_lo, t_hi).

    Returns a list of `(a, b)` rationals with `Xi(a) < 0 < Xi(b)` (or reversed),
    each certified by enclosures that exclude 0.  A bracket proves at least one
    on-line zero of L inside it.
    """
    t_lo, t_hi = _fr(t_lo), _fr(t_hi)
    ts = [t_lo + (t_hi - t_lo) * i / grid for i in range(grid + 1)]
    signs = xi_signs(chi, parity, ts, eps_sign, M, K)
    brackets = []
    for i in range(grid):
        s0, s1 = signs[i], signs[i + 1]
        if s0 == 0 or s1 == 0 or s0 == s1:
            continue
        a, b = ts[i], ts[i + 1]
        sa, sb = s0, s1
        for _ in range(bisect):
            mid = (a + b) / 2
            sm = xi_sign(chi, parity, mid, eps_sign, M, K)
            if sm == 0:
                break
            if sm == sa:
                a, sa = mid, sm
            else:
                b, sb = mid, sm
        brackets.append((a, b))
    return brackets
