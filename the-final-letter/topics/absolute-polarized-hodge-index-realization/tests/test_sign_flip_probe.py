"""Tests for the archimedean sign-flip experiment."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import sign_flip_probe as S  # noqa: E402


def test_low_k_minus_is_negative_definite():
    for k in (4, 6):
        assert np.all(S.sign_eigs(k, -1) < 0)


def test_low_k_plus_is_not_negative_definite():
    assert np.any(S.sign_eigs(4, 1) > 0)


def test_higher_k_minus_develops_positive_directions():
    assert np.any(S.sign_eigs(8, -1) > 0)
