"""RH-MTC / p-adic MTC — finite MTC and local determinant computation layer.

The archived source (``archive/maths/rh/research/rh-mtc/padic-mtc.html``)
proposes a prime-indexed family of modular tensor categories
``C_p = SU(2)_{p-2}`` at ``q = exp(pi i / p)``, asserts that the
Reshetikhin–Turaev weight of a length-``n`` periodic orbit is ``p^{-n}``,
and concludes the Riemann hypothesis from a global adelic determinant.

This module reconstructs only the finite, checkable layer:

* the simple objects, quantum dimensions and Verlinde ``S``-matrix of
  ``SU(2)_{p-2}``;
* the proposed normalised local RT weight ``p^{-n}`` and its exact
  Euler-factor bookkeeping;
* a numerical residual for the archived Gauss-sum identity, which is
  recorded as a *failed source claim* rather than used as a theorem.

It makes no claim about the global operator or RH.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Iterable

import mpmath as mp
import sympy as sp

#: The source only considers odd primes ``p >= 3``.
MIN_PRIME = 3


def _checked_prime(p: int) -> int:
    """Return ``p`` after checking that it lies in the source's domain."""
    if isinstance(p, bool) or not isinstance(p, int):
        raise TypeError("p must be an integer")
    if p < MIN_PRIME:
        raise ValueError("the source restricts to primes p >= 3")
    if not sp.isprime(p):
        raise ValueError(f"{p} is not prime")
    return p


def _checked_spin(p: int, j: Fraction | int) -> sp.Rational:
    """Return the spin ``j`` as an exact sympy rational in the admissible range."""
    _checked_prime(p)
    q = sp.Rational(j)
    if q < 0 or q > sp.Rational(p - 2, 2):
        raise ValueError(f"spin j={j} is outside 0 <= j <= (p-2)/2")
    return q


def simple_spins(p: int) -> tuple[Fraction, ...]:
    """The spins of the simple objects of ``SU(2)_{p-2}``.

    These are ``j = 0, 1/2, 1, ..., (p-2)/2``, giving ``p - 1`` objects.
    """
    _checked_prime(p)
    return tuple(Fraction(k, 2) for k in range(p - 1))


def simple_object_count(p: int) -> int:
    """Number of simple objects of ``C_p = SU(2)_{p-2}``: ``p - 1``."""
    return len(simple_spins(p))


def quantum_dimension(p: int, j: Fraction | int) -> sp.Expr:
    """Quantum dimension ``d_j = sin((2j+1) pi / p) / sin(pi / p)``."""
    q = _checked_spin(p, j)
    return sp.sin((2 * q + 1) * sp.pi / p) / sp.sin(sp.pi / p)


def total_quantum_dimension_sq(p: int) -> sp.Expr:
    """The exact symbolic sum ``D_p^2 = sum_j d_j^2``."""
    _checked_prime(p)
    return sp.Add(*[quantum_dimension(p, j) ** 2 for j in simple_spins(p)])


def sine_square_sum_exact(p: int) -> sp.Rational:
    """Exact value of ``sum_{r=1}^{p-1} sin^2(r pi / p)``.

    The primitive ``p``-th roots of unity are the roots of the cyclotomic
    polynomial ``Phi_p``.  Their sum is read off from its coefficients.
    Because ``p`` is odd, ``r -> 2r`` permutes the non-zero residues modulo
    ``p``, so this is also ``sum_r exp(2 pi i r / p)``.  Finally
    ``sin^2(x) = (1 - cos(2x)) / 2``.
    """
    _checked_prime(p)
    x = sp.symbols("x")
    phi = sp.Poly(sp.cyclotomic_poly(p, x), x)
    root_sum = -phi.nth(phi.degree() - 1) / phi.LC()
    return sp.Rational(p - 1, 2) - sp.Rational(1, 2) * root_sum


def rt_weight(p: int, n: int) -> Fraction:
    """The source's normalised local RT weight ``p^{-n}``, exactly."""
    _checked_prime(p)
    if n < 0:
        raise ValueError("the orbit length n must be non-negative")
    return Fraction(1, p**n)


def local_partial_sum(p: int, n_terms: int) -> Fraction:
    """Exact partial sum ``sum_{k=0}^{n_terms-1} p^{-k}``."""
    _checked_prime(p)
    if n_terms < 0:
        raise ValueError("n_terms must be non-negative")
    return sum((rt_weight(p, k) for k in range(n_terms)), Fraction(0))


