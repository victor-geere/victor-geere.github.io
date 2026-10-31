"""Tests for the finite Krein/Hodge structure."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import krein_hodge as K  # noqa: E402


def test_local_krein_structure():
    q, a = K.local_B(), K.local_A()
    out = K.check_krein(q, a)
    assert out["S2"] < 1e-12
    assert out["preserves"] < 1e-12
    assert out["S_A"] < 1e-12
    assert out["signature_S"] == (1, 2)
    assert out["signature_h"] == (3, 0)


def test_general_lorentzian():
    n = 4
    q = np.diag([1.0] + [-1.0] * (n - 1))
    a = np.array([1.0] + [0.0] * (n - 1))
    out = K.check_krein(q, a)
    assert out["S2"] < 1e-12
    assert out["preserves"] < 1e-12
    assert out["signature_S"] == (1, n - 1)
    assert out["signature_h"] == (n, 0)


def test_positive_definite_h():
    q, a = K.local_B(), K.local_A()
    h = K.hodge_riemann(q, K.reflection(q, a))
    assert np.all(np.linalg.eigvalsh(h) > 0)
