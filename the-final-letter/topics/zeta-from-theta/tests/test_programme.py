"""Tests for the theta-first development (C1–C4)."""

import sys
from pathlib import Path

import mpmath
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    bridge_residual,
    completed_zeta,
    completed_zeta_theta,
    dirichlet_zeta,
    functional_equation_residual_theta,
    gamma_R,
)


def test_dirichlet_bridge_at_two():
    """C1: the Dirichlet series reproduces ζ(2) = π²/6.

    The tail of the partial sum is bounded by `N^{1−σ}/(σ−1)`; at `σ = 2`,
    `N = 2·10⁴` this is `5·10⁻⁵`.
    """
    mpmath.mp.dps = 20
    assert abs(dirichlet_zeta(2, 20000) - mpmath.pi ** 2 / 6) < 1e-4


def test_bridge_residual_small():
    """C1: `Σ n^{−s}` agrees with `ζ(s)` on `Re s > 1`.

    Tolerances are the tail bound `N^{1−σ}/(σ−1)`, not machine precision.
    """
    mpmath.mp.dps = 20
    for s, tol in ((2.0, 1e-4), (3.2 - 1.1j, 1e-6), (4.0, 1e-8)):
        assert bridge_residual(s, 20000) < tol


def test_bridge_residual_decreases():
    """C1: the bridge residual decreases as `N` grows (convergence)."""
    mpmath.mp.dps = 20
    assert bridge_residual(2.0, 20000) < bridge_residual(2.0, 2000)


def test_gamma_R_at_two():
    """C4: `Γℝ(2) = π^{−1} Γ(1) = 1/π`."""
    mpmath.mp.dps = 20
    assert abs(gamma_R(2) - 1 / mpmath.pi) < 1e-18


def test_theta_side_matches_completed_zeta():
    """C2: the theta-side `Λ_θ` equals `Λ` on `Re s > 1`."""
    mpmath.mp.dps = 15
    for s in (2.0, 2.5 + 0.4j):
        assert abs(completed_zeta_theta(s) - completed_zeta(s)) < 1e-8


def test_theta_side_functional_equation():
    """C3: `Λ_θ(1 − s) = Λ_θ(s)` numerically."""
    mpmath.mp.dps = 15
    for s in (2.0, 2.5 + 0.4j):
        assert functional_equation_residual_theta(s) < 1e-8
