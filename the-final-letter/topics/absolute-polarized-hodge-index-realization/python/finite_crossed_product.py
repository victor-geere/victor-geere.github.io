"""Finite crossed-product checks for the Hodge index.

A = C*(Z/3) x| Z/2, the group algebra of S_3, in its regular representation.
The algebra is six dimensional.  For a faithful state phi(a)=Tr(rho a),
H=-log rho, delta(a)=[H,a], the finite theorem (for self-adjoint a) gives

    Re phi(a^* delta(a)) >= 0,

with equality iff a commutes with H.  Hence -B is negative semidefinite on
the self-adjoint part of the kernel of phi.
"""

from __future__ import annotations

import numpy as np

__all__ = [
    "U",
    "V",
    "group_elements",
    "left_regular",
    "algebra_basis",
    "hermitian_basis",
    "transverse_form",
    "kernel_basis",
    "form_matrix_on_kernel",
    "hodge_index_holds",
    "tracial_state",
    "nontracial_state",
]


def U(n: int, x: int) -> np.ndarray:
    m = np.zeros((n, n), dtype=complex)
    for y in range(n):
        m[(y + x) % n, y] = 1
    return m


def V(n: int) -> np.ndarray:
    m = np.zeros((n, n), dtype=complex)
    for y in range(n):
        m[(-y) % n, y] = 1
    return m


def group_elements(n: int = 3) -> list[tuple[int, int]]:
    return [(x, e) for e in (0, 1) for x in range(n)]


def mul(g: tuple[int, int], h: tuple[int, int], n: int = 3) -> tuple[int, int]:
    x, e = g
    y, d = h
    return ((x + (y if e == 0 else -y)) % n, (e + d) % 2)


def left_regular(g: tuple[int, int], n: int = 3) -> np.ndarray:
    elems = group_elements(n)
    idx = {h: i for i, h in enumerate(elems)}
    m = np.zeros((len(elems), len(elems)), dtype=complex)
    for j, h in enumerate(elems):
        m[idx[mul(g, h, n)], j] = 1
    return m


def algebra_basis(n: int = 3) -> list[np.ndarray]:
    return [left_regular(g, n) for g in group_elements(n)]


def _herm_coords(m: np.ndarray) -> np.ndarray:
    n = m.shape[0]
    vals = [m[i, i].real for i in range(n)]
    for i in range(n):
        for j in range(i + 1, n):
            vals.append(m[i, j].real)
    for i in range(n):
        for j in range(i + 1, n):
            vals.append(m[i, j].imag)
    return np.array(vals)


def _herm_from_coords(v: np.ndarray, n: int) -> np.ndarray:
    m = np.zeros((n, n), dtype=complex)
    k = 0
    for i in range(n):
        m[i, i] = v[k]
        k += 1
    for i in range(n):
        for j in range(i + 1, n):
            m[i, j] = v[k] + 1j * v[k + n * (n - 1) // 2]
            m[j, i] = np.conj(m[i, j])
            k += 1
    return m


def hermitian_basis(n: int = 3) -> list[np.ndarray]:
    """A real basis of the self-adjoint part of the crossed product."""
    vecs = []
    for m in algebra_basis(n):
        vecs.append(_herm_coords(m + m.conj().T))
        vecs.append(_herm_coords(1j * (m - m.conj().T)))
    _, s, vt = np.linalg.svd(np.array(vecs))
    rank = int(np.sum(s > 1e-9))
    dim = len(group_elements(n))
    return [_herm_from_coords(vt[i], dim) for i in range(rank)]


def transverse_form(rho: np.ndarray, a: np.ndarray) -> float:
    h = -np.diag(np.log(np.diag(rho)))
    delta = h @ a - a @ h
    return float(np.real(np.trace(rho @ (a.conj().T @ delta))))


def kernel_basis(rho: np.ndarray, n: int = 3) -> list[np.ndarray]:
    basis = hermitian_basis(n)
    phi = np.real([np.trace(rho @ m) for m in basis])
    _, _, vt = np.linalg.svd(phi.reshape(1, -1))
    ns = vt[1:].T
    return [sum(ns[k, r] * basis[k] for k in range(len(basis))) for r in range(ns.shape[1])]


def form_matrix_on_kernel(rho: np.ndarray, n: int = 3) -> np.ndarray:
    ker = kernel_basis(rho, n)
    h = -np.diag(np.log(np.diag(rho)))
    g = np.zeros((len(ker), len(ker)))
    for i in range(len(ker)):
        for j in range(len(ker)):
            g[i, j] = np.real(np.trace(rho @ (ker[i].conj().T @ (h @ ker[j] - ker[j] @ h))))
    g = (g + g.T) / 2
    return -g


def hodge_index_holds(rho: np.ndarray, n: int = 3, tol: float = 1e-8) -> bool:
    return bool(np.all(np.linalg.eigvalsh(form_matrix_on_kernel(rho, n)) <= tol))


def tracial_state(n: int = 3) -> np.ndarray:
    dim = len(group_elements(n))
    return np.eye(dim, dtype=complex) / dim


def nontracial_state(n: int = 3) -> np.ndarray:
    dim = len(group_elements(n))
    p = np.linspace(0.3, 0.05, dim)
    p = p / p.sum()
    return np.diag(p)


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    rho = nontracial_state()
    print("hermitian basis:", len(hermitian_basis()))
    print("non-tracial Hodge index:", hodge_index_holds(rho))
    print("tracial Hodge index:", hodge_index_holds(tracial_state()))
    for a in hermitian_basis():
        print("form:", transverse_form(rho, a))
