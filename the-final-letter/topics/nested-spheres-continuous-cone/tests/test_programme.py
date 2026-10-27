import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    fibre_radius,
    fibre_radii,
    local_diagonal,
    local_diagonal_integral,
    mean_zero_coeff,
    period_coeff_sum,
    phi_energy,
    phi_mean,
    purification_factor,
    sampling_arc,
    sampling_chord,
    sampling_ratio,
)


def test_fibre_radius_pos_and_nesting():
    """C1: radii are positive, strictly nested, and exact rationals."""
    radii = fibre_radii(50)
    assert radii[0] == 1
    assert all(r > 0 for r in radii)
    assert all(radii[i + 1] < radii[i] for i in range(len(radii) - 1))
    assert fibre_radius(7) == sp.Rational(1, 7)
    with pytest.raises(ValueError):
        fibre_radius(0)
    with pytest.raises(ValueError):
        fibre_radii(-2)


def test_mean_zero_coeff_and_period_sum():
    """C2: every period sums to zero and the exceptional value is 1 - N."""
    for N in range(1, 31):
        assert period_coeff_sum(N) == 0
        assert mean_zero_coeff(N, N) == 1 - N
        for m in range(1, 2 * N + 1):
            expected = 1 - N if m % N == 0 else 1
            assert mean_zero_coeff(N, m) == expected
    # Edge cases: N = 1 makes every coefficient zero.
    assert [mean_zero_coeff(1, m) for m in range(1, 5)] == [0, 0, 0, 0]
    with pytest.raises(ValueError):
        mean_zero_coeff(0, 1)
    with pytest.raises(ValueError):
        mean_zero_coeff(3, 0)


def test_purification_factor_vanishes_at_one():
    """C3: the factor 1 - N^{1-s} is zero at s = 1 and 1 - N at s = 0."""
    s = sp.symbols("s")
    for N in (2, 3, 10, 101):
        assert sp.simplify(purification_factor(N, 1)) == 0
        assert sp.simplify(purification_factor(N, 0)) == 1 - N
        assert sp.simplify(purification_factor(N, s) - (1 - N ** (1 - s))) == 0
    with pytest.raises(ValueError):
        purification_factor(0, s)


def test_sampling_chord_below_arc():
    """C4: 2 sin(π/N) < 2π/N for N >= 2 and the ratio tends to one."""
    for N in range(2, 201):
        gap = sp.N(sampling_arc(N) - sampling_chord(N), 40)
        assert gap > 0
    ratio_10 = sp.N(sampling_ratio(10), 30)
    ratio_1000 = sp.N(sampling_ratio(1000), 30)
    assert ratio_10 < ratio_1000 < 1
    # N = 1 is degenerate: the chord is zero, the arc is 2π.
    assert sampling_chord(1) == 0
    assert sp.simplify(sampling_arc(1) - 2 * PI) == 0
    with pytest.raises(ValueError):
        sampling_chord(0)


def test_local_diagonal_integral_corrected():
    """C5: the exact integral equals -∫φ + R∫φ², never the constant -1/2."""
    R = sp.symbols("R", real=True)
    u = sp.symbols("u", real=True)
    test_functions = [
        lambda v: sp.Rational(1, 2),
        lambda v: sp.Rational(3, 4) * (1 - v ** 2),
    ]
    for phi in test_functions:
        mean = phi_mean(phi)
        energy = phi_energy(phi)
        assert sp.simplify(mean - 1) == 0  # normalised filter
        assert sp.simplify(
            local_diagonal_integral(phi, R) - local_diagonal(R, mean, energy)
        ) == 0
    # For φ = 1/2 the corrected value is -1 + R/2, not -1/2.
    assert sp.simplify(local_diagonal(R, 1, sp.Rational(1, 2)) - (-1 + R / 2)) == 0


def test_local_diagonal_edge_cases():
    """C6: zero radius and zero energy both give the constant -1."""
    R, q = sp.symbols("R q", real=True)
    assert sp.simplify(local_diagonal(0, 1, q) + 1) == 0
    assert sp.simplify(local_diagonal(R, 1, 0) + 1) == 0
    assert sp.simplify(sp.diff(local_diagonal(R, 1, q), R) - q) == 0