def local_partial_sum_closed(p: int, n_terms: int) -> Fraction:
    """Closed form ``(1 - p^{-N}) / (1 - p^{-1})`` of the partial sum."""
    _checked_prime(p)
    if n_terms < 0:
        raise ValueError("n_terms must be non-negative")
    numerator = 1 - rt_weight(p, n_terms)
    denominator = 1 - rt_weight(p, 1)
    return numerator / denominator  # type: ignore[return-value]


def local_factor(p: int) -> Fraction:
    """The local Euler factor ``1 - p^{-1}`` at ``s = 1``."""
    return 1 - rt_weight(p, 1)


def local_determinant_limit(p: int) -> Fraction:
    """The local determinant value ``(1 - p^{-1})^{-1} = p / (p - 1)``."""
    return Fraction(p, p - 1)


def verlinde_s(p: int, j: Fraction | int, jp: Fraction | int) -> sp.Expr:
    """The Verlinde ``S``-matrix element ``S_{jj'}`` of ``SU(2)_{p-2}``."""
    a = _checked_spin(p, j)
    b = _checked_spin(p, jp)
    return sp.sqrt(sp.Rational(2, p)) * sp.sin((2 * a + 1) * (2 * b + 1) * sp.pi / p)


def verlinde_s_squared_error(p: int, dps: int = 40) -> float:
    """Return ``max |(S^2 - I)_{jj'}|`` computed at ``dps`` decimal digits.

    For self-conjugate ``SU(2)`` spins the Verlinde matrix should satisfy
    ``S^2 = I``.  This is a finite numerical check, not part of the Lean core.
    """
    _checked_prime(p)
    with mp.workdps(dps):
        spins = simple_spins(p)
        sq2p = mp.sqrt(mp.mpf(2) / p)

        def s(a: Fraction, b: Fraction) -> mp.mpc:
            return sq2p * mp.sin(
                (2 * mp.mpf(a.numerator) / a.denominator + 1)
                * (2 * mp.mpf(b.numerator) / b.denominator + 1)
                * mp.pi
                / p
            )

        err = mp.mpf(0)
        for a in spins:
            for b in spins:
                entry = sum(s(a, c) * s(c, b) for c in spins)
                target = mp.mpf(1) if a == b else mp.mpf(0)
                err = max(err, abs(entry - target))
        return float(err)


def archived_gauss_sum_residual(p: int, dps: int = 40) -> float:
    """Numerical residual of the archived appendix identity.

    The source claims

    ``sum_j d_j theta_j S_{j j'} = tau_p S_{0 j'}``
    with ``tau_p = exp(i pi / 4) / sqrt(p)``.

    The archived obstruction notes already concede ``G_p != tau_p``.  This
    function returns the maximum residual over ``j'`` so that the failure is
    recorded as a computation instead of being silently promoted.
    """
    _checked_prime(p)
    with mp.workdps(dps):
        spins = simple_spins(p)
        sq2p = mp.sqrt(mp.mpf(2) / p)
        sinpp = mp.sin(mp.pi / p)
        tau = mp.exp(1j * mp.pi / 4) / mp.sqrt(p)

        def jj(j: Fraction) -> mp.mpf:
            return mp.mpf(2) * mp.mpf(j.numerator) / j.denominator

        def jv(j: Fraction) -> mp.mpf:
            return mp.mpf(j.numerator) / j.denominator

        def d(j: Fraction) -> mp.mpf:
            return mp.sin((jj(j) + 1) * mp.pi / p) / sinpp

        def theta(j: Fraction) -> mp.mpc:
            return mp.exp(1j * mp.pi * (jv(j) * (jv(j) + 1) - mp.mpf(1) / 4) / p)

        def s(a: Fraction, b: Fraction) -> mp.mpf:
            return sq2p * mp.sin((jj(a) + 1) * (jj(b) + 1) * mp.pi / p)

        residual = mp.mpf(0)
        for jp in spins:
            lhs = sum(d(j) * theta(j) * s(j, jp) for j in spins)
            rhs = tau * s(Fraction(0), jp)
            residual = max(residual, abs(lhs - rhs))
        return float(residual)


def is_source_prime(p: int) -> bool:
    """Whether ``p`` belongs to the source's prime-indexed family."""
    try:
        _checked_prime(p)
    except (TypeError, ValueError):
        return False
    return True
