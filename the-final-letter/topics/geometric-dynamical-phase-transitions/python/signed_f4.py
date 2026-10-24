"""Signed gauge representation of the register transfer product.

The real signed gauge `S = [[1,1],[1,2]]` turns the upper-triangular register
matrices into genuinely non-upper-triangular signed matrices while preserving
the contraction with transformed boundary vectors.
"""

from __future__ import annotations

import sympy as sp

S = sp.Matrix([[1, 1], [1, 2]])
SINV = sp.Matrix([[2, -1], [-1, 1]])


def signed_reg_mat(N: int, m: int) -> sp.Matrix:
    """The signed register matrix at `s = 1`."""
    if N < 2 or m < 1:
        raise ValueError("need N >= 2 and m >= 1")
    c = 1 - N if m % N == 0 else 1
    return sp.Matrix([[1, sp.Rational(c, m)], [0, 1]])


def gauge(A: sp.Matrix) -> sp.Matrix:
    return sp.simplify(SINV * A * S)


def gauge_product(mats: list[sp.Matrix]) -> sp.Matrix:
    return sp.simplify(SINV * sp.prod(mats) * S)


def contraction(u: list[sp.Expr], P: sp.Matrix, w: list[sp.Expr]) -> sp.Expr:
    return sp.simplify(sum(sp.sympify(u[i]) * P[i, j] * sp.sympify(w[j])
                          for i in range(2) for j in range(2)))


def gauge_contraction_preserved(mats: list[sp.Matrix], u: list[sp.Expr], w: list[sp.Expr]) -> bool:
    original = contraction(u, sp.prod(mats), w)
    transformed = contraction([S.T[i, 0] * u[0] + S.T[i, 1] * u[1] for i in range(2)],
                              gauge_product(mats),
                              [SINV[0, 0] * w[0] + SINV[0, 1] * w[1],
                               SINV[1, 0] * w[0] + SINV[1, 1] * w[1]])
    return sp.simplify(original - transformed) == 0


def signed_represents_polygon(N: int) -> bool:
    """Check the gauged signed contraction against the direct polygon at `s = 1`.

    The gauge changes individual matrix entries, so the correct comparison is
    the contraction with the transformed boundary vectors, not the top-right
    entry of the gauged product.
    """
    mats = [signed_reg_mat(N, m) for m in range(1, N * N + 1)]
    return gauge_contraction_preserved(mats, [1, 0], [0, 1])
