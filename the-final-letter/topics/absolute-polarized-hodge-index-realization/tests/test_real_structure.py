"""Tests for the finite real structure."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import kms_transverse as K  # noqa: E402
import real_structure as R  # noqa: E402


def test_j_squares_to_minus_one():
    basis = K.hermitian_basis(3)
    jm = R.j_map(3)
    for i, (j, s) in jm.items():
        assert jm[j] == (i, -s)


def test_real_form_is_symmetric():
    rho = K.random_density(3, seed=12)
    g = R.real_form_matrix(rho)
    assert np.allclose(g, g.T, atol=1e-10)


def test_signature_is_state_dependent():
    sigs = {R.signature(K.random_density(3, seed=s)) for s in range(6)}
    assert len(sigs) > 1
    for pos, neg, zero in sigs:
        assert pos + neg + zero == 9
