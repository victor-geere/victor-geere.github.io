"""Finite real structure on the off-diagonal symplectic form.

J rotates the real/imaginary off-diagonal Hermitian pairs:
J(S_ij)=A_ij, J(A_ij)=-S_ij, J=0 on the diagonal.  The real form
g(a,b) = omega(a,Jb) is symmetric; on M_3(C) its nondegenerate part has
signature (1,1): one polarization direction and one Hodge-index direction.
"""

from __future__ import annotations

import numpy as np

from kms_transverse import hermitian_basis, random_density
from off_diagonal import derivative_off

__all__ = [
    "j_map",
    "apply_j",
    "omega",
    "real_form_matrix",
    "signature",
    "hodge_index_pair",
]


def j_map(n: int = 3) -> dict[int, tuple[int, int]]:
    """J on the Hermitian basis: real off-diagonal -> imag, imag -> -real."""
    out: dict[int, tuple[int, int]] = {}
    for m in range(n * (n - 1) // 2):
        real = n + 2 * m
        imag = n + 2 * m + 1
        out[real] = (imag, 1)
        out[imag] = (real, -1)
    return out


def apply_j(basis: list[np.ndarray], coeffs: np.ndarray, n: int = 3) -> np.ndarray:
    jm = j_map(n)
    out = np.zeros_like(basis[0])
    for i, c in enumerate(coeffs):
        if i in jm:
            target, sign = jm[i]
            out += sign * c * basis[target]
    return out


def omega(rho: np.ndarray, a: np.ndarray, b: np.ndarray) -> float:
    return float(np.imag(derivative_off(rho, a, b)))


def real_form_matrix(rho: np.ndarray, n: int = 3) -> np.ndarray:
    basis = hermitian_basis(n)
    dim = len(basis)
    jm = j_map(n)
    out = np.zeros((dim, dim))
    for j in range(dim):
        # J(b_j)
        if j in jm:
            target, sign = jm[j]
            jb = sign * basis[target]
        else:
            jb = np.zeros_like(basis[j])
        for i in range(dim):
            out[i, j] = omega(rho, basis[i], jb)
    return (out + out.T) / 2


def signature(rho: np.ndarray, n: int = 3, tol: float = 1e-7) -> tuple[int, int, int]:
    e = np.linalg.eigvalsh(real_form_matrix(rho, n))
    return int(np.sum(e > tol)), int(np.sum(e < -tol)), int(np.sum(np.abs(e) <= tol))


def hodge_index_pair(rho: np.ndarray, n: int = 3) -> bool:
    pos, neg, _ = signature(rho, n)
    return pos == 1 and neg == 1


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for seed in range(3):
        rho = random_density(3, seed=seed)
        print(seed, signature(rho), hodge_index_pair(rho))
