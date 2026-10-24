"""Harmonic sine / greedy harmonic essays — exact computation layer.

The archived essay `archive/essays/harmonic-sine-rh-proof.html` defines the
harmonic angles `α_n = π/(n+2)`, a greedy selection rule, and a sine/cosine
fusion step.  The essay's Riemann-hypothesis claim is retracted in its own
header and is *not* part of this module.

All finite computations are done exactly over `ℚ` by measuring the target
angle in units of `π`.  A target `x ∈ [0, 1]` means `θ = π x`.  The exact
layer never rounds a selection decision; `mpmath` is used only for the
high-precision sine reconstruction (and that test states its tolerance).
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi


# ---------------------------------------------------------------------------
# Harmonic angles
# ---------------------------------------------------------------------------

def alpha(n: int) -> sp.Expr:
    """The harmonic angle `α_n = π / (n + 2)` (Definition 2.1)."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return PI / (n + 2)


def alpha_scaled(n: int) -> sp.Rational:
    """The angle in units of `π`: `1 / (n + 2)`."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.Rational(1, n + 2)


def harmonic_sum_scaled(n_max: int) -> sp.Rational:
    """Exact `∑_{n=0}^{n_max} 1/(n+2) = H_{n_max+2} - 1`.

    This is the identity recorded in Definition 2.1.  The sum is formed
    term by term so that it is independent of sympy's `harmonic`.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return sum((sp.Rational(1, n + 2) for n in range(n_max + 1)), sp.Integer(0))


def harmonic_sum(n_max: int) -> sp.Expr:
    """`∑_{n=0}^{n_max} α_n = π (H_{n_max+2} - 1)`."""
    return PI * harmonic_sum_scaled(n_max)


# ---------------------------------------------------------------------------
# Greedy selection (Definition 2.2)
# ---------------------------------------------------------------------------

def _as_target(x: sp.Expr) -> sp.Rational:
    """Coerce a target in `π` units to an exact rational, with bounds check."""
    x = sp.Rational(x)
    if not (0 <= x <= 1):
        raise ValueError("target x must satisfy 0 <= x <= 1 (θ = π x)")
    return x


def greedy_word(x: sp.Expr, n_max: int) -> list[int]:
    """The selection word `δ_0 … δ_{n_max}` for target `θ = π x`.

    `δ_n = 1` exactly when the residual `θ - θ_n` is at least `α_n`
    (the source's step function `Θ` is non-strict at zero).  The target is
    kept as an exact rational, so no comparison rounds.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    x = _as_target(x)
    acc = sp.Integer(0)
    word: list[int] = []
    for n in range(n_max + 1):
        a = sp.Rational(1, n + 2)
        take = bool(x - acc >= a)
        word.append(1 if take else 0)
        if take:
            acc += a
    return word


def greedy_accumulated(x: sp.Expr, n_max: int) -> sp.Rational:
    """The accumulated angle `θ_{n_max+1}` in units of `π`."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    x = _as_target(x)
    acc = sp.Integer(0)
    for n, d in enumerate(greedy_word(x, n_max)):
        if d:
            acc += sp.Rational(1, n + 2)
    return acc


def residual(x: sp.Expr, n_steps: int) -> sp.Rational:
    """The residual `(θ - θ_N)/π` after `N = n_steps` processed indices."""
    if n_steps < 0:
        raise ValueError("n_steps must be non-negative")
    x = _as_target(x)
    return x - greedy_accumulated(x, n_steps - 1) if n_steps > 0 else x


def residual_bound(x: sp.Expr, n_steps: int) -> bool:
    """The correct finite residual bound `0 ≤ r_N/π ≤ 1/(N+1)`.

    The source states `0 ≤ r_N ≤ π/(N+2)`; that is one index too strong
    (see `source_residual_bound` and the erratum in the README).
    """
    if n_steps < 0:
        raise ValueError("n_steps must be non-negative")
    r = residual(x, n_steps)
    return bool(0 <= r <= sp.Rational(1, n_steps + 1))


def source_residual_bound(x: sp.Expr, n_steps: int) -> bool:
    """The bound as stated by the source: `0 ≤ r_N/π ≤ 1/(N+2)`."""
    if n_steps < 0:
        raise ValueError("n_steps must be non-negative")
    r = residual(x, n_steps)
    return bool(0 <= r <= sp.Rational(1, n_steps + 2))


# ---------------------------------------------------------------------------
# Fusion step
# ---------------------------------------------------------------------------

def fusion_step(s: sp.Expr, c: sp.Expr, a: sp.Expr) -> tuple[sp.Expr, sp.Expr]:
    """Rotate `(s, c)` by `a`: the source's sine/cosine fusion rule.

    `(s, c) ↦ (s cos a + c sin a, c cos a − s sin a)`.
    """
    return (s * sp.cos(a) + c * sp.sin(a), c * sp.cos(a) - s * sp.sin(a))


def reconstruct_sine(x: sp.Expr, n_max: int, dps: int = 50):
    """Reconstruct `sin(π x)` by applying the exact greedy word, at `dps` digits.

    Selection is decided exactly by `greedy_word`; only the final rotation
    arithmetic is numerical.  Returns an `mpmath.mpf`.
    """
    import mpmath as mp

    x = _as_target(x)
    word = greedy_word(x, n_max)
    mp.mp.dps = dps
    theta = mp.pi * mp.mpf(x.p) / mp.mpf(x.q)
    s, c = mp.mpf(0), mp.mpf(1)
    for n, d in enumerate(word):
        if d:
            a = mp.pi / (n + 2)
            s, c = s * mp.cos(a) + c * mp.sin(a), c * mp.cos(a) - s * mp.sin(a)
    return s


# ---------------------------------------------------------------------------
# The claimed zeta bridge (Proposition 4.4)
# ---------------------------------------------------------------------------

def subsum(x: sp.Expr, s: sp.Expr, n_max: int) -> sp.Expr:
    """`Φ(s, θ) = ∑_n δ_n(θ) (n+2)^{-s}` truncated at `n_max`."""
    word = greedy_word(x, n_max)
    return sp.simplify(
        sum((sp.Pow(n + 2, -s) for n, d in enumerate(word) if d), sp.Integer(0))
    )
