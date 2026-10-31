"""Tests for the zero-sum growth obstruction."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import zero_sum_probe as Z  # noqa: E402


def test_fourier_transform_grows_in_imaginary_direction():
    vals = Z.growth([1, 5, 10, 14])
    assert vals[0] < vals[1] < vals[2] < vals[3]
    assert vals[3] > 10 * vals[0]
