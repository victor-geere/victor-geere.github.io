"""Greedy harmonic transfer operator — exact computation layer.

The archived source directory for this topic is empty.  The objects below
are therefore an explicit *reconstruction*, not a recovery of a source
definition:

* ``weight(n) = 1/(n+2)`` is the normalised greedy harmonic angle
  ``α_n / π`` with ``α_n = π/(n+2)``;
* ``transfer`` is the weighted shift ``(T a)_n = weight(n) * a_{n+1}``;
* ``transfer_iterate`` is its ``k``-fold iterate;
* ``remainder`` is the normalised greedy remainder after one step;
* ``total_weight`` is the finite transferred mass ``Σ_{n<N} weight(n)``.

The weights, transfer steps, iterates, and total mass are exact sympy
rationals.  ``selects`` uses an exact sign test and falls back to a
60-digit numerical evaluation only when sympy cannot decide the sign.
The module has no import-time side effects.
"""

from __future__ import annotations

from typing import Sequence

import sympy as sp


def _nonnegative_int(n: int, name: str = "n") -> int:
    if not isinstance(n, int) or n < 0:
        raise ValueError(f"{name} must be a non-negative integer")
    return n


def weight(n: int) -> sp.Rational:
    """Return the exact normalised harmonic weight ``1 / (n + 2)``."""
    _nonnegative_int(n)
    return sp.Rational(1, n + 2)


def transfer(seq: Sequence[sp.Expr], n: int) -> sp.Expr:
    """Return ``(T a)_n = weight(n) * a_{n+1}`` for a finite sequence."""
    _nonnegative_int(n)
    if n + 1 >= len(seq):
        raise IndexError("transfer index exceeds the available sequence")
    return weight(n) * sp.sympify(seq[n + 1])


def transfer_sequence(seq: Sequence[sp.Expr]) -> list[sp.Expr]:
    """Apply one transfer step to a finite sequence.

    The result has length ``max(len(seq) - 1, 0)``.  An empty or
    one-element sequence has no outgoing weight and yields ``[]``.
    """
    return [transfer(seq, n) for n in range(max(len(seq) - 1, 0))]


def transfer_iterate(
    seq: Sequence[sp.Expr], k: int
) -> list[sp.Expr]:
    """Apply the transfer operator ``k`` times."""
    _nonnegative_int(k, "k")
    out = [sp.sympify(x) for x in seq]
    for _ in range(k):
        out = transfer_sequence(out)
    return out


def remainder(theta: sp.Expr, n: int) -> sp.Expr:
    """Return the normalised greedy remainder ``θ - weight(n)``."""
    _nonnegative_int(n)
    return sp.simplify(sp.sympify(theta) - weight(n))


def selects(theta: sp.Expr, n: int) -> bool:
    """Whether the greedy step at index ``n`` is taken.

    The step is taken exactly when ``weight(n) <= θ``; equality counts as
    a selection.  Exact sympy comparison is used, with a high-precision
    fallback only if the sign cannot be decided symbolically.
    """
    _nonnegative_int(n)
    difference = sp.simplify(sp.sympify(theta) - weight(n))
    sign = difference.is_nonnegative
    if sign is None:
        return bool(sp.N(difference, 60) >= 0)
    return bool(sign)


def total_weight(n_max: int) -> sp.Expr:
    """Return the exact finite transferred mass ``Σ_{n=0}^{N-1} weight(n)``.

    The closed form is the harmonic-number identity
    ``total_weight(N) = H_{N+1} - 1``.
    """
    _nonnegative_int(n_max)
    return sp.simplify(sum((weight(n) for n in range(n_max)), sp.Integer(0)))


def total_weight_closed_form(n_max: int) -> sp.Expr:
    """Return ``H_{N+1} - 1``, the harmonic closed form of the total mass."""
    _nonnegative_int(n_max)
    return sp.simplify(sp.harmonic(n_max + 1) - 1)
