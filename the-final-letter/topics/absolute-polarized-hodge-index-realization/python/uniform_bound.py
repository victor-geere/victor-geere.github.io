"""Uniform-bound check for the finite KMS form.

For a finite-dimensional algebra with faithful state rho and H=-log rho,

    B(a,a) = Re Tr(rho a^* [H,a]) <= 2 ||H|| ||a||^2.

For KMS weights p^{-k beta}, ||H|| ~ beta k log p, which grows with the level
and diverges at beta=1.  The naive uniform bound therefore fails.
"""

from __future__ import annotations

import numpy as np

from kms_transverse import hermitian_basis, random_density, transverse_form

__all__ = ["bound_holds", "kms_norm"]


def bound_holds(rho: np.ndarray, a: np.ndarray, tol: float = 1e-9) -> bool:
    h = -np.diag(np.log(np.diag(rho)))
    lhs = transverse_form(rho, a)
    rhs = 2 * np.linalg.norm(h, 2) * np.linalg.norm(a, 2) ** 2
    return bool(lhs <= rhs + tol)


def kms_norm(beta: float, k: int, p: float) -> float:
    """Norm of H for a weight p^{-k beta}."""
    return abs(beta * k * np.log(p))


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for n in (2, 3):
        rho = random_density(n, seed=1)
        print(n, [bound_holds(rho, a) for a in hermitian_basis(n)])
    print("kms norms", [round(kms_norm(1.0, k, 2.0), 3) for k in (1, 2, 4, 8)])
