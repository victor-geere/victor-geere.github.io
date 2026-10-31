"""p-adic greedy sine — exact computation layer.

The proposal considered here is a p-adic analogue of the greedy harmonic
sine with steps ``p^{-n}`` on ``Z_p``.  That step sequence is not
p-adically null: ``|p^{-n}|_p = p^n``, which grows.  The corrected
construction uses the base-``p`` digit expansion (equivalently, steps
``p^n`` with digits ``0, ..., p-1``), which is what this module computes.

The module contains:

* exact base-``p`` digits and truncations, with the identity
  ``partial(x, N) = x mod p^N``;
* the p-adic norm bookkeeping that shows ``p^{-n}`` grows and ``p^n``
  shrinks;
* the truncated p-adic sine series
  ``sin_p(x) = sum_k (-1)^k x^(2k+1)/(2k+1)!`` and exact reduction
  modulo ``p^m``;
* the Newton polygon of the sine coefficients, whose first slope gives
  the valuation of the first non-zero p-adic zero;
* a finite search for approximate zeros in ``p Z_p``.

No relation to the Kubota--Leopoldt p-adic zeta function is asserted or
implemented here.
"""

from __future__ import annotations

from fractions import Fraction
from math import factorial
from typing import Iterable

__all__ = [
    "padic_valuation",
    "padic_norm_int",
    "padic_norm_p_pow",
    "padic_norm_p_neg_pow",
    "factorial_valuation",
    "base_digits",
    "partial_sum",
    "residual_high",
    "p_adic_sine_partial",
    "padic_reduction",
    "newton_points",
    "lower_hull",
    "first_slope",
    "newton_slopes",
    "first_root_valuation",
    "p_adic_sine_mod",
    "approximate_zeros",
]


def _check_prime(p: int) -> None:
    if p < 2:
        raise ValueError("p must be at least 2")
    if any(p % k == 0 for k in range(2, int(p**0.5) + 1)):
        raise ValueError("p must be prime")


def padic_valuation(n: int, p: int) -> int:
    """The p-adic valuation ``v_p(n)`` of a non-zero integer."""
    _check_prime(p)
    if n == 0:
        raise ValueError("v_p(0) is undefined")
    n = abs(n)
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def padic_norm_int(n: int, p: int) -> Fraction:
    """The p-adic norm ``|n|_p = p^{-v_p(n)}``."""
    if n == 0:
        return Fraction(0)
    return Fraction(1, p ** padic_valuation(n, p))


def padic_norm_p_pow(p: int, n: int) -> Fraction:
    """``|p^n|_p = p^{-n}``; these steps tend to zero."""
    _check_prime(p)
    if n < 0:
        raise ValueError("n must be non-negative")
    return Fraction(1, p ** n)


def padic_norm_p_neg_pow(p: int, n: int) -> Fraction:
    """``|p^{-n}|_p = p^n``; the proposed steps grow, not shrink."""
    _check_prime(p)
    if n < 0:
        raise ValueError("n must be non-negative")
    return Fraction(p ** n, 1)


def factorial_valuation(n: int, p: int) -> int:
    """Legendre's formula for ``v_p(n!)``."""
    _check_prime(p)
    if n < 0:
        raise ValueError("n must be non-negative")
    total = 0
    while n:
        n //= p
        total += n
    return total


def base_digits(x: int, p: int) -> list[int]:
    """The base-``p`` digits of ``x >= 0``, least significant first."""
    _check_prime(p)
    if x < 0:
        raise ValueError("x must be non-negative")
    if x == 0:
        return [0]
    digits: list[int] = []
    while x:
        digits.append(x % p)
        x //= p
    return digits


def partial_sum(x: int, p: int, n_terms: int) -> int:
    """The low ``n_terms`` base-``p`` digits read as an integer.

    This is exactly ``x % p^n_terms``; it is the p-adic greedy
    truncation of ``x`` after ``n_terms`` digits.
    """
    _check_prime(p)
    if x < 0 or n_terms < 0:
        raise ValueError("x and n_terms must be non-negative")
    return sum(d * p**i for i, d in enumerate(base_digits(x, p)[:n_terms]))


