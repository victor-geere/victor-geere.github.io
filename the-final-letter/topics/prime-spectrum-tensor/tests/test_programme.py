import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    GAMMA_1,
    PI,
    atomic_kernel,
    fhat0,
    g0,
    gram_form,
    mode_sq_sum,
    phi_series,
    phi_term,
    pole_weight,
    prime_current,
    prime_weight,
    von_mangoldt,
)


def test_von_mangoldt_exact_and_edge_cases():
    assert von_mangoldt(0) == 0
    assert von_mangoldt(1) == 0
    assert sp.simplify(von_mangoldt(2) - sp.log(2)) == 0
    assert sp.simplify(von_mangoldt(8) - sp.log(2)) == 0
    assert sp.simplify(von_mangoldt(9) - sp.log(3)) == 0
    assert von_mangoldt(6) == 0
    assert von_mangoldt(12) == 0
    with pytest.raises(ValueError):
        von_mangoldt(-1)


def test_prime_weights_are_nonnegative():
    for n in range(2, 60):
        assert sp.N(prime_weight(n), 30) >= 0
    # The finite prime current is non-negative on the constant test function.
    value = sp.N(prime_current(lambda x: sp.Integer(1), 40), 30)
    assert value > 0
    # Empty truncations contribute nothing.
    assert prime_current(lambda x: sp.Integer(1), 1) == 0


def test_pole_weight_identity_is_exact():
    gamma = sp.symbols("gamma", real=True)
    lhs = sp.Abs(fhat0(sp.I / 2, gamma)) ** 2
    target = pole_weight(gamma)
    difference = sp.simplify(sp.expand((lhs - target).rewrite(sp.exp)))
    assert difference == 0


def test_witness_convolution_matches_closed_form():
    mp.mp.dps = 30
    gamma = mp.mpf("14.1347251417346937904572519836")

    def f0(u):
        return (2 / mp.sqrt(mp.pi)) * mp.exp(-(u**2)) * mp.cos(gamma * u)

    for v in (mp.mpf("0.3"), mp.mpf("0.7"), mp.mpf("1.1")):
        direct = mp.quad(lambda u: f0(u) * f0(v - u), [-8, v / 2, 8])
        closed = mp.sqrt(2 / mp.pi) * mp.exp(-(v**2) / 2) * (
            mp.cos(gamma * v) + mp.exp(-(gamma**2) / 2))
        assert abs(direct - closed) < mp.mpf("1e-20")


def test_theorem_b_witness_is_negative():
    """Theorem B's strict negativity, computed directly from primes and Phi."""
    mp.mp.dps = 25
    gamma = mp.mpf("14.1347251417346937904572519836")
    X = 20000

    def g(v):
        return mp.sqrt(2 / mp.pi) * mp.exp(-(v**2) / 2) * (
            mp.cos(gamma * v) + mp.exp(-(gamma**2) / 2))

    def phi(u):
        u = abs(u)
        total = mp.mpf(0)
        e2u = mp.exp(2 * u)
        for n in range(1, 14):
            total += (
                2 * mp.pi**2 * n**4 * mp.exp(mp.mpf(9) * u / 2)
                - 3 * mp.pi * n**2 * mp.exp(mp.mpf(5) * u / 2)
            ) * mp.exp(-mp.pi * n**2 * e2u)
        return total

    sieve = bytearray([1]) * (X + 1)
    sieve[0] = sieve[1] = 0
    for p in range(2, int(X**0.5) + 1):
        if sieve[p]:
            for multiple in range(p * p, X + 1, p):
                sieve[multiple] = 0

    pi_g = mp.mpf(0)
    for p in range(2, X + 1):
        if sieve[p]:
            log_p = mp.log(p)
            power = p
            while power <= X:
                pi_g += log_p * g(mp.log(power)) / mp.sqrt(power)
                power *= p

    theta_g = 2 * mp.quad(
        lambda u: phi(u) * g(u),
        [0, mp.mpf("0.5"), 1, mp.mpf("1.5"), 2, mp.mpf("2.6"), mp.mpf("3.8")],
    )
    # tensor.md Theorem B: Pi = -0.6776451473..., Theta = +0.0003426692...,
    # total = -0.6773024781... < 0.
    assert abs(pi_g + mp.mpf("0.6776451473")) < mp.mpf("1e-6")
    assert theta_g > 0
    assert pi_g + theta_g < mp.mpf("-0.6")
    assert abs(pi_g + theta_g + mp.mpf("0.6773024781")) < mp.mpf("1e-8")


def test_jacobi_terms_and_series_are_positive():
    for n in range(1, 6):
        for u in (sp.Integer(0), sp.Rational(1, 2), sp.Integer(2)):
            assert sp.N(phi_term(n, u), 30) > 0
    # The truncated density is positive as well (each term is positive).
    assert sp.N(phi_series(sp.Rational(1, 3), 8), 30) > 0
    assert phi_series(sp.Integer(1), 0) == 0
    with pytest.raises(ValueError):
        phi_term(0, sp.Integer(0))


def test_finite_gram_form_is_nonnegative_and_matches_modes():
    weights = [sp.Rational(1, 2), sp.Rational(3, 2), sp.Integer(1)]
    freqs = [sp.Integer(1), sp.Integer(2), sp.Rational(5, 2)]
    points = [sp.Rational(0), sp.Rational(1, 3), sp.Rational(2, 3)]
    coeffs = [sp.Integer(1), sp.I, sp.Rational(1, 2) - sp.I]

    form = gram_form(weights, freqs, points, coeffs)
    modal = mode_sq_sum(weights, freqs, points, coeffs)
    assert abs(complex(sp.N(form, 30)) - complex(sp.N(modal, 30))) < 1e-20
    assert sp.N(sp.re(form), 30) >= -sp.Float("1e-25")

    # Edge case: no test points gives the zero form.
    assert gram_form(weights, freqs, [], []) == 0
    with pytest.raises(ValueError):
        atomic_kernel([sp.Integer(1)], [sp.Integer(1), sp.Integer(2)], sp.Integer(0))
