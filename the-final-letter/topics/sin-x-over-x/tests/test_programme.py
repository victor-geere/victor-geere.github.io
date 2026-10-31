import sys
from fractions import Fraction
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    error_bound,
    euler_product_truncated,
    first_exact_steps,
    greedy_breakpoints,
    greedy_theta,
    greedy_word,
    harmonic_step,
    integral_recon_sinc,
    integral_sinc,
    period_pieces,
    recon_sinc,
    recon_sine,
    sinc,
    theta_ext,
    vanishing_radius,
)

TOL = mp.mpf("1e-12")


def _close(a, b, tol=TOL):
    return abs(mp.mpf(a) - mp.mpf(b)) <= tol


def test_harmonic_step_and_argument_errors():
    assert harmonic_step(0) == Fraction(1, 2)
    assert harmonic_step(4) == Fraction(1, 6)
    with pytest.raises(ValueError):
        harmonic_step(-1)
    with pytest.raises(ValueError):
        greedy_word(Fraction(1, 2), -1)
    with pytest.raises(ValueError):
        greedy_word(Fraction(-1, 2), 3)
    with pytest.raises(ValueError):
        greedy_theta(Fraction(-1, 2), 3)


def test_greedy_word_at_one_and_theta_values():
    # y = 1: take 1/2, 1/3, skip 1/4 and 1/5, take 1/6 exactly.
    assert greedy_word(1, 6) == [1, 1, 0, 0, 1, 0]
    assert greedy_theta(1, 2) == Fraction(5, 6)
    assert greedy_theta(1, 4) == Fraction(5, 6)
    assert greedy_theta(1, 5) == Fraction(1, 1)
    assert greedy_theta(1, 8) == Fraction(1, 1)
    # A harmonic step is taken exactly.
    assert greedy_theta(Fraction(1, 3), 3) == Fraction(1, 3)
    assert greedy_theta(Fraction(1, 2), 1) == Fraction(1, 2)


def test_residual_invariant_on_grid():
    # |theta_N(y) - y| <= 1/(N+1), the residual invariant behind the
    # pointwise error bound.
    for k in range(25):
        y = Fraction(k, 24)
        for n_max in (1, 2, 5, 20, 200):
            assert abs(greedy_theta(y, n_max) - y) <= Fraction(1, n_max + 1)


def test_vanishing_zone_and_boundary():
    # Strictly inside |x| < 1/(N+1) the reconstruction is identically zero.
    for n_max in (1, 3, 10, 50):
        r = vanishing_radius(n_max)
        for x in (r / 3, r / 2, -r / 3):
            assert recon_sine(x, n_max) == 0
            assert recon_sinc(x, n_max) == 0
    # At the boundary x = 1/(N+1) the last step is selected exactly, so
    # the normalised sinc value is recovered exactly.
    n_max = 9
    x = Fraction(1, 10)
    assert _close(recon_sinc(x, n_max), sinc(x))


def test_integer_defect_is_exact():
    # At odd integers the finite stages do not vanish: theta_1 = 1/2,
    # theta_2 = theta_3 = theta_4 = 5/6, and theta_5 = 1.
    assert _close(recon_sinc(1, 1), mp.mpf(1) / mp.pi)
    for n_max in (2, 3, 4):
        assert _close(recon_sinc(1, n_max), mp.mpf(1) / (2 * mp.pi))
        assert _close(recon_sinc(3, n_max), mp.mpf(1) / (6 * mp.pi))
    for n_max in (5, 8, 20):
        assert abs(recon_sinc(1, n_max)) < mp.mpf("1e-40")
        assert abs(recon_sinc(3, n_max)) < mp.mpf("1e-40")
    # Even integers reduce to the zero branch and vanish at every stage.
    for n_max in (1, 2, 5):
        assert abs(recon_sinc(2, n_max)) < mp.mpf("1e-40")
        assert abs(recon_sinc(-4, n_max)) < mp.mpf("1e-40")


def test_origin_and_noncommuting_limits():
    # sinc_N(0) = 0 for every N, while sinc(0) = 1.
    for n_max in (1, 5, 100):
        assert recon_sinc(0, n_max) == 0
    assert sinc(0) == 1
    # For fixed small x the N-limit recovers sinc(x) (error is bounded).
    x = Fraction(2, 7)
    n_max = 400
    assert abs(recon_sinc(x, n_max) - sinc(x)) <= error_bound(x, n_max)
    # But for fixed N, x -> 0 gives 0, so the two limits differ.
    for n_max in (1, 10, 100):
        x = Fraction(1, 10 * (n_max + 1))
        assert recon_sinc(x, n_max) == 0
        assert sinc(x) > mp.mpf("0.99")


