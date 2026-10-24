"""HST programme: exact finite computations.

The module works in π-normalised angle units.  An angle ``θ`` is represented
by ``t = θ/π ∈ [0, 1]`` as :class:`fractions.Fraction`; the harmonic angles
are then ``α_n/π = 1/(n+2)``.  All arithmetic is exact.

The functions implement

* the greedy harmonic digit recursion of the source's equation (1),

  ``δ_n = 1`` iff ``θ − accumulated ≥ α_n``,  ``accumulated ← accumulated + δ_n α_n``;

* the exact threshold scan over the greedy harmonic tree;

* the Haar wavelets on split nodes, in the correctly normalised zero-mean
  form used by the reconstruction, and the source's unnormalised form;

* exact L² inner products of those piecewise-constant wavelets.

Nothing here depends on mpmath; the analytic claims of the source (Fredholm
determinant, meromorphic continuation, explicit formula) are not computed.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Iterable

import sympy as sp

__all__ = [
    "alpha_scaled",
    "alpha",
    "greedy_digits",
    "greedy_accumulated",
    "residual",
    "thresholds_exact",
    "tree_intervals",
    "tree_wavelets",
    "HaarWavelet",
    "reconstructed_wavelet",
    "source_wavelet",
    "haar_norm_sq",
    "haar_mean",
    "inner_product",
    "tree_intervals",
]


def alpha_scaled(n: int) -> Fraction:
    """The harmonic angle divided by π: ``α_n/π = 1/(n+2)``."""
    if n < 0:
        raise ValueError("harmonic index must be non-negative")
    return Fraction(1, n + 2)


def alpha(n: int) -> sp.Expr:
    """The harmonic angle ``α_n = π/(n+2)`` as an exact sympy expression."""
    return sp.pi * alpha_scaled(n)


def greedy_digits(t: Fraction, n_max: int) -> list[int]:
    """Return the greedy digits ``δ_0, …, δ_{n_max}`` at ``t = θ/π``.

    ``δ_n`` is selected when the residual ``t − accumulated`` is at least
    ``1/(n+2)``.  Digits are exact (:class:`fractions.Fraction` arithmetic).
    """
    t = Fraction(t)
    if not (0 <= t <= 1):
        raise ValueError("t = θ/π must lie in [0, 1]")
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    digits: list[int] = []
    accumulated = Fraction(0)
    for n in range(n_max + 1):
        a = alpha_scaled(n)
        d = 1 if a <= t - accumulated else 0
        digits.append(d)
        if d:
            accumulated += a
    return digits


def greedy_accumulated(t: Fraction, n_max: int) -> Fraction:
    """Selected mass ``Σ_{k≤n_max} δ_k(t)/(k+2) = θ_N/π``."""
    return sum(
        (Fraction(d, k + 2) for k, d in enumerate(greedy_digits(t, n_max))),
        Fraction(0),
    )


def residual(t: Fraction, n_max: int) -> Fraction:
    """Residual ``t − Σ_{k≤n_max} δ_k/(k+2)`` after ``n_max+1`` digits."""
    return Fraction(t) - greedy_accumulated(t, n_max)


def tree_intervals(n_max: int) -> list[tuple[Fraction, Fraction, Fraction]]:
    """Cylinder intervals of the greedy tree up to depth ``n_max``.

    Each entry is ``(lo, hi, accumulated)`` for ``t ∈ [lo, hi)``; on the
    interval the residual is the affine function ``t − accumulated``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    intervals: list[tuple[Fraction, Fraction, Fraction]] = [(Fraction(0), Fraction(1), Fraction(0))]
    result = list(intervals)
    for n in range(n_max):
        a = alpha_scaled(n)
        nxt: list[tuple[Fraction, Fraction, Fraction]] = []
        for lo, hi, s in result:
            cut = s + a
            left_hi = min(hi, cut)
            if lo < left_hi:
                nxt.append((lo, left_hi, s))
            right_lo = max(lo, cut)
            if right_lo < hi:
                nxt.append((right_lo, hi, cut))
        result = nxt
    return result


