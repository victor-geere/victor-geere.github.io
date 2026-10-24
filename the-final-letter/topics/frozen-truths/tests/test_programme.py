import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    cosh_weight,
    exp_neg_log_ratio,
    gaussian_zero_slice,
    gaussian_zero_slice_integral,
    last_chord,
    last_chord_abs,
    last_chord_limit,
    last_chord_product,
    ratio_min_max,
    twin_moduli_equal,
)


def test_last_chord_pairing_exact():
    """truths.md 11.1 / 14.1: the pairing is independent of s."""
    s = sp.Rational(3, 7) + sp.I * sp.Rational(5, 3)
    for N in range(2, 13):
        assert sp.simplify(last_chord_product(N, s) - last_chord_limit(N)) == 0
    # Edge case: N = 1 makes H_1 vanish and the pairing value zero.
    assert last_chord_product(1, s) == 0
    assert last_chord_limit(1) == 0


def test_boundary_modulus_and_self_dual_abscissa():
    """truths.md 2.8 / 11.2: |H_N(sigma)| and equality only at 1/2."""
    for N in (2, 3, 10, 97):
        for k in range(0, 11):
            sigma = sp.Rational(k, 10)
            lhs = sp.simplify(sp.Abs(last_chord(N, sigma)))
            rhs = sp.simplify(last_chord_abs(N, sigma))
            assert sp.simplify(lhs - rhs) == 0
            assert twin_moduli_equal(N, sigma) == (sigma == sp.Rational(1, 2))


def test_last_chord_limit_tolerance():
    """truths.md 11.1: (N-1)^2/(4N^2) -> 1/4; tolerance 1e-6 at N = 10^6."""
    value = float(sp.N(last_chord_limit(10**6), 30))
    assert abs(value - 0.25) < 1e-6
    assert last_chord_limit(2) == sp.Rational(1, 16)


def test_integer_ratio_identity():
    """truths.md 1.14: exp(-|log(m/n)|) = min/max, including m = n."""
    pairs = [(1, 10), (2, 3), (3, 2), (5, 5), (97, 89), (10, 1)]
    for m, n in pairs:
        assert sp.simplify(exp_neg_log_ratio(m, n) - ratio_min_max(m, n)) == 0


def test_cosh_weight_strict_and_even():
    """truths.md 12.3 / 13.3: cosh(alpha u) > 1 for alpha != 0, u > 0."""
    for alpha in (sp.Rational(1, 3), sp.Integer(2), sp.Rational(-5, 2)):
        for u in (sp.Rational(1, 4), sp.Integer(1), sp.Integer(3)):
            assert sp.simplify(cosh_weight(alpha, u) - cosh_weight(-alpha, u)) == 0
            assert float(sp.N(cosh_weight(alpha, u), 30)) > 1.0
    # Edge case: the weight is identically 1 only at alpha = 0.
    assert sp.simplify(cosh_weight(0, sp.Rational(7, 3))) == 1


def test_gaussian_zero_slice_positive_exact():
    """truths.md 15.1, Gaussian model: K(alpha,0) = (sqrt(pi)/2) e^(alpha^2/4)."""
    for alpha in (sp.Integer(0), sp.Rational(1, 2), sp.Integer(1), sp.Rational(3, 2)):
        formula = gaussian_zero_slice(alpha)
        integral = gaussian_zero_slice_integral(alpha)
        assert sp.simplify(integral - formula) == 0
        assert float(sp.N(formula, 30)) > 0.0


def test_invalid_inputs():
    """Edge/failure cases: invalid arguments are rejected."""
    with pytest.raises(ValueError):
        last_chord(0, sp.Integer(0))
    with pytest.raises(ValueError):
        last_chord_abs(-3, sp.Integer(0))
    with pytest.raises(TypeError):
        last_chord(sp.Rational(5, 2), sp.Integer(0))
    with pytest.raises(ValueError):
        exp_neg_log_ratio(0, 1)
    with pytest.raises(ValueError):
        gaussian_zero_slice(sp.I)
