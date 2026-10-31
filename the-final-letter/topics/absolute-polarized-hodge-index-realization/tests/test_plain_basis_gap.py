"""Tests for the plain-sine-basis gap and its near-degeneracy."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import plain_basis_gap as G  # noqa: E402


def test_gap_values():
    mu = G.gap_plain(12)
    assert abs(mu.min() - 0.24494312) < 1e-6
    mu16 = G.gap_plain(16)
    assert abs(mu16.min() - 0.03700702) < 1e-6


def test_gap_is_not_monotone():
    g14 = G.gap_plain(14).min()
    g16 = G.gap_plain(16).min()
    g18 = G.gap_plain(18).min()
    assert g16 < g14
    assert g16 < g18


def test_near_degeneracy_is_stable_under_quadrature():
    a = G.gap_plain(16, n_nodes=120).min()
    b = G.gap_plain(16, n_nodes=240).min()
    assert abs(a - b) < 1e-7
