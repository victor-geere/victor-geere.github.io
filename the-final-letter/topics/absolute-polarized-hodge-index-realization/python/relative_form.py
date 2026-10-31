"""Relative modular form and its sign.

For two faithful states rho, psi on M_n(C), the relative Hamiltonian is
H_rel = log rho - log psi, and the relative form is

    B_rel(a,a) = Re Tr(rho a^* [H_rel, a]).

Unlike the modular form H=-log rho, this is not nonnegative: random states
give indefinite values.  The naive relative renormalization therefore does
not inherit the Hodge-index sign.
"""

from __future__ import annotations

import numpy as np

from kms_transverse import hermitian_basis, random_density

__all__ = [
    "relative_form",
    "relative_values",
    "is_indefinite",
    "symmetric_relative_form",
    "symmetric_values",
]


def relative_form(rho: np.ndarray, psi: np.ndarray, a: np.ndarray) -> float:
    h = np.diag(np.log(np.diag(rho)) - np.log(np.diag(psi)))
    delta = h @ a - a @ h
    return float(np.real(np.trace(rho @ (a.conj().T @ delta))))


def relative_values(rho: np.ndarray, psi: np.ndarray) -> np.ndarray:
    return np.array([relative_form(rho, psi, a) for a in hermitian_basis(rho.shape[0])])


def is_indefinite(rho: np.ndarray, psi: np.ndarray, tol: float = 1e-9) -> bool:
    v = relative_values(rho, psi)
    return bool(np.any(v > tol) and np.any(v < -tol))


def symmetric_relative_form(rho: np.ndarray, psi: np.ndarray, a: np.ndarray) -> float:
    return 0.5 * (relative_form(rho, psi, a) + relative_form(psi, rho, a))


def symmetric_values(rho: np.ndarray, psi: np.ndarray) -> np.ndarray:
    return np.array([symmetric_relative_form(rho, psi, a) for a in hermitian_basis(rho.shape[0])])


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for n in (2, 3):
        for seed in range(3):
            rho = random_density(n, seed=seed)
            psi = random_density(n, seed=seed + 10)
            v = relative_values(rho, psi)
            print(n, seed, "min", round(float(v.min()), 4),
                  "max", round(float(v.max()), 4), "indefinite", is_indefinite(rho, psi))
