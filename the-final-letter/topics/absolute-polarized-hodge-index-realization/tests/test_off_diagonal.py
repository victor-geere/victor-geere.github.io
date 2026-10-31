"""Tests for the off-diagonal dictionary."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import kms_transverse as K  # noqa: E402
import off_diagonal as O  # noqa: E402


def test_diagonal_derivative_vanishes():
    rho = K.random_density(3, seed=8)
    for a in K.hermitian_basis(3):
        assert O.diagonal_vanishes(rho, a)


def test_off_diagonal_is_nonzero():
    rho = K.random_density(3, seed=9)
    basis = K.hermitian_basis(3)
    d = O.derivative_off(rho, basis[3], basis[4])
    assert abs(d) > 1e-8
    # On Hermitian pairs the form is purely imaginary.
    assert abs(d.real) < 1e-6


def test_conjugate_symmetry():
    rho = K.random_density(3, seed=10)
    basis = K.hermitian_basis(3)
    assert O.symmetry_check(rho, basis[0], basis[1])
