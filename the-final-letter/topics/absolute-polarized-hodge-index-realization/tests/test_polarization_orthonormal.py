"""Tests for the orthonormal and degree-zero Hodge-index construction."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import polarization as P  # noqa: E402


def test_orthonormal_gram():
    d = P.check_orthonormal()
    assert d["gram_defect"] < 1e-9
    assert d["Omega_antisym"] < 1e-9


def test_star_identities_and_R_negative():
    d = P.check_orthonormal()
    assert d["U2_defect"] < 1e-9
    assert d["R_sym"] < 1e-9
    assert d["R_signature"] == (0, 4)
    assert np.all(d["R_eig"] < -1e-8)


def test_degree_zero_projection_negative_definite():
    d = P.check_orthonormal()
    assert abs(d["det_Omega_p"]) > 1e-6
    assert d["R_p_signature"] == (0, 2)
    assert np.all(d["R_p_eig"] < -1e-8)
