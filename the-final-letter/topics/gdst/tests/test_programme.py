import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    K00_integral,
    alpha,
    ax5_diagonal,
    dirichlet_prefix,
    finite_identity_residual,
    greedy_digits,
    greedy_remainders,
    non_monotone_counterexample,
    post_selection_bound_holds,
    rejected_weight,
    remainder_bound_holds,
    selected_weight,
)


def test_alpha_values_and_edge_cases():
    assert alpha(0) == sp.Rational(1, 2)
    assert alpha(1) == sp.Rational(1, 3)
    assert alpha(3) == sp.Rational(1, 5)
    for bad in (-1, -7):
        with pytest.raises(ValueError):
            alpha(bad)
    with pytest.raises(ValueError):
        greedy_digits(sp.Rational(1, 2), -1)


def test_finite_partial_sum_identity_exact():
    targets = [
        sp.Rational(0),
        sp.Rational(1, 2),
        sp.Rational(2, 5),
        sp.Rational(3, 5),
        sp.Rational(1),
        sp.Rational(7, 13),
    ]
    for x in targets:
        for n_max in (0, 1, 2, 7, 20, 50):
            assert finite_identity_residual(x, n_max) == 0


def test_remainder_bounds_and_post_selection_bound():
    for k in range(13):
        x = sp.Rational(k, 12)
        for n_max in (0, 1, 2, 5, 20, 60):
            assert remainder_bound_holds(x, n_max)
        for n in range(12):
            assert post_selection_bound_holds(x, n)


def test_selected_rejected_split_exact():
    for x in (sp.Rational(1, 7), sp.Rational(2, 5), sp.Rational(3, 5), sp.Rational(5, 6)):
        for s in (1, 2, 3):
            for n_max in (0, 1, 10, 30):
                total = selected_weight(x, s, n_max) + rejected_weight(x, s, n_max)
                assert sp.simplify(total - dirichlet_prefix(s, n_max)) == 0


def test_selected_and_rejected_weights_are_nonnegative():
    x = sp.Rational(4, 9)
    for s in (1, 2):
        for n_max in (0, 5, 25):
            assert selected_weight(x, s, n_max) >= 0
            assert rejected_weight(x, s, n_max) >= 0


def test_digit_non_monotonicity_counterexample():
    d1_left, d1_right = non_monotone_counterexample()
    assert (d1_left, d1_right) == (1, 0)
    # The word really is binary, and x = 1 forces the first two digits on.
    assert set(greedy_digits(sp.Rational(4, 9), 25)) <= {0, 1}
    assert greedy_digits(sp.Rational(1), 2) == [1, 1, 0]


def test_boundary_zero_and_one():
    zeros = greedy_digits(sp.Rational(0), 40)
    assert all(d == 0 for d in zeros)
    assert finite_identity_residual(sp.Rational(0), 40) == 0

    digits_one, rems_one = greedy_digits(sp.Rational(1), 4), greedy_remainders(sp.Rational(1), 4)
    assert digits_one[0] == 1 and digits_one[1] == 1
    assert rems_one[0] == sp.Rational(1, 2)
    assert rems_one[1] == sp.Rational(1, 6)


def test_retracted_ax5_formula_is_negative_at_zero():
    # The source retracts AX5: at n = 0 it gives pi/12 * (1 - 3/2) = -pi/24.
    assert sp.simplify(ax5_diagonal(0) - (-PI / 24)) == 0
    assert ax5_diagonal(0) < 0
    # The actual finite kernel value K(0,0) = integral_0^pi f_0^2 is pi/12.
    assert sp.simplify(K00_integral() - PI / 12) == 0
    assert sp.simplify(K00_integral() - ax5_diagonal(0)) != 0
