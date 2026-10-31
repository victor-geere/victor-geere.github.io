"""Tests for the finite Hodge-Riemann package."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import finite_hodge_riemann as H  # noqa: E402
import kms_transverse as K  # noqa: E402


def test_Cs_explicit_formula():
    rho = K.random_density(3, seed=4)
    a = K.hermitian_basis(3)[-1]
    p = np.diag(rho)
    for s in (0.0, 0.5, 1.0):
        expected = sum(
            p[i] ** s * p[j] ** (1 - s) * abs(a[i, j]) ** 2
            for i in range(3) for j in range(3)
        )
        assert abs(H.C_s(rho, a, s) - expected) < 1e-12


def test_half_weight_positive():
    for n in (2, 3, 4):
        rho = K.random_density(n, seed=5)
        assert H.half_weight_positive(rho)


def test_derivative_is_minus_transverse():
    for n in (2, 3):
        rho = K.random_density(n, seed=6)
        for a in K.hermitian_basis(n):
            assert abs(H.derivative_C(rho, a) + K.transverse_form(rho, a)) < 1e-4
