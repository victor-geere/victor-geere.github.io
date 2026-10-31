"""Linear-algebra checks on the CCM probe matrix."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import ccm_structure as C  # noqa: E402


def test_split_is_symmetric_plus_antisymmetric():
    sym, anti = C.split(C.PROBE_MATRIX)
    assert np.allclose(sym, sym.T)
    assert np.allclose(anti, -anti.T)
    assert np.allclose(sym + anti, C.PROBE_MATRIX)


def test_antisymmetric_dominance():
    assert C.antisymmetric_dominated()


def test_diagonal_is_small():
    assert np.max(np.abs(C.diagonal())) < 2e-3
