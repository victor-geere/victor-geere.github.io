"""Exact-rational partial-sum-plus-tail layer for ζ, ζ(s,a) and L(s,χ).

This module is the clean API over the harvested `rativ.py` interval engine and
`partial_tail.py` Euler–Maclaurin evaluator.  Everything is exact rational
arithmetic; no floating point is used.  The transcendental enclosures are the
trusted leaves described in the topic README.
"""

from __future__ import annotations

from fractions import Fraction as F

import rativ as R
from rativ import Cx, Iv, cexp, exp_iv, log_point, q, sin_cos_iv
from partial_tail import bernoulli, certificate, evaluate, tail_radius

__all__ = [
    "Iv", "Cx", "q", "bernoulli", "tail_radius",
    "zeta_enclosure", "L_enclosure", "eta_enclosure",
    "eta_cos_sin_enclosure", "certificate_for", "verify_certificate_file",
]


def zeta_enclosure(re_lo, re_hi, im_lo, im_hi, M: int = 20, K: int = 8,
                   bits: int = 64) -> Cx:
    """Enclosure of ζ(s) for s in the rational rectangle."""
    _, out = evaluate("zeta", re_lo, re_hi, im_lo, im_hi, M, K, bits)
    return out.box


def L_enclosure(chi: list[int], re_lo, re_hi, im_lo, im_hi, M: int = 20,
                K: int = 8, bits: int = 64) -> Cx:
    """Enclosure of L(s, χ) for a Dirichlet character given by its values."""
    _, out = evaluate("L", re_lo, re_hi, im_lo, im_hi, M, K, bits, chi=chi)
    return out.box


def eta_enclosure(re_lo, re_hi, im_lo, im_hi, M: int = 20, K: int = 8,
                  bits: int = 64) -> Cx:
    """Enclosure of η(s) = (1 − 2^(1−s)) ζ(s) on the rectangle."""
    zeta = zeta_enclosure(re_lo, re_hi, im_lo, im_hi, M, K, bits)
    S = Cx(Iv(q(re_lo), q(re_hi)), Iv(q(im_lo), q(im_hi)))
    one = Cx.one()
    L2 = log_point(2, bits)
    d = one.sub(S)
    arg = Cx(d.re.mul(L2), d.im.mul(L2))
    factor = one.sub(cexp(arg, bits))
    return factor.mul(zeta)


def eta_cos_sin_enclosure(sigma_lo, sigma_hi, t_lo, t_hi, M: int = 20,
                          bits: int = 64) -> tuple[Iv, Iv]:
    """Enclosures of the cos and sin series of the finite eta partial sum.

    Returns `(cos_series, sin_series)` for
    `Σ_{n=1}^{M} (-1)^(n-1) n^(-σ) cos(t log n)` and the corresponding sine
    series.  The imaginary part of the eta partial sum is minus the sine series.
    """
    sig = Iv(q(sigma_lo), q(sigma_hi))
    tt = Iv(q(t_lo), q(t_hi))
    cos_sum = Iv.pt(0)
    sin_sum = Iv.pt(0)
    for n in range(1, M + 1):
        Ln = log_point(n, bits)
        # n^(-σ) = exp(-σ log n), monotone in σ
        e = exp_iv(Iv(-(sig.hi * Ln.hi), -(sig.lo * Ln.lo)), bits)
        s, c = sin_cos_iv(tt.mul(Ln), bits)
        sign = F(1) if n % 2 == 1 else F(-1)
        cos_sum = cos_sum.add(e.mul(c).scale(sign))
        sin_sum = sin_sum.add(e.mul(s).scale(sign))
    return cos_sum, sin_sum


def certificate_for(kind: str, re_lo, re_hi, im_lo, im_hi, M: int = 20,
                    K: int = 8, bits: int = 64,
                    chi: list[int] | None = None) -> dict:
    """Build a checkable certificate for `kind ∈ {"zeta", "L"}`."""
    B, out = evaluate(kind, re_lo, re_hi, im_lo, im_hi, M, K, bits, chi=chi)
    params = {"re": [str(re_lo), str(re_hi)], "im": [str(im_lo), str(im_hi)],
              "M": M, "K": K, "bits": bits}
    if chi is not None:
        params["chi"] = chi
    return certificate(B, out, kind, params)


def verify_certificate_file(path, weak_atoms: bool = False) -> bool:
    """Independently verify a certificate JSON file."""
    import verify_certificate as VC
    return VC.verify(path, weak_atoms=weak_atoms)
