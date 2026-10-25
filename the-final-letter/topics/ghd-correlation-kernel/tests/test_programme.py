import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    K_diag,
    K_diag_n,
    K_off,
    K_off_source,
    alpha,
    greedy_digits,
    is_positive_semidefinite,
    kernel_integral,
    leading_principal_minors,
    scaled_kernel_matrix,
    step_indicator,
)


def test_threshold_at_own_angle_is_selected():
    """C1: θ_n* = α_n is attained: at θ = α_n index n is selected first."""
    for n in range(13):
        digits = greedy_digits(alpha(n), n)
        assert digits[n] == 1
        assert sum(digits[:n]) == 0


def test_diagonal_closed_form_and_half_value():
    """C2: the t-form, the n-form, positivity, and the value at π/2."""
    for n in range(31):
        assert sp.simplify(K_diag(alpha(n)) - K_diag_n(n)) == 0
        assert sp.N(K_diag_n(n), 30) > 0
    assert sp.simplify(K_diag(PI / 2) - PI / 12) == 0
    assert sp.simplify(K_diag(PI / 3) - K_diag(2 * PI / 3)) == 0


def test_off_diagonal_closed_form_matches_integral():
    """C3: the corrected off-diagonal formula equals the defining integral."""
    pairs = [(0, 0), (0, 1), (1, 0), (2, 5), (7, 2), (4, 4), (3, 17)]
    for n, m in pairs:
        assert sp.simplify(K_off(n, m) - kernel_integral(n, m)) == 0
        assert sp.simplify(K_off(n, m) - K_off(m, n)) == 0
    for n in range(12):
        assert sp.simplify(K_off(n, n) - K_diag_n(n)) == 0


def test_archived_off_diagonal_formula_is_refuted():
    """C4: the printed source formula disagrees with the integral (erratum)."""
    # n = 0, m = 1 gives a = 1/2, b = 1/3.  The integral is π/72.
    assert sp.simplify(kernel_integral(0, 1) - PI / 72) == 0
    assert sp.simplify(K_off(0, 1) - PI / 72) == 0
    # The archived formula gives 143π/1296, off by a factor 143/18.
    assert sp.simplify(K_off_source(0, 1) - 143 * PI / 1296) == 0
    assert sp.simplify(K_off_source(0, 1) - K_off(0, 1)) != 0
    # The printed expression is only asserted for n < m, but it does not
    # even degenerate to the (correct) diagonal when n = m.
    assert sp.simplify(K_off_source(0, 0) - 5 * PI / 24) == 0
    assert sp.simplify(K_off_source(0, 0) - K_diag_n(0)) != 0


def test_finite_kernel_is_symmetric_and_positive_semidefinite():
    """C5: exact symmetry and PSD of finite sections of the step kernel."""
    matrix = scaled_kernel_matrix(7)
    assert matrix == matrix.T
    minors = leading_principal_minors(7)
    assert all(minor > 0 for minor in minors)
    assert is_positive_semidefinite(7)
    # The finite step functions have distinct jumps, so the section is
    # positive definite, not merely semidefinite.
    assert matrix.rank() == 7


def test_actual_greedy_digits_are_not_monotone():
    """C6: the step model is not the real greedy kernel.

    Index 2 is selected at θ = π/4 but not at the larger target θ = π/2,
    because at π/2 index 0 consumes the whole angle.  Hence δ_2 is not a
    step function and the closed forms do not compute the true kernel.
    """
    assert step_indicator(PI / 4, 2) == 1
    assert step_indicator(PI / 2, 2) == 1  # the step model says 1 at both
    assert greedy_digits(PI / 4, 2)[2] == 1
    assert greedy_digits(PI / 2, 2)[2] == 0
    # A second, sharper witness: δ_0(π) = 1 but δ_2(π) = 0.
    assert greedy_digits(PI, 2) == [1, 1, 0]


def test_edge_cases():
    """C8: rejects bad indices, handles size zero and equal indices."""
    for n in (-1, -5):
        with pytest.raises(ValueError):
            alpha(n)
        with pytest.raises(ValueError):
            K_off(n, 0)
        with pytest.raises(ValueError):
            K_diag_n(n)
    assert scaled_kernel_matrix(0).shape == (0, 0)
    assert leading_principal_minors(0) == []
    assert is_positive_semidefinite(0)
    # n = m is the diagonal edge case of the off-diagonal formula.
    assert sp.simplify(K_off(9, 9) - K_diag_n(9)) == 0
    # Symmetry edge case: swapped arguments give the same exact expression.
    assert sp.simplify(K_off(1, 2) - K_off(2, 1)) == 0


def test_true_greedy_kernel_matches_archived_small_values():
    """C7: the actual greedy kernel differs from the step model.

    The exact values agree with the archive's own negative-result note
    ``vanishing_result.md``: K(0,0)=π/12, K(1,1)=2π/9, K(0,1)=−7π/72,
    K(2,2)=23π/72, K(1,2)=π/48.  In particular the true off-diagonal
    entry is negative, whereas the step model gives +π/72.
    """
    from programme import true_kernel_matrix

    matrix = true_kernel_matrix(6)  # in units of π
    assert matrix[0, 0] == sp.Rational(1, 12)
    assert matrix[1, 1] == sp.Rational(2, 9)
    assert matrix[0, 1] == sp.Rational(-7, 72)
    assert matrix[2, 2] == sp.Rational(23, 72)
    assert matrix[1, 2] == sp.Rational(1, 48)
    assert matrix == matrix.T
    # The true kernel is a Gram matrix, so it is positive semidefinite.
    assert all(matrix[:k, :k].det() >= 0 for k in range(1, 7))
    # The step model is not the true kernel: same diagonal at n = 0 and 1,
    # different off-diagonal at (0, 1) and diagonal at n = 2.
    assert sp.simplify(K_off(0, 1) - PI / 72) == 0
    assert sp.simplify(K_off(2, 2) - PI * matrix[2, 2]) != 0