def residual_high(x: int, p: int, n_terms: int) -> int:
    """The remaining high part ``x / p^n_terms`` after the truncation."""
    _check_prime(p)
    if x < 0 or n_terms < 0:
        raise ValueError("x and n_terms must be non-negative")
    return x // p**n_terms


def p_adic_sine_partial(x: int, p: int, terms: int) -> Fraction:
    """The finite p-adic sine ``sum_{k<terms} (-1)^k x^(2k+1)/(2k+1)!``."""
    _check_prime(p)
    if terms < 0:
        raise ValueError("terms must be non-negative")
    total = Fraction(0)
    for k in range(terms):
        total += Fraction((-1) ** k * x ** (2 * k + 1), factorial(2 * k + 1))
    return total


def padic_reduction(q: Fraction, p: int, m: int) -> int:
    """The residue of ``q`` modulo ``p^m`` in ``{0, ..., p^m - 1}``.

    The rational must be p-adically integral, i.e. ``v_p(q) >= 0``.
    """
    _check_prime(p)
    if m < 0:
        raise ValueError("m must be non-negative")
    if q == 0:
        return 0
    num, den = q.numerator, q.denominator
    v_num = 0 if num == 0 else padic_valuation(num, p)
    v_den = padic_valuation(den, p)
    if v_num < v_den:
        raise ValueError("q is not p-adically integral")
    modulus = p**m
    return (num % modulus) * pow(den % modulus, -1, modulus) % modulus


def newton_points(p: int, terms: int) -> list[tuple[int, int]]:
    """Points ``(2k+1, v_p(1/(2k+1)!))`` of the p-adic sine."""
    _check_prime(p)
    if terms < 1:
        raise ValueError("terms must be positive")
    return [(2 * k + 1, -factorial_valuation(2 * k + 1, p)) for k in range(terms)]


def lower_hull(points: Iterable[tuple[int, int]]) -> list[tuple[int, int]]:
    """The lower convex hull of a finite set of integer points."""
    hull: list[tuple[int, int]] = []
    for point in points:
        while len(hull) >= 2:
            x1, y1 = hull[-2]
            x2, y2 = hull[-1]
            # Keep the lower hull: drop the middle point if it is on or
            # above the chord from the previous point to the new one.
            if (y2 - y1) * (point[0] - x2) >= (point[1] - y2) * (x2 - x1):
                hull.pop()
            else:
                break
        hull.append(point)
    return hull


def first_slope(p: int, terms: int = 60) -> Fraction:
    """The first slope of the Newton polygon of the sine series."""
    hull = lower_hull(newton_points(p, terms))
    if len(hull) < 2:
        raise ValueError("not enough points for a slope")
    (x1, y1), (x2, y2) = hull[0], hull[1]
    return Fraction(y2 - y1, x2 - x1)


def newton_slopes(p: int, terms: int = 60) -> list[Fraction]:
    """All slopes of the Newton polygon, in order."""
    hull = lower_hull(newton_points(p, terms))
    return [
        Fraction(hull[i + 1][1] - hull[i][1], hull[i + 1][0] - hull[i][0])
        for i in range(len(hull) - 1)
    ]


def first_root_valuation(p: int, terms: int = 60) -> Fraction:
    """The valuation of the first non-zero p-adic zero (Newton polygon)."""
    return -first_slope(p, terms)


def p_adic_sine_mod(x: int, p: int, terms: int, m: int) -> int:
    """The truncated p-adic sine reduced modulo ``p^m``."""
    return padic_reduction(p_adic_sine_partial(x, p, terms), p, m)


def approximate_zeros(p: int, m: int, terms: int = 60) -> list[int]:
    """Search ``x = p k`` modulo ``p^m`` for approximate sine zeros.

    This is a finite search, not a proof that the listed residues are
    zeros of the infinite series.
    """
    _check_prime(p)
    if m < 1:
        raise ValueError("m must be positive")
    zeros = []
    for k in range(p ** (m - 1)):
        x = p * k
        if p_adic_sine_mod(x, p, terms, m) == 0:
            zeros.append(x)
    return zeros
