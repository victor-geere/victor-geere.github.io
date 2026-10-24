"""Greedy-harmonic Hilbert–Pólya — exact computation layer.

The archived programme defines two families of local quadratic factors,
`Q₀` and `Qₙ`, whose roots are the Galerkin eigenvalues `λₙ,±`.  This
module treats those quadratics as exact sympy objects and checks the
algebra that the source's trace formula relies on: discriminants, roots,
Vieta identities, and the finite trace/determinant bookkeeping.

Nothing here asserts the analytic parts of the programme (the transfer
operator, the Fredholm determinant identity, self-adjointness of `H`, or
the Mellin bijectivity).  Those remain source claims or open items.
"""

from __future__ import annotations

from typing import Tuple

import sympy as sp

PI = sp.pi


def _check_index(n: int, *, minimum: int = 0) -> None:
    if not isinstance(n, int):
        raise TypeError("n must be an integer")
    if n < minimum:
        raise ValueError(f"n must be at least {minimum}")


def q0(s: sp.Expr) -> sp.Expr:
    """The base local quadratic `Q₀(s) = s² − (3/2)s + 1/4`."""
    return s**2 - sp.Rational(3, 2) * s + sp.Rational(1, 4)


def q_n(n: int, s: sp.Expr) -> sp.Expr:
    """The local quadratic `Qₙ(s)` for `n ≥ 1`.

    `Qₙ(s) = s² − (2n+3)/(n+2) s + (2n+3)/((n+1)(n+2)²)`.
    """
    _check_index(n, minimum=1)
    return (
        s**2
        - sp.Rational(2 * n + 3, n + 2) * s
        + sp.Rational(2 * n + 3, (n + 1) * (n + 2) ** 2)
    )


def disc0() -> sp.Rational:
    """The discriminant of `Q₀`: `(3/2)² − 4·(1/4) = 5/4`."""
    return sp.Rational(5, 4)


def discriminant(n: int) -> sp.Expr:
    """The discriminant `b² − 4c` of `Qₙ` from its coefficients, `n ≥ 1`."""
    _check_index(n, minimum=1)
    b = sp.Rational(2 * n + 3, n + 2)
    c = sp.Rational(2 * n + 3, (n + 1) * (n + 2) ** 2)
    return sp.simplify(b**2 - 4 * c)


def discriminant_closed_form(n: int) -> sp.Expr:
    """The source's closed form for the discriminant, `n ≥ 1`."""
    _check_index(n, minimum=1)
    return sp.Rational(2 * n + 3, 1) * (2 * n * n + 5 * n - 1) / (
        (n + 1) * (n + 2) ** 2
    )


def roots0() -> Tuple[sp.Expr, sp.Expr]:
    """The two roots `(3 ∓ √5)/4` of `Q₀`, returned as `(λ₋, λ₊)`."""
    return ((3 - sp.sqrt(5)) / 4, (3 + sp.sqrt(5)) / 4)


def roots_n(n: int) -> Tuple[sp.Expr, sp.Expr]:
    """The closed-form roots `(λₙ,₋, λₙ,₊)` of `Qₙ` for `n ≥ 1`."""
    _check_index(n, minimum=1)
    d = sp.sqrt(sp.Rational(2 * n + 3, 1) * (2 * n * n + 5 * n - 1) / (n + 1))
    a = 2 * n + 3
    b = 2 * (n + 2)
    return ((a - d) / b, (a + d) / b)


def vieta_sum(n: int) -> sp.Rational:
    """Sum of the two roots of `Qₙ`: the trace of the `2 × 2` block."""
    _check_index(n, minimum=0)
    if n == 0:
        return sp.Rational(3, 2)
    return sp.Rational(2 * n + 3, n + 2)


def vieta_product(n: int) -> sp.Rational:
    """Product of the two roots of `Qₙ`: the determinant of the block."""
    _check_index(n, minimum=0)
    if n == 0:
        return sp.Rational(1, 4)
    return sp.Rational(2 * n + 3, (n + 1) * (n + 2) ** 2)


def block_trace(n: int) -> sp.Rational:
    """Trace of the `n`-th Galerkin block, i.e. `λₙ,₋ + λₙ,₊`."""
    return vieta_sum(n)


def partial_trace(n_blocks: int) -> sp.Expr:
    """Exact trace of the first `n_blocks` Galerkin blocks."""
    _check_index(n_blocks, minimum=0)
    return sp.simplify(sum(block_trace(n) for n in range(n_blocks)))


def partial_trace_closed_form(n_blocks: int) -> sp.Expr:
    """Closed form `2N + 1 − H_{N+1}` for the partial trace."""
    _check_index(n_blocks, minimum=0)
    return sp.Integer(2 * n_blocks + 1) - sp.harmonic(n_blocks + 1)


def block_constant(n: int) -> sp.Rational:
    """The constant (determinant) term of `Qₙ`, i.e. `λₙ,₋ · λₙ,₊`."""
    return vieta_product(n)


def partial_determinant(n_blocks: int) -> sp.Expr:
    """Product of the constant terms of the first `n_blocks` blocks."""
    _check_index(n_blocks, minimum=0)
    return sp.simplify(sp.prod([block_constant(n) for n in range(n_blocks)]))


def partial_determinant_closed_form(n_blocks: int) -> sp.Expr:
    """Closed form `(2N+1)! / (3 · 2^N · (N!)² · ((N+1)!)²)`."""
    _check_index(n_blocks, minimum=0)
    if n_blocks == 0:
        return sp.Integer(1)
    N = n_blocks
    return sp.factorial(2 * N + 1) / (
        3 * 2**N * sp.factorial(N) ** 2 * sp.factorial(N + 1) ** 2
    )


def eigenvalue_ordering_holds(n_max: int, tol: float = 1e-12) -> bool:
    """Check `0 < λₙ,₋ < 1 < λₙ,₊` numerically for `0 ≤ n ≤ n_max`.

    The source asserts the ordering for every `n`; this is a finite
    high-precision check, not a proof for all `n`.
    """
    _check_index(n_max, minimum=0)
    low, high = roots0()
    # Base block: 0 < λ₀,₋ < 1 < λ₀,₊.
    if not (
        sp.N(low, 40) > -tol
        and sp.N(low, 40) < 1
        and sp.N(high, 40) > 1
    ):
        return False
    for n in range(1, n_max + 1):
        lm, lp = roots_n(n)
        if not (
            sp.N(lm, 40) > -tol
            and sp.N(lm, 40) < 1
            and sp.N(lp, 40) > 1
        ):
            return False
    return True
