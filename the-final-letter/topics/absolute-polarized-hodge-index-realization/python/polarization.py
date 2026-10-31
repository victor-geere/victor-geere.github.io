"""L2 polarization and compatible complex structure for the CCM probe.

H is the L2 Gram matrix of the probe basis; Omega is the antisymmetric part of
the CCM probe matrix.  The polar decomposition of A = H^{-1} Omega gives
U^2 = -I, U^T H U = H, and R = Omega U is symmetric and negative definite.
"""

from __future__ import annotations

import numpy as np

from ccm_structure import PROBE_MATRIX, split

__all__ = [
    "l2_gram",
    "compatible_star",
    "hodge_index_form",
    "orthonormalize",
    "star_from_antisymmetric",
    "degree_zero_projection",
    "check",
    "check_orthonormal",
    "signature",
]

_A = 1.5
_K = 4


def _F(k, x, a=_A):
    return np.sin(k * np.pi * x / (2 * a)) * np.where(
        np.abs(x) <= a, np.cos(np.pi * x / (2 * a)), 0.0
    )


def l2_gram(a: float = _A, k: int = _K, n: int = 120) -> np.ndarray:
    nodes, weights = np.polynomial.legendre.leggauss(n)
    x = a * nodes
    w = a * weights
    phi = np.array([_F(j + 1, x, a) for j in range(k)])
    h = (phi * w) @ phi.T
    return (h + h.T) / 2


def compatible_star(h: np.ndarray, omega: np.ndarray) -> np.ndarray:
    t = np.linalg.solve(h, omega)
    ev, v = np.linalg.eig(t)
    mu = np.abs(ev.imag)
    p = np.real(v @ np.diag(mu) @ np.linalg.inv(v))
    return t @ np.linalg.inv(p)


def hodge_index_form(omega: np.ndarray, u: np.ndarray) -> np.ndarray:
    return omega @ u


def signature(m: np.ndarray, tol: float = 1e-9) -> tuple[int, int]:
    e = np.linalg.eigvalsh((m + m.T) / 2)
    return int(np.sum(e > tol)), int(np.sum(e < -tol))


def orthonormalize(h: np.ndarray) -> np.ndarray:
    """W with W^T H W = I (H positive definite)."""
    ev, v = np.linalg.eigh(h)
    return v @ np.diag(ev ** -0.5) @ v.T


def star_from_antisymmetric(a: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """For invertible antisymmetric A: U=A(-A^2)^{-1/2}, R=A U."""
    ev, v = np.linalg.eig(a)
    mu = np.abs(ev.imag)
    p = np.real(v @ np.diag(mu) @ np.linalg.inv(v))
    u = a @ np.linalg.inv(p)
    return u, a @ u


def _constraints(a: float = _A, k: int = _K, n: int = 160) -> tuple[np.ndarray, np.ndarray]:
    nodes, weights = np.polynomial.legendre.leggauss(n)
    x = a * nodes
    w = a * weights
    phi = np.array([_F(j + 1, x, a) for j in range(k)])
    return phi @ w, (np.exp(x) * phi) @ w


def degree_zero_projection(h: np.ndarray, omega: np.ndarray) -> dict:
    """Orthonormalize, project onto the two degree-zero constraints, build R."""
    w = orthonormalize(h)
    om = w.T @ omega @ w
    l1, l2 = _constraints()
    ell = np.vstack([w.T @ l1, w.T @ l2])
    _, _, vt = np.linalg.svd(ell)
    c = vt[2:].T
    om_p = c.T @ om @ c
    u_p, r_p = star_from_antisymmetric(om_p)
    return {"W": w, "Omega": om, "C": c, "Omega_p": om_p, "U_p": u_p, "R_p": r_p}


def check_orthonormal() -> dict:
    h = l2_gram()
    s, omega = split(PROBE_MATRIX)
    w = orthonormalize(h)
    om = w.T @ omega @ w
    u, r = star_from_antisymmetric(om)
    d = degree_zero_projection(h, omega)
    return {
        "gram_defect": float(np.linalg.norm(w.T @ h @ w - np.eye(4))),
        "Omega_antisym": float(np.linalg.norm(om + om.T)),
        "Omega_eig": np.linalg.eigvals(om),
        "U2_defect": float(np.linalg.norm(u @ u + np.eye(4))),
        "R_sym": float(np.linalg.norm(r - r.T)),
        "R_eig": np.linalg.eigvalsh((r + r.T) / 2),
        "R_signature": signature(r),
        "Omega_p": d["Omega_p"],
        "R_p_eig": np.linalg.eigvalsh((d["R_p"] + d["R_p"].T) / 2),
        "R_p_signature": signature(d["R_p"]),
        "det_Omega_p": float(np.linalg.det(d["Omega_p"])),
    }


def check() -> dict:
    s, omega = split(PROBE_MATRIX)
    h = l2_gram()
    u = compatible_star(h, omega)
    r = hodge_index_form(omega, u)
    return {
        "H": h,
        "Omega": omega,
        "U": u,
        "R": r,
        "cond_H": float(np.linalg.cond(h)),
        "U2_defect": float(np.linalg.norm(u @ u + np.eye(4))),
        "H_orth_defect": float(np.linalg.norm(u.T @ h @ u - h)),
        "R_sym_defect": float(np.linalg.norm(r - r.T)),
        "R_eig": np.linalg.eigvalsh((r + r.T) / 2),
        "R_signature": signature(r),
    }


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    d = check()
    print("cond H:", d["cond_H"])
    print("U^2+I:", d["U2_defect"], "H-orth:", d["H_orth_defect"])
    print("R sym defect:", d["R_sym_defect"])
    print("R eig:", np.round(d["R_eig"], 8))
    print("R signature:", d["R_signature"])
