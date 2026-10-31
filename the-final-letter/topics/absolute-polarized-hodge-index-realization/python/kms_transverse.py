"""Finite KMS Hodge-index checks.

For A = M_n(C), a faithful state phi(a) = Tr(rho a), H = -log rho, and the
transverse derivation delta(a) = [H,a], the transverse form is

    B(a,b) = phi(a^* delta(b)).

The theorem of notes/03-kms-hodge-index.md is

    Re B(a,a) = 1/2 sum_{i,j} (p_i-p_j)|a_ij|^2 log(p_i/p_j) >= 0,

with equality iff [H,a] = 0.  Hence -B is negative semidefinite and is the
Hodge-index form on the kernel of phi.
"""

from __future__ import annotations

import numpy as np

__all__ = [
    "random_density",
    "hermitian_basis",
    "kernel_basis",
    "transverse_form",
    "explicit_form",
    "form_matrix_on_kernel",
    "hodge_index_holds",
]


def random_density(n: int, seed: int = 0) -> np.ndarray:
    rng = np.random.default_rng(seed)
    w = rng.dirichlet(np.ones(n))
    return np.diag(w)


def hermitian_basis(n: int) -> list[np.ndarray]:
    basis = []
    for i in range(n):
        m = np.zeros((n, n), dtype=complex)
        m[i, i] = 1
        basis.append(m)
    for i in range(n):
        for j in range(i + 1, n):
            m = np.zeros((n, n), dtype=complex)
            m[i, j] = 1
            m[j, i] = 1
            basis.append(m)
            m = np.zeros((n, n), dtype=complex)
            m[i, j] = 1j
            m[j, i] = -1j
            basis.append(m)
    return basis


def kernel_basis(rho: np.ndarray) -> list[np.ndarray]:
    """Real basis of Hermitian a with Tr(rho a) = 0."""
    n = rho.shape[0]
    basis = hermitian_basis(n)
    phi = np.real([np.trace(rho @ m) for m in basis])
    _, _, vt = np.linalg.svd(phi.reshape(1, -1))
    ns = vt[1:].T  # (n^2, n^2-1)
    return [sum(ns[k, r] * basis[k] for k in range(len(basis))) for r in range(ns.shape[1])]


def transverse_form(rho: np.ndarray, a: np.ndarray) -> float:
    n = rho.shape[0]
    h = -np.diag(np.log(np.diag(rho)))
    delta = h @ a - a @ h
    return float(np.real(np.trace(rho @ (a.conj().T @ delta))))


def explicit_form(rho: np.ndarray, a: np.ndarray) -> float:
    """The right-hand side 1/2 sum (p_i-p_j)|a_ij|^2 log(p_i/p_j)."""
    p = np.diag(rho)
    n = len(p)
    total = 0.0
    for i in range(n):
        for j in range(n):
            if i == j:
                continue
            total += 0.5 * (p[i] - p[j]) * abs(a[i, j]) ** 2 * np.log(p[i] / p[j])
    return float(total)


def form_matrix_on_kernel(rho: np.ndarray) -> np.ndarray:
    ker = kernel_basis(rho)
    g = np.zeros((len(ker), len(ker)))
    for i in range(len(ker)):
        for j in range(len(ker)):
            g[i, j] = np.real(
                np.trace(rho @ (ker[i].conj().T @ (
                    (-np.diag(np.log(np.diag(rho)))) @ ker[j]
                    - ker[j] @ (-np.diag(np.log(np.diag(rho))))
                )))
            )
    g = (g + g.T) / 2
    return -g


def hodge_index_holds(rho: np.ndarray, tol: float = 1e-9) -> bool:
    return bool(np.all(np.linalg.eigvalsh(form_matrix_on_kernel(rho)) <= tol))


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for n in (2, 3, 4):
        for seed in range(3):
            rho = random_density(n, seed)
            print(n, seed, hodge_index_holds(rho), np.linalg.eigvalsh(form_matrix_on_kernel(rho)))
