"""Off-diagonal half-weight-times-log form.

For C_s(a,b) = Tr(rho a^* rho^s b rho^{-s}), the derivative at s=1/2 is

    D(a,b) = sum_{i,j} (p_i p_j)^{1/2} conj(a_ij) b_ij log(p_i/p_j).

D(a,a) = 0 for self-adjoint a, but D(a,b) != 0 for a != b.  This is the
off-diagonal form that the CCM local term requires.
"""

from __future__ import annotations

import numpy as np

from kms_transverse import hermitian_basis, random_density

__all__ = [
    "C_off",
    "derivative_off",
    "diagonal_vanishes",
    "symmetry_check",
]


def C_off(rho: np.ndarray, a: np.ndarray, b: np.ndarray, s: float) -> complex:
    rs = np.diag(np.diag(rho) ** s)
    rs_inv = np.diag(np.diag(rho) ** (-s))
    return complex(np.trace(rho @ (a.conj().T @ (rs @ b @ rs_inv))))


def derivative_off(rho: np.ndarray, a: np.ndarray, b: np.ndarray,
                   s: float = 0.5, eps: float = 1e-5) -> complex:
    return (C_off(rho, a, b, s + eps) - C_off(rho, a, b, s - eps)) / (2 * eps)


def diagonal_vanishes(rho: np.ndarray, a: np.ndarray, tol: float = 1e-6) -> bool:
    return abs(derivative_off(rho, a, a)) < tol


def symmetry_check(rho: np.ndarray, a: np.ndarray, b: np.ndarray,
                   tol: float = 1e-6) -> bool:
    d_ab = derivative_off(rho, a, b)
    d_ba = derivative_off(rho, b, a)
    return abs(d_ab - np.conj(d_ba)) < tol


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    rho = random_density(3, seed=7)
    basis = hermitian_basis(3)
    a, b = basis[0], basis[1]
    print("diagonal zero:", diagonal_vanishes(rho, a))
    print("off-diagonal:", derivative_off(rho, a, b))
    print("symmetry:", symmetry_check(rho, a, b))
