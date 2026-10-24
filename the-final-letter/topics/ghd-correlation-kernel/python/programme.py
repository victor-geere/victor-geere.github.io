"""GHD correlation kernel — exact computation layer.

The archived GHD corpus defines the harmonic angles ``α n = π/(n+2)`` and
the centred step functions ``φ n(θ) = 1[θ ≥ α n] − θ/π``, then forms the
Gram matrix ``K(n,m) = ∫₀^π φ n φ m dθ``.  The source calls the result the
"correlation kernel" of the greedy harmonic decomposition.

This module computes that *step-model* kernel exactly with sympy.  It also
computes the *actual* greedy selection word, because the two differ: the
step model is not the correlation kernel of the real greedy recursion.
The distinction is the main open item of the reconstructed programme.

Everything is exact; no floating point is used except in explicit numerical
comparisons.  Indices are non-negative integers throughout.
"""

from __future__ import annotations

from typing import Sequence

import sympy as sp

PI = sp.pi


def _check_index(n: int) -> None:
    """Reject anything that is not a non-negative integer index."""
    if isinstance(n, bool) or not isinstance(n, int) or n < 0:
        raise ValueError(f"index must be a non-negative integer, got {n!r}")


def alpha(n: int) -> sp.Expr:
    """Harmonic angle ``α n = π/(n+2)``."""
    _check_index(n)
    return PI / (n + 2)


def alpha_scaled(n: int) -> sp.Rational:
    """The harmonic angle in units of ``π``: ``α n / π = 1/(n+2)``."""
    _check_index(n)
    return sp.Rational(1, n + 2)


def step_indicator(theta: sp.Expr, n: int) -> int:
    """The step-model indicator ``1[θ ≥ α n]`` (not the greedy digit)."""
    _check_index(n)
    delta = sp.simplify(theta - alpha(n))
    decision = delta.is_nonnegative
    if decision is None:
        decision = bool(sp.N(delta, 60) >= 0)
    return 1 if decision else 0


def model_phi(theta: sp.Expr, n: int) -> sp.Expr:
    """Centred step function ``φ n(θ) = 1[θ ≥ α n] − θ/π``."""
    return sp.Integer(step_indicator(theta, n)) - theta / PI


def greedy_digits(theta: sp.Expr, n_max: int) -> list[int]:
    """Run the *actual* greedy decomposition for indices ``0..n_max``.

    At step ``n`` the angle ``α n`` is selected when the residual
    ``θ − (accumulated angle)`` is at least ``α n``.  Returns the binary
    selection word ``δ 0 … δ n_max``.
    """
    _check_index(n_max)
    acc = sp.Integer(0)
    digits: list[int] = []
    for n in range(n_max + 1):
        residual = sp.simplify(theta - acc - alpha(n))
        decision = residual.is_nonnegative
        if decision is None:
            decision = bool(sp.N(residual, 60) >= 0)
        digits.append(1 if decision else 0)
        if decision:
            acc += alpha(n)
    return digits


def greedy_accumulated(theta: sp.Expr, n_max: int) -> sp.Expr:
    """Total angle selected by the actual greedy recursion up to ``n_max``."""
    digits = greedy_digits(theta, n_max)
    return sp.simplify(sum(alpha(n) for n, d in enumerate(digits) if d))


def K_diag(t: sp.Expr) -> sp.Expr:
    """Step-model diagonal kernel at threshold ``t``.

    ``K(t,t) = (t³ + (π − t)³) / (3π²)``.
    """
    return (t ** 3 + (PI - t) ** 3) / (3 * PI ** 2)


def K_diag_n(n: int) -> sp.Expr:
    """Source closed form at ``t = α n``: ``(π/3)(1 + (n+1)³)/(n+2)³``."""
    _check_index(n)
    return PI / 3 * (1 + (n + 1) ** 3) / (n + 2) ** 3


def K_off(n: int, m: int) -> sp.Expr:
    """Corrected exact step-model off-diagonal kernel.

    With ``a = 1/(n+2)`` and ``b = 1/(m+2)``,

        ``K(n,m) = π [ (a² + b²)/2 − max(a,b) + 1/3 ]``.

    The expression is symmetric in ``n, m`` and reduces to ``K_diag_n``
    when ``n = m``.
    """
    _check_index(n)
    _check_index(m)
    a = alpha_scaled(n)
    b = alpha_scaled(m)
    return sp.simplify(PI * ((a ** 2 + b ** 2) / 2 - max(a, b) + sp.Rational(1, 3)))


