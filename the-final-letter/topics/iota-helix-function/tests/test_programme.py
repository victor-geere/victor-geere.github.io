import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    eta_partial,
    eta_x,
    eta_y,
    greedy_dot,
    helix_x,
    helix_y,
    paired_partial,
    phase,
    radius,
    source_greedy_dot,
)


def test_radius_and_index_edge_cases():
    """C3: radius edge cases and index validation."""
    # The first step has unit radius for every real σ.
    assert radius(sp.Rational(1, 2), 1) == 1
    assert radius(-sp.Rational(3, 2), 1) == 1
    # σ = 0 is the boundary case: every step has unit length.
    assert radius(0, 7) == 1
    # The iota sequence is 1-based.
    with pytest.raises(ValueError):
        radius(sp.Rational(1, 2), 0)
    with pytest.raises(ValueError):
        phase(0, -3)


def test_helix_components_match_eta_terms():
    """C1: the helix coordinates equal the eta term components exactly."""
    for sigma in (sp.Rational(1, 2), sp.Integer(1), sp.Rational(3, 2)):
        for t in (sp.Rational(1, 3), sp.Integer(2)):
            for n in range(1, 8):
                dx = sp.simplify(sp.expand_trig(helix_x(sigma, t, n)) - eta_x(sigma, t, n))
                dy = sp.simplify(sp.expand_trig(helix_y(sigma, t, n)) - eta_y(sigma, t, n))
                assert dx == 0
                assert dy == 0


def test_first_step_is_one():
    """C2: at n = 1 the walk moves by exactly 1, for every s."""
    for sigma in (sp.Rational(1, 2), sp.Integer(3)):
        for t in (sp.Integer(0), sp.Rational(5, 7)):
            assert sp.simplify(helix_x(sigma, t, 1)) == 1
            assert sp.simplify(helix_y(sigma, t, 1)) == 0


def test_step_length_identity():
    """C4: |v_n|² = r_n² = n^(-2σ)."""
    for sigma in (sp.Rational(1, 2), sp.Integer(2)):
        for n in range(1, 9):
            lhs = helix_x(sigma, sp.Rational(2, 5), n) ** 2
            lhs += helix_y(sigma, sp.Rational(2, 5), n) ** 2
            assert sp.simplify(lhs - radius(sigma, n) ** 2) == 0


def test_phase_increment_identity():
    """C5: Φ_{n+1} - Φ_n = π - t log((n+1)/n)."""
    t = sp.Rational(3, 5)
    for n in range(1, 10):
        lhs = sp.simplify(phase(t, n + 1) - phase(t, n))
        rhs = PI - t * sp.log(sp.Rational(n + 1, n))
        assert sp.simplify(lhs - rhs) == 0


def test_finite_eta_pairing():
    """C6: the even eta partial sums equal the paired positive sums."""
    for sigma in (sp.Rational(1, 2), sp.Integer(2)):
        for M in range(1, 8):
            assert sp.simplify(eta_partial(sigma, 2 * M) - paired_partial(sigma, M)) == 0
        # Each pair is positive for σ > 0.
        for k in range(1, 8):
            assert sp.N(radius(sigma, 2 * k - 1) - radius(sigma, 2 * k), 30) > 0


def test_real_axis_greedy_pattern():
    """C7: at t = 0, GC holds at N = 1 and even N, and fails at odd N ≥ 3."""
    for sigma in (sp.Rational(1, 2), sp.Integer(2)):
        for N in range(1, 21):
            dot = sp.N(greedy_dot(sigma, 0, N), 30)
            if N == 1:
                assert dot == 0
            elif N % 2 == 0:
                assert dot < 0
            else:
                assert dot > 0


def test_source_pairing_omits_alternating_sign():
    """C8: the note's w_N = N^(-s) pairing is not the dot product with v_N.

    At σ = 1/2, t = 0 and N = 2 the source expression is positive while the
    geometric dot product with the actual step is negative.
    """
    sigma = sp.Rational(1, 2)
    assert sp.N(source_greedy_dot(sigma, 0, 2), 30) > 0
    assert sp.N(greedy_dot(sigma, 0, 2), 30) < 0
    # The two pairings differ exactly by the omitted sign (-1)^(N-1).
    for N in range(1, 7):
        lhs = greedy_dot(sigma, sp.Rational(1, 3), N)
        rhs = (-1) ** (N - 1) * source_greedy_dot(sigma, sp.Rational(1, 3), N)
        # The identity is exact; sympy leaves the log-trigonometric form
        # unevaluated, so we check it at 30 digits (tolerance 1e-20).
        assert abs(complex(sp.N(lhs - rhs, 30))) < 1e-20
