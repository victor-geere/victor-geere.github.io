"""Tests for the UV localization of the K=16 small eigenvector."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import uv_localization as U  # noqa: E402


def test_total_small_vector_is_uv_localized():
    d = U.small_vectors()
    assert d["total"]["participation"] < 5.0
    assert d["total"]["top_mass"] > 0.8
    assert min(d["total"]["top"]) >= 12


def test_prime_and_arch_small_vectors_are_broader():
    d = U.small_vectors()
    assert d["prime"]["participation"] > d["total"]["participation"]
    assert d["arch"]["participation"] > d["prime"]["participation"]
