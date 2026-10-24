import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from bridges import (  # noqa: E402
    clock_zero,
    clock_zero_is_zero,
    last_chord_abs,
    last_chord_product,
    last_chord_twin_difference,
    local_diagonal_integral,
    local_diagonal_normalized,
    prefactor_lower_bound_holds,
    self_dual_abscissa,
)


def test_last_chord_product_is_exact():
    sigma = sp.symbols("sigma", real=True)
    for N in (2, 3, 5, 10):
        lhs = sp.simplify(last_chord_abs(N, sigma) * last_chord_abs(N, 1 - sigma))
        assert sp.simplify(lhs - last_chord_product(N)) == 0


def test_last_chord_unique_self_dual_abscissa():
    for N in (2, 3, 7):
        assert self_dual_abscissa(N) == [sp.Rational(1, 2)]


def test_last_chord_twin_difference_vanishes_only_at_half():
    for N in (3, 5):
        assert sp.simplify(last_chord_twin_difference(N, sp.Rational(1, 2))) == 0
        assert sp.simplify(last_chord_twin_difference(N, sp.Rational(1, 3))) != 0


def test_clock_zeros_are_exact():
    for N in (2, 3, 10):
        for k in (-2, -1, 0, 1, 2):
            assert clock_zero_is_zero(N, k)
            assert sp.simplify(clock_zero(N, k) - (1 - 2 * sp.I * k * sp.pi / sp.log(N))) == 0


def test_non_clock_point_is_not_a_zero():
    # s = 1 + 0.3 i is not a clock zero for N = 5.
    N = 5
    s = 1 + sp.Rational(3, 10) * sp.I
    residual = sp.simplify(sp.exp((1 - s) * sp.log(N)) - 1)
    assert sp.N(residual, 30) != 0


def test_prefactor_lower_bound():
    for N in (2, 3, 10, 50):
        for sigma in (0.25, 0.5, 0.75, 1.5):
            for t in (0.0, 1.0, 14.134725):
                assert prefactor_lower_bound_holds(N, sigma, t)


def test_local_diagonal_identity_for_normalized_quartic():
    u = sp.symbols("u", real=True)
    f = sp.Rational(3, 4) * (1 - u**2)
    R = sp.symbols("R", real=True)
    lhs = local_diagonal_integral(f, R)
    rhs = local_diagonal_normalized(f, R)
    assert sp.simplify(lhs - rhs) == 0
    assert sp.simplify(lhs - (-1 + R * sp.Rational(3, 5))) == 0


def test_local_diagonal_rejects_unnormalized_function():
    u = sp.symbols("u", real=True)
    with pytest.raises(ValueError):
        local_diagonal_normalized(u**2, 3)


def test_register_weight_at_period_is_negative():
    from bridges import register_coefficient_at_multiple

    for N in (2, 3, 10):
        assert register_coefficient_at_multiple(N) == 1 - N
        assert register_coefficient_at_multiple(N) < 0


def test_heat_flow_reduces_to_polygon_at_tau_zero():
    from bridges import eta_coefficients, heat_flow_reduces_to_polygon

    s = sp.symbols("s")
    for N in (2, 3, 5):
        assert heat_flow_reduces_to_polygon(N, s)
        coeffs = eta_coefficients(N)
        assert len(coeffs) == N * N
        assert coeffs[N - 1] == 1 - N


def test_davenport_heilbronn_word_is_odd_and_mean_zero():
    from bridges import dh_coeffs, dh_is_odd, dh_mean_zero, dh_xi

    a = dh_coeffs()
    assert len(a) == 5
    assert sp.simplify(a[4]) == 0
    assert dh_is_odd()
    assert dh_mean_zero()


def test_complex_last_chord_twin_product():
    from bridges import last_chord_complex_product

    s = sp.Rational(1, 3) + 2 * sp.I
    for N in (2, 3, 5):
        assert last_chord_complex_product(N, s) == 0


def test_last_chord_asymptotic_classes():
    from bridges import last_chord_abs

    N = 10**10
    assert float(last_chord_abs(N, 0.25)) > 100.0
    assert abs(float(last_chord_abs(N, 0.5)) - 0.5) < 1e-5
    assert float(last_chord_abs(N, 0.75)) < 1e-5


def test_last_chord_dichotomy_twins():
    from bridges import last_chord_abs

    N = 10**10
    left = float(last_chord_abs(N, 0.25))
    left_twin = float(last_chord_abs(N, 0.75))
    right = float(last_chord_abs(N, 0.75))
    right_twin = float(last_chord_abs(N, 0.25))
    assert left > 100.0 and left_twin < 1e-5
    assert right < 1e-5 and right_twin > 100.0


def test_last_chord_exact_ratio():
    from bridges import last_chord_ratio

    for N in (2, 3, 5):
        for sigma in (sp.Rational(1, 3), sp.Rational(1, 2), sp.Rational(2, 3)):
            assert sp.simplify(last_chord_ratio(N, sigma) - (sp.Rational(1, 2) - sp.Rational(1, 2 * N))) == 0


def test_heat_flow_derivative_at_zero():
    from bridges import heat_flow_derivative, heat_flowed_polygon

    s = sp.symbols("s")
    tau = sp.symbols("tau")
    for N in (2, 3, 5):
        derivative = sp.diff(heat_flowed_polygon(N, tau, s), tau).subs(tau, 0)
        assert sp.simplify(derivative - heat_flow_derivative(N, s)) == 0


def test_dh_xi_is_strictly_between_zero_and_one():
    from bridges import dh_xi

    value = sp.N(dh_xi(), 50)
    assert value > 0
    assert value < 1


def test_dh_dft_eigenvector():
    import mpmath as mp
    from bridges import dh_coeffs

    mp.mp.dps = 50
    a = [mp.mpf(str(sp.N(c, 50))) for c in dh_coeffs()]
    for k in range(1, 6):
        lhs = sum(a[r - 1] * mp.expj(2 * mp.pi * r * k / 5) for r in range(1, 6))
        lhs = lhs / (mp.mpf(5) ** 0.5 * mp.j)
        assert abs(lhs - a[k - 1]) < mp.mpf('1e-40')