def test_pointwise_convergence_and_uniformity_away_from_zero():
    for n_max in (20, 100, 400):
        for x in (Fraction(-7, 4), Fraction(-1, 2), Fraction(4, 3), Fraction(9, 5)):
            assert abs(recon_sinc(x, n_max) - sinc(x)) <= error_bound(x, n_max)
    # The bound is uniform on |x| >= a, with rate 1/((N+1)a).
    a = Fraction(2)
    n_max = 50
    for x in (2, Fraction(5, 2), 7, -3):
        assert abs(recon_sinc(x, n_max) - sinc(x)) <= mp.mpf(1) / ((n_max + 1) * a)


def test_convergence_is_not_uniform_near_the_origin():
    # At x_N = 1/(N+2) (inside the zero interval) sinc_N = 0 but
    # sinc(x_N) -> 1, so the sup-distance stays near 1.
    for n_max in (10, 100, 1000):
        x = Fraction(1, n_max + 2)
        assert recon_sinc(x, n_max) == 0
        assert sinc(x) > mp.mpf("0.98")
    assert recon_sinc(0, 10) == 0
    assert sinc(0) == 1


def test_parity_and_periodicity():
    # The reconstructed sine is odd and 2-periodic; the reconstructed
    # sinc is even (S_N is odd, dividing by pi*x).
    for n_max in (2, 7):
        for x in (Fraction(1, 3), Fraction(5, 4), Fraction(9, 7)):
            assert _close(recon_sine(-x, n_max), -recon_sine(x, n_max))
            assert _close(recon_sine(x + 2, n_max), recon_sine(x, n_max))
            assert _close(recon_sinc(-x, n_max), recon_sinc(x, n_max))


def test_breakpoints_and_period_pieces():
    assert greedy_breakpoints(1) == [Fraction(0), Fraction(1, 2), Fraction(1)]
    assert greedy_breakpoints(2) == [
        Fraction(0),
        Fraction(1, 3),
        Fraction(1, 2),
        Fraction(5, 6),
        Fraction(1),
    ]
    pieces = period_pieces(1)
    # N = 1: S_1 = 1 on (1/2, 1) and -1 on (1, 3/2), zero elsewhere.
    assert pieces == [
        (Fraction(1, 2), Fraction(1), mp.mpf(1)),
        (Fraction(1), Fraction(3, 2), mp.mpf(-1)),
    ]
    with pytest.raises(ValueError):
        greedy_breakpoints(-1)
    with pytest.raises(ValueError):
        period_pieces(-1)


def test_integral_values_and_convergence_to_one_half():
    recorded = {
        1: "0.110317800076326",
        2: "0.200338196925457",
        3: "0.256375071676042",
        4: "0.294176323865080",
        5: "0.321176532846836",
        6: "0.342862352413666",
    }
    values = []
    for n_max, expected in recorded.items():
        value = integral_recon_sinc(n_max)
        assert abs(value - mp.mpf(expected)) < mp.mpf("1e-9")
        values.append(value)
    # The finite-stage integral increases towards the classical 1/2.
    assert values == sorted(values)
    assert values[-1] < integral_sinc() == mp.mpf(1) / 2


def test_integral_truncation_stability():
    # Truncation parameters are well inside the recorded tolerance.
    for n_max in (1, 3, 5):
        assert abs(integral_recon_sinc(n_max, periods=60) - integral_recon_sinc(n_max, periods=30)) < mp.mpf("1e-14")


def test_eventual_exactness_on_rationals():
    # Greedy Egyptian expansions of rationals terminate, so each of these
    # arguments is reconstructed exactly at a finite stage.
    expected = {
        Fraction(1, 2): 1,
        Fraction(1, 3): 2,
        Fraction(2, 7): 27,
        Fraction(3, 7): 230,
        Fraction(1): 5,
        Fraction(5, 4): 3,
    }
    for x, n_max in expected.items():
        assert first_exact_steps(x) == n_max
        assert abs(recon_sinc(x, n_max) - sinc(x)) < mp.mpf("1e-38")
    with pytest.raises(ValueError):
        first_exact_steps(Fraction(1, 3), limit=1)
    with pytest.raises(ValueError):
        first_exact_steps(Fraction(1, 3), limit=0)


