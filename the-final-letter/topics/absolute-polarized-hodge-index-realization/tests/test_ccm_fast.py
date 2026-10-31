"""Cross-check of the CCM probe by two independent quadrature methods."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import ccm_fast as F  # noqa: E402


def test_fast_matches_mpmath_probe():
    m = F.fast_matrix()
    assert np.max(np.abs(m - F.PROBE_MPMATH)) < 1e-7
