"""GDST twin series — exact finite computation layer.

The archived GDST programme splits the shifted zeta prefix into a selected
series `E(θ,s)` and a rejected series `Ω(θ,s)` using the greedy harmonic
digits `δ_n(θ)`.  The source's analytic statements concern the infinite
series.  This module implements only the finite prefixes

    E_N(θ,s) = Σ_{n<N, δ_n(θ)=1} (n+2)^(-s)
    Ω_N(θ,s) = Σ_{n<N, δ_n(θ)=0} (n+2)^(-s)
    H_N(s)    = Σ_{n<N} (n+2)^(-s)

and checks the finite complement identity `E_N + Ω_N = H_N` exactly with
sympy.  No infinite limit, zero of zeta, or RH statement is computed here.
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi


def alpha(n: int) -> sp.Expr:
    """The greedy harmonic fraction `α_n = π / (n + 2)`."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return PI / (n + 2)


def greedy_digits(theta: sp.Expr, n_max: int) -> list[int]:
    """Greedy selection word `δ_0 … δ_{n_max}` for `θ ∈ [0, π]`.

    At index `n` the fraction `α_n` is selected when the residual is at
    least `α_n`.  The comparison is exact when sympy can decide it and
    otherwise falls back to a 60-digit evaluation.
    """
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    acc = sp.Integer(0)
    digits: list[int] = []
    for n in range(n_max + 1):
        residual = sp.simplify(theta - acc - alpha(n))
        take = residual.is_nonnegative
        if take is None:
            take = bool(sp.N(residual, 60) >= 0)
        digits.append(1 if take else 0)
        if take:
            acc += alpha(n)
    return digits


def term(n: int, s: sp.Expr) -> sp.Expr:
    """The Dirichlet weight `(n + 2)^(-s)`."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return sp.Pow(n + 2, -s)


def partial_zeta(s: sp.Expr, n_max: int) -> sp.Expr:
    """The full shifted prefix `H_N(s) = Σ_{n=0}^{N} (n+2)^(-s)`."""
    if n_max < 0:
        raise ValueError("n_max must be non-negative")
    return sp.simplify(sum((term(n, s) for n in range(n_max + 1)), sp.Integer(0)))


def selected_sum(theta: sp.Expr, s: sp.Expr, n_max: int) -> sp.Expr:
    """The selected prefix `E_N(θ,s)` over indices `0 … n_max`."""
    digits = greedy_digits(theta, n_max)
    return sp.simplify(
        sum((term(n, s) for n, d in enumerate(digits) if d), sp.Integer(0))
    )


def rejected_sum(theta: sp.Expr, s: sp.Expr, n_max: int) -> sp.Expr:
    """The rejected prefix `Ω_N(θ,s)` over indices `0 … n_max`."""
    digits = greedy_digits(theta, n_max)
    return sp.simplify(
        sum((term(n, s) for n, d in enumerate(digits) if not d), sp.Integer(0))
    )


def complement_residual(theta: sp.Expr, s: sp.Expr, n_max: int) -> sp.Expr:
    """The exact residual `E_N + Ω_N - H_N`; it must simplify to zero."""
    return sp.simplify(
        selected_sum(theta, s, n_max)
        + rejected_sum(theta, s, n_max)
        - partial_zeta(s, n_max)
    )


def count_selected(theta: sp.Expr, n_max: int) -> int:
    """The number of selected indices among `0 … n_max`."""
    return sum(greedy_digits(theta, n_max))


def selected_fraction(theta: sp.Expr, n_max: int) -> sp.Rational:
    """The exact selected fraction `D(N) / (N + 1)` for the finite word."""
    return sp.Rational(count_selected(theta, n_max), n_max + 1)
