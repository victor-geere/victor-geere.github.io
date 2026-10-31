"""Tests for the finite KMS Hodge index."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import kms_transverse as K  # noqa: E402


def test_formula_matches_explicit_sum():
    for n in (2, 3):
        rho = K.random_density(n, seed=1)
        for a in K.hermitian_basis(n):
            assert abs(K.transverse_form(rho, a) - K.explicit_form(rho, a)) < 1e-10


def test_nonnegative_on_the_algebra():
    for n in (2, 3, 4):
        rho = K.random_density(n, seed=2)
        for a in K.hermitian_basis(n):
            assert K.transverse_form(rho, a) >= -1e-12


def test_hodge_index_on_kernel():
    for n in (2, 3, 4):
        for seed in range(3):
            rho = K.random_density(n, seed=seed)
            g = K.form_matrix_on_kernel(rho)
            assert np.all(np.linalg.eigvalsh(g) <= 1e-9)


def test_equality_iff_commuting():
    rho = np.diag([0.3, 0.7])
    commuting = np.diag([1.0, -1.0])
    assert abs(K.transverse_form(rho, commuting)) < 1e-12
    noncommuting = np.array([[0.0, 1.0], [1.0, 0.0]], dtype=complex)
    assert K.transverse_form(rho, noncommuting) > 1e-6
