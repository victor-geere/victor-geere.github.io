"""Tests for the L2 polarization and compatible Hodge star."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import polarization as P  # noqa: E402


def test_l2_gram_positive_definite():
    h = P.l2_gram()
    assert np.all(np.linalg.eigvalsh(h) > 0)


def test_compatible_star_identities():
    d = P.check()
    assert d["U2_defect"] < 1e-8
    assert d["H_orth_defect"] < 1e-8


def test_hodge_index_form_symmetric_and_negative():
    d = P.check()
    assert d["R_sym_defect"] < 1e-8
    assert d["R_signature"] == (0, 4)
    assert np.all(d["R_eig"] < -1e-8)
