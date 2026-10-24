"""Tests for the finite-operator reconstruction of the archived
harmonic–categorical Hilbert–Pólya claim.

Every computation row of the programme ledger is covered here.  The
source's global RH claim is deliberately not tested: it is archived, not
a theorem of this reconstruction.
"""

import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    charpoly_2x2,
    det_A,
    det_one_minus_A,
    diag_constant,
    discriminant_2x2,
    eigenvalues_2x2,
    entry,
    is_upper_triangular,
    matrix_A,
    realise_symmetric_2x2,
    weight,
)


def test_weight_exact_values_and_empty_sum():
    # c_{0,0}(3) = 1/2 + 2/3 + 3/4  (the harmonic-weight case)
    assert sp.simplify(weight(0, 0, 3) - sp.Rational(23, 12)) == 0
    # c_{0,1}(3) = 1/2^2 + 2/3^2 + 3/4^2
    assert sp.simplify(weight(0, 1, 3) - sp.Rational(95, 144)) == 0
    # c_{1,0}(2) = 1/2^2 + 2/3^2
    assert sp.simplify(weight(1, 0, 2) - sp.Rational(17, 36)) == 0
    # Edge case: the empty truncation contributes nothing.
    assert weight(1, 0, 0) == 0
    assert weight(sp.Rational(1, 2), 3, 0) == 0


def test_entry_matches_source_formula_and_below_diagonal():
    s, N = sp.Integer(1), 4
    for n in range(4):
        for m in range(4):
            expected = (
                sp.Integer(0)
                if n < m
                else sp.binomial(n, m) * weight(s, n - m, N)
            )
            assert sp.simplify(entry(s, N, m, n) - expected) == 0
    # Every strictly-below-diagonal entry is exactly zero.
    for m in range(1, 4):
        for n in range(m):
            assert entry(s, N, m, n) == 0


def test_matrix_A_upper_triangular_and_constant_diagonal():
    for s in (sp.Integer(1), sp.Rational(1, 2), sp.Rational(1, 2) + sp.I / 3):
        for N in (1, 3):
            for k in (0, 1):
                M = matrix_A(s, N, k)
                assert M.shape == (k + 1, k + 1)
                assert is_upper_triangular(M)
                assert diag_constant(s, N, k)
                c = weight(s, 0, N)
                assert M.trace() == (k + 1) * c


def test_det_A_and_det_one_minus_A_closed_forms():
    for s in (sp.Integer(1), sp.Integer(2), sp.Rational(1, 2)):
        for N in (1, 3):
            c = weight(s, 0, N)
            for k in (0, 1, 2):
                assert sp.simplify(det_A(s, N, k) - c ** (k + 1)) == 0
                assert sp.simplify(
                    det_one_minus_A(s, N, k) - (1 - c) ** (k + 1)
                ) == 0


def test_symmetric_2x2_real_spectrum():
    # Rational symmetric matrices, including one with a non-square discriminant.
    for a, b, d in ((2, 1, 2), (1, 2, 4), (1, 1, 0), (-3, 5, 7)):
        data = realise_symmetric_2x2(a, b, d)
        assert sp.simplify(data["discriminant"]) >= 0
        # Trace and determinant match the characteristic polynomial.
        assert sp.simplify(data["trace"] - (a + d)) == 0
        assert sp.simplify(data["determinant"] - (a * d - b * b)) == 0
        # Both stated roots really are roots of the characteristic polynomial.
        assert data["charpoly_at_l1"] == 0
        assert data["charpoly_at_l2"] == 0
        # The discriminant is exactly the squared eigenvalue gap.
        l1, l2 = eigenvalues_2x2(a, b, d)
        assert sp.simplify((l1 - l2) ** 2 - discriminant_2x2(a, b, d)) == 0


def test_source_critical_line_parameter():
    # The source evaluates the transfer operator at s = 1/2 + i t.
    t = sp.Rational(1, 3)
    s = sp.Rational(1, 2) + sp.I * t
    N, k = 3, 1
    c = weight(s, 0, N)
    assert diag_constant(s, N, k)
    M = matrix_A(s, N, k)
    assert is_upper_triangular(M)
    assert M.trace() == (k + 1) * c
    # The finite determinant is the product of the (equal) diagonal entries of
    # I - A_k, so the factorised form is exact without expanding complex powers.
    diagonal = [(sp.eye(k + 1) - M)[i, i] for i in range(k + 1)]
    assert diagonal == [1 - c] * (k + 1)


def test_edge_cases_and_invalid_inputs():
    # Empty truncation N = 0: A_k is the zero matrix.
    assert weight(1, 0, 0) == 0
    assert matrix_A(1, 0, 2) == sp.zeros(3, 3)
    assert det_A(1, 0, 2) == 0
    assert det_one_minus_A(1, 0, 2) == 1
    # A 1 x 1 truncation is just the scalar c.
    assert sp.simplify(det_A(1, 2, 0) - weight(1, 0, 2)) == 0
    # Invalid arguments are rejected rather than silently truncated.
    with pytest.raises(ValueError):
        weight(1, 0, -1)
    with pytest.raises(ValueError):
        entry(1, 2, -1, 0)
    with pytest.raises(ValueError):
        matrix_A(1, 2, -1)
    with pytest.raises(ValueError):
        is_upper_triangular(sp.Matrix([[1, 2]]))
    # The discriminant is always non-negative, including the degenerate b = 0 case.
    for a, d in ((0, 0), (5, 5), (-2, 7)):
        assert discriminant_2x2(a, 0, d) >= 0
        cp = charpoly_2x2(a, 0, d)
        x = sp.Symbol("x")
        assert sp.expand(cp - (x - a) * (x - d)) == 0
