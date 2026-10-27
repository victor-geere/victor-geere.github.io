#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
011/rigorous/dirichlet_interval.py — a rigorous interval engine for the completed
Dirichlet L-function's logarithmic derivative  Lambda'_chi / Lambda_chi.

This is the missing numerical piece of the 011 "Dirichlet Route B" generalisation.
It sits directly on top of the 010 engine and **reuses** it rather than
reimplementing anything:

  * `../010/rigorous/ivmath.py`      — real intervals `Num(v, e)`, rigorous
    `pi`, `cos`, `sin`;
  * `../010/rigorous/eta_interval.py` — the complex interval `Cx`, the pointwise
    rigorous `psi_num` (digamma `psi`, `psi'`), the elementary `_exp_pos`,
    `EPS` and `fast_mode`.

Two 010 primitives are deliberately **not** reused, because they are not sound
for the boxes this engine must handle; rigorous local replacements are provided
(see `_div_iv`, `_exp_box`, `_log_frac`):

  * `eta_interval.ndef` (= `Cx` division) uses `[x.lo/y.hi, x.hi/y.lo]`, correct
    only for a nonnegative numerator; for `x = L'` it under-covers by ~`|x| *
    relwidth(y)`, which exceeds the width of `L'/L`;
  * `eta_interval.exp_num` collapses to a **zero-width point** for a genuine
    interval `y` with `y.hi <= 0` (the two ends invert and `Num` clamps the
    radius to 0);
  * `eta_interval.log_hi` uses a fixed 600-term `2 atanh((p-1)/(p+1))` series
    whose tail is only ~`2.7e-8` at `p = 163`, far above the working precision —
    and `b = a + M` reaches 163 already at `M = 20`, `N = 8`.

Everything is a bound; nothing is a float estimate, and there is no mpmath in the
rigorous path (mpmath supplies only the Bernoulli *numerators* and denominators,
which are exact integers, and the working-precision arithmetic of `ivmath`).

Method
------
For a Dirichlet character `chi` of modulus `N` (a coefficient list of length `N`,
`chi[0] = 0`),

    L(chi, s) = N^(-s) * sum_{a=1}^{N-1} chi(a) * zeta(s, a/N),

and the Hurwitz zeta is enclosed by Euler-Maclaurin:

    zeta(s,a) = sum_{k<M} (a+k)^(-s) + (a+M)^(1-s)/(s-1) + (1/2)(a+M)^(-s)
              + sum_{j=1..K} B_{2j}/(2j)! * (s)_{2j-1} * (a+M)^(-s-2j+1) + R_K(s),

    R_K(s) = -(s)_{2K+1}/(2K+1)! * int_0^inf B~_{2K+1}(x) (a+M+x)^(-s-2K-1) dx,

with the periodic-Bernoulli bound

    |R_K| <= |(s)_{2K+1}|/(2K+1)! * sup|B~_{2K+1}| * b^(-sigma-2K)/(sigma+2K),
    sup|B~_{2K+1}| <= 2 (2K+1)! zeta(2K+1)/(2 pi)^(2K+1),   b = a+M.

The box (s in [s_lo,s_hi] + i [t_lo,t_hi]) is handled by evaluating every term with
interval arithmetic over the box (so the s-variation of the EM *sum* is enclosed
automatically) and using the *worst-case* remainder over the box: `sigma` is
replaced by its lower endpoint `s_lo` throughout, which maximises
`b^(-sigma-2K)/(sigma+2K)`.  The differentiated formulas are those of
`lib/dirichlet_engine_probe.py`: each elementary term gains `log` factors and

    (s)_n'  = (s)_n * A,    (s)_n'' = (s)_n * (A^2 - B),
    A = sum_{i<n} 1/(s+i),  B = sum_{i<n} 1/(s+i)^2.

The remainders for `zeta'` and `zeta''` are obtained by differentiating the integral
representation of `R_K` (see `_hurwitz_all`): with `P = (s)_{2K+1}`,
`J = int B~ (b+x)^(-s-2K-1) dx`,

    R =  -P/(2K+1)! J,      R' = -[P' J + P J']/(2K+1)!,
    R''= -[P'' J + 2 P' J' + P J'']/(2K+1)!,

