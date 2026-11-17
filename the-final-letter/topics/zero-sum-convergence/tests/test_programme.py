"""Tests for the zero-sum convergence computations (C1–C4)."""

import sys
from pathlib import Path

import mpmath
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    counting_ratio,
    gaussian_zero_sum,
    trivial_gaussian_sum,
    zero_count,
)

mpmath.mp.dps = 20


def test_zero_count_monotone():
    """C1: the zero count is non-decreasing in T."""
    assert zero_count(50.0) >= zero_count(20.0) >= 1


def test_counting_ratio_bounded():
    """C2: `N(T)/(T log T)` stays below 1 on the tested range."""
    for T in (20.0, 50.0, 100.0):
        assert counting_ratio(T) < 1.0


def test_gaussian_zero_partial_sums_converge():
    """C3: the Gaussian zero sums stabilise as T grows."""
    a = gaussian_zero_sum(1.0, 1.0, 25.0)
    b = gaussian_zero_sum(1.0, 1.0, 50.0)
    assert abs(a - b) < 1e-3


def test_trivial_gaussian_sum_converges():
    """C4: the trivial-zero Gaussian sum has a limit as N grows."""
    a = trivial_gaussian_sum(1.0, 50)
    b = trivial_gaussian_sum(1.0, 200)
    assert abs(a - b) < 1e-10
