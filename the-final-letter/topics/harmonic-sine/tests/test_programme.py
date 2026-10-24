import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    greedy_residuals,
    greedy_word,
    half_angle_sine,
    harmonic_angle,
    reconstruct_sine,
    residual_bound_holds,
    rotation_step,
    step_sine,
)


def _eq_nonneg(a: sp.Expr, b: sp.Expr) -> bool:
    """Exact equality of two non-negative expressions, via equal squares."""
    return (
        sp.trigsimp(sp.simplify(a ** 2 - b ** 2)) == 0
        and a.is_nonnegative is True
        and b.is_nonnegative is True
    )


def test_harmonic_angle_values_and_edge_case():
    assert sp.simplify(harmonic_angle(0) - PI / 2) == 0
    assert sp.simplify(harmonic_angle(3) - PI / 5) == 0
    with pytest.raises(ValueError):
        harmonic_angle(-1)
    with pytest.raises(ValueError):
        greedy_word(sp.Rational(1, 2), -1)


def test_half_angle_sine_identity_exact():
    for n in range(12):
        eps = harmonic_angle(n)
        lhs = half_angle_sine(n)
        rhs = sp.sin(eps / 2)
        assert _eq_nonneg(lhs, rhs)
        assert sp.simplify(lhs ** 2 - (1 - sp.cos(eps)) / 2) == 0
        assert sp.simplify(lhs ** 2 + sp.cos(eps / 2) ** 2 - 1) == 0


def test_source_half_angle_is_not_the_rotation_sine():
    # Erratum: h_n = sqrt((1 - cos(pi/(n+2)))/2) = sin(pi/(2(n+2))),
    # whereas the rotation update needs sin(pi/(n+2)).
    assert sp.simplify(half_angle_sine(0) - sp.sqrt(2) / 2) == 0
    assert sp.simplify(step_sine(0) - 1) == 0
    for n in range(6):
        assert sp.simplify(step_sine(n) - half_angle_sine(n)) != 0
    # Doubling the half-angle recovers the required step exactly.
    for n in range(6):
        assert _eq_nonneg(
            2 * half_angle_sine(n) * sp.cos(harmonic_angle(n) / 2),
            step_sine(n),
        )


def test_rotation_is_angle_addition_symbolic():
    theta, eps = sp.symbols("theta eps", real=True)
    s, c = sp.sin(theta), sp.cos(theta)
    s1, c1 = rotation_step(s, c, eps)
    assert sp.simplify(s1 - sp.sin(theta + eps)) == 0
    assert sp.simplify(c1 - sp.cos(theta + eps)) == 0


def test_rotation_preserves_unit_circle_symbolic():
    theta, eps = sp.symbols("theta eps", real=True)
    s, c = sp.sin(theta), sp.cos(theta)
    s1, c1 = rotation_step(s, c, eps)
    assert sp.simplify(s1 ** 2 + c1 ** 2 - 1) == 0
    # Degenerate steps: zero rotation and a right-angle rotation.
    assert rotation_step(s, c, 0) == (s, c)
    s2, c2 = rotation_step(s, c, PI / 2)
    assert sp.simplify(s2 - c) == 0 and sp.simplify(c2 + s) == 0


def test_greedy_residual_bound_on_grid():
    for k in range(25):
        y = sp.Rational(k, 24)
        for n_max in (1, 2, 5, 40, 200):
            assert residual_bound_holds(y, n_max)


def test_greedy_residual_boundary_equality_at_y_equals_one():
    # The source notes that equality r_n = pi/(n+1) is possible at n = 1,
    # y = 1.  Check it exactly in pi units: r_1 = 1/2 = 1/(1+1).
    rs = greedy_residuals(sp.Integer(1), 1)
    assert rs[1] == sp.Rational(1, 2)
    assert greedy_word(sp.Integer(1), 3) == [1, 1, 0, 0]


def test_reconstruction_convergence_with_stated_tolerance():
    tol = mp.mpf("1e-12")
    n_max = 400
    for k in range(1, 12):
        y = sp.Rational(k, 12)
        approx = reconstruct_sine(y, n_max)
        exact = mp.sin(mp.pi * mp.mpf(k) / 12)
        assert abs(approx - exact) <= tol
    # Endpoints and the source's exceptional target y = 1.
    for y in (sp.Integer(0), sp.Rational(1, 2), sp.Integer(1)):
        approx = reconstruct_sine(y, n_max)
        exact = mp.sin(mp.pi * mp.mpf(int(y.p)) / int(y.q))
        assert abs(approx - exact) <= tol
