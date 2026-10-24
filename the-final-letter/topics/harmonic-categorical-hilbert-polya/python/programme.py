"""Harmonic–categorical Hilbert–Pólya — exact finite-operator layer.

The archived source claims a Hilbert–Pólya proof of the Riemann
Hypothesis.  This module reconstructs only the finite, checkable algebra
that the claimed proof uses:

* the truncated diagonal weights of the greedy transfer operator,
  ``c_{s,r}(N) = sum_{j=0}^{N-1} (j+1)/(j+2)^(s+1+r)``;
* the truncated coefficient matrix of source equation (2),
  ``A_k(s,N)[m,n] = binom(n,m) c_{s,n-m}(N)`` for ``m <= n`` and ``0``
  below the diagonal;
* the finite determinant identities ``det A_k = c^{k+1}`` and
  ``det(I - A_k) = (1 - c)^{k+1}``;
* the real spectrum of a ``2 x 2`` real symmetric (Hermitian) matrix.

Nothing here proves RH, the Fredholm determinant identity of source
Theorem 5.1, or the Hurwitz limit of source §7.  Those remain archived
claims / open items in the programme dossier.
"""

from __future__ import annotations

from typing import Any

import sympy as sp

__all__ = [
    "weight",
    "entry",
    "matrix_A",
    "is_upper_triangular",
    "diag_constant",
    "det_A",
    "det_one_minus_A",
    "discriminant_2x2",
    "charpoly_2x2",
    "eigenvalues_2x2",
    "realise_symmetric_2x2",
]


def _check_nat(name: str, value: int) -> int:
    """Validate and normalise a non-negative integer parameter."""
    if isinstance(value, bool) or not isinstance(value, (int, sp.Integer)):
        raise TypeError(f"{name} must be an integer")
    if value < 0:
        raise ValueError(f"{name} must be non-negative")
    return int(value)


def weight(s: Any, r: int, N: int) -> sp.Expr:
    """Truncated weight ``c_{s,r}(N)``.

    ``sum_{j=0}^{N-1} (j+1) / (j+2)^(s+1+r)``.  For ``N = 0`` the empty
    sum is zero.  ``s`` may be an exact rational, algebraic or complex
    sympy expression.
    """
    r = _check_nat("r", r)
    N = _check_nat("N", N)
    exponent = sp.sympify(s) + 1 + r
    total = sum(
        sp.Rational(j + 1) / sp.Pow(j + 2, exponent) for j in range(N)
    )
    return sp.simplify(total)


def entry(s: Any, N: int, m: int, n: int) -> sp.Expr:
    """Source equation (2), truncated at ``N`` terms in the ``j``-series."""
    N = _check_nat("N", N)
    m = _check_nat("m", m)
    n = _check_nat("n", n)
    if n < m:
        return sp.Integer(0)
    return sp.binomial(n, m) * weight(s, n - m, N)


def matrix_A(s: Any, N: int, k: int) -> sp.Matrix:
    """The ``(k+1) x (k+1)`` truncation ``A_k(s, N)``."""
    N = _check_nat("N", N)
    k = _check_nat("k", k)
    return sp.Matrix(k + 1, k + 1, lambda i, j: entry(s, N, i, j))


def is_upper_triangular(M: sp.Matrix) -> bool:
    """Whether every entry strictly below the diagonal is zero."""
    rows, cols = M.shape
    if rows != cols:
        raise ValueError("matrix must be square")
    return all(M[i, j] == 0 for i in range(rows) for j in range(i))


def diag_constant(s: Any, N: int, k: int) -> bool:
    """Whether every diagonal entry of ``A_k`` equals ``weight(s, 0, N)``."""
    N = _check_nat("N", N)
    k = _check_nat("k", k)
    c = weight(s, 0, N)
    M = matrix_A(s, N, k)
    return all(M[i, i] == c for i in range(k + 1))


def det_A(s: Any, N: int, k: int) -> sp.Expr:
    """The finite determinant ``det A_k(s,N)``."""
    return sp.simplify(matrix_A(s, N, k).det())


def det_one_minus_A(s: Any, N: int, k: int) -> sp.Expr:
    """The finite determinant ``det(I - A_k(s,N))`` of source Lemma 4.1."""
    k = _check_nat("k", k)
    N = _check_nat("N", N)
    return sp.simplify((sp.eye(k + 1) - matrix_A(s, N, k)).det())


def discriminant_2x2(a: Any, b: Any, d: Any) -> sp.Expr:
    """Characteristic discriminant ``(a-d)^2 + 4b^2`` of ``[[a,b],[b,d]]``."""
    a, b, d = sp.sympify(a), sp.sympify(b), sp.sympify(d)
    return sp.expand((a - d) ** 2 + 4 * b**2)


def charpoly_2x2(a: Any, b: Any, d: Any, x: Any = None) -> sp.Expr:
    """Characteristic polynomial ``x^2 - (a+d)x + (ad - b^2)``."""
    x = sp.Symbol("x") if x is None else sp.sympify(x)
    a, b, d = sp.sympify(a), sp.sympify(b), sp.sympify(d)
    return sp.expand(x**2 - (a + d) * x + (a * d - b**2))


def eigenvalues_2x2(a: Any, b: Any, d: Any) -> tuple[sp.Expr, sp.Expr]:
    """The two real roots ``(a+d ± sqrt(disc))/2`` for a symmetric matrix."""
    a, b, d = sp.sympify(a), sp.sympify(b), sp.sympify(d)
    disc = discriminant_2x2(a, b, d)
    root = sp.sqrt(disc)
    return ((a + d + root) / 2, (a + d - root) / 2)


def realise_symmetric_2x2(a: Any, b: Any, d: Any) -> dict[str, Any]:
    """Collect the exact spectral data of the real symmetric matrix ``[[a,b],[b,d]]``."""
    a, b, d = sp.sympify(a), sp.sympify(b), sp.sympify(d)
    l1, l2 = eigenvalues_2x2(a, b, d)
    x = sp.Symbol("x")
    charpoly = charpoly_2x2(a, b, d, x)
    return {
        "discriminant": discriminant_2x2(a, b, d),
        "eigenvalues": (l1, l2),
        "trace": sp.simplify(l1 + l2),
        "determinant": sp.simplify(l1 * l2),
        "charpoly_at_l1": sp.simplify(charpoly.subs(x, l1)),
        "charpoly_at_l2": sp.simplify(charpoly.subs(x, l2)),
    }
