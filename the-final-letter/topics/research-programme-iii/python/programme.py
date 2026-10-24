"""Research Programme III — exact computation layer.

The module implements the objects that the archived proposal actually
defines:

* the quantum dimensions ``d_{j,k}`` of ``SU(2)_k``;
* the total quantum dimension squared ``D_k^2`` in the proposal's
  normalisation;
* the Egyptian denominators ``m_{j,k} = D_k^2 / d_{j,k}^2``;
* finite categorical Dirichlet polynomials ``Psi_k(s)`` with arbitrary
  supplied signs ``chi_{j,k} in {+1,-1}``.

The proposal does **not** give an explicit formula for the Galois signs
``chi_{j,k}``; callers must supply them.  The default all-ones pattern is
only a bookkeeping device, not a claim about the modular tensor category.
No limit to ``zeta`` is asserted by this module.

Everything is exact sympy algebra.  The one asymptotic check uses sympy's
arbitrary-precision evaluation and states its tolerance in the test.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import sympy as sp

PI = sp.pi


def level_size(k: int) -> int:
    """Return ``N = k + 2`` for a level ``k >= 1``."""
    if not isinstance(k, int) or isinstance(k, bool):
        raise TypeError("level k must be an int")
    if k < 1:
        raise ValueError("level k must be at least 1")
    return k + 2


def object_indices(k: int) -> list[int]:
    """Return the labels ``n = 2j + 1`` of the simple objects.

    For ``SU(2)_k`` the spins are ``j = 0, 1/2, ..., k/2``, so ``n`` runs
    through ``1, 2, ..., k+1 = N-1``.  Note that ``n`` is *not* restricted
    to odd values: half-integer spins give even ``n``.
    """
    return list(range(1, level_size(k)))


def _check_n(k: int, n: int) -> int:
    N = level_size(k)
    if not isinstance(n, int) or isinstance(n, bool):
        raise TypeError("object label n must be an int")
    if not 1 <= n <= N - 1:
        raise ValueError(f"object label n must satisfy 1 <= n <= {N - 1}")
    return N


def quantum_dimension(k: int, n: int) -> sp.Expr:
    """Quantum dimension ``d_n = sin(pi n/N) / sin(pi/N)``, ``N = k+2``."""
    N = _check_n(k, n)
    return sp.sin(PI * n / N) / sp.sin(PI / N)


def total_quantum_dimension_squared(k: int) -> sp.Expr:
    """``D_k^2`` exactly as written in the proposal: ``N/(4 sin^2(pi/N))``.

    This is the literal archived normalisation.  It differs by a factor of
    two from the standard ``SU(2)_k`` value ``N/(2 sin^2(pi/N))``; see the
    programme README.
    """
    N = level_size(k)
    return N / (4 * sp.sin(PI / N) ** 2)


def egyptian_denominator(k: int, n: int) -> sp.Expr:
    """Egyptian denominator ``m_n = D_k^2 / d_n^2``, simplified.

    Algebraically this is ``N/(4 sin^2(pi n/N))``.
    """
    N = _check_n(k, n)
    return N / (4 * sp.sin(PI * n / N) ** 2)


def egyptian_denominator_from_ratio(k: int, n: int) -> sp.Expr:
    """The defining ratio ``D_k^2 / d_n^2`` before simplification."""
    _check_n(k, n)
    return total_quantum_dimension_squared(k) / quantum_dimension(k, n) ** 2


def midpoint_denominator(k: int) -> sp.Expr:
    """Value of ``m_n`` at the reflection fixed point ``n = N/2``.

    Requires even ``k`` (equivalently even ``N``).  The value is exactly
    ``N/4`` because ``sin(pi/2) = 1``.
    """
    N = level_size(k)
    if N % 2 != 0:
        raise ValueError("a reflection fixed point requires even k")
    return egyptian_denominator(k, N // 2)


def _coerce_signs(signs: Sequence[int] | None, count: int) -> list[int]:
    if signs is None:
        return [1] * count
    out = list(signs)
    if len(out) != count:
        raise ValueError(f"expected {count} signs, got {len(out)}")
    for ch in out:
        if ch not in (-1, 1):
            raise ValueError("every sign must be +1 or -1")
    return out


def psi(k: int, s: sp.Expr, signs: Sequence[int] | None = None) -> sp.Expr:
    """Finite categorical Dirichlet polynomial ``Psi_k(s)``.

    ``Psi_k(s) = sum_n chi_n m_n^{-s}`` over ``n = 1, ..., N-1``.  The
    signs are supplied by the caller.  ``signs=None`` uses all ``+1``;
    that is a neutral default, not the Galois character of the source.
    """
    N = level_size(k)
    chis = _coerce_signs(signs, N - 1)
    sexpr = sp.sympify(s)
    total = sp.Integer(0)
    for n, ch in zip(object_indices(k), chis):
        total += ch * sp.Pow(egyptian_denominator(k, n), -sexpr)
    return sp.simplify(total)


def trivial_bound(k: int, sigma: sp.Expr) -> sp.Expr:
    """The triangle-inequality bound ``sum_n m_n^{-sigma}`` for real sigma."""
    sexpr = sp.sympify(sigma)
    return sp.simplify(
        sum(sp.Pow(egyptian_denominator(k, n), -sexpr) for n in object_indices(k))
    )


def normalised_psi(k: int, s: sp.Expr, signs: Sequence[int] | None = None) -> sp.Expr:
    """``Psi_k(s) / Psi_k(1/2)``, the proposal's normalisation."""
    denominator = psi(k, sp.Rational(1, 2), signs)
    if sp.simplify(denominator) == 0:
        raise ZeroDivisionError("Psi_k(1/2) vanishes for this sign pattern")
    return sp.simplify(psi(k, s, signs) / denominator)


def scaled_leading_term(k: int, n: int) -> sp.Expr:
    """``m_n * n^2 / N^3``; tends to ``1/(4 pi^2)`` as ``N -> infinity``."""
    N = _check_n(k, n)
    return sp.simplify(egyptian_denominator(k, n) * n ** 2 / N ** 3)
