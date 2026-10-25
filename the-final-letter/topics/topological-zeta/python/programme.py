"""Topological zeta — exact finite MTC / S-matrix computation layer.

The archived programme (see ``README.md``) describes a topological
realisation of the Riemann zeta function.  That realisation is a source
claim, not a theorem of this reconstruction.  What the source *does*
define rigorously, and what this module computes, is the finite modular
algebra on which the programme rests:

* squared quantum dimensions ``d_i**2``, the total dimension ``D**2``,
  and the Egyptian denominators ``m_i = D**2 / d_i**2``;
* the Egyptian identity ``sum_i 1/m_i = 1`` and its non-unit form
  ``sum_{i != 0} 1/m_i = 1 - 1/D**2``;
* the Ising and ``SU(2)_4`` modular ``S``-matrices, checked for symmetry
  and unitarity exactly over ``Q(sqrt 2)`` and ``Q(sqrt 3)``;
* the finite MTC Dirichlet polynomial ``Psi(s) = sum_i chi(m_i) m_i**-s``
  and, in particular, the Ising polynomial ``2 * 4**-s - 2**-s``;
* a high-precision check that the completed function asserted in the
  source does *not* satisfy the asserted functional equation (see the
  erratum recorded in the dossier).

Everything is exact unless a function is explicitly marked as numerical.
"""

from __future__ import annotations

from typing import Iterable, Sequence

import mpmath as mp
import sympy as sp

PI = sp.pi


# ---------------------------------------------------------------------------
# Quantum dimensions and Egyptian denominators
# ---------------------------------------------------------------------------


def _positive(expr: sp.Expr, label: str) -> sp.Expr:
    """Simplify ``expr`` and require it to be provably positive."""
    value = sp.simplify(expr)
    if value.is_positive is not True:
        raise ValueError(f"{label} must be positive, got {value!r}")
    return value


def quantum_denominators(dims: Sequence[sp.Expr]) -> tuple[sp.Expr, tuple[sp.Expr, ...]]:
    """Return ``(D**2, (m_i))`` for the quantum dimensions ``dims``.

    ``D**2 = sum_i d_i**2`` and ``m_i = D**2 / d_i**2``.  The dimensions
    must be provably positive; an empty or non-positive family raises
    ``ValueError``.
    """
    if len(dims) == 0:
        raise ValueError("an MTC has at least one simple object")
    checked = tuple(_positive(d, "quantum dimension") for d in dims)
    D2 = sp.simplify(sum(d * d for d in checked))
    ms = tuple(sp.simplify(D2 / (d * d)) for d in checked)
    return D2, ms


def denominators_are_integral(ms: Iterable[sp.Expr]) -> bool:
    """Whether every Egyptian denominator is a positive integer."""
    return all(sp.simplify(m).is_Integer and sp.simplify(m) > 0 for m in ms)


def egyptian_sum(ms: Sequence[sp.Expr]) -> sp.Expr:
    """The full Egyptian sum ``sum_i 1/m_i`` (equals ``1``)."""
    if len(ms) == 0:
        raise ValueError("empty denominator family")
    return sp.simplify(sum(1 / m for m in ms))


def nonunit_egyptian_sum(ms: Sequence[sp.Expr]) -> sp.Expr:
    """The non-unit sum ``sum_{i != 0} 1/m_i = 1 - 1/D**2``."""
    if len(ms) == 0:
        raise ValueError("empty denominator family")
    # The unit object is ms[0]; the non-unit sum really sums the rest.
    return sp.simplify(sum((1 / m for m in ms[1:]), sp.Integer(0)))


def ising_dims() -> tuple[sp.Expr, ...]:
    """Quantum dimensions ``(1, sqrt 2, 1)`` of the Ising category."""
    return (sp.Integer(1), sp.sqrt(2), sp.Integer(1))


def su2_dims(k: int) -> tuple[sp.Expr, ...]:
    """Quantum dimensions of ``SU(2)_k`` for level ``k >= 1``.

    ``d_i = sin(pi (i+1)/(k+2)) / sin(pi/(k+2))`` for ``i = 0, ..., k``.
    """
    if k < 1:
        raise ValueError("level k must be at least 1")
    theta = PI / (k + 2)
    return tuple(
        sp.simplify(sp.sin((i + 1) * theta) / sp.sin(theta)) for i in range(k + 1)
    )


# ---------------------------------------------------------------------------
# Modular S-matrices
# ---------------------------------------------------------------------------