def test_integral_argument_errors():
    for bad in (-1,):
        with pytest.raises(ValueError):
            integral_recon_sinc(bad)
    with pytest.raises(ValueError):
        integral_recon_sinc(2, periods=0)
    with pytest.raises(ValueError):
        integral_recon_sinc(2, moment_order=0)

def test_euler_product_origin_obstruction():
    # Every Euler-type product with non-zero constant term is 1 at x=0,
    # while the reconstructed sinc is 0 there.
    for n_max in (0, 1, 5, 50):
        assert euler_product_truncated(0, n_max) == 1
    for stage in (1, 5, 50):
        assert recon_sinc(0, stage) == 0
    assert euler_product_truncated(0, 10) != recon_sinc(0, 10)


def test_euler_product_wallis_point():
    # The Wallis point survives exactly at every finite stage.
    with mp.workdps(40):
        wallis = mp.mpf(2) / mp.pi
    for stage in range(1, 11):
        assert abs(recon_sinc(Fraction(1, 2), stage) - wallis) < mp.mpf("1e-35")
    # The truncated Euler products decrease to the same value.
    values = [euler_product_truncated(Fraction(1, 2), n_max) for n_max in (1, 2, 5, 10, 50, 200)]
    assert values == sorted(values, reverse=True)
    assert abs(mp.mpf(values[-1].numerator) / values[-1].denominator - wallis) < mp.mpf("1e-3")
    # Half-integers are exact for every stage as well.
    for k in (3, 5, -3):
        for stage in (1, 2, 7):
            assert abs(recon_sinc(Fraction(k, 2), stage) - sinc(Fraction(k, 2))) < mp.mpf("1e-40")


def test_euler_product_integer_zeros_and_jump():
    # The Euler product vanishes at every positive integer.
    for n_max in (1, 2, 10):
        assert euler_product_truncated(1, n_max) == 0
    for n_max in (2, 10):
        assert euler_product_truncated(2, n_max) == 0
    # The finite stage does not vanish at odd integers until N = 5.
    with mp.workdps(40):
        expected = mp.mpf(1) / (2 * mp.pi)
    assert abs(recon_sinc(1, 2) - expected) < mp.mpf("1e-35")
    assert recon_sinc(1, 5) == 0
    # Away from the zero, the function has a jump across x = 1, so it is
    # not analytic there and has no order of vanishing.
    left = recon_sinc(1 - Fraction(1, 1000), 5)
    right = recon_sinc(1 + Fraction(1, 1000), 5)
    assert left > mp.mpf("0.15") and right < mp.mpf("-0.15")


def test_euler_coefficient_heuristic_is_vacuous():
    # Euler's x^2 coefficient is -sum 1/n^2 < 0.
    for n_max in (1, 10, 100):
        coefficient = -sum(Fraction(1, n * n) for n in range(1, n_max + 1))
        assert coefficient < 0
    # The reconstructed sinc is flat on a neighbourhood of the origin,
    # so all its Taylor coefficients there are 0.  Comparing the x^2
    # coefficient would give sum 1/n^2 = 0, i.e. zeta(2) = 0.
    for stage in (1, 5, 50):
        for x in (Fraction(1, 10 * (stage + 1)), Fraction(1, 100 * (stage + 1))):
            assert recon_sinc(x, stage) == 0


def test_euler_product_argument_errors():
    with pytest.raises(ValueError):
        euler_product_truncated(0, -1)

def test_taylor_coefficient_exact_and_truncated():
    # Exact sin(x)/x has x^2 coefficient -1/6; the normalised sinc has
    # -pi^2/6.  The truncation is flat on a neighbourhood, so all its
    # Taylor coefficients at 0 vanish.
    x = sp.symbols("x")
    exact = sp.series(sp.sin(x) / x, x, 0, 3).coeff(x, 2)
    assert sp.simplify(exact + sp.Rational(1, 6)) == 0
    normalised = sp.series(sp.sin(sp.pi * x) / (sp.pi * x), x, 0, 3).coeff(x, 2)
    assert sp.simplify(normalised + sp.pi ** 2 / 6) == 0
    for stage in (1, 5, 50):
        for x0 in (Fraction(1, 10 * (stage + 1)), Fraction(1, 100 * (stage + 1))):
            assert recon_sinc(x0, stage) == 0
