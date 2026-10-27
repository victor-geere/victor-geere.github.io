import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    action,
    binomial_sum,
    binomial_weight,
    level_action_sum,
    node_value,
    total_action_sum,
    two_point_drag_approx,
    two_point_log_growth,
)


def test_binomial_weight_values():
    assert binomial_weight(sp.Rational(1, 2), 4, 0) == sp.Rational(1, 16)
    assert binomial_weight(sp.Rational(1, 2), 4, 2) == sp.Rational(6, 16)
    assert binomial_weight(sp.Rational(1, 3), 3, 1) == sp.Rational(4, 9)
    # Degenerate probabilities: only the certain branch survives.
    assert binomial_weight(0, 5, 0) == 1
    assert binomial_weight(0, 5, 3) == 0
    assert binomial_weight(1, 5, 5) == 1
    assert binomial_weight(1, 5, 2) == 0


def test_binomial_weights_sum_to_one():
    for p in (sp.Rational(1, 3), sp.Rational(2, 5), sp.Rational(1, 10)):
        for k in range(0, 26):
            assert binomial_sum(p, k) == 1
    # The identity is algebraic, so it also holds outside [0, 1].
    assert binomial_sum(sp.Integer(2), 7) == 1


def test_binomial_identity_edge_cases():
    assert binomial_sum(sp.Rational(1, 2), 0) == 1
    assert binomial_sum(sp.Integer(1), 0) == 1
    with pytest.raises(ValueError):
        binomial_weight(sp.Rational(1, 2), 3, 4)
    with pytest.raises(ValueError):
        binomial_weight(sp.Rational(1, 2), -1, 0)


def test_node_value_and_lattice_ratio():
    S0, u, d = sp.Integer(100), sp.Rational(3, 2), sp.Rational(2, 3)
    for k in range(1, 12):
        for j in range(k):
            ratio = sp.simplify(node_value(S0, u, d, k, j + 1) / node_value(S0, u, d, k, j))
            assert ratio == sp.simplify(u / d)
    assert node_value(S0, u, d, 0, 0) == S0
    with pytest.raises(ValueError):
        node_value(S0, u, d, 2, 3)


def test_action_is_constant_one_over_eps():
    eps = sp.Integer(7)
    for S in (sp.Integer(1), sp.Integer(50), sp.Rational(3, 11)):
        assert action(S, eps) == sp.Rational(1, 7)
    with pytest.raises(ValueError):
        action(0, eps)
    with pytest.raises(ValueError):
        action(1, 0)


def test_level_and_total_action_sum():
    eps = sp.Integer(5)
    for k in range(0, 16):
        assert level_action_sum(sp.Rational(1, 2), k, eps) == sp.Rational(1, 5)
    for n in (0, 1, 2, 5, 10, 20):
        assert total_action_sum(n, eps) == sp.Rational(n + 1, 5)
    with pytest.raises(ValueError):
        total_action_sum(-1, eps)
    with pytest.raises(ValueError):
        total_action_sum(3, 0)


def test_two_point_volatility_drag():
    # Exact: exact log growth is strictly below -r^2 / 2.
    for r in (sp.Rational(1, 10), sp.Rational(1, 3), sp.Rational(1, 2), sp.Rational(9, 10)):
        g = two_point_log_growth(r)
        approx = two_point_drag_approx(r)
        assert sp.simplify(g - approx).is_negative
        assert sp.N(g, 40) < sp.N(approx, 40)
    # Difference from the approximation is second order in r^2:
    # g + r^2/2 = -r^4/4 + O(r^6).
    r = sp.symbols("r", positive=True)
    series = sp.series(sp.log(1 - r**2) / 2 + r**2 / 2, r, 0, 6).removeO()
    assert sp.simplify(series + r**4 / 4) == 0
    with pytest.raises(ValueError):
        two_point_log_growth(1)
    with pytest.raises(ValueError):
        two_point_log_growth(-sp.Rational(1, 2))
