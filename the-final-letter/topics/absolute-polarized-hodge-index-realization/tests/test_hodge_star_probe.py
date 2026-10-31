"""Tests for the Hodge-star compatibility obstruction."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import hodge_star_probe as H  # noqa: E402


def test_S_is_ill_conditioned_and_indefinite():
    d = H.star_diagnostics()
    assert d["cond_S"] > 100
    assert np.sum(d["eig_S"] > 0) == 2
    assert np.sum(d["eig_S"] < 0) == 2


def test_T_eigenvalues_are_purely_imaginary():
    d = H.star_diagnostics()
    assert np.max(np.abs(np.real(d["eig_T"]))) < 1e-8


def test_T2_is_not_scalar():
    d = H.star_diagnostics()
    assert d["t2_defect"] > 1e3
