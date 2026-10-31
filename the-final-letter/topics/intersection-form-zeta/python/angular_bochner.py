"""A finite sector model of the angular Bochner compression.

The note ``notes/06-angular-bochner-attack.md`` uses the angular Bochner
framework of the accompanying PDF as a normal form for the finite-level
polarization of the scaling correspondence.  This module supplies a small,
honest numerical check of the Bochner step:

* ``sector_fourier`` computes the Fourier coefficients of the indicators of
  ``m`` equal angular sectors;
* ``bochner_matrix`` compresses a positive-definite kernel with non-negative
  Fourier coefficients to those sectors.  The kernel weights are
  ``|zeta(sigma + i t (j+1))|^2 exp(-damping * j^2)``; they are positive, so
  the matrix is positive semidefinite by construction;
* ``min_eigenvalue`` and ``sweep`` report the smallest eigenvalue as the
  sector count and the damping change.

This is a finite model of the *Bochner positivity*, not the full zeta-weighted
projective system of the PDF, and it says nothing about the uniform limit.
"""

from __future__ import annotations

import numpy as np
import mpmath as mp

__all__ = [
    "sector_fourier",
    "zeta_weights",
    "bochner_matrix",
    "min_eigenvalue",
    "sweep",
]


def sector_fourier(m: int, tmax: int) -> np.ndarray:
    """Fourier coefficients ``c[k, j+tmax]`` of the ``m`` equal sector indicators.

    The sectors are ``[2*pi*k/m, 2*pi*(k+1)/m]`` and the coefficients are
    ``(1/2*pi) * integral_{I_k} exp(-i j theta) dtheta``.
    """
    if m < 1 or tmax < 0:
        raise ValueError("m >= 1 and tmax >= 0")
    c = np.zeros((m, 2 * tmax + 1), dtype=complex)
    for k in range(m):
        a = 2 * np.pi * k / m
        b = 2 * np.pi * (k + 1) / m
        c[k, tmax] = 1.0 / m
        for j in range(1, tmax + 1):
            val = (np.exp(-1j * j * a) - np.exp(-1j * j * b)) / (2 * np.pi * 1j * j)
            c[k, tmax + j] = val
            c[k, tmax - j] = np.conj(val)
    return c


def zeta_weights(
    tmax: int,
    sigma: float,
    t: float,
    damping: float,
    dps: int = 30,
) -> np.ndarray:
    """Positive kernel weights ``|zeta(sigma + i t (j+1))|^2 exp(-damping j^2)``."""
    mp.mp.dps = dps
    js = np.arange(-tmax, tmax + 1)
    weights = np.empty_like(js, dtype=float)
    for idx, j in enumerate(js):
        z = mp.zeta(mp.mpf(sigma) + 1j * mp.mpf(t) * (j + 1))
        weights[idx] = float(abs(z) ** 2) * np.exp(-damping * j * j)
    return weights


def bochner_matrix(
    m: int,
    tmax: int,
    sigma: float = 0.5,
    t: float = 1.0,
    damping: float = 1e-3,
) -> np.ndarray:
    """Compressed kernel matrix ``G[k,l] = sum_j w_j c[k,j] conj(c[l,j])``."""
    c = sector_fourier(m, tmax)
    w = zeta_weights(tmax, sigma, t, damping)
    return (c * w) @ c.conj().T


def min_eigenvalue(g: np.ndarray) -> float:
    """Smallest eigenvalue of a Hermitian matrix."""
    return float(np.linalg.eigvalsh(g)[0])


def sweep(
    m_values: list[int],
    tmax: int = 20,
    sigma: float = 0.5,
    t: float = 1.0,
    damping: float = 1e-3,
) -> list[tuple[int, float]]:
    """``(m, min eigenvalue)`` for each sector count."""
    out = []
    for m in m_values:
        g = bochner_matrix(m, tmax, sigma, t, damping)
        out.append((m, min_eigenvalue(g)))
    return out


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for m, val in sweep([2, 4, 8, 16, 32]):
        print(f"m = {m:3d}   min eigenvalue = {val:.6e}   m*min = {m*val:.6f}")
