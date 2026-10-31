"""Finite Hodge-Riemann package for the KMS/endmotive model.

For A = M_n(C), phi(a) = Tr(rho a), Delta^s(a) = rho^s a rho^{-s}, define

    C_s(a,b) = phi(a^* Delta^s b).

Proposition 1: C_s(a,a) = sum p_i^s p_j^{1-s} |a_ij|^2 >= 0, so C_{1/2} is a
positive-definite polarization.

Proposition 2: B(a,a) = phi(a^*[H,b]) = -d/ds C_s(a,a)|_{s=0}, and -B is
negative semidefinite on the kernel of phi (the finite KMS Hodge index).
"""

from __future__ import annotations

import numpy as np

from kms_transverse import (
    hermitian_basis,
    kernel_basis,
    random_density,
    transverse_form,
)

__all__ = [
    "rho_power",
    "C_s",
    "C_matrix",
    "half_weight_positive",
    "derivative_C",
    "check_derivative",
]


def rho_power(rho: np.ndarray, s: float) -> np.ndarray:
    return np.diag(np.diag(rho) ** s)


def C_s(rho: np.ndarray, a: np.ndarray, s: float) -> float:
    rs = rho_power(rho, s)
    rs_inv = rho_power(rho, -s)
    return float(np.real(np.trace(rho @ (a.conj().T @ (rs @ a @ rs_inv)))))


def C_matrix(rho: np.ndarray, s: float) -> np.ndarray:
    basis = hermitian_basis(rho.shape[0])
    n = len(basis)
    out = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            out[i, j] = C_s(rho, basis[i].conj().T @ basis[j], s)
    return (out + out.T) / 2


def half_weight_positive(rho: np.ndarray, tol: float = 1e-9) -> bool:
    return bool(np.all(np.linalg.eigvalsh(C_matrix(rho, 0.5)) > -tol))


def derivative_C(rho: np.ndarray, a: np.ndarray, eps: float = 1e-5) -> float:
    """Central finite difference of s -> C_s(a,a) at s=0."""
    return (C_s(rho, a, eps) - C_s(rho, a, -eps)) / (2 * eps)


def check_derivative(rho: np.ndarray, a: np.ndarray, tol: float = 1e-5) -> bool:
    return abs(derivative_C(rho, a) + transverse_form(rho, a)) < tol


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for n in (2, 3, 4):
        rho = random_density(n, seed=3)
        print(n, "half-weight positive:", half_weight_positive(rho))
        a = hermitian_basis(n)[-1]
        print("  derivative:", derivative_C(rho, a), " -B:", -transverse_form(rho, a))
