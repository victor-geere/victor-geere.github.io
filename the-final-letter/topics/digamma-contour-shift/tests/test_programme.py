"""Tests for the digamma-expansion computations (C1–C3)."""

import sys
from pathlib import Path

import mpmath
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    digamma_expansion_value,
    digamma_remainder,
    remainder_bound,
    remainder_ratio,
)


def test_expansion_close_to_digamma():
    """C1: the truncation is close to ψ at moderate arguments."""
    w = 2 + 3j
    assert abs(digamma_remainder(w)) < 1e-3


def test_remainder_bound_holds():
    """C2: the harvested bound 1/(81 (Re w)^5) holds."""
    for w in (1 + 1j, 2 + 5j, 0.5 + 2j, 3 + 10j):
        assert remainder_ratio(w) <= 1.0


def test_remainder_decays():
    """C3: the remainder decays as the argument grows."""
    r_small = abs(digamma_remainder(2 + 2j))
    r_large = abs(digamma_remainder(2 + 20j))
    assert r_large < r_small


def test_bound_rejects_nonpositive_real_part():
    """Edge case: the bound is only stated for positive real part."""
    with pytest.raises(ValueError):
        remainder_bound(-1 + 1j)
