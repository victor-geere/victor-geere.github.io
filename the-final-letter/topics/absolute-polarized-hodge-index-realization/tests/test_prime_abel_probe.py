"""Tests for the Abel-regularization obstruction."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import prime_abel_probe as P  # noqa: E402


def test_abel_sums_do_not_converge():
    s1 = P.abel_sum(0.01, 1.0, x_max=500_000)
    s2 = P.abel_sum(0.001, 1.0, x_max=500_000)
    s3 = P.abel_sum(0.0001, 1.0, x_max=500_000)
    assert abs(s1 - s2) > 1.0
    assert abs(s2 - s3) > 1.0
