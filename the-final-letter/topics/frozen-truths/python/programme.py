"""Frozen truths — exact computation layer.

The module reconstructs the finite, exact part of `truths.md`: the
last-chord boundary term and its pairing, the self-dual abscissa, the
integer-ratio identity, and the hyperbolic-cosine weight.  It also
records an exact Gaussian model computation for the solved `γ = 0`
slice of the cosine kernel (truths.md 15.1).

All arithmetic is sympy-exact.  Numerical limits state their tolerance.
The analytic and Riemann-hypothesis-adjacent claims of the source are
*not* computed here; they are recorded as source claims in the dossier.
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi


def _positive_int(value: int, name: str) -> int:
    if not isinstance(value, int) or isinstance(value, bool):
        raise TypeError(f"{name} must be an integer")
    if value < 1:
        raise ValueError(f"{name} must be a positive integer")
    return value


def last_chord(N: int, s: sp.Expr) -> sp.Expr:
    """The last-chord boundary term ``H_N(s) = ((1 - N)/2) * N**(-2s)``.

    ``N`` is a positive integer and ``s`` may be real or complex.
    """
    _positive_int(N, "N")
    return sp.Rational(1 - N, 2) * sp.Pow(N, -2 * s)


def last_chord_square(N: int) -> sp.Expr:
    """The constant pairing value ``(N - 1)**2 / (4 N**2)``."""
    _positive_int(N, "N")
    return sp.Rational((N - 1) ** 2, 4 * N**2)


def last_chord_product(N: int, s: sp.Expr) -> sp.Expr:
    """Simplify ``H_N(s) * H_N(1 - s)`` exactly."""
    return sp.simplify(last_chord(N, s) * last_chord(N, 1 - s))


def last_chord_abs(N: int, sigma: sp.Expr) -> sp.Expr:
    """The twin modulus ``|H_N(sigma)| = ((N - 1)/2) * N**(-2 sigma)``.

    ``sigma`` is real.  The formula also holds at ``N = 1``, where both
    sides vanish.
    """
    _positive_int(N, "N")
    sigma = sp.sympify(sigma)
    if sigma.is_real is False:
        raise ValueError("sigma must be real")
    return sp.Rational(N - 1, 2) * sp.Pow(N, -2 * sigma)


def twin_moduli_equal(N: int, sigma: sp.Expr) -> bool:
    """Exact test of ``|H_N(sigma)| == |H_N(1 - sigma)|``."""
    _positive_int(N, "N")
    sigma = sp.sympify(sigma)
    return sp.simplify(last_chord_abs(N, sigma) - last_chord_abs(N, 1 - sigma)) == 0


def last_chord_limit(N: int) -> sp.Rational:
    """The exact partial value ``(N - 1)**2 / (4 N**2)``."""
    return last_chord_square(N)


def exp_neg_log_ratio(m: int, n: int) -> sp.Expr:
    """Exact evaluation of ``exp(-|log(m/n)|)`` for positive integers."""
    _positive_int(m, "m")
    _positive_int(n, "n")
    ratio = sp.Rational(m, n)
    return sp.simplify(sp.exp(-sp.Abs(sp.log(ratio))))


def ratio_min_max(m: int, n: int) -> sp.Expr:
    """The right-hand side ``min(m,n)/max(m,n)``."""
    _positive_int(m, "m")
    _positive_int(n, "n")
    return sp.Rational(min(m, n), max(m, n))


def cosh_weight(alpha: sp.Expr, u: sp.Expr) -> sp.Expr:
    """The cosine-kernel weight ``cosh(alpha u)``."""
    return sp.cosh(sp.sympify(alpha) * sp.sympify(u))


def gaussian_zero_slice(alpha: sp.Expr) -> sp.Expr:
    """Exact Gaussian model of the solved slice ``K(alpha, 0)``.

    For the model kernel ``Phi(u) = exp(-u**2)``,

        ``∫_0^∞ Phi(u) cosh(alpha u) du = (sqrt(pi)/2) exp(alpha**2/4)``,

    which is strictly positive for every real ``alpha``.  This is a
    model of truths.md 15.1, not the source's Jacobi-theta ``Phi``.
    """
    alpha = sp.sympify(alpha)
    if alpha.is_real is False:
        raise ValueError("alpha must be real")
    return sp.sqrt(PI) / 2 * sp.exp(alpha**2 / 4)


def gaussian_zero_slice_integral(alpha: sp.Expr) -> sp.Expr:
    """Evaluate the defining integral for the Gaussian model exactly."""
    u = sp.symbols("u", positive=True)
    alpha = sp.sympify(alpha)
    return sp.simplify(
        sp.integrate(sp.exp(-(u**2)) * sp.cosh(alpha * u), (u, 0, sp.oo))
    )
