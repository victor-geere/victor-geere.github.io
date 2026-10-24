"""Dyadic sheaf cohomology — exact computation layer.

The archived source (`archive/essays/rh/dyadic-sheaf.html` and its two
companions) is a speculative sketch.  It defines, concretely:

* the dyadic filtration with radii ``2^{-k}`` and boxes
  ``{2^{-k} <= |x| < 2^{-k+1}}``;
* the alignment energy
  ``E(x; t) = (1 - cos(2*pi*t/x))^2 + (1 - cos(2*pi*x))^2``;
* the divisor-detection identity
  ``cos(2*pi*p/x) + cos(2*pi*x) - 2 = 0  iff  x | p``.

This module implements exactly those finite objects with sympy.  It also
keeps the rank bookkeeping of a finite two-term complex as a *toy model*
for the ``H^0``/``H^1`` dimension count of the conjectural sheaf complex;
it is not the sheaf cohomology of the source, which is undefined.

Nothing here proves the Riemann hypothesis.  The cohomological bridge is
open (see the theme README).
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi


def dyadic_radius(k: int) -> sp.Rational:
    """The dyadic ball radius ``2^{-k}`` (``k >= 0``)."""
    if k < 0:
        raise ValueError("dyadic radius index must be non-negative")
    return sp.Rational(1, 2) ** k


def dyadic_shell(k: int) -> tuple[sp.Rational, sp.Rational]:
    """The source's dyadic box ``[2^{-k}, 2^{-k+1})`` as exact rationals.

    ``k`` may be any integer; the box always has positive length
    ``2^{-k}``.
    """
    lower = sp.Rational(2) ** (-k)
    upper = sp.Rational(2) ** (-k + 1)
    if not lower < upper:
        raise AssertionError("dyadic shell must have positive length")
    return lower, upper


def dyadic_shell_index(x: sp.Expr) -> int:
    """The unique ``k`` with ``2^{-k} <= x < 2^{-k+1}``.

    Exact for positive rationals; raises ``ValueError`` for ``x <= 0``.
    """
    x = sp.Rational(x)
    if x <= 0:
        raise ValueError("dyadic shell index requires x > 0")
    y = x
    k = 0
    while y >= 2:
        y /= 2
        k -= 1
    while y < 1:
        y *= 2
        k += 1
    return k


def energy(t: sp.Expr, x: sp.Expr) -> sp.Expr:
    """The source alignment energy ``E(x; t)``."""
    return (1 - sp.cos(2 * PI * t / x)) ** 2 + (1 - sp.cos(2 * PI * x)) ** 2


def energy_zero(t: sp.Expr, x: sp.Expr) -> bool:
    """Exact decision of ``E(x; t) = 0`` by symbolic simplification."""
    return sp.simplify(energy(t, x)) == 0


def divisor_detection(p: int, x: int) -> bool:
    """The source's criterion ``E(p; x) = 0  iff  x | p`` (``x >= 1``)."""
    if x < 1:
        raise ValueError("divisor detection requires x >= 1")
    return energy_zero(sp.Integer(p), sp.Integer(x))


def dyadic_difference_matrix(n: int) -> sp.Matrix:
    """The finite dyadic difference complex ``C^0 -> C^1`` on scales 0..n.

    ``C^0`` has basis the dyadic scales ``2^{-0}, ..., 2^{-n}``;
    ``C^1`` has basis the ``n`` edges between consecutive scales;
    ``(D f)_j = f_{j+1} - f_j``.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    D = sp.zeros(n, n + 1)
    for j in range(n):
        D[j, j] = -1
        D[j, j + 1] = 1
    return D


def cohomology_dimensions(n: int) -> dict[str, int]:
    """Dimensions of ``H^0 = ker d`` and ``H^1 = coker d`` for the toy complex.

    Returns ``{"C0", "C1", "rank", "H0", "H1", "euler"}``.  This is the
    finite rank bookkeeping of the two-term complex, *not* a computation
    of the conjectural dyadic sheaf cohomology.
    """
    D = dyadic_difference_matrix(n)
    rank = D.rank()
    c0 = n + 1
    c1 = n
    h0 = c0 - rank
    h1 = c1 - rank
    return {"C0": c0, "C1": c1, "rank": rank, "H0": h0, "H1": h1, "euler": h0 - h1}
