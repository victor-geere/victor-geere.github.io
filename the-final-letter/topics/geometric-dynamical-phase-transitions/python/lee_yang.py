"""Finite Lee–Yang circle theorem for the two-spin Ising model.

`Z_K(z) = exp(K) z^2 + 2z + exp(K)`, `K > 0`. The two roots are complex
conjugates of modulus one.
"""

from __future__ import annotations

import sympy as sp


def ising2_partition(K: sp.Expr, z: sp.Expr) -> sp.Expr:
    K = sp.sympify(K)
    z = sp.sympify(z)
    return sp.exp(K) * z**2 + 2 * z + sp.exp(K)


def ising2_roots(K: sp.Expr) -> list[sp.Expr]:
    K = sp.sympify(K)
    z = sp.symbols("z")
    return sp.solve(sp.exp(K) * z**2 + 2 * z + sp.exp(K), z)


def ising2_roots_on_unit_circle(K: sp.Expr, dps: int = 50) -> bool:
    for root in ising2_roots(K):
        modulus = abs(complex(sp.N(root, dps)))
        if abs(modulus - 1.0) > 1e-12:
            return False
    return True
