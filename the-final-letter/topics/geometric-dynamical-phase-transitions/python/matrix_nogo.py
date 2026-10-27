"""General nonnegative matrix-product contraction checks.

A product of entrywise nonnegative matrices is entrywise nonnegative, so any
contraction with nonnegative boundary vectors is nonnegative. This is the
Python companion of ``lean/MatrixNoGo.lean``.
"""

from __future__ import annotations

import sympy as sp


def mat_prod(mats: list[sp.Matrix]) -> sp.Matrix:
    """Product of a list of matrices, in list order."""
    if not mats:
        raise ValueError("need at least one matrix")
    out = sp.eye(mats[0].rows)
    for A in mats:
        out = out * A
    return sp.simplify(out)


def all_entries_nonneg(A: sp.Matrix) -> bool:
    return all(bool(sp.simplify(A[i, j]) >= 0) for i in range(A.rows) for j in range(A.cols))


def contraction(u: list[sp.Expr], P: sp.Matrix, w: list[sp.Expr]) -> sp.Expr:
    """``Σ_i Σ_j u_i P_ij w_j``."""
    if len(u) != P.rows or len(w) != P.cols:
        raise ValueError("dimension mismatch")
    return sp.simplify(sum(sp.sympify(u[i]) * P[i, j] * sp.sympify(w[j])
                          for i in range(P.rows) for j in range(P.cols)))


def eta_two_neg_one() -> sp.Integer:
    """The `N=2` polygon at `s=-1`: `1 - 2 + 3 - 4 = -2`."""
    return sp.Integer(1) - 2 + 3 - 4


def nonnegative_contraction(mats: list[sp.Matrix], u: list[sp.Expr], w: list[sp.Expr]) -> sp.Expr:
    """Contraction of a nonnegative matrix product with nonnegative vectors."""
    for A in mats:
        if not all_entries_nonneg(A):
            raise ValueError("all matrix entries must be nonnegative")
    if any(bool(sp.sympify(x) < 0) for x in u) or any(bool(sp.sympify(x) < 0) for x in w):
        raise ValueError("boundary vectors must be nonnegative")
    return contraction(u, mat_prod(mats), w)
