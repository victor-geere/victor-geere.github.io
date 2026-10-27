import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    ccm_fourier_matrix,
    cone_radius,
    cone_radius_ratio,
    helix_torsion,
    intersection_abscissa,
    intersection_point,
    mobius_log_coefficient,
    prime_power_weights,
    prime_weight,
    scaled_helix_torsion,
    source_log_coefficient,
    source_torsion_linear_phase,
    verify_helix_torsion,
    verify_scaled_helix_torsion,
)


def test_helix_torsion_from_frenet_formula():
    for omega in (sp.Rational(1, 2), sp.Integer(1), sp.Rational(3, 2), sp.Integer(2)):
        assert verify_helix_torsion(omega)
        assert sp.simplify(
            helix_torsion(omega) - omega / (1 + omega**2)
        ) == 0
    assert sp.simplify(helix_torsion(1) - sp.Rational(1, 2)) == 0


def test_scaled_helix_and_constant_radius_counterexample():
    # c = 1 recovers the unit helix.
    assert verify_scaled_helix_torsion(1, sp.Rational(3, 2))
    assert sp.simplify(
        scaled_helix_torsion(1, sp.Rational(3, 2))
        - helix_torsion(sp.Rational(3, 2))
    ) == 0
    # c = 1/2, omega = 1: the source's constant-scaling step is false.
    assert sp.simplify(
        scaled_helix_torsion(sp.Rational(1, 2), 1) - sp.Rational(4, 5)
    ) == 0
    assert sp.simplify(
        scaled_helix_torsion(sp.Rational(1, 2), 1) - helix_torsion(1)
    ) != 0


def test_source_torsion_formula_is_not_frenet_torsion():
    omega = sp.symbols("omega", positive=True)
    # Equation (3.2) at linear phase is the true torsion divided by (1 + ω²).
    assert sp.simplify(
        source_torsion_linear_phase(omega)
        - helix_torsion(omega) / (1 + omega**2)
    ) == 0
    # At ω = 1 it predicts 1/4, while the Frenet torsion is 1/2.
    assert sp.simplify(source_torsion_linear_phase(1) - sp.Rational(1, 4)) == 0
    assert sp.simplify(helix_torsion(1) - sp.Rational(1, 2)) == 0


def test_cone_radius_ratio_decay_and_edge():
    sigma, t = sp.Integer(1), sp.Integer(2)
    # Edge case k = 0: the first intersection has radius x_0^0 = 1.
    assert sp.simplify(cone_radius(sigma, t, 0) - 1) == 0
    # Exact geometric ratio, independent of k.
    for k in range(5):
        assert sp.simplify(
            cone_radius_ratio(sigma, t, k)
            - sp.exp(-sigma * PI / t)
        ) == 0
    # Strict decay for sigma, t > 0.
    for k in range(6):
        assert sp.N(cone_radius(sigma, t, k + 1), 40) < sp.N(
            cone_radius(sigma, t, k), 40
        )
    with pytest.raises(ValueError):
        cone_radius(0, t, 1)
    with pytest.raises(ValueError):
        cone_radius(sigma, 0, 1)


def test_intersection_polygon_points():
    sigma, t = sp.Integer(1), sp.Integer(3)
    # P_k lies in the xz-plane by construction.
    for k in range(5):
        x, y, z = intersection_point(sigma, t, k)
        assert y == 0
        assert sp.simplify(z - intersection_abscissa(t, k)) == 0
        assert sp.simplify(x - (-1) ** k * cone_radius(sigma, t, k)) == 0
    # Edge case: P_0 = (1, 0, 1).
    assert intersection_point(sigma, t, 0) == (1, 0, 1)
    # Abscissae strictly increase and the sign of x alternates.
    for k in range(5):
        assert sp.N(intersection_abscissa(t, k + 1), 40) > sp.N(
            intersection_abscissa(t, k), 40
        )
        assert sp.sign((-1) ** k) == (-1) ** k


def test_mobius_identity_source_mismatch():
    # Coefficient of p^{-ks} in Σ μ(n)/n log ζ(ns): 1 at k=1, 0 otherwise.
    for k in range(1, 9):
        expected = sp.Integer(1) if k == 1 else sp.Integer(0)
        assert mobius_log_coefficient(k) == expected
    # The source's right-hand side Σ_p log(1-p^{-s}) has coefficient -1/k.
    for k in range(1, 9):
        assert source_log_coefficient(k) == -sp.Rational(1, k)
    # Hence the source identity fails already at k = 1 and k = 2.
    assert mobius_log_coefficient(1) != source_log_coefficient(1)
    assert mobius_log_coefficient(2) != source_log_coefficient(2)


def test_prime_power_weights_positive():
    # Exact weights, including the m = 0 edge case log p.
    assert sp.simplify(prime_weight(2, 0) - sp.log(2)) == 0
    assert sp.simplify(
        prime_weight(2, 1) - sp.log(2) / sp.sqrt(2)
    ) == 0
    rows = prime_power_weights([2, 3, 5, 7], 4)
    assert len(rows) == 4 * 5
    for p, m, w in rows:
        assert sp.N(w, 40) > 0
    with pytest.raises(ValueError):
        prime_weight(1, 1)
    with pytest.raises(ValueError):
        prime_weight(2, -1)


def test_ccm_fourier_matrix_hermitian_and_shift():
    L = sp.Integer(2)
    xs = [sp.log(2), sp.log(3)]
    weights = [prime_weight(2, 1), prime_weight(3, 1)]
    Q = ccm_fourier_matrix(xs, weights, L, 1)
    assert Q.shape == (3, 3)
    assert sp.simplify(Q - Q.H).is_zero_matrix
    # The derivative part is diagonal and equals -μ_ℓ.
    modes = [2 * PI / L * (k + sp.Rational(1, 2)) for k in range(-1, 2)]
    assert sp.simplify(
        Q[1, 1] - (-modes[1] + sum(weights) / L)
    ) == 0
    assert sp.simplify(Q[0, 0] - (-modes[0] + sum(weights) / L)) == 0
