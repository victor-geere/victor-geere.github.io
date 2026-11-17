"""Tests for the geometric-zeta computations (G1–G6)."""

import sys
from pathlib import Path

import mpmath
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    additive_residual,
    all_bases_partial,
    is_perfect_power,
    lambert_residual,
    lattice_bound_ratio,
    lattice_lower_bound,
    log_residual,
    non_perfect_powers,
    prime_power_log_partial,
)


def test_additive_identity_at_two():
    """G2: ζ(2) = 1 + Σ_{a∈A} 1/(a²−1), at the tail-consistent tolerance."""
    mpmath.mp.dps = 20
    assert additive_residual(2, 20000) < 1e-4


def test_additive_identity_complex():
    """G2: the same identity at a complex point with Re s > 1."""
    mpmath.mp.dps = 15
    assert additive_residual(2.5 + 0.4j, 5000) < 1e-3


def test_all_bases_are_not_zeta():
    """G2: using all bases a ≥ 2 gives 7/4 at s = 2, not ζ(2)."""
    mpmath.mp.dps = 15
    assert abs(all_bases_partial(2, 200) - mpmath.mpf(7) / 4) < 2e-2
    assert abs(all_bases_partial(2, 200) - mpmath.zeta(2)) > 0.05


def test_perfect_power_count():
    """G2: perfect powers are sparse; non-perfect-powers have density 1."""
    n_max = 10000
    pp = sum(is_perfect_power(n) for n in range(1, n_max + 1))
    assert pp < int(mpmath.sqrt(n_max) * mpmath.log(n_max, 2)) + 1
    assert len(non_perfect_powers(n_max)) >= n_max - pp - 1


def test_lambert_identity():
    """G3: Σ_k q^k/(1−q^k) = Σ_n d(n)q^n for |q| < 1."""
    mpmath.mp.dps = 20
    assert lambert_residual(0.5, 60) < 1e-15


def test_log_identity():
    """G4: log ζ(s) = Σ_p Σ_m p^{−ms}/m on Re s > 1."""
    mpmath.mp.dps = 15
    assert log_residual(2, 2000) < 1e-3


def test_prime_power_log_partial_positive():
    """G4: every term of the logarithmic sum is positive on the real axis."""
    mpmath.mp.dps = 15
    assert prime_power_log_partial(2, 2000).real > 0


def test_lattice_lower_bound_valid():
    """The J=0,1,2 lattice bounds are below ζ(σ)^2 and improve with J."""
    mpmath.mp.dps = 15
    for sigma in (2.0, 3.0):
        z2 = mpmath.zeta(sigma) ** 2
        prev = mpmath.mpf(0)
        for J in (0, 1, 2):
            b = lattice_lower_bound(sigma, J, 40)
            assert b < z2
            assert b > prev
            prev = b


def test_lattice_j0_ratio():
    """The J=0 AM-GM bound is non-trivial at σ=2 (ratio above 0.6)."""
    mpmath.mp.dps = 15
    assert 0.6 < lattice_bound_ratio(2.0, 0, 40) < 1.0


def test_lattice_higher_order_ratio():
    """At σ=3 the J=3 bound is already above 0.95 of ζ(3)^2."""
    mpmath.mp.dps = 15
    assert 0.95 < lattice_bound_ratio(3.0, 3, 40) < 1.0
