"""Tests for gap robustness across smooth windows."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import window_robustness as W  # noqa: E402


def test_well_conditioned_windows_are_stable():
    for name in ("sin2", "poly2"):
        for k in (16, 20, 24):
            d = W.gap_window(k, name)
            assert d["cond"] < 2500
            assert d["gap"] > 0.03


def test_poly2_is_best_conditioned():
    assert W.gap_window(24, "poly2")["cond"] < W.gap_window(24, "sin4")["cond"]
