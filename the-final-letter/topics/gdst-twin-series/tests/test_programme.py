import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    alpha,
    complement_residual,
    count_selected,
    greedy_digits,
    partial_zeta,
    rejected_sum,
    selected_sum,
)


def test_greedy_digits_edge_values():
    # θ = 0 is the empty selection: no fraction is ever reached.
    assert greedy_digits(sp.Integer(0), 12) == [0] * 13
    # θ = π starts by selecting α_0 = π/2.
    assert greedy_digits(PI, 0) == [1]
    # The source domain is θ ∈ [0, π]; a negative index is invalid.
    with pytest.raises(ValueError):
        alpha(-1)
    with pytest.raises(ValueError):
        greedy_digits(PI, -1)


def test_finite_complement_identity_symbolic():
    s = sp.symbols("s", real=True)
    for theta in (sp.Integer(0), sp.Rational(1, 7) * PI, sp.Rational(1, 3) * PI, PI):
        for n_max in (0, 1, 5, 11):
            assert complement_residual(theta, s, n_max) == 0


def test_complement_at_s_zero_counts_indices():
    # At s = 0 every weight is 1, so H_N = N + 1 = E_N + Ω_N.
    for theta in (sp.Integer(0), sp.Rational(2, 5) * PI, PI):
        digits = greedy_digits(theta, 9)
        n_sel = count_selected(theta, 9)
        assert partial_zeta(0, 9) == 10
        assert selected_sum(theta, 0, 9) == n_sel
        assert rejected_sum(theta, 0, 9) == 10 - n_sel
        assert selected_sum(theta, 0, 9) + rejected_sum(theta, 0, 9) == 10


def test_complement_is_exact_harmonic_prefix_at_s_one():
    expected = sum((sp.Rational(1, n + 2) for n in range(8)), sp.Integer(0))
    for theta in (sp.Integer(0), sp.Rational(1, 5) * PI, sp.Rational(3, 4) * PI, PI):
        assert partial_zeta(1, 7) == expected
        assert selected_sum(theta, 1, 7) + rejected_sum(theta, 1, 7) == expected


def test_selected_prefix_is_nonnegative_and_bounded():
    for theta in (sp.Integer(0), sp.Rational(1, 9) * PI, sp.Rational(5, 9) * PI, PI):
        for s in (sp.Rational(-1, 2), sp.Integer(0), sp.Integer(1), sp.Integer(2)):
            e = selected_sum(theta, s, 12)
            o = rejected_sum(theta, s, 12)
            h = partial_zeta(s, 12)
            assert sp.N(e, 30) >= 0
            assert sp.N(o, 30) >= 0
            assert sp.simplify(e + o - h) == 0
            assert sp.N(e, 30) <= sp.N(h, 30) + sp.Float("1e-25")


def test_invalid_weight_index_raises():
    with pytest.raises(ValueError):
        partial_zeta(1, -1)
    with pytest.raises(ValueError):
        selected_sum(PI, 1, -1)