def ising_S() -> sp.Matrix:
    """The Ising modular ``S``-matrix over ``Q(sqrt 2)``."""
    r = sp.sqrt(2)
    return sp.Matrix(
        [
            [sp.Rational(1, 2), r / 2, sp.Rational(1, 2)],
            [r / 2, 0, -r / 2],
            [sp.Rational(1, 2), -r / 2, sp.Rational(1, 2)],
        ]
    )


def su2_S(k: int) -> sp.Matrix:
    """The ``SU(2)_k`` modular ``S``-matrix.

    ``S_ij = sqrt(2/(k+2)) * sin(pi (i+1)(j+1)/(k+2))`` for
    ``i, j = 0, ..., k`` (the index ``i`` labels spin ``i/2``).
    """
    if k < 1:
        raise ValueError("level k must be at least 1")
    factor = sp.sqrt(sp.Rational(2, k + 2))
    theta = PI / (k + 2)
    return sp.Matrix(
        k + 1,
        k + 1,
        lambda i, j: sp.simplify(factor * sp.sin((i + 1) * (j + 1) * theta)),
    )


def is_unitary(M: sp.Matrix) -> bool:
    """Exact check ``M * M.H = 1`` for a square sympy matrix."""
    n = M.rows
    if M.cols != n:
        return False
    prod = sp.simplify(M * M.H)
    return prod == sp.eye(n)


def is_symmetric(M: sp.Matrix) -> bool:
    """Exact check ``M = M^T``."""
    return sp.simplify(M - M.T) == sp.zeros(*M.shape)


def s_matrix_quantum_dimensions(M: sp.Matrix, dims: Sequence[sp.Expr]) -> bool:
    """Exact check of the modular-data identity ``S_{0i} = d_i / D``."""
    D = sp.sqrt(sum(d * d for d in dims))
    return all(sp.simplify(M[0, i] - dims[i] / D) == 0 for i in range(M.cols))


# ---------------------------------------------------------------------------
# Finite MTC Dirichlet polynomials
# ---------------------------------------------------------------------------


def psi(ms: Sequence[sp.Expr], chi: Sequence[int], s: sp.Expr) -> sp.Expr:
    """The finite MTC Dirichlet polynomial ``sum_i chi_i m_i**(-s)``."""
    if len(ms) != len(chi):
        raise ValueError("denominators and character values must have equal length")
    if len(ms) == 0:
        raise ValueError("empty Dirichlet polynomial")
    return sp.simplify(sum(c * sp.Pow(m, -s) for m, c in zip(ms, chi)))


def ising_psi(s: sp.Expr) -> sp.Expr:
    """Ising polynomial with Galois character ``(1, -1, 1)``:
    ``2 * 4**(-s) - 2**(-s)``."""
    return sp.simplify(2 * sp.Pow(4, -s) - sp.Pow(2, -s))


def ising_psi_factored(s: sp.Expr) -> sp.Expr:
    """The same polynomial in factored form ``2**(-s) * (2**(1-s) - 1)``."""
    return sp.simplify(sp.Pow(2, -s) * (sp.Pow(2, 1 - s) - 1))


# ---------------------------------------------------------------------------
# Numerical check of the source's completion (not a proof)
# ---------------------------------------------------------------------------


def _as_mpc(s: complex | mp.mpc) -> mp.mpc:
    return mp.mpc(s)


def completed_psi(
    s: complex | mp.mpc,
    ms: Sequence[int],
    chi: Sequence[int],
    q: int,
    a: int = 0,
) -> mp.mpc:
    """The source's completion ``(q/pi)**((s+a)/2) Gamma((s+a)/2) Psi(s)``."""
    z = _as_mpc(s)
    value = mp.fsum(mp.mpf(c) * mp.power(mp.mpf(m), -z) for m, c in zip(ms, chi))
    return (
        mp.power(mp.mpf(q) / mp.pi, (z + a) / 2)
        * mp.gamma((z + a) / 2)
        * value
    )


def ising_completion(s: complex | mp.mpc) -> mp.mpc:
    """Completed Ising polynomial with ``q = 4``, ``a = 0``."""
    return completed_psi(s, (4, 2, 4), (1, -1, 1), 4, 0)


def completion_ratios(samples: Sequence[complex]) -> list[mp.mpc]:
    """The ratios ``Lambda(s) / Lambda(1-s)`` for the Ising completion.

    A functional equation ``Lambda(s) = eps * Lambda(1-s)`` with constant
    ``eps`` would make every ratio equal.  The archived source asserts
    this with ``eps = 1``; the returned ratios show that no such constant
    exists for the stated completion.
    """
    return [ising_completion(s) / ising_completion(1 - s) for s in samples]
