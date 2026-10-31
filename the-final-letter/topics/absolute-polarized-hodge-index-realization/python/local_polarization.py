"""Local polarized Hodge-index check.

The fibre of the absolute construction at a prime p is the abelian surface
E_p x E_p.  Its Neron-Severi space has the rank-three basis H, V, Delta with
Gram matrix B below.  This module checks the local Hodge index numerically;
the same statement is Lean-proved as T5-T9 of
../intersection-form-zeta/lean/Topic.lean.
"""

from __future__ import annotations

import numpy as np

__all__ = [
    "B",
    "A",
    "intersection",
    "signature",
    "defect",
    "hodge_holds",
    "restricted_gram",
]

B = np.array([[0, 1, 1], [1, 0, 1], [1, 1, 0]], dtype=int)
A = np.array([1, 1, 1], dtype=int)


def intersection(d, e) -> int:
    """Intersection number d^T B e."""
    d = np.asarray(d, dtype=int)
    e = np.asarray(e, dtype=int)
    return int(d @ B @ e)


def signature() -> tuple[int, int]:
    """Signature (positive, negative) of B."""
    eigs = np.linalg.eigvalsh(B.astype(float))
    pos = int(np.sum(eigs > 1e-9))
    neg = int(np.sum(eigs < -1e-9))
    return pos, neg


def defect(d) -> int:
    """6 d^2 - (A.d)^2 = -2((a-b)^2 + (b-c)^2 + (c-a)^2)."""
    d = np.asarray(d, dtype=int)
    a, b, c = (int(x) for x in d)
    return -2 * ((a - b) ** 2 + (b - c) ** 2 + (c - a) ** 2)


def hodge_holds(d) -> bool:
    """6 d^2 <= (A.d)^2."""
    d = np.asarray(d, dtype=int)
    return 6 * intersection(d, d) <= intersection(A, d) ** 2


def restricted_gram(basis) -> np.ndarray:
    """Gram matrix of B restricted to the span of the given vectors."""
    basis = [np.asarray(v, dtype=int) for v in basis]
    n = len(basis)
    out = np.zeros((n, n), dtype=int)
    for i in range(n):
        for j in range(n):
            out[i, j] = intersection(basis[i], basis[j])
    return out


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    print("signature:", signature())
    print("A^2:", intersection(A, A))
    print("restricted Gram on A^perp:", restricted_gram([[1, -1, 0], [1, 1, -2]]).tolist())
    worst = 0
    for a in range(-5, 6):
        for b in range(-5, 6):
            for c in range(-5, 6):
                d = np.array([a, b, c])
                assert hodge_holds(d)
                assert 6 * intersection(d, d) - intersection(A, d) ** 2 == defect(d)
                worst = min(worst, defect(d))
    print("deliberate negative defect (D=(1,0,0)):", defect([1, 0, 0]))
    print("grid check passed")
