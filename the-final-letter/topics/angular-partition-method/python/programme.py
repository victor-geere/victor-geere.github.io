"""Exact arithmetic for the angular partition method.

The module deliberately uses :class:`fractions.Fraction` throughout. There is
no floating point, no truncation, and no numerical tail estimate: the examples
are exact finite identities or exact self-similar fixed points.
"""

from fractions import Fraction
from typing import List, Sequence


class NotSelfSimilar(ValueError):
    """Raised when a contraction ratio is 1, so the fixed point is undefined."""


def sector_angle_terms(n: int) -> List[Fraction]:
    """The first ``n`` halving-sector angles in normalized full-turn units.

    The sectors are ``1, 1/2, 1/4, ...`` measured in full turns. In radians
    these are ``2*pi, pi, pi/2, ...``; the normalized form keeps the arithmetic
    rational.
    """
    if n < 0:
        raise ValueError("n must be nonnegative")
    return [Fraction(1, 2**k) for k in range(n)]


def sector_angle_sum(n: int) -> Fraction:
    """Exact sum of the first ``n`` normalized sector angles."""
    return sum(sector_angle_terms(n), Fraction(0))


def sector_angle_closed_form(n: int) -> Fraction:
    """The closed form ``2 - 2/2**n`` for the normalized halving sectors."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    return Fraction(2) - Fraction(2, 2**n)


def half_turn_terms(n: int) -> List[Fraction]:
    """The first ``n`` terms of ``1/2 + 1/4 + ...``."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    return [Fraction(1, 2 ** (k + 1)) for k in range(n)]


def half_turn_sum(n: int) -> Fraction:
    """Exact partial sum of ``1/2 + 1/4 + ...``."""
    return sum(half_turn_terms(n), Fraction(0))


def half_turn_closed_form(n: int) -> Fraction:
    """The closed form ``1 - 1/2**n`` for the half-turn series."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    return Fraction(1) - Fraction(1, 2**n)


def geometric_partial(a: Fraction, r: Fraction, n: int) -> Fraction:
    """Exact finite geometric sum ``a + a r + ... + a r**(n-1)``."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    return sum((a * r**k for k in range(n)), Fraction(0))


def geometric_closed_form(a: Fraction, r: Fraction, n: int) -> Fraction:
    """The exact finite identity ``a (1 - r**n) / (1 - r)``."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    if r == 1:
        raise NotSelfSimilar("ratio 1 has no finite self-similar closed form")
    return a * (1 - r**n) / (1 - r)


def self_similar_total(a: Fraction, r: Fraction) -> Fraction:
    """Solve the exact no-tail fixed point ``S = a + r S``."""
    if r == 1:
        raise NotSelfSimilar("ratio 1 has no self-similar total")
    return a / (1 - r)


def reciprocal_weights(n: int) -> List[Fraction]:
    """The first ``n`` reciprocal weights ``1/(k+1)``."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    return [Fraction(1, k + 1) for k in range(n)]


def successive_ratios(seq: Sequence[Fraction]) -> List[Fraction]:
    """Ratios ``seq[k+1]/seq[k]`` for a nonzero sequence."""
    out: List[Fraction] = []
    for left, right in zip(seq, seq[1:]):
        if left == 0:
            raise ZeroDivisionError("ratio undefined for a zero term")
        out.append(right / left)
    return out


def is_constant_ratio(seq: Sequence[Fraction]) -> bool:
    """Whether all successive ratios of ``seq`` agree exactly."""
    ratios = successive_ratios(seq)
    return len(set(ratios)) <= 1


def reciprocal_weights_not_geometric() -> bool:
    """The reciprocal weights ``1, 1/2, 1/3, ...`` are not constant-ratio."""
    return not is_constant_ratio(reciprocal_weights(6))


def squared_tail_radii(weights: Sequence[Fraction]) -> List[Fraction]:
    """Squared radii `R_n^2 = sum_{k>=n} weights[k]`, with `R_N = 0`.

    The result has length ``len(weights) + 1``.  The annulus between
    ``R_{n+1}`` and ``R_n`` has normalized area ``weights[n]``.  This is the
    exact radial bookkeeping transform; no geometric decay is assumed.
    """
    n = len(weights)
    out = [Fraction(0)] * (n + 1)
    for k in range(n - 1, -1, -1):
        if weights[k] < 0:
            raise ValueError("annular weights must be nonnegative")
        out[k] = out[k + 1] + weights[k]
    return out


def weights_from_squared_radii(squared_radii: Sequence[Fraction]) -> List[Fraction]:
    """The annulus weights `R_k^2 - R_{k+1}^2` of a squared-radius sequence."""
    if len(squared_radii) < 2:
        raise ValueError("need at least two radii")
    out: List[Fraction] = []
    for left, right in zip(squared_radii, squared_radii[1:]):
        if right > left:
            raise ValueError("squared radii must be nonincreasing")
        out.append(left - right)
    return out


def annular_telescope(squared_radii: Sequence[Fraction]) -> Fraction:
    """The total area `R_0^2 - R_N^2` of a finite annular partition."""
    if not squared_radii:
        raise ValueError("need at least one radius")
    return squared_radii[0] - squared_radii[-1]


def annular_weights_sum(squared_radii: Sequence[Fraction]) -> Fraction:
    """The sum of the annulus weights of a finite annular partition."""
    return sum(weights_from_squared_radii(squared_radii), Fraction(0))


def rational_cake_value(head: Fraction, ratio: Fraction) -> Fraction:
    """A named, exact self-similar cake value."""
    return self_similar_total(head, ratio)


# ---------------------------------------------------------------------------
# Phase-carrying tail coil (exact pairs of rationals)
# ---------------------------------------------------------------------------

Complex = tuple[Fraction, Fraction]


def cadd(a: Complex, b: Complex) -> Complex:
    return (a[0] + b[0], a[1] + b[1])


def csub(a: Complex, b: Complex) -> Complex:
    return (a[0] - b[0], a[1] - b[1])


def cdiv(a: Complex, b: Complex) -> Complex:
    den = b[0] * b[0] + b[1] * b[1]
    if den == 0:
        raise ZeroDivisionError("complex division by zero")
    return ((a[0] * b[0] + a[1] * b[1]) / den,
            (a[1] * b[0] - a[0] * b[1]) / den)


def complex_tail(terms: Sequence[Complex], n: int) -> Complex:
    """The exact tail `terms[n] + terms[n+1] + ...` of a finite complex list."""
    if n < 0:
        raise ValueError("n must be nonnegative")
    re = sum((t[0] for t in terms[n:]), Fraction(0))
    im = sum((t[1] for t in terms[n:]), Fraction(0))
    return (re, im)


def coil_radius_squared(point: Complex) -> Fraction:
    """The exact squared radius of a coil point."""
    return point[0] * point[0] + point[1] * point[1]


def coil_telescope(terms: Sequence[Complex], n: int) -> bool:
    """Check the exact chord identity `sum_{k<n} terms[k] = tail(0) - tail(n)`."""
    prefix = (Fraction(0), Fraction(0))
    for term in terms[:n]:
        prefix = cadd(prefix, term)
    return prefix == csub(complex_tail(terms, 0), complex_tail(terms, n))


def unit_coil(terms: Sequence[Complex], n: int) -> Complex:
    """The exact unit-coil point `tail(n) / tail(0)`."""
    total = complex_tail(terms, 0)
    if total == (Fraction(0), Fraction(0)):
        raise ZeroDivisionError("unit coil needs a nonzero total")
    return cdiv(complex_tail(terms, n), total)