def K_off_source(n: int, m: int) -> sp.Expr:
    """The archived off-diagonal formula, transcribed verbatim.

    ``K = (π/6)[a³ + b³ − 2ab + 6a²b + 6ab²]`` with ``a = 1/(n+2)``,
    ``b = 1/(m+2)`` for ``n < m`` and the symmetric swap otherwise.
    """
    _check_index(n)
    _check_index(m)
    a = alpha_scaled(n)
    b = alpha_scaled(m)
    if a < b:
        a, b = b, a
    return sp.simplify(
        PI / 6 * (a ** 3 + b ** 3 - 2 * a * b + 6 * a ** 2 * b + 6 * a * b ** 2)
    )


def _step_phi_symbol(t: sp.Expr) -> sp.Expr:
    """Symbolic centred step function with threshold ``t``."""
    x = sp.Symbol("x", real=True)
    return sp.Piecewise((1 - x / PI, x >= t), (-x / PI, True))


def kernel_integral(n: int, m: int) -> sp.Expr:
    """Evaluate ``∫₀^π φ n(θ) φ m(θ) dθ`` exactly by splitting at the steps."""
    _check_index(n)
    _check_index(m)
    x = sp.Symbol("x", real=True)
    integrand = sp.simplify(_step_phi_symbol(alpha(n)) * _step_phi_symbol(alpha(m)))
    return sp.simplify(sp.integrate(integrand, (x, 0, PI)))


def scaled_kernel_matrix(size: int) -> sp.Matrix:
    """The finite Gram matrix ``K(n,m)/π`` for ``0 ≤ n,m < size``.

    Entries are exact rationals because every kernel entry is a rational
    multiple of ``π``.
    """
    _check_index(size)
    entries = [[sp.nsimplify(K_off(n, m) / PI) for m in range(size)] for n in range(size)]
    return sp.Matrix(entries)


def leading_principal_minors(size: int) -> list[sp.Rational]:
    """Exact leading principal minors of ``K(n,m)/π``; all should be ≥ 0."""
    matrix = scaled_kernel_matrix(size)
    return [sp.nsimplify(matrix[:k, :k].det()) for k in range(1, size + 1)]


def is_positive_semidefinite(size: int) -> bool:
    """Exact PSD test for the finite section via leading principal minors."""
    return all(minor >= 0 for minor in leading_principal_minors(size))


def true_kernel_matrix(size: int) -> sp.Matrix:
    """Exact kernel of the *actual* greedy recursion, in units of ``π``.

    The interval ``[0, π]`` is identified with ``[0, 1]`` in units of ``π``.
    Starting from one leaf with zero accumulated angle, each step splits a
    leaf at ``accum + 1/(k+2)``; after ``size`` steps every leaf carries a
    constant selection word.  The exact integral on a leaf
    ``[a, b] ⊂ [0, 1]`` is

        ``∫ₐᵇ (δ n − u)(δ m − u) du``,

    so the returned matrix ``K/π`` is rational.  The leaf count can grow
    exponentially, so this is intended for small ``size`` only.
    """
    _check_index(size)
    rational = sp.Rational
    leaves: list[tuple[sp.Rational, sp.Rational, sp.Rational, tuple[int, ...]]] = [
        (rational(0), rational(1), rational(0), ())
    ]
    for k in range(size):
        step = rational(1, k + 2)
        new_leaves = []
        for a, b, acc, word in leaves:
            threshold = acc + step
            if threshold <= a:
                new_leaves.append((a, b, acc + step, word + (1,)))
            elif threshold >= b:
                new_leaves.append((a, b, acc, word + (0,)))
            else:
                new_leaves.append((a, threshold, acc, word + (0,)))
                new_leaves.append((threshold, b, acc + step, word + (1,)))
        leaves = new_leaves
    matrix = sp.zeros(size)
    for a, b, _acc, word in leaves:
        for n in range(size):
            dn = word[n]
            for m in range(n, size):
                dm = word[m]
                matrix[n, m] += (
                    dn * dm * (b - a)
                    - (dn + dm) * (b ** 2 - a ** 2) / 2
                    + (b ** 3 - a ** 3) / 3
                )
    for n in range(size):
        for m in range(n):
            matrix[n, m] = matrix[m, n]
    return matrix


def diagonal_trace(n_max: int) -> sp.Expr:
    """Exact finite trace ``∑_{n=0}^{n_max} K(n,n)`` of the step model."""
    _check_index(n_max)
    return sp.simplify(sum(K_diag_n(n) for n in range(n_max + 1)))


def selection_word_report(theta: sp.Expr, n_max: int) -> dict[str, Sequence]:
    """Small diagnostic: step-model bits and actual greedy bits side by side."""
    step = [step_indicator(theta, n) for n in range(n_max + 1)]
    greedy = greedy_digits(theta, n_max)
    return {"step": step, "greedy": greedy}
