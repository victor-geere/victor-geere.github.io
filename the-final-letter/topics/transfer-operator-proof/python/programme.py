"""Transfer-operator proof — finite exact computation layer.

The archived source (``archive/maths/rh.html``) is an exploratory
Hilbert--Pólya programme, not a proof.  It *defines* a finite Euler /
Fredholm determinant, a von Mangoldt weight, and a Petersson form that is
actually an indefinite Krein form.  This module implements exactly those
finite objects.  It does **not** implement, and does not claim, the
analytic continuation of the operator family, the completion of ``xi``,
or the Riemann Hypothesis.

All arithmetic is exact sympy arithmetic unless a function name explicitly
says ``numeric``.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi


def primes_up_to(n: int) -> list[int]:
    """All primes ``p <= n`` (exact, deterministic)."""
    if n < 2:
        return []
    return list(sp.primerange(2, n + 1))


def von_mangoldt(n: int) -> sp.Expr:
    """The von Mangoldt function ``Λ(n)`` (Definition 2.1).

    ``Λ(n) = log p`` when ``n = p^k`` for a prime ``p`` and ``k >= 1``,
    and ``0`` otherwise.  ``Λ(1) = 0``.
    """
    if n < 1:
        raise ValueError("n must be positive")
    if n == 1:
        return sp.Integer(0)
    factorisation = sp.factorint(n)
    if len(factorisation) == 1:
        p = next(iter(factorisation))
        return sp.log(p)
    return sp.Integer(0)


def prime_sieve(s: sp.Expr, primes: Sequence[int]) -> sp.Expr:
    """The truncated prime-sieve product ``∏_p sin(π s / p)``.

    Definition 1.1 of the source.  The product is truncated to the supplied
    primes; the infinite product is not convergent without regularisation.
    """
    if not primes:
        return sp.Integer(1)
    return sp.prod(sp.sin(PI * s / p) for p in primes)


def prime_weight(p: int, s: sp.Expr) -> sp.Expr:
    """The transfer-operator eigenvalue ``p^{-s}`` (Definition 2.2)."""
    if p < 2:
        raise ValueError("p must be prime (>= 2)")
    return sp.Pow(p, -s)


def fredholm_det(eigenvalues: Iterable[sp.Expr]) -> sp.Expr:
    """Finite Fredholm determinant ``∏_i (1 - λ_i)``.

    For the diagonal model operator of Definition 2.2 this is the
    truncated Euler product ``∏_p (1 - p^{-s})``.  It vanishes exactly
    when some eigenvalue equals ``1``.
    """
    return sp.prod(1 - x for x in eigenvalues)


def truncated_euler_product(s: sp.Expr, primes: Sequence[int]) -> sp.Expr:
    """``∏_{p in primes} (1 - p^{-s})``, the finite determinant of the model."""
    return fredholm_det(prime_weight(p, s) for p in primes)


def diagonal_form(weights: Sequence[sp.Expr], x: Sequence[sp.Expr], y: Sequence[sp.Expr]) -> sp.Expr:
    """The real diagonal (Euclidean) pairing ``Σ_i w_i x_i y_i``."""
    if not (len(weights) == len(x) == len(y)):
        raise ValueError("weights, x and y must have the same length")
    return sp.Add(*[w * a * b for w, a, b in zip(weights, x, y)])


def diagonal_energy(weights: Sequence[sp.Expr], x: Sequence[sp.Expr]) -> sp.Expr:
    """The quadratic form ``Σ_i w_i x_i²`` of a diagonal operator."""
    return diagonal_form(weights, x, x)


def krein_form(signs: Sequence[sp.Expr], x: Sequence[sp.Expr], y: Sequence[sp.Expr]) -> sp.Expr:
    """The indefinite (Krein) form ``Σ_i sign_i x_i y_i``.

    This is the finite algebraic model of Definition 3.1: symmetric, but
    not positive definite when a negative sign occurs.
    """
    if not (len(signs) == len(x) == len(y)):
        raise ValueError("signs, x and y must have the same length")
    return sp.Add(*[s * a * b for s, a, b in zip(signs, x, y)])


def xi_numeric(s: complex, dps: int = 30) -> complex:
    """The completed xi function ``ξ(s)`` evaluated numerically with mpmath.

    ``ξ(s) = ½ s(s-1) π^{-s/2} Γ(s/2) ζ(s)``.  This is a numerical
    evaluation only; the functional equation it is tested against is a
    classical theorem, not a result of this programme.
    """
    import mpmath as mp

    with mp.workdps(dps):
        z = mp.mpc(s)
        value = (
            mp.mpf("0.5")
            * z
            * (z - 1)
            * mp.power(mp.pi, -z / 2)
            * mp.gamma(z / 2)
            * mp.zeta(z)
        )
        return complex(value)
