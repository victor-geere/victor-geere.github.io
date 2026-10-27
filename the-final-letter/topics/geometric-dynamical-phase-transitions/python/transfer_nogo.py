"""The register transfer matrix and its sign obstruction.

The polygon is the top-right entry of a bond-dimension-2 product of
upper-triangular register matrices. The coupling at position ``m`` is the
corresponding filter coefficient times ``m**(-s)``. At ``m = N`` that coupling
is negative for every real ``s`` and every ``N > 1``, so the register chain
cannot be ferromagnetic.
"""

from __future__ import annotations

import sympy as sp


def _check_N(N: int) -> None:
    if not isinstance(N, int) or isinstance(N, bool):
        raise TypeError("N must be an integer")
    if N < 2:
        raise ValueError("N must satisfy N >= 2")


def reg_coeff(N: int, m: int) -> int:
    """The integer register coefficient at position ``m``."""
    _check_N(N)
    if not isinstance(m, int) or isinstance(m, bool):
        raise TypeError("m must be an integer")
    if m < 1:
        raise ValueError("m must satisfy m >= 1")
    return 1 - N if m % N == 0 else 1


def reg_matrix(N: int, s: sp.Expr, m: int) -> sp.Matrix:
    """The bond-dimension-2 register transfer matrix at position ``m``."""
    _check_N(N)
    ss = sp.sympify(s)
    coupling = sp.Integer(reg_coeff(N, m)) * sp.Integer(m) ** (-ss)
    return sp.Matrix([[1, coupling], [0, 1]])


def reg_product(N: int, s: sp.Expr, M: int) -> sp.Matrix:
    """The product of the first ``M`` register matrices."""
    _check_N(N)
    if not isinstance(M, int) or isinstance(M, bool):
        raise TypeError("M must be an integer")
    if M < 0:
        raise ValueError("M must satisfy M >= 0")
    out = sp.eye(2)
    for m in range(1, M + 1):
        out = out * reg_matrix(N, s, m)
    return sp.simplify(out)


def reg_topright_sum(N: int, s: sp.Expr, M: int) -> sp.Expr:
    """The direct coefficient sum at length ``M``."""
    _check_N(N)
    ss = sp.sympify(s)
    return sp.simplify(
        sum(sp.Integer(reg_coeff(N, m)) * sp.Integer(m) ** (-ss) for m in range(1, M + 1))
    )


def reg_product_matches_polygon(N: int, s: sp.Expr) -> bool:
    """Check the product identity at the quadratic link ``M = N^2``."""
    _check_N(N)
    return sp.simplify(reg_product(N, s, N * N)[0, 1] - reg_topright_sum(N, s, N * N)) == 0


def reg_coupling(N: int, s: sp.Expr, m: int) -> sp.Expr:
    """The off-diagonal coupling at position ``m``."""
    return sp.simplify(reg_matrix(N, s, m)[0, 1])


def register_couplings_nonnegative(N: int, s: sp.Expr) -> bool:
    """Whether every register coupling up to ``N^2`` is nonnegative."""
    _check_N(N)
    return all(bool(reg_coupling(N, s, m) >= 0) for m in range(1, N * N + 1))
