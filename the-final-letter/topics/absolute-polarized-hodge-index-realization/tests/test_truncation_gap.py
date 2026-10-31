"""Tests for the spectral-gap behaviour under truncation."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import truncation_gap as G  # noqa: E402


def test_even_truncations_are_negative_definite():
    for k in (4, 6):
        d = G.gap_for(k)
        assert not d["degenerate"]
        assert np.all(d["R_eig"] < -1e-8)
        assert d["min_gap"] > 0.1


def test_odd_truncation_has_zero_mode():
    for k in (5, 7):
        d = G.gap_for(k)
        assert d["degenerate"]
        assert d["min_gap"] is None


def test_gap_decreases_with_basis_size():
    g4 = G.gap_for(4)["min_gap"]
    g6 = G.gap_for(6)["min_gap"]
    g8 = G.gap_for(8)["min_gap"]
    g10 = G.gap_for(10)["min_gap"]
    assert g4 > g6 > g8 > g10
    assert g10 > 0


def test_gap_decay_slows():
    g6 = G.gap_for(6)["min_gap"]
    g8 = G.gap_for(8)["min_gap"]
    g10 = G.gap_for(10)["min_gap"]
    r1 = g8 / g6
    r2 = g10 / g8
    assert r2 > r1
