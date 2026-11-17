"""Rational interval certificates for QEFE quantities.

This is the reusable wrapper around the `partial-sum-plus-tail` exact-rational
interval engine.  It returns `rativ.Iv` boxes (pairs of `Fraction`s) for

* the Dirichlet beta function ``beta(s) = L(s, chi_4)``;
* the completed square-lattice series
  ``Lambda_Z2(s) = 4 pi^(-s) Gamma(s) zeta(s) beta(s)`` at integer and
  half-integer arguments (where Gamma is rational or a rational multiple of
  ``sqrt(pi)``);
* the finite phase-corrected series
  ``Psi(s,t) = sum chi_i m_i^(-sigma) e^(-it log m_i)`` over rational
  rectangles in ``sigma`` and ``t``.

All arithmetic is exact rational arithmetic; the only trusted leaves are the
transcendental enclosures of `partial-sum-plus-tail` (pi, exp, log, sin, cos).
No floating point is used.
"""

from __future__ import annotations

import importlib.util
import sys
from fractions import Fraction as F
from math import factorial
from pathlib import Path

_PST_PY = Path(__file__).resolve().parents[2] / "partial-sum-plus-tail" / "python"
if str(_PST_PY) not in sys.path:
    sys.path.insert(0, str(_PST_PY))

from rativ import Iv, exp_iv, log_iv, log_point, pi_iv, q, sin_cos_iv, sin_iv  # noqa: E402

_spec = importlib.util.spec_from_file_location("qefe_pst_programme", _PST_PY / "programme.py")
_pst = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_pst)


def _box(re_lo, re_hi, im_lo, im_hi) -> tuple[Iv, Iv]:
    return Iv(q(re_lo), q(re_hi)), Iv(q(im_lo), q(im_hi))


def _stirling_log_gamma(x: Iv, bits: int, terms: int) -> Iv:
    """Enclosure of log Gamma on an interval x >= 8 using Stirling's series.

    For real x > 0 the Stirling series is enveloping: the remainder after
    ``terms`` terms is bounded in absolute value by the first omitted term.
    """
    if x.lo < 8:
        raise ValueError("Stirling enclosure needs x >= 8")
    logx = log_iv(x, bits)
    # (x - 1/2) log x - x + (1/2) log(2 pi)
    out = x.sub(Iv.pt(F(1, 2))).mul(logx).sub(x)
    out = out.add(log_iv(pi_iv(bits).scale(2), bits).scale(F(1, 2)))
    for r in range(1, terms + 1):
        b = _pst.bernoulli(2 * r)
        coef = b / ((2 * r) * (2 * r - 1))
        out = out.add(x.pow_int(-(2 * r - 1)).scale(coef))
    # first omitted term bounds the remainder
    b_rem = _pst.bernoulli(2 * terms + 2)
    rem_coef = abs(b_rem) / ((2 * terms + 2) * (2 * terms + 1))
    rem = x.pow_int(-(2 * terms + 1)).scale(rem_coef)
    return out.inflate(rem.hi)


def _gamma_positive(x: F, bits: int = 160, terms: int = 10) -> Iv:
    """Enclosure of Gamma(x) for rational x > 0, shifting to x >= 8."""
    if x <= 0:
        raise ValueError("gamma requires a positive argument")
    n = 0
    while x + n < 8:
        n += 1
    y = x + n
    logg = _stirling_log_gamma(Iv.pt(y), bits, terms)
    g = exp_iv(logg, bits)
    denom = F(1)
    for i in range(n):
        denom *= x + i
    return g.div(Iv.pt(denom))


def gamma_enclosure(x, bits: int = 160, terms: int = 10) -> Iv:
    """Enclosure of Gamma(x) for a rational x, with poles rejected.

    Positive arguments use recurrence to x >= 8 and Stirling's series.  Negative
    non-integers use the reflection formula
    ``Gamma(x) Gamma(1-x) = pi / sin(pi x)``.
    """
    x = F(x)
    if x.denominator == 1 and x <= 0:
        raise ValueError("Gamma has a pole at non-positive integers")
    if x > 0:
        return _gamma_positive(x, bits=bits, terms=terms)
    # x < 0, non-integer
    g1 = _gamma_positive(1 - x, bits=bits, terms=terms)
    sinpx = sin_iv(pi_iv(bits).scale(x), bits)
    if sinpx.contains_zero():
        raise ValueError("Gamma enclosure crosses a pole")
    return pi_iv(bits).div(sinpx.mul(g1))