def thresholds_exact(n_max: int) -> list[Fraction]:
    """Exact thresholds ``θ_n*/π = inf{t : δ_n(t)=1}`` for ``n < n_max``.

    The scan follows the cylinder intervals of the tree and takes the least
    left endpoint at which the ``n``-th digit becomes selected.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    intervals: list[tuple[Fraction, Fraction, Fraction]] = [(Fraction(0), Fraction(1), Fraction(0))]
    thresholds: list[Fraction] = []
    for n in range(n_max):
        a = alpha_scaled(n)
        cut_intervals: list[tuple[Fraction, Fraction, Fraction]] = []
        threshold: Fraction | None = None
        for lo, hi, s in intervals:
            cut = s + a
            right_lo = max(lo, cut)
            if right_lo < hi:
                cut_intervals.append((right_lo, hi, cut))
                threshold = right_lo if threshold is None else min(threshold, right_lo)
            left_hi = min(hi, cut)
            if lo < left_hi:
                cut_intervals.append((lo, left_hi, s))
        if threshold is None:
            raise ArithmeticError("no digit-1 cylinder at this depth")
        thresholds.append(threshold)
        intervals = cut_intervals
    return thresholds


@dataclass(frozen=True)
class HaarWavelet:
    """A compactly supported piecewise-constant wavelet.

    ``pieces`` is a tuple of ``(lo, hi, value)`` in π-normalised coordinates;
    the value is a sympy expression (possibly a square root).  Inner products
    are the Lebesgue integral in ``t``; the L²([0, π]) inner product is ``π``
    times this value.
    """

    pieces: tuple[tuple[Fraction, Fraction, sp.Expr], ...]

    def support(self) -> tuple[Fraction, Fraction]:
        return min(p[0] for p in self.pieces), max(p[1] for p in self.pieces)


def _wavelet_from_children(
    lo: Fraction, cut: Fraction, hi: Fraction, a: Fraction, b: Fraction, L: Fraction
) -> HaarWavelet:
    """Zero-mean, unit-norm wavelet on ``[lo, hi]`` split at ``cut``.

    ``a = cut − lo`` (left child), ``b = hi − cut`` (right child) and
    ``L = a + b``.  Values are ``−√(b/(aL))`` on the left and ``√(a/(bL))``
    on the right; the global sign is conventional.
    """
    c_left = -sp.sqrt(sp.Rational(b) / (sp.Rational(a) * sp.Rational(L)))
    c_right = sp.sqrt(sp.Rational(a) / (sp.Rational(b) * sp.Rational(L)))
    return HaarWavelet(
        (
            (lo, cut, sp.simplify(c_left)),
            (cut, hi, sp.simplify(c_right)),
        )
    )


def tree_wavelets(n_max: int) -> list[HaarWavelet]:
    """All Haar wavelets of split nodes up to depth ``n_max``.

    A node at depth ``n`` splits when its right child (the digit-1 part) is
    non-empty and has positive length; at a split node the right child has
    length exactly ``α_n/π``.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    intervals: list[tuple[Fraction, Fraction, Fraction]] = [(Fraction(0), Fraction(1), Fraction(0))]
    wavelets: list[HaarWavelet] = []
    for n in range(n_max):
        a = alpha_scaled(n)
        nxt: list[tuple[Fraction, Fraction, Fraction]] = []
        for lo, hi, s in intervals:
            cut = s + a
            left_hi = min(hi, cut)
            right_lo = max(lo, cut)
            if lo < cut < hi:
                # split node: both children have positive length
                ca = cut - lo
                cb = hi - cut
                wavelets.append(_wavelet_from_children(lo, cut, hi, ca, cb, ca + cb))
            if lo < left_hi:
                nxt.append((lo, left_hi, s))
            if right_lo < hi:
                nxt.append((right_lo, hi, cut))
        intervals = nxt
    return wavelets


def reconstructed_wavelet(a: Fraction, b: Fraction) -> HaarWavelet:
    """The reconstruction's normalised wavelet on a node of child lengths ``a``, ``b``.

    Coordinates are local: the node is ``[0, a+b]`` with left child ``[0, a]``
    and right child ``[a, a+b]``.
    """
    a = Fraction(a)
    b = Fraction(b)
    if a <= 0 or b <= 0:
        raise ValueError("both child lengths must be positive")
    return _wavelet_from_children(Fraction(0), a, a + b, a, b, a + b)


def source_wavelet(a: Fraction, b: Fraction) -> HaarWavelet:
    """The source's displayed wavelet, with coefficients ``1/√b`` and ``−1/√a``.

    Source equation (5): the right child (digit 1, length ``b = α_n``) carries
    ``+1/√b`` and the left child (length ``a``) carries ``−1/√a``.
    """
    a = Fraction(a)
    b = Fraction(b)
    if a <= 0 or b <= 0:
        raise ValueError("both child lengths must be positive")
    return HaarWavelet(
        (
            (Fraction(0), a, sp.simplify(-1 / sp.sqrt(sp.Rational(a)))),
            (a, a + b, sp.simplify(1 / sp.sqrt(sp.Rational(b)))),
        )
    )


def haar_norm_sq(w: HaarWavelet) -> sp.Expr:
    """Squared norm ``∫_0^1 ψ² dt`` in π-normalised coordinates."""
    total = sp.Integer(0)
    for lo, hi, value in w.pieces:
        total += sp.Rational(hi - lo) * value**2
    return sp.simplify(total)


def haar_mean(w: HaarWavelet) -> sp.Expr:
    """Mean ``∫_0^1 ψ dt`` in π-normalised coordinates."""
    total = sp.Integer(0)
    for lo, hi, value in w.pieces:
        total += sp.Rational(hi - lo) * value
    return sp.simplify(total)


def _refine(
    w1: HaarWavelet, w2: HaarWavelet
) -> Iterable[tuple[Fraction, Fraction, sp.Expr, sp.Expr]]:
    """Yield pairwise-refined pieces ``(lo, hi, v1, v2)`` of two wavelets."""
    for lo1, hi1, v1 in w1.pieces:
        for lo2, hi2, v2 in w2.pieces:
            lo = max(lo1, lo2)
            hi = min(hi1, hi2)
            if lo < hi:
                yield lo, hi, v1, v2


def inner_product(w1: HaarWavelet, w2: HaarWavelet) -> sp.Expr:
    """Exact inner product ``∫_0^1 w1 w2 dt`` in π-normalised coordinates."""
    total = sp.Integer(0)
    for lo, hi, v1, v2 in _refine(w1, w2):
        total += sp.Rational(hi - lo) * v1 * v2
    return sp.simplify(total)
