"""Tests for the smooth-window gap stability."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import smooth_window_gap as S  # noqa: E402


def test_smooth_gap_positive_at_16_and_20():
    for k in (16, 20):
        d = S.gap_smooth(k)
        assert d["gap"] > 0.03
        assert d["cond_H"] < 2000


def test_gap_does_not_collapse_at_24():
    d = S.gap_smooth(24)
    assert d["gap"] > 0.03
