"""Tests for the smooth-basis sign flip."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import smooth_sign_flip as S  # noqa: E402


def test_smooth_minus_is_negative_definite_at_4():
    assert np.all(S.smooth_sign_eigs(4, -1) < 0)


def test_smooth_minus_is_not_uniform_at_6():
    # One positive direction appears; the sign convention is not settled.
    assert np.any(S.smooth_sign_eigs(6, -1) > 0)


def test_smooth_plus_is_not_negative_definite_at_4():
    assert np.any(S.smooth_sign_eigs(4, 1) > 0)
