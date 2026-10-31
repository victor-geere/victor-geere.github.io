"""Tests for the large-K poly2 resonance."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import large_k_gap as L  # noqa: E402


def test_gap_is_stable_through_28_then_dips():
    assert L.gap_poly2(28) > 0.03
    assert L.gap_poly2(32) < 0.02


def test_dip_is_stable_under_quadrature():
    a = L.gap_poly2(32, n_nodes=200)
    b = L.gap_poly2(32, n_nodes=300)
    assert abs(a - b) < 1e-9


def test_recovery_at_36_and_40():
    assert L.gap_poly2(36) > 0.015
    assert L.gap_poly2(40) > 0.02
