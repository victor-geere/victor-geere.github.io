"""Tests for the local polarized Hodge-index realization."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import local_polarization as L  # noqa: E402


def test_signature_and_ample_class():
    assert L.signature() == (1, 2)
    assert L.intersection(L.A, L.A) == 6


def test_hodge_inequality_on_a_grid():
    for a in range(-4, 5):
        for b in range(-4, 5):
            for c in range(-4, 5):
                d = (a, b, c)
                assert L.hodge_holds(d)
                assert 6 * L.intersection(d, d) - L.intersection(L.A, d) ** 2 == L.defect(d)


def test_equality_iff_multiple_of_ample():
    for t in range(-3, 4):
        d = (t, t, t)
        assert 6 * L.intersection(d, d) == L.intersection(L.A, d) ** 2
    assert L.defect((1, 0, 0)) < 0


def test_negative_definite_on_ample_orthogonal():
    gram = L.restricted_gram([[1, -1, 0], [1, 1, -2]])
    assert np.all(np.linalg.eigvalsh(gram.astype(float)) < 0)
    for v in ([1, -1, 0], [1, 1, -2], [2, 0, -2]):
        assert L.intersection(L.A, v) == 0
