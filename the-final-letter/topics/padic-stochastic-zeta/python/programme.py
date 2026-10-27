"""p-adic and stochastic zeta — exact computation layer.

The archived source (`archive/essays/p-adic.html`) defines the p-adic
norm, a finite little-endian base-`p` encoding of a digit sequence, and
the Kubota–Leopoldt interpolation factor `1 - p^(k-1)`.  It does not
define a stochastic process.  This module implements those exact local
objects with sympy and adds one archimedean eta value as context; the
zeta/stochastic bridge is left open in the dossier.

Every function is exact.  Numerical checks are performed only in the
tests, with explicit sympy simplification rather than floating point.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp


def _check_prime_base(p: int) -> None:
    """Raise unless ``p`` is an integer at least 2."""
    if not isinstance(p, int) or p < 2:
        raise ValueError("the base p must be an integer >= 2")


def padic_valuation(p: int, n: int) -> int:
    """The p-adic valuation of a non-zero integer.

    Returns the largest ``e >= 0`` with ``p**e | n``.  The valuation of
    zero is infinite and is rejected.
    """
    _check_prime_base(p)
    if not isinstance(n, int):
        raise TypeError("n must be an integer")
    if n == 0:
        raise ValueError("the p-adic valuation of zero is infinite")
    n = abs(n)
    e = 0
    while n % p == 0:
        n //= p
        e += 1
    return e


def padic_norm(p: int, n: int) -> sp.Rational:
    """The p-adic norm of an integer: ``p**(-v_p(n))``, and ``0`` at zero."""
    _check_prime_base(p)
    if not isinstance(n, int):
        raise TypeError("n must be an integer")
    if n == 0:
        return sp.Rational(0)
    return sp.Rational(1, p ** padic_valuation(p, n))


def padic_valuation_rational(p: int, q: sp.Rational | int) -> int:
    """The p-adic valuation of a non-zero rational."""
    _check_prime_base(p)
    q = sp.Rational(q)
    if q == 0:
        raise ValueError("the p-adic valuation of zero is infinite")
    return padic_valuation(p, int(q.p)) - padic_valuation(p, int(q.q))


def padic_norm_rational(p: int, q: sp.Rational | int) -> sp.Rational:
    """The p-adic norm of a rational, with ``|0|_p = 0``."""
    _check_prime_base(p)
    q = sp.Rational(q)
    if q == 0:
        return sp.Rational(0)
    return sp.Integer(p) ** (-padic_valuation_rational(p, q))


def ultrametric_holds(p: int, q: sp.Rational | int, r: sp.Rational | int) -> bool:
    """Check the ultrametric inequality ``|q + r|_p <= max(|q|_p, |r|_p)``."""
    lhs = padic_norm_rational(p, sp.Rational(q) + sp.Rational(r))
    rhs = max(padic_norm_rational(p, q), padic_norm_rational(p, r))
    return bool(lhs <= rhs)


def encode_digits(p: int, digits: Sequence[int]) -> int:
    """Encode a little-endian digit string: ``Σ digits[k] * p**k``.

    The source restricts digits to ``{0, …, p-1}``; that restriction is
    enforced here.  The empty string encodes ``0``.
    """
    _check_prime_base(p)
    total = 0
    for k, d in enumerate(digits):
        if not isinstance(d, int):
            raise TypeError("digits must be integers")
        if not 0 <= d < p:
            raise ValueError(f"digit {d} is not in [0, {p})")
        total += d * p**k
    return total


def encode_bound_holds(p: int, digits: Sequence[int]) -> bool:
    """Check that a valid length-``n`` encoding is below ``p**n``."""
    value = encode_digits(p, digits)
    return value < p ** len(digits)


def euler_factor(p: int) -> sp.Rational:
    """The local Euler factor at ``s = 1``: ``1 - p**(-1)``."""
    _check_prime_base(p)
    return sp.Rational(p - 1, p)


def euler_telescope(p: int, n: int) -> tuple[sp.Expr, sp.Expr]:
    """Return both sides of the finite Euler-factor telescoping identity.

    ``(1 - p⁻¹) * Σ_{k<N} p⁻ᵏ = 1 - p⁻ᴺ``.
    """
    _check_prime_base(p)
    if n < 0:
        raise ValueError("N must be non-negative")
    x = sp.Rational(1, p)
    lhs = sp.simplify((1 - x) * sum(x**k for k in range(n)))
    rhs = sp.simplify(1 - x**n)
    return lhs, rhs


def zeta_at_negative_integer(k: int) -> sp.Rational:
    """The exact value ``ζ(1-k) = -B_k/k`` for ``k >= 2``."""
    if not isinstance(k, int) or k < 2:
        raise ValueError("the formula ζ(1-k) = -B_k/k is used here for k >= 2")
    return sp.Rational(-sp.bernoulli(k), k)


def kl_factor(p: int, k: int) -> sp.Rational:
    """The Kubota–Leopoldt interpolation factor ``1 - p**(k-1)``."""
    _check_prime_base(p)
    if not isinstance(k, int) or k < 1:
        raise ValueError("k must be an integer >= 1")
    return sp.Rational(1 - p ** (k - 1))


def kl_value(p: int, k: int = 2) -> sp.Rational:
    """The value predicted by ``ζ_p(1-k) = (1-p**(k-1)) ζ(1-k)``.

    This is the rational bookkeeping on the right-hand side; it is not a
    construction of the p-adic zeta function.
    """
    if k < 2:
        raise ValueError("use k >= 2; the k = 1 pole is not evaluated here")
    return sp.Rational(kl_factor(p, k) * zeta_at_negative_integer(k))


def eta_at_two() -> sp.Expr:
    """The archimedean Dirichlet eta value ``η(2) = π²/12``.

    This is context for the word "eta" in the topic label.  The archived
    source does not define a p-adic eta function; this value is recorded
    as an archimedean check, not as a p-adic result.
    """
    n = sp.symbols("n", integer=True, positive=True)
    return sp.summation((-1) ** (n + 1) / n**2, (n, 1, sp.oo))


def digit_strings(p: int, length: int) -> Iterable[tuple[int, ...]]:
    """All valid length-``length`` digit strings over ``{0, …, p-1}``."""
    _check_prime_base(p)
    if length < 0:
        raise ValueError("length must be non-negative")
    if length == 0:
        yield ()
        return
    for head in range(p):
        for tail in digit_strings(p, length - 1):
            yield (head,) + tail