def lambda_z2_rational(s, bits: int = 160, terms: int = 10) -> Iv:
    """Enclosure of Lambda_Z2(s) for rational s > 0, s != 1.

    Uses the general rational Gamma enclosure plus the zeta and beta
    enclosures.  The Euler--Maclaurin evaluator is valid for positive real part;
    the critical strip 0 < s < 1 is included.  The pole at s = 1 is rejected.
    """
    s = F(s)
    if s <= 0 or s == 1:
        raise ValueError("require 0 < s, s != 1")
    g = gamma_enclosure(s, bits=bits, terms=terms)
    z = zeta_enclosure(s, s, bits=bits)
    b = beta_enclosure(s, s, bits=bits)
    pi_pow = exp_iv(log_iv(pi_iv(bits), bits).scale(-s), bits)
    return pi_pow.mul(z).mul(b).scale(4).mul(g)


def beta_enclosure(re_lo, re_hi, im_lo=0, im_hi=0, M: int = 25, K: int = 10,
                   bits: int = 160) -> Iv:
    """Enclosure of ``beta(s) = L(s, chi_4)`` for a rational rectangle."""
    return _pst.L_enclosure([0, 1, 0, -1], re_lo, re_hi, im_lo, im_hi,
                            M=M, K=K, bits=bits).re


def zeta_enclosure(re_lo, re_hi, im_lo=0, im_hi=0, M: int = 25, K: int = 10,
                   bits: int = 160) -> Iv:
    """Enclosure of ``zeta(s)`` for a rational rectangle."""
    return _pst.zeta_enclosure(re_lo, re_hi, im_lo, im_hi, M=M, K=K, bits=bits).re


def _sqrt_pi(bits: int) -> Iv:
    """Enclosure of ``sqrt(pi)`` from the log/exp atoms."""
    return exp_iv(log_iv(pi_iv(bits), bits).scale(F(1, 2)), bits)


def lambda_z2_integer(s: int, bits: int = 160, M: int = 25, K: int = 10) -> Iv:
    """Enclosure of ``Lambda_Z2(s)`` at an integer ``s >= 2``.

    ``Gamma(s) = (s-1)!`` exactly, so the only transcendental factors are
    ``pi^(-s)``, ``zeta(s)`` and ``beta(s)``.
    """
    if s < 2:
        raise ValueError("integer s must be at least 2")
    z = zeta_enclosure(s, s, bits=bits, M=M, K=K)
    b = beta_enclosure(s, s, bits=bits, M=M, K=K)
    return pi_iv(bits).pow_int(-s).mul(z).mul(b).scale(4 * factorial(s - 1))


def lambda_z2_half(n: int, bits: int = 160, M: int = 25, K: int = 10) -> Iv:
    """Enclosure of ``Lambda_Z2(n + 1/2)`` for ``n >= 1``.

    ``Gamma(n+1/2) = (2n)!/(4^n n!) sqrt(pi)`` and
    ``pi^(-(n+1/2)) = pi^(-n) / sqrt(pi)``.
    """
    if n < 1:
        raise ValueError("use n >= 1 so that Re s > 1")
    s_re = F(2 * n + 1, 2)
    z = zeta_enclosure(s_re, s_re, bits=bits, M=M, K=K)
    b = beta_enclosure(s_re, s_re, bits=bits, M=M, K=K)
    sp = _sqrt_pi(bits)
    gamma = sp.scale(F(factorial(2 * n), 4 ** n * factorial(n)))
    pi_pow = pi_iv(bits).pow_int(-n).mul(sp.inv())
    return pi_pow.mul(z).mul(b).scale(4).mul(gamma)


def phase_psi_enclosure(ms, chi, sigma_lo, sigma_hi, t_lo=0, t_hi=0,
                        bits: int = 160) -> tuple[Iv, Iv]:
    """Enclosure of the finite phase-corrected series ``Psi(sigma,t)``.

    Returns ``(real, imag)`` rational intervals.  ``ms`` and ``chi`` are the
    equal-length lists ``m_i`` and ``chi_i``; ``sigma`` and ``t`` range over the
    given rational rectangles.
    """
    if len(ms) != len(chi) or not ms:
        raise ValueError("ms and chi must have the same non-zero length")
    sigma = Iv(q(sigma_lo), q(sigma_hi))
    t = Iv(q(t_lo), q(t_hi))
    real = Iv.pt(F(0))
    imag = Iv.pt(F(0))
    for m, c in zip(ms, chi):
        if m <= 0:
            raise ValueError("m_i must be positive")
        lm = log_point(m, bits)
        magnitude = exp_iv(lm.mul(sigma).neg(), bits)
        sn, cs = sin_cos_iv(lm.mul(t), bits)
        real = real.add(magnitude.mul(cs).scale(F(c)))
        imag = imag.add(magnitude.mul(sn).scale(F(-c)))
    return real, imag
