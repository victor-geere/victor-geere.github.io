"""Tests for the prime/archimedean gap split."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import prime_arch_split as S  # noqa: E402


def test_components_sum_to_total():
    mp, ma = S.components_plain(12)
    from plain_basis_gap import fast_matrix_plain
    m = fast_matrix_plain(12)
    assert np.max(np.abs(mp + ma - m)) < 1e-9


def test_archimedean_gap_is_robust():
    for k in (12, 16, 20):
        mu = S.projected_spectra(k)["arch"]
        assert mu.min() > 0.1


def test_prime_gap_is_small():
    for k in (12, 16, 20):
        mu = S.projected_spectra(k)["prime"]
        assert mu.min() < 0.05


def test_total_gap_at_16_is_prime_driven():
    d = S.projected_spectra(16)
    assert d["total"].min() < d["arch"].min()
