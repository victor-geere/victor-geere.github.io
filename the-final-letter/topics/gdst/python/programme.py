"""Greedy Dirichlet Sub-Sum Transform — exact finite computation layer.

This module reconstructs the finite part of the GDST source
(``archive/maths/rh/research/gdst/rh-proof/proof.html``, Parts I and III):
the greedy harmonic recursion on ``[0, 1]`` with fractions
``alpha_n = 1/(n+2)``, the finite partial-sum identity, the remainder
bounds, and the selected/rejected split of a truncated Dirichlet series.

Everything is exact: inputs are converted to ``sympy`` rationals and all
comparisons are decided symbolically.  The archived global RH claim and
the operator-theoretic axioms are deliberately *not* implemented here;
they are recorded as source claims in the programme dossier.
"""

from __future__ import annotations

from typing import Sequence

import sympy as sp

PI = sp.pi
HALF = sp.Rational(1, 2)


def _check_index(n: int, name: str = "n") -> None:
    if not isinstance(n, int) or n < 0:
        raise ValueError(f"{name} must be a non-negative integer")


def alpha(n: int) -> sp.Rational:
    """The greedy harmonic fraction ``alpha_n = 1/(n+2)``."""
    _check_index(n)
    return sp.Rational(1, n + 2)


def greedy_trajectory(x: sp.Expr | int | sp.Rational, n_max: int) -> tuple[list[int], list[sp.Expr]]:
    """Return the digits and remainders for indices ``0 .. n_max``.

    ``digits[k] = delta_k(x)`` and ``remainders[k] = r_k(x)``, following
    the mutual recursion of the source.  All comparisons are exact.
    """
    _check_index(n_max, "n_max")
    x = sp.sympify(x)
    d = 1 if x >= HALF else 0
    r = sp.simplify(x - sp.Rational(d, 2))
    digits = [d]
    remainders = [r]
    for n in range(n_max):
        threshold = sp.Rational(1, n + 3)  # alpha_{n+1}
        d = 1 if r >= threshold else 0
        r = sp.simplify(r - sp.Rational(d, n + 3))
        digits.append(d)
        remainders.append(r)
    return digits, remainders


def greedy_digits(x: sp.Expr | int | sp.Rational, n_max: int) -> list[int]:
    """The greedy digit word ``delta_0(x) .. delta_{n_max}(x)``."""
    return greedy_trajectory(x, n_max)[0]


def greedy_remainders(x: sp.Expr | int | sp.Rational, n_max: int) -> list[sp.Expr]:
    """The greedy remainders ``r_0(x) .. r_{n_max}(x)``."""
    return greedy_trajectory(x, n_max)[1]


def partial_sum(x: sp.Expr | int | sp.Rational, n_max: int) -> sp.Expr:
    """The finite selected sum ``sum_{k<=n_max} delta_k(x)/(k+2)``."""
    digits = greedy_digits(x, n_max)
    return sp.simplify(sum(sp.Rational(d, k + 2) for k, d in enumerate(digits)))


def finite_identity_residual(x: sp.Expr | int | sp.Rational, n_max: int) -> sp.Expr:
    """The exact residual ``x - partial_sum(x, n_max) - r_{n_max}(x)``.

    The source's finite partial-sum identity says this is zero.
    """
    _, remainders = greedy_trajectory(x, n_max)
    return sp.simplify(sp.sympify(x) - partial_sum(x, n_max) - remainders[-1])


def selected_weight(x: sp.Expr | int | sp.Rational, s: sp.Expr | int, n_max: int) -> sp.Expr:
    """The finite selected series ``E_N(x,s) = sum_{delta_k=1} (k+2)^(-s)``."""
    digits = greedy_digits(x, n_max)
    return sp.simplify(
        sum((sp.Integer(k + 2)) ** (-sp.sympify(s)) for k, d in enumerate(digits) if d == 1)
    )


def rejected_weight(x: sp.Expr | int | sp.Rational, s: sp.Expr | int, n_max: int) -> sp.Expr:
    """The finite rejected series ``Omega_N(x,s) = sum_{delta_k=0} (k+2)^(-s)``."""
    digits = greedy_digits(x, n_max)
    return sp.simplify(
        sum((sp.Integer(k + 2)) ** (-sp.sympify(s)) for k, d in enumerate(digits) if d == 0)
    )


def dirichlet_prefix(s: sp.Expr | int, n_max: int) -> sp.Expr:
    """The truncated Dirichlet prefix ``sum_{k=0}^{N} (k+2)^(-s)``."""
    _check_index(n_max, "n_max")
    return sp.simplify(
        sum((sp.Integer(k + 2)) ** (-sp.sympify(s)) for k in range(n_max + 1))
    )


def remainder_bound_holds(x: sp.Expr | int | sp.Rational, n_max: int) -> bool:
    """Check ``0 <= r_{n_max}(x) <= 1/(n_max+2)`` exactly."""
    _, remainders = greedy_trajectory(x, n_max)
    r = remainders[-1]
    return bool(r >= 0 and r <= alpha(n_max))


def post_selection_bound_holds(x: sp.Expr | int | sp.Rational, n: int) -> bool:
    """Check the quadratic post-selection bound after a selection at ``n+1``.

    Returns ``True`` when no selection is made (the implication is vacuous).
    """
    digits, remainders = greedy_trajectory(x, n + 1)
    if digits[n + 1] != 1:
        return True
    bound = sp.Rational(1, (n + 2) * (n + 3))
    return bool(remainders[n + 1] <= bound)


def ax5_diagonal(n: int) -> sp.Expr:
    """The **retracted** AX5 diagonal formula ``pi/12 * (1 - 3/(n+2))``.

    The source explicitly retracts this formula because it is negative at
    ``n = 0``; it is kept here only as a documented counterexample.
    """
    _check_index(n)
    return PI / 12 * (1 - sp.Rational(3, n + 2))


def K00_integral() -> sp.Expr:
    """The exact diagonal kernel value ``K(0,0) = integral_0^pi f_0^2``.

    Here ``f_0(theta) = delta_0(theta) - theta/pi`` and
    ``delta_0(theta) = 1`` for ``theta >= pi/2``.
    """
    t = sp.symbols("t", real=True)
    left = sp.integrate((t / PI) ** 2, (t, 0, PI / 2))
    right = sp.integrate((1 - t / PI) ** 2, (t, PI / 2, PI))
    return sp.simplify(left + right)


def non_monotone_counterexample() -> tuple[int, int]:
    """The source's non-monotonicity witness for ``delta_1``.

    Returns ``(delta_1(2/5), delta_1(3/5))``; the source states the pair
    ``(1, 0)``, contradicting monotonicity of ``delta_1``.
    """
    return greedy_digits(sp.Rational(2, 5), 1)[1], greedy_digits(sp.Rational(3, 5), 1)[1]


def digit_word(x: sp.Expr | int | sp.Rational, n_max: int) -> Sequence[int]:
    """Alias returning the finite digit word (kept for readability in tests)."""
    return greedy_digits(x, n_max)
