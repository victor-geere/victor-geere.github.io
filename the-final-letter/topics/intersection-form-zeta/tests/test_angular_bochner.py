"""Finite checks for the angular Bochner normal-form note.

These tests verify only the Bochner step of the framework: the sector Fourier
coefficients, the Hermitian positive-semidefinite compression, and the absence
of a uniform gap in the equal-sector model.  They say nothing about the
uniform limit, which the note identifies with Weil positivity / RH.
"""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import angular_bochner as A  # noqa: E402


def test_sector_fourier_orthogonality():
    m, tmax = 8, 12
    c = A.sector_fourier(m, tmax)
    assert c.shape == (m, 2 * tmax + 1)
    for k in range(m):
        assert abs(c[k, tmax] - 1 / m) < 1e-14
    for j in range(1, tmax + 1):
        assert abs(c[:, tmax + j].sum()) < 1e-12
        assert abs(c[:, tmax - j].sum()) < 1e-12
        for k in range(m):
            assert abs(c[k, tmax - j] - np.conj(c[k, tmax + j])) < 1e-14


def test_gram_is_hermitian_psd():
    for m in (4, 8, 16):
        g = A.bochner_matrix(m, tmax=20, sigma=0.5, t=1.0, damping=1e-3)
        assert np.allclose(g, g.conj().T, atol=1e-12)
        assert A.min_eigenvalue(g) > -1e-10


def test_min_eigenvalue_decays_with_sectors():
    values = A.sweep([4, 8, 16, 32], tmax=20, damping=1e-3)
    eigs = [v for _, v in values]
    assert all(v > 0 for v in eigs)
    assert eigs[0] > eigs[-1]
    # The model has no uniform gap: m * min eigenvalue decreases.
    scaled = [m * v for m, v in values]
    assert scaled[0] > scaled[-1]


def test_zeta_weights_are_positive():
    w = A.zeta_weights(tmax=8, sigma=0.5, t=1.0, damping=1e-3)
    assert len(w) == 17
    assert np.all(w > 0)
