"""Tests for the archimedean comparison."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import arch_compare as C  # noqa: E402


def test_crossings_are_distinct_but_close():
    d = C.crossings()
    assert abs(d["ccm"] - 6.2288527370) < 1e-8
    assert abs(d["weil"] - 6.2898359888) < 1e-8
    assert 0 < d["weil"] - d["ccm"] < 0.1


def test_opposite_signs_at_zero():
    assert C.weil_omega(0) < 0
    from arch_symbol import arch_real
    assert arch_real(0.01) > 0
