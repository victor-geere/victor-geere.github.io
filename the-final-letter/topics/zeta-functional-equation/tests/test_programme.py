"""Tests for the zeta functional-equation computations (C1–C4)."""

import sys
from pathlib import Path

import mpmath
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    completed_zeta,
    critical_line_zero,
    functional_equation_residual,
    log_deriv_zeta,
    trivial_zero_value,
)


def test_functional_equation_residual_small():
    """C1: `Λ(1 − s) = Λ(s)` to numerical precision."""
    mpmath.mp.dps = 25
    for s in (0.7 + 2.1j, 1.3 - 4.4j, 2.5 + 0.3j):
        assert functional_equation_residual(s) < 1e-18


def test_completed_zeta_value_at_two():
    """C2: `Λ(2) = π^{−1} ζ(2) = π/6`."""
    mpmath.mp.dps = 30
    assert abs(completed_zeta(2) - mpmath.pi / 6) < 1e-25


def test_critical_line_zeros_are_zeros():
    """C3: `|ζ(1/2 + iγ_1)|` is tiny at the first zero."""
    mpmath.mp.dps = 20
    gamma = critical_line_zero(1)
    assert abs(mpmath.zeta(mpmath.mpc(0.5, gamma))) < 1e-8


def test_log_deriv_finite_on_critical_line():
    """C4: `ζ′/ζ` is finite at a non-zero point of the critical line."""
    value = log_deriv_zeta(0.5 + 3.0j)
    assert abs(value) < 10


def test_trivial_zeros_vanish():
    """C4b: `ζ(−2n) = 0` for the first few trivial zeros."""
    for n in (1, 2, 3):
        assert abs(trivial_zero_value(n)) < 1e-20
