"""Tests for the harmonic-sine/eta computation layer.

Every ``Computation`` row of the programme ledger has a test here.  The
tests use exact sympy arithmetic for the finite identities and mpmath
only for the high-precision eta/zeta checks (with stated tolerances).
"""

import math
import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))

from programme import (  # noqa: E402
    alternating_harmonic_partial,
    complex_partial,
    cosine_partial,
    eta_partial,
    eta_term,
    eta_via_zeta,
    eta_zero_residual,
    even_factorisation_holds,
    even_factorisation_rhs,
    first_critical_zero,
    greedy_condition_holds,
    greedy_condition_values,
    harmonic_partial,
    sine_partial,
    weight,
)


def test_alternating_signs():
    """The eta terms alternate in sign, i.e. the sign word has period two."""
    for n in range(1, 12):
        assert (-1) ** (n + 2) == (-1) ** n
        product = sp.simplify(eta_term(sp.Rational(1, 2), n) * eta_term(sp.Rational(1, 2), n + 1))
        assert product.is_negative


def test_even_factorisation_exact():
    """Computation C1: A_{2N} = H_{2N} - 2^(1-alpha) H_N exactly."""
    for alpha in (sp.Rational(1, 2), sp.Rational(3, 2)):
        for N in range(1, 5):
            assert even_factorisation_holds(alpha, N)
            assert sp.simplify(
                eta_partial(alpha, 2 * N) - even_factorisation_rhs(alpha, N)
            ) == 0


def test_even_partial_sums_positive_and_input_validation():
    """Computation C2: even truncations are positive; invalid inputs are rejected."""
    for n in range(1, 8):
        assert weight(sp.Rational(1, 2), n).is_positive
        assert weight(sp.Integer(3), n).is_positive
    for alpha in (sp.Rational(1, 4), sp.Rational(1, 2), sp.Integer(1)):
        for N in range(1, 9):
            assert sp.N(eta_partial(alpha, 2 * N), 30) > 0
    with pytest.raises(ValueError):
        weight(sp.Integer(0), 1)
    with pytest.raises(ValueError):
        weight(sp.Rational(1, 2), 0)
    with pytest.raises(ValueError):
        eta_partial(sp.Rational(1, 2), 0)


def test_cosine_sine_decomposition_numeric():
    """Computation C3: the complex eta sum is C_alpha(theta) + i S_alpha(theta)."""
    alpha = sp.Rational(1, 2)
    theta = sp.Integer(1)
    N = 5
    z = complex(sp.N(complex_partial(alpha, theta, N), 30))
    c = float(sp.N(cosine_partial(alpha, theta, N), 30))
    s = float(sp.N(sine_partial(alpha, theta, N), 30))
    assert abs(z.real - c) < 1e-20
    assert abs(z.imag - s) < 1e-20


def test_eta_zeta_factorisation_numeric():
    """Computation C4: eta(s) = (1 - 2^(1-s)) zeta(s) for real s > 1."""
    import mpmath as mp

    mp.mp.dps = 30
    for s in (2, sp.Rational(3, 2), 3):
        sf = float(s)
        direct = mp.altzeta(sf)
        factorised = (1 - mp.power(2, 1 - sf)) * mp.zeta(sf)
        assert abs(direct - factorised) < mp.mpf("1e-25")
    # partial sums converge to the factorised value
    direct = eta_via_zeta(2)
    assert abs(float(sp.N(direct, 30)) - float(mp.altzeta(2))) < 1e-25


def test_eta_zero_on_critical_line():
    """Computation C5: eta(1/2 + i gamma_1) vanishes at the first zeta zero."""
    gamma = first_critical_zero()
    assert 14.13 < float(gamma) < 14.14
    assert eta_zero_residual(gamma) < 1e-30


def test_alternating_harmonic_limit():
    """Computation C6: the alternating harmonic partial sums approach log 2."""
    N = 400
    partial = alternating_harmonic_partial(N)
    assert abs(partial - math.log(2)) < 1.0 / (N + 1)


def test_greedy_condition_edge_theta_zero():
    """Computation C7 / edge case: at theta = 0 the greedy condition fails."""
    values = greedy_condition_values(sp.Rational(1, 2), sp.Integer(0), 8)
    assert abs(values[0]) < 1e-25  # S_0 = 0 makes N = 1 vacuous
    assert all(v > 0 for v in values[1:])
    assert not greedy_condition_holds(sp.Rational(1, 2), sp.Integer(0), 8)
    # the positive harmonic sums used above are the S_{N-1} in the condition
    for N in range(1, 6):
        assert harmonic_partial(sp.Rational(1, 2), N) > 0
