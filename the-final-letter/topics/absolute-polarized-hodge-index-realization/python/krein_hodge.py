"""Finite Krein/Hodge structure for the Lorentzian Hodge index.

Q is a real symmetric form of signature (1, rho-1); A is an ample vector with
Q(A,A)>0.  The fundamental symmetry is

    S = -I + 2 A A^T Q / (A^T Q A),

so S(A)=A, S=-1 on A^perp, S^2=I, S^T Q S=Q.  The Hodge-Riemann form h=Q S
is positive definite.
"""

from __future__ import annotations

import numpy as np

__all__ = [
    "local_B",
    "local_A",
    "reflection",
    "hodge_riemann",
    "signature",
    "check_krein",
]


def local_B() -> np.ndarray:
    return np.array([[0, 1, 1], [1, 0, 1], [1, 1, 0]], dtype=float)


def local_A() -> np.ndarray:
    return np.array([1.0, 1.0, 1.0])


def reflection(q: np.ndarray, a: np.ndarray) -> np.ndarray:
    a = np.asarray(a, dtype=float)
    q = np.asarray(q, dtype=float)
    denom = float(a @ q @ a)
    if denom <= 0:
        raise ValueError("Q(A,A) must be positive")
    n = q.shape[0]
    return -np.eye(n) + (2.0 / denom) * np.outer(a, a @ q)


def hodge_riemann(q: np.ndarray, s: np.ndarray) -> np.ndarray:
    return q @ s


def signature(m: np.ndarray, tol: float = 1e-9) -> tuple[int, int]:
    e = np.linalg.eigvalsh((m + m.T) / 2)
    return int(np.sum(e > tol)), int(np.sum(e < -tol))


def check_krein(q: np.ndarray, a: np.ndarray) -> dict:
    s = reflection(q, a)
    h = hodge_riemann(q, s)
    return {
        "S": s,
        "h": h,
        "S2": float(np.max(np.abs(s @ s - np.eye(q.shape[0])))),
        "preserves": float(np.max(np.abs(s.T @ q @ s - q))),
        "S_A": float(np.max(np.abs(s @ a - a))),
        "signature_S": signature(s),
        "signature_h": signature(h),
    }


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    q = local_B()
    a = local_A()
    out = check_krein(q, a)
    print("S:\n", np.round(out["S"], 6))
    print("S^2 error:", out["S2"], "preserves:", out["preserves"])
    print("signature S:", out["signature_S"], "signature h:", out["signature_h"])
    print("h:\n", np.round(out["h"], 6))