and, using `log u <= sqrt(u)` and `log^2 u <= u` for `u >= 1` (so for `u = b+x >= 1`),

    |J|   <= supB b^(-sigma-2K)/(sigma+2K),
    |J'|  <= supB b^(-sigma-2K+1/2)/(sigma+2K-1/2),
    |J''| <= supB b^(-sigma-2K+1)/(sigma+2K-1).

The assembled engine returns `(f, f') = (Lambda'_chi/Lambda_chi, (log Lambda_chi)'')`
for

    Lambda_chi(s) = (N/pi)^((s+a)/2) Gamma((s+a)/2) L(chi,s),   a = parity in {0,1}.

See `README.md` in this folder for the API, the measured widths and the limits.
"""
from __future__ import annotations

import os
import sys
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
# the 010 engine is reused, not copied
_ENGINE_010 = os.path.abspath(os.path.join(_HERE, "..", "..", "010", "rigorous"))
if _ENGINE_010 not in sys.path:
    sys.path.insert(0, _ENGINE_010)

import mpmath as mp            # noqa: E402  (working precision only, no estimates)
import ivmath as iv            # noqa: E402
import eta_interval as E       # noqa: E402

ZERO = E.ZERO
ONE = E.ONE


# --------------------------------------------------------------------------- #
#  small helpers
# --------------------------------------------------------------------------- #

def _frac(x) -> Fraction:
    """Exact Fraction from int / Fraction / str / float / mpf.

    `mpf` is converted bit-exactly via its `_mpf_` mantissa, so passing a box
    endpoint as an `mpf` does not silently move the box.
    """
    if isinstance(x, Fraction):
        return x
    if isinstance(x, bool):
        return Fraction(int(x))
    if isinstance(x, int):
        return Fraction(x)
    if isinstance(x, mp.mpf):
        sign, man, exp, bc = x._mpf_
        if man == 0:
            return Fraction(0)
        v = Fraction(int(man), 1)
        if exp >= 0:
            v *= 2 ** int(exp)
        else:
            v /= 2 ** (-int(exp))
        return v if sign == 0 else -v
    if isinstance(x, float):
        return Fraction(x)
    return Fraction(str(x))


def _mpf(x) -> mp.mpf:
    f = _frac(x)
    return mp.mpf(f.numerator) / mp.mpf(f.denominator)


def _num(lo, hi) -> iv.Num:
    """The real interval [lo, hi] (order-insensitive)."""
    lo, hi = _mpf(lo), _mpf(hi)
    if hi < lo:
        lo, hi = hi, lo
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + E.EPS)


def _cx_box(s_lo, s_hi, t_lo, t_hi) -> E.Cx:
    return E.Cx(_num(s_lo, s_hi), _num(t_lo, t_hi))


def _cx_plus_int(z: E.Cx, r) -> E.Cx:
    r = _mpf(r)
    return E.Cx(z.re + iv.Num(r), z.im)


def _scale_num(z: E.Cx, q: iv.Num) -> E.Cx:
    """(q * z) for a real interval q and a complex interval z."""
    return E.Cx(z.re * q, z.im * q)


def _neg(z: E.Cx) -> E.Cx:
    return E.Cx(-z.re, -z.im)


# --------------------------------------------------------------------------- #
#  rigorous division and exponential, replacing two unsound 010 primitives
# --------------------------------------------------------------------------- #
#
# `eta_interval.ndef(x, y)` returns `[x.lo/y.hi, x.hi/y.lo]`, the correct image of
# `x/y` only when the numerator interval `x` is **nonnegative**.  For a signed
# numerator the true image is `[x.lo/y.lo, x.hi/y.hi]` (on a rectangle the extrema
# of the map `x/y`, monotone in each variable separately, occur at corners), so the
# 010 formula *under-covers* by about `|x| * relwidth(y)`.  With `x = L'` and
# `y = |L|^2` that is ~1e-11, larger than the enclosure width of `L'/L`: a silent
# unsoundness that makes an "enclosure" miss its value.  `_div_iv` uses all four
# corners, hence the exact image.
#
# `eta_interval.exp_num` for an interval with `y.hi <= 0` returns
# `[e^{y.hi} - err, e^{y.lo} + err]`; when the interval is wider than `err` this is
# inverted and `Num` clamps the negative radius to 0, so it returns a **point**.
# `_exp_box` uses monotonicity and a pointwise rigorous exponential at each end.

def _div_iv(x: iv.Num, y: iv.Num) -> iv.Num:
    """Rigorous `x/y` for `0 < y.lo <= y.hi`, signed numerator."""
    if y.lo <= 0:
        raise ValueError("_div_iv: denominator interval touches 0")
    cands = (x.lo / y.lo, x.lo / y.hi, x.hi / y.lo, x.hi / y.hi)
    lo, hi = min(cands), max(cands)
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + E.EPS)


def _cdiv(a: E.Cx, b: E.Cx) -> E.Cx:
    """Rigorous complex division, requires |b| bounded away from 0."""
    d = b.re * b.re + b.im * b.im
    if d.lo <= 0:
        raise ValueError("_cdiv: denominator box touches 0")
    return E.Cx(_div_iv(a.re * b.re + a.im * b.im, d),
                _div_iv(a.im * b.re - a.re * b.im, d))


def _exp_pt(x) -> iv.Num:
    """Rigorous `e^x` for a point `x` (any sign)."""
    x = _mpf(x)
    if x >= 0:
        return E._exp_pos(iv.Num(x, 0))
    return E.ndef(iv.Num(1, 0), E._exp_pos(iv.Num(-x, 0)))


def _exp_box(ylo, yhi) -> iv.Num:
    """Rigorous enclosure of `e^y` for `y` in `[ylo, yhi]` (monotone)."""
    ylo, yhi = _mpf(ylo), _mpf(yhi)
    if yhi < ylo:
        ylo, yhi = yhi, ylo
    a, b = _exp_pt(ylo), _exp_pt(yhi)
    lo, hi = a.lo, b.hi
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + E.EPS)


def _abs_ub(z: E.Cx) -> mp.mpf:
    """Rigorous upper bound on |z| over the box."""
    return mp.sqrt((abs(z.re.v) + z.re.e) ** 2 + (abs(z.im.v) + z.im.e) ** 2)


def _factorial(n: int) -> int:
    r = 1
    for i in range(2, n + 1):
        r *= i
    return r


def _bern_frac(n: int) -> Fraction:
    """Exact Bernoulli number B_n."""
    num, den = mp.bernfrac(n)
    return Fraction(int(num), int(den))


_LOG_CACHE = {}
_LOG2 = None


@iv._pin
def _log_frac(num, den) -> iv.Num:
    """Rigorous log(num/den) for positive integers.

    `eta_interval.log_hi` evaluates `2 atanh((p-1)/(p+1))` with a *fixed* 600
    terms, whose tail is `~ p^{-1200}`: for `p = 163` that is only `2.7e-8`, far
    above the working precision (this bites the Hurwitz engine at `b = a + M ~ 163`).
    Here the argument is first reduced to `r = q / 2^e` in `[1,2)`, so the series
    argument `t = (r-1)/(r+1)` lies in `[0, 1/3)` and the tail `t^{2K+1}` reaches
    the working precision with `K = 2 WORK + 60` terms.  `log 2` comes from the
    `eta_interval` series (which has a `~3^{-320}` tail).
    """
    global _LOG2
    num, den = int(num), int(den)
    if num <= 0 or den <= 0:
        raise ValueError("_log_frac: need positive integers")
    key = (num, den, int(iv.WORK))
    cached = _LOG_CACHE.get(key)
    if cached is not None:
        return cached
    q = Fraction(num, den)
    e = q.numerator.bit_length() - q.denominator.bit_length()
    r = q / Fraction(2) ** e if e >= 0 else q * Fraction(2) ** (-e)
    while r >= 2:
        e += 1
        r = r / 2
    while r < 1:
        e -= 1
        r = r * 2
    t = (r - 1) / (r + 1)                 # 0 <= t < 1/3
    K = 2 * int(iv.WORK) + 60
    t2 = t * t
    tp = t
    terms = []
    for j in range(K):
        terms.append(2 * tp / (2 * j + 1))
        tp = tp * t2
    tail = (2 * tp / (2 * K + 1)) / (1 - t2)         # tp = t^{2K+1}
    acc = iv._series(terms, tail)
    if e:
        if _LOG2 is None:
            _LOG2 = E._log2()
        acc = acc + _LOG2.mul_int(e)
    _LOG_CACHE[key] = acc
    return acc


def _num_frac(q) -> iv.Num:
    """The exact rational `q` as a `Num` with a *relative* error bound.

    `ivmath.Num`'s operations add an absolute slack `EPS`; scaling by an exact
    rational through `mul_int`/`div_int` (`eta_interval._cscale`) would therefore
    floor a tiny value at `EPS` (e.g. `b^{-2j+1} ~ 10^{-130}` at `K = 50`), which
    then poisons every later product.  Building the rational directly at the
    working precision and charging a *relative* slack keeps the enclosure sound
    and tight: the mpf division is correctly rounded at `WORK` digits, and
    `EPS = 10^-(WORK-20)` dominates it.
    """
    q = _frac(q)
    val = mp.mpf(q.numerator) / mp.mpf(q.denominator)
    return iv.Num(val, abs(val) * E.EPS)


def _pow_neg_s(logbase: iv.Num, s_lo, s_hi, t_lo, t_hi) -> E.Cx:
    """Rigorous enclosure of `base^(-s)` on the box, base > 0 with log = logbase.

    base^(-s) = exp(-sigma log base) * (cos(tau log base) - i sin(tau log base));
    the magnitude and the phase are independent functions of `sigma` and `tau`, so
    the product of the two one-dimensional images encloses the image of the box.
    """
    sigma = _num(s_lo, s_hi)
    yy = -(sigma * logbase)
    mag = _exp_box(yy.lo, yy.hi)
    tau = _num(t_lo, t_hi)
    theta = tau * logbase
    return E.Cx(mag * iv.cos_num(theta), -(mag * iv.sin_num(theta)))


# --------------------------------------------------------------------------- #
#  the Hurwitz-zeta engine
# --------------------------------------------------------------------------- #

def _zeta_ub(x) -> mp.mpf:
    """Rigorous upper bound for zeta(x), x = 2K+1 >= 3: 1 + 1/(x-1)."""
    return 1 + mp.mpf(1) / (_mpf(x) - 1)


@iv._pin
def _hurwitz_all(alpha, s_lo, s_hi, t_lo, t_hi, M=20, K=50):
    """(zeta, zeta', zeta'') enclosures of `zeta(s, alpha)` on the box.

    `alpha` must be an exact positive rational; `M >= 1`, `K >= 1`.
    Raises `ValueError` if the box contains the pole `s = 1`.

    Pinned to the module working precision: the elementary `exp`/rational scaling
    inside use mpmath at the *current* `mp.mp.dps`, which must not be below `WORK`.
    """
    alpha = _frac(alpha)
    if alpha <= 0:
        raise ValueError("hurwitz_zeta_box: alpha must be positive")
    if M < 1 or K < 1:
        raise ValueError("hurwitz_zeta_box: need M >= 1 and K >= 1")

    s_lo_f, s_hi_f = _frac(s_lo), _frac(s_hi)
    t_lo_f, t_hi_f = _frac(t_lo), _frac(t_hi)
    # the pole of zeta(s, a) at s = 1: refuse rather than divide by zero silently
    if s_lo_f <= 1 <= s_hi_f and t_lo_f <= 0 <= t_hi_f:
        raise ValueError("hurwitz_zeta_box: the box contains the pole s = 1")

    n_alpha, d_alpha = alpha.numerator, alpha.denominator
    b_num = n_alpha + M * d_alpha          # b = alpha + M = b_num / d_alpha
    b_frac = Fraction(b_num, d_alpha)
    logb = _log_frac(b_num, d_alpha)

    ONEcx = E.Cx(ONE, ZERO)
    S = _cx_box(s_lo_f, s_hi_f, t_lo_f, t_hi_f)
    logb_c = _scale_num(ONEcx, logb)       # Cx(log b, 0)

    # --- sum_{k<M} (alpha+k)^{-s} and its first two s-derivatives --------------
    T0 = E.Cx(ZERO, ZERO)
    T1 = E.Cx(ZERO, ZERO)
    T2 = E.Cx(ZERO, ZERO)
    for k in range(M):
        la = _log_frac(n_alpha + k * d_alpha, d_alpha)
        w = _pow_neg_s(la, s_lo_f, s_hi_f, t_lo_f, t_hi_f)
        T0 = T0 + w
        T1 = T1 - _scale_num(w, la)
        T2 = T2 + _scale_num(w, la * la)

    # --- b^{-s} and the pole / half terms -------------------------------------
    bs = _pow_neg_s(logb, s_lo_f, s_hi_f, t_lo_f, t_hi_f)      # b^{-s}
    sm1 = E.Cx(_num(s_lo_f - 1, s_hi_f - 1), _num(t_lo_f, t_hi_f))
    if (sm1.re * sm1.re + sm1.im * sm1.im).lo <= 0:
        raise ValueError("hurwitz_zeta_box: denominator (s-1) touches 0")
    inv = _cdiv(ONEcx, sm1)
    inv2 = inv * inv
    inv3 = inv2 * inv
    half_frac = _num_frac(Fraction(1, 2))
    f = _scale_num(bs, _num_frac(b_frac))                      # b^{1-s}
    pole0 = f * inv
    pole1 = _neg(_scale_num(f, logb)) * inv - f * inv2
    lb_f = logb_c * f
    pole2 = _scale_num(f, logb * logb) * inv + E._cscale(lb_f * inv2, Fraction(2)) \
        + E._cscale(f * inv3, Fraction(2))
    half0 = _scale_num(bs, half_frac)
    half1 = _neg(_scale_num(_scale_num(bs, logb), half_frac))
    half2 = _scale_num(_scale_num(bs, logb * logb), half_frac)

    # --- the Euler-Maclaurin corrections --------------------------------------
    # The j-th correction is  c_j (s)_{2j-1} b^{-s-2j+1} = c_j b^{-s} R_j  with
    #     R_j = (s)_{2j-1} b^{-(2j-1)} = prod_{i<2j-1} (s+i)/b,
    # whose factors are all O(|s|+2K)/b.  Keeping `R_j` (rather than the tower
    # `(s)_{2j-1}` times the tiny `b^{-2j+1}`) is what makes the enclosure tight:
    # `ivmath.Num` adds an absolute slack `EPS` per operation, so a product with a
    # factor of size 10^{-(2K+1)log b} and a factor of size |(s)_{2K+1}| ~ 10^{190}
    # would carry an unusable relative error.
    #   R_j' / R_j = A_j,   R_j'' / R_j = A_j^2 - B_j,
    #   A_j = sum_{i<2j-1} 1/(s+i),   B_j = sum_{i<2j-1} 1/(s+i)^2.
    # Hence  term_j  = c_j bs R_j,  term_j' = term_j (A_j - log b),
    #        term_j'' = c_j bs (R_j ((A_j-log b)^2 - B_j)) = c_j bs R_j ((A_j-log b)^2 - B_j).
    invb = _num_frac(Fraction(d_alpha, b_num))
    R = _scale_num(S, invb)                   # R_1 = s/b
    A = _cdiv(ONEcx, S)                      # A_1 = 1/s
    Bq = A * A                                # B_1 = 1/s^2
    C0 = E.Cx(ZERO, ZERO)
    C1 = E.Cx(ZERO, ZERO)
    C2 = E.Cx(ZERO, ZERO)
    for j in range(1, K + 1):
        cj = _num_frac(_bern_frac(2 * j) / _factorial(2 * j))
        U = bs * R
        C0 = C0 + _scale_num(U, cj)
        Am = E.Cx(A.re - logb_c.re, A.im - logb_c.im)          # A_j - log b
        C1 = C1 + _scale_num(U * Am, cj)
        D = Am * Am - Bq                                       # (A_j - log b)^2 - B_j
        C2 = C2 + _scale_num(U * D, cj)
        # advance to R_{j+1}, A_{j+1}, B_{j+1}
        t1 = _cx_plus_int(S, 2 * j - 1)
        t2 = _cx_plus_int(S, 2 * j)
        R = R * _scale_num(t1, invb) * _scale_num(t2, invb)
        i1 = _cdiv(ONEcx, t1)
        i2 = _cdiv(ONEcx, t2)
        A = A + i1 + i2
        Bq = Bq + i1 * i1 + i2 * i2

    # after the loop R = (s)_{2K+1} b^{-(2K+1)}, A = sum_{i<=2K} 1/(s+i),
    # Bq = sum_{i<=2K} 1/(s+i)^2
    # --- the rigorous remainders ----------------------------------------------
    # sup|B~_{2K+1}| <= 2 (2K+1)! zeta(2K+1)/(2 pi)^{2K+1};  zeta(x) <= 1 + 1/(x-1)
    pi_lo = iv.pi().lo
    two_pi_lo = 2 * pi_lo
    Bfac = 2 * _zeta_ub(2 * K + 1) / two_pi_lo ** (2 * K + 1)
    sig = _mpf(s_lo_f)                      # worst case for b^{-sigma-2K}/(sigma+2K)
    bm = _mpf(b_frac)
    J0 = Bfac * bm ** (-sig - 2 * K) / (sig + 2 * K)
    J1 = Bfac * bm ** (-sig - 2 * K + mp.mpf(1) / 2) / (sig + 2 * K - mp.mpf(1) / 2)
    J2 = Bfac * bm ** (-sig - 2 * K + 1) / (sig + 2 * K - 1)
    Rmod = _abs_ub(R)
    Pm = Rmod * bm ** (2 * K + 1)           # |(s)_{2K+1}| = |R| b^{2K+1}: mpf only
    Am_ub = _abs_ub(A)
    Dm = _abs_ub(A * A - Bq)
    safety = 1 + mp.mpf("1e-15")
    R0 = (Pm * J0) * safety
    R1 = (Pm * (Am_ub * J0 + J1)) * safety
    R2 = (Pm * (Dm * J0 + 2 * Am_ub * J1 + J2)) * safety

    z0 = (T0 + pole0 + half0 + C0).inflate(R0)
    z1 = (T1 + pole1 + half1 + C1).inflate(R1)
    z2 = (T2 + pole2 + half2 + C2).inflate(R2)
    _HURWITZ_LAST_RADII[0] = (R0, R1, R2)
    return z0, z1, z2


# the radii of the most recent `_hurwitz_all`, for the verifier's dominance test
_HURWITZ_LAST_RADII = [None]


def hurwitz_remainder_bound(alpha, s_lo, s_hi, t_lo, t_hi, M=20, K=50):
    """The rigorous EM truncation bounds `(R0, R1, R2)` for `zeta^{(k)}`.

    Exposed for verification: the differentiated EM partial sums computed in
    high precision must differ from the true `zeta^{(k)}` by at most `R_k`.
    """
    _hurwitz_all(alpha, s_lo, s_hi, t_lo, t_hi, M, K)
    return _HURWITZ_LAST_RADII[0]


@iv._pin
def hurwitz_zeta_box(s_lo, s_hi, t_lo, t_hi, alpha, M=20, K=50) -> E.Cx:
    """Rigorous `Cx` enclosure of `zeta(s, alpha)` for `s` in the box.

    Euler-Maclaurin with `M` direct terms and `K` Bernoulli corrections, plus the
    periodic-Bernoulli remainder bound (see the module docstring).  `alpha` is an
    exact positive rational.  The box must not contain the pole `s = 1`.
    """
    return _hurwitz_all(alpha, s_lo, s_hi, t_lo, t_hi, M, K)[0]


# --------------------------------------------------------------------------- #
#  the Dirichlet L-function
# --------------------------------------------------------------------------- #

def _check_chi(chi):
    N = len(chi)
    if N < 2:
        raise ValueError("dirichlet: the modulus N must be >= 2")
    if chi[0] != 0:
        raise ValueError("dirichlet: chi[0] must be 0")
    return N


@iv._pin
def _dirichlet_all(chi, s_lo, s_hi, t_lo, t_hi, M=20, K=50):
    """(L, L', L'') enclosures of `L(chi, s)` on the box.  Pinned (see `_hurwitz_all`)."""
    N = _check_chi(chi)
    T0 = E.Cx(ZERO, ZERO)
    T1 = E.Cx(ZERO, ZERO)
    T2 = E.Cx(ZERO, ZERO)
    for a in range(1, N):
        c = chi[a]
        if c == 0:
            continue
        z0, z1, z2 = _hurwitz_all(Fraction(a, N), s_lo, s_hi, t_lo, t_hi, M, K)
        if c == 1:
            T0, T1, T2 = T0 + z0, T1 + z1, T2 + z2
        elif c == -1:
            T0, T1, T2 = T0 - z0, T1 - z1, T2 - z2
        else:
            q = Fraction(int(c))
            T0 = T0 + E._cscale(z0, q)
            T1 = T1 + E._cscale(z1, q)
            T2 = T2 + E._cscale(z2, q)

    logN = _log_frac(N, 1)
    Ns = _pow_neg_s(logN, s_lo, s_hi, t_lo, t_hi)              # N^{-s}
    lN = _scale_num(E.Cx(ONE, ZERO), logN)                     # Cx(log N, 0)
    lN_Ns = lN * Ns
    L = Ns * T0
    Lp = Ns * T1 - lN_Ns * T0
    Lpp = Ns * T2 - E._cscale(lN_Ns * T1, Fraction(2)) + (lN * lN_Ns) * T0
    return L, Lp, Lpp


@iv._pin
def dirichlet_L_box(chi, s_lo, s_hi, t_lo, t_hi, M=20, K=50) -> E.Cx:
    """Rigorous `Cx` enclosure of `L(chi, s)` on the box.

    `L(chi,s) = N^(-s) sum_{a<N} chi(a) zeta(s, a/N)`.  The box must not contain
    `s = 1` with `t = 0`: the individual Hurwitz-zeta terms have a pole there (the
    sum is entire for non-trivial `chi`, but the pole does not cancel in interval
    arithmetic).
    """
    return _dirichlet_all(chi, s_lo, s_hi, t_lo, t_hi, M, K)[0]


@iv._pin
def dirichlet_L_logderiv(chi, s_lo, s_hi, t_lo, t_hi, M=20, K=50):
    """`(L'/L(chi,s), (L'/L)'(chi,s))` as `Cx` enclosures on the box.

    `(L'/L)' = L''/L - (L'/L)^2`.  Raises `ValueError` when the enclosure of `L`
    cannot exclude 0 (a genuine zero of `L`, or a box too wide for the division).
    """
    L, Lp, Lpp = _dirichlet_all(chi, s_lo, s_hi, t_lo, t_hi, M, K)
    if not L.excludes_zero():
        raise ValueError("dirichlet_L_logderiv: the L box contains 0")
    rho = _cdiv(Lp, L)
    rhop = _cdiv(Lpp, L) - rho * rho
    return rho, rhop


def _psi_box(w_re_lo, w_re_hi, w_im_lo, w_im_hi):
    """Rigorous `(psi(w), psi'(w))` over a box with `Re w > 0`.

    `psi_num` is pointwise, so evaluate at the box centre and inflate by a
    rigorous Lipschitz bound: for `sigma = Re w >= sig_lo > 0`,

        |psi''(w)| <= 2 (1/sig_lo^3 + 1/(2 sig_lo^2)),

    because `|w+n| >= sig_lo + n` and `sum_n 1/(sig_lo+n)^3 <= 1/sig_lo^3 +
    int_0^inf 1/(sig_lo+x)^3 dx`.  (The 010 engine uses the value 2.5 here; that
    is only valid for large `t`, so this engine uses the explicit bound, which is
    valid for every `Re w > 0`.)
    """
    wr_lo, wr_hi = _frac(w_re_lo), _frac(w_re_hi)
    wi_lo, wi_hi = _frac(w_im_lo), _frac(w_im_hi)
    wc_re = (wr_lo + wr_hi) / 2
    wc_im = (wi_lo + wi_hi) / 2
    dw_re = (wr_hi - wr_lo) / 2
    dw_im = (wi_hi - wi_lo) / 2
    sig_lo = wr_lo
    if sig_lo <= 0:
        raise ValueError("_psi_box: Re w must be positive")
    rw = mp.sqrt(_mpf(dw_re) ** 2 + _mpf(dw_im) ** 2)
    pc, ppc = E.psi_num(wc_re, wc_im)
    M2 = 2 * (mp.mpf(1) / _mpf(sig_lo) ** 3 + mp.mpf(1) / (2 * _mpf(sig_lo) ** 2))
    if rw > 0:
        pp_ub = _abs_ub(ppc)
        psi_infl = (pp_ub + M2 * rw) * rw
        psip_infl = M2 * rw
    else:
        psi_infl = psip_infl = mp.mpf(0)
    psi = E.Cx(iv.Num(pc.re.v, pc.re.e + psi_infl),
               iv.Num(pc.im.v, pc.im.e + psi_infl))
    psip = E.Cx(iv.Num(ppc.re.v, ppc.re.e + psip_infl),
                iv.Num(ppc.im.v, ppc.im.e + psip_infl))
    return psi, psip


@iv._pin
def lambda_logderiv(chi, parity, s_lo, s_hi, t_lo, t_hi, M=20, K=50):
    """`(Lambda'_chi/Lambda_chi, (log Lambda_chi)'')` as `Cx` enclosures.

    `Lambda_chi(s) = (N/pi)^((s+a)/2) Gamma((s+a)/2) L(chi,s)`, `a = parity`, so

        Lambda'/Lambda = (1/2) log(N/pi) + (1/2) psi((s+a)/2) + L'/L,
        (log Lambda)'' = (1/4) psi'((s+a)/2) + (L'/L)'.

    This is the box-correct object the Dirichlet Route-B reduction consumes.
    """
    N = _check_chi(chi)
    rho, rhop = dirichlet_L_logderiv(chi, s_lo, s_hi, t_lo, t_hi, M, K)
    a = _frac(parity)
    s_lo_f, s_hi_f = _frac(s_lo), _frac(s_hi)
    t_lo_f, t_hi_f = _frac(t_lo), _frac(t_hi)
    # w = (s + a) / 2
    psi, psip = _psi_box((s_lo_f + a) / 2, (s_hi_f + a) / 2, t_lo_f / 2, t_hi_f / 2)
    logpi = E._log_num(iv.pi())
    const = (_log_frac(N, 1) - logpi).div_int(2)           # (1/2) log(N/pi)
    base = _scale_num(E.Cx(ONE, ZERO), const)
    half = iv.Num(1).div_int(2)
    quarter = iv.Num(1).div_int(4)
    f = base + _scale_num(psi, half) + rho
    fp = _scale_num(psip, quarter) + rhop
    return f, fp


# re-exported for callers that want to control the working precision
set_precision = E.set_precision
fast_mode = E.fast_mode
Cx = E.Cx


if __name__ == "__main__":       # tiny self-test
    import time
    chi3 = [0, 1, -1]
    t0 = time.time()
    box = dirichlet_L_box(chi3, Fraction(1, 2), Fraction(1, 2), Fraction(5), Fraction(5), 20, 50)
    print("L(chi3, 0.5+5i) in", box, " width %.2e" % float(max(box.re.hi - box.re.lo, box.im.hi - box.im.lo)))
    f, fp = lambda_logderiv(chi3, 1, Fraction(1, 2), Fraction(1, 2), Fraction(5), Fraction(5), 20, 50)
    print("Lambda'/Lambda =", f)
    print("(log Lambda)'' =", fp)
    print("elapsed %.2f s" % (time.time() - t0))
