"""Gap inventory and strengthening list — exact computation layer.

The archived source (`gaps.html`) is a checklist.  Its one complete
elementary identity is the *last-chord identity* used in the section
"The remaining gap, collapsed":

    H_N(s) = ((1 - N) / 2) * N ** (-2 s)
    H_N(s) * H_N(1 - s) = (N - 1) ** 2 / (4 N ** 2)  ->  1 / 4.

This module works with the identity exactly in sympy.  It also exposes
the scale factors `N ** (-2 delta)` and `N ** (2 delta)` whose product is
one; those model the north/south pole split at `s = 1/2 + delta`.  No
zero of `zeta` is computed or asserted here.
"""

from __future__ import annotations

import sympy as sp

S = sp.symbols("s", real=True)
DELTA = sp.symbols("delta", positive=True)


def _check_scale(N: int) -> None:
    if not isinstance(N, int) or N < 1:
        raise ValueError("N must be a positive integer")


def chord(N: int, s: sp.Expr = S) -> sp.Expr:
    """The last chord ``H_N(s) = ((1 - N)/2) * N**(-2s)``."""
    _check_scale(N)
    return sp.simplify(sp.Rational(1 - N, 2) * N ** (-2 * s))


def chord_closed(N: int) -> sp.Rational:
    """The closed form ``(N - 1)**2 / (4 N**2)`` of the chord product."""
    _check_scale(N)
    return sp.Rational((N - 1) ** 2, 4 * N**2)


def chord_product(N: int, s: sp.Expr = S) -> sp.Expr:
    """The symbolic product ``H_N(s) * H_N(1 - s)``."""
    _check_scale(N)
    return sp.simplify(chord(N, s) * chord(N, 1 - s))


def chord_product_limit() -> sp.Expr:
    """The limit of the chord product as ``N -> oo``; equals ``1/4``."""
    N = sp.symbols("N", positive=True, integer=True)
    return sp.limit(sp.Rational(1, 4) - 1 / (2 * N) + 1 / (4 * N**2), N, sp.oo)


def north(N: int, delta: sp.Expr = DELTA) -> sp.Expr:
    """North-pole scale factor ``N ** (-2 delta)``."""
    _check_scale(N)
    return N ** (-2 * delta)


def south(N: int, delta: sp.Expr = DELTA) -> sp.Expr:
    """South-pole scale factor ``N ** (2 delta)``."""
    _check_scale(N)
    return N ** (2 * delta)


def pole_ratio(N: int, delta: sp.Expr = DELTA) -> sp.Expr:
    """The ratio ``H_N(1/2 + delta) / H_N(1/2 - delta) = N ** (-4 delta)``."""
    _check_scale(N)
    return sp.simplify(chord(N, sp.Rational(1, 2) + delta) / chord(N, sp.Rational(1, 2) - delta))


def product_sequence(n_max: int) -> list[sp.Rational]:
    """The chord products for ``N = 2 .. n_max`` (both inclusive)."""
    if n_max < 2:
        raise ValueError("n_max must be at least 2")
    return [chord_closed(N) for N in range(2, n_max + 1)]
