import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    kosters_kernel,
    moment_ledger,
    montgomery_F,
    sinc,
    sinc_series,
    sinc_taylor_coeff,
    sinc_taylor_polynomial,
    sine_kernel,
)

X, Y, MU, NU = sp.symbols("x y mu nu", real=True)


def test_sinc_edge_cases():
    """C1: normalisation at zero, the half value, integer zeros, evenness."""
    assert sinc(0) == 1
    assert sp.simplify(sinc(sp.Rational(1, 2)) - 2 / PI) == 0
    assert sp.simplify(sinc(1)) == 0
    assert sp.simplify(sinc(-3)) == 0
    assert sp.simplify(sinc(-X) - sinc(X)) == 0


def test_sine_kernel_diagonal_and_symmetry():
    """C2: K(x,x) = 1 and K(x,y) = K(y,x)."""
    assert sp.simplify(sine_kernel(X, X) - 1) == 0
    assert sp.simplify(sine_kernel(X, Y) - sine_kernel(Y, X)) == 0
    assert sp.simplify(sine_kernel(2, 2) - 1) == 0


def test_montgomery_factor_values_and_nonnegativity():
    """C3: exact values of F and non-negativity on a rational grid."""
    assert sp.simplify(montgomery_F(0)) == 0
    assert sp.simplify(montgomery_F(1)) == 1
    assert sp.simplify(montgomery_F(sp.Rational(1, 2)) - (1 - 4 / PI**2)) == 0
    tol = sp.Float("1e-25")
    for k in range(1, 25):
        value = sp.N(montgomery_F(sp.Rational(k, 7)), 40)
        assert value >= -tol


def test_sinc_taylor_moments():
    """C4: the exact even Taylor moments agree with sympy's series."""
    for n in range(0, 5):
        lhs = sinc_taylor_polynomial(X, n)
        rhs = sinc_series(X, n)
        assert sp.simplify(lhs - rhs) == 0
    assert sinc_taylor_coeff(0) == 1
    assert sp.simplify(sinc_taylor_coeff(1) + PI**2 / 6) == 0
    assert sp.simplify(sinc_taylor_coeff(2) - PI**4 / 120) == 0


def test_invalid_taylor_orders_raise():
    """Edge case: negative orders are rejected by the moment bookkeeping."""
    with pytest.raises(ValueError):
        sinc_taylor_coeff(-1)
    with pytest.raises(ValueError):
        sinc_taylor_polynomial(X, -1)
    with pytest.raises(ValueError):
        sinc_series(X, -1)


def test_kosters_kernel_diagonal_and_modulus_squared():
    """C5: the phase factor normalises to one on the diagonal and has unit
    modulus, so |K(mu,nu)|^2 = sinc(mu-nu)^2."""
    assert sp.simplify(kosters_kernel(2, 2) - 1) == 0
    kernel = kosters_kernel(MU, NU)
    modulus_sq = sp.expand(kernel * sp.conjugate(kernel))
    assert sp.simplify(modulus_sq - sinc(MU - NU) ** 2) == 0


def test_shifted_moment_bookkeeping():
    """C6: a finite shifted-moment matrix is Hermitian with unit diagonal and
    the correct modulus on every entry."""
    shifts = [0, sp.Rational(1, 3), sp.Rational(1, 2), 1]
    ledger = moment_ledger(shifts)
    assert ledger["diagonal"] == [1, 1, 1, 1]
    assert ledger["hermitian_residual"].is_zero_matrix
    assert ledger["modulus_residual"].is_zero_matrix


def test_sinc_positivity_on_open_unit_interval():
    """C7: sinc is positive on (0, 1)."""
    tol = sp.Float("1e-30")
    for k in range(1, 20):
        value = sp.N(sinc(sp.Rational(k, 20)), 40)
        assert value > tol
