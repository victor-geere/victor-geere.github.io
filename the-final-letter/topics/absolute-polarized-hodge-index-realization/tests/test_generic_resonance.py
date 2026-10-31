"""Tests for the generic K=32 resonance."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import generic_resonance as R  # noqa: E402


def test_both_windows_dip_at_32():
    assert R.gap_window(28, "sin2")["gap"] > 0.03
    assert R.gap_window(28, "poly2")["gap"] > 0.03
    assert R.gap_window(32, "sin2")["gap"] < 0.02
    assert R.gap_window(32, "poly2")["gap"] < 0.02


def test_sin2_dip_is_deeper():
    assert R.gap_window(32, "sin2")["gap"] < R.gap_window(32, "poly2")["gap"]
