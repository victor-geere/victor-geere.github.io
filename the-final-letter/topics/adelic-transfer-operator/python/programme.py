"""Adelic transfer operator — exact local MTC / Fredholm computation layer.

The archived source is a thesis outline.  It specifies the local
modular tensor category ``C_p = SU(2)_{p-2}``, its quantum dimensions
and S-matrix, the local RT weight ``p^{-n}``, and the local Fredholm
factor ``(1 - p^{-s})^{-1}``.  The global adelic operator, the global
determinant identity, the functional equation, the Ruelle-pressure
exclusion argument, and the Riemann-hypothesis conclusion are archived
claims and are **not** implemented or verified here.

Only finite, exact local bookkeeping is implemented.  The module has no
import-time side effects.
"""

from __future__ import annotations

import sympy as sp

PI = sp.pi


def _validate_p(p: int) -> None:
    """The source uses odd primes p >= 3 (level p - 2)."""
    if isinstance(p, bool) or not isinstance(p, int):
        raise TypeError("p must be an integer")
    if p < 3:
        raise ValueError("p must be at least 3")
    if p % 2 == 0:
        raise ValueError("p must be odd")


def _validate_label(p: int, a: int) -> None:
    if isinstance(a, bool) or not isinstance(a, int):
        raise TypeError("a must be an integer")
    if not 1 <= a <= p - 1:
        raise ValueError("label a must satisfy 1 <= a <= p - 1")


def quantum_dimension(p: int, a: int) -> sp.Expr:
    """Quantum dimension ``d_a = sin(pi a / p) / sin(pi / p)``.

    The identity object is ``a = 1`` in the ``1 .. p - 1`` labelling
    (``a = 2 j + 1`` for spin ``j``).
    """
    _validate_p(p)
    _validate_label(p, a)
    return sp.sin(PI * a / p) / sp.sin(PI / p)


def s_matrix(p: int) -> sp.Matrix:
    """The real symmetric S-matrix ``S_{ab} = sqrt(2/p) sin(pi a b / p)``.

    Rows and columns are indexed by ``a, b = 1 .. p - 1``.
    """
    _validate_p(p)
    n = p - 1
    return sp.Matrix(
        n,
        n,
        lambda i, j: sp.sqrt(sp.Rational(2, p)) * sp.sin(PI * (i + 1) * (j + 1) / p),
    )


def cosine_sum(p: int, k: int) -> sp.Integer:
    """Exact value of ``sum_{b=1}^{p-1} cos(pi k b / p)`` for odd ``p``.

    The sum is periodic in ``k`` with period ``2 p``:

    * ``k = 0`` gives ``p - 1``;
    * nonzero even ``k`` gives ``-1``;
    * odd ``k`` gives ``0`` (pair ``b`` with ``p - b``).
    """
    _validate_p(p)
    k %= 2 * p
    if k == 0:
        return sp.Integer(p - 1)
    if k % 2 == 0:
        return sp.Integer(-1)
    return sp.Integer(0)


def s_squared_entry(p: int, a: int, c: int) -> sp.Integer:
    """Exact entry ``(S^2)_{ac}`` using the product-to-sum identity.

    ``(S^2)_{ac} = (1/p) (C(a-c) - C(a+c))`` where ``C(k)`` is
    :func:`cosine_sum`.  This avoids the trigonometric simplification
    that ``sympy`` cannot complete for larger ``p``.
    """
    _validate_p(p)
    _validate_label(p, a)
    _validate_label(p, c)
    return sp.Rational(1, p) * (cosine_sum(p, a - c) - cosine_sum(p, a + c))


def s_matrix_squared_is_identity(p: int) -> bool:
    """Check exactly that the S-matrix is an involution, ``S^2 = I``."""
    return all(
        s_squared_entry(p, a, c) == (1 if a == c else 0)
        for a in range(1, p)
        for c in range(1, p)
    )


def sin_sq_sum(p: int) -> sp.Expr:
    """Exact value of ``sum_{a=1}^{p-1} sin^2(pi a / p) = p/2``.

    Derived from ``sin^2 x = (1 - cos 2x)/2`` and
    ``cosine_sum(p, 2) = -1``.
    """
    return sp.Rational(p - 1, 2) - sp.Rational(1, 2) * cosine_sum(p, 2)


def total_quantum_dimension_sq_sum(p: int) -> sp.Expr:
    """``sum_a d_a^2`` computed from the exact sine-square sum."""
    _validate_p(p)
    return sp.simplify(sin_sq_sum(p) / sp.sin(PI / p) ** 2)


def total_quantum_dimension(p: int) -> sp.Expr:
    """The source's total quantum dimension ``D_p = sqrt(p / (2 sin^2(pi/p)))``."""
    _validate_p(p)
    return sp.sqrt(sp.Rational(p, 2)) / sp.sin(PI / p)


def rt_weight(p: int, n: int) -> sp.Rational:
    """Local RT weight of a length-``n`` orbit: ``p^{-n}``."""
    if isinstance(p, bool) or not isinstance(p, int) or p <= 0:
        raise ValueError("p must be a positive integer")
    if isinstance(n, bool) or not isinstance(n, int) or n < 0:
        raise ValueError("n must be a non-negative integer")
    return sp.Rational(1, p) ** n


def local_det(x: sp.Expr) -> sp.Expr:
    """The local Fredholm/Euler factor ``(1 - x)^{-1}``."""
    if sp.simplify(x - 1) == 0:
        raise ValueError("the local Fredholm factor is singular at x = 1")
    return 1 / (1 - x)


def geometric_partial_sum(x: sp.Expr, n_terms: int) -> sp.Expr:
    """``sum_{k=0}^{n_terms-1} x^k``."""
    if isinstance(n_terms, bool) or not isinstance(n_terms, int) or n_terms < 0:
        raise ValueError("n_terms must be a non-negative integer")
    return sum((x**k for k in range(n_terms)), sp.Integer(0))


def euler_truncation_residual(x: sp.Expr, n_terms: int) -> sp.Expr:
    """Residual of ``(1 - x) sum_{k<N} x^k = 1 - x^N``.

    Returns a simplified expression that is exactly zero when the identity
    holds.
    """
    return sp.simplify(
        (1 - x) * geometric_partial_sum(x, n_terms) - (1 - x**n_terms)
    )


def local_det_tail(p: int, n_terms: int) -> sp.Expr:
    """Exact tail ``sum_{k>=N} p^{-k} = p^{-N} / (1 - 1/p)`` at ``x = 1/p``."""
    if isinstance(p, bool) or not isinstance(p, int) or p <= 1:
        raise ValueError("p must be an integer greater than 1")
    x = sp.Rational(1, p)
    return x**n_terms / (1 - x)


def verlinde_coefficient(p: int, a: int, b: int, c: int) -> sp.Expr:
    """Verlinde coefficient ``N_{ab}^{c}`` for small ``p``.

    ``N_{ab}^{c} = sum_d S_{ad} S_{bd} S_{cd} / S_{1d}``.  The expression
    is simplified exactly; this is practical only for small ``p`` (the
    source's table covers ``p = 3, 5, 7``).
    """
    _validate_p(p)
    for label in (a, b, c):
        _validate_label(p, label)
    S = s_matrix(p)
    return sp.simplify(
        sum(
            S[a - 1, d - 1] * S[b - 1, d - 1] * S[c - 1, d - 1] / S[0, d - 1]
            for d in range(1, p)
        )
    )
