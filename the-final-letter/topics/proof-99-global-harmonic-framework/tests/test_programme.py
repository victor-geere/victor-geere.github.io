import sys
from pathlib import Path

import mpmath as mp
import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    a,
    a_squared,
    b,
    b_squared,
    b_squared_partial,
    critical_line_modulus,
    rank_one_det,
    rank_one_det_formula,
    symmetry_defect,
    telescoping_partial,
    weighted_gram_det,
    weighted_gram_det_formula,
)


def test_coefficient_sequences_and_errors():
    assert sp.simplify(a(1) - 1 / sp.sqrt(2)) == 0
    assert b(1) == sp.Rational(1, 2)
    assert a_squared(3) == sp.Rational(1, 12)
    assert b_squared(3) == sp.Rational(1, 16)
    # b_n < a_n for n >= 1, the elementary ordering of the two sequences
    assert sp.simplify(a(2) - b(2)).is_positive
    for bad in (0, -1):
        with pytest.raises(ValueError):
            a(bad)
        with pytest.raises(ValueError):
            b(bad)


def test_telescoping_partial_sum_exact():
    running = sp.Integer(0)
    for n in range(0, 41):
        if n >= 1:
            running += a_squared(n)
        assert telescoping_partial(n) == sp.Rational(n, n + 1)
        assert running == telescoping_partial(n)


def test_b_squared_partial_matches_harmonic():
    for n in range(0, 11):
        assert b_squared_partial(n) == sp.harmonic(n + 1, 2) - 1
    # edge case: the empty sum vanishes
    assert b_squared_partial(0) == 0


def test_rank_one_determinant_matches_lemma():
    for n_max in (1, 2, 3):
        assert sp.simplify(rank_one_det(n_max) - rank_one_det_formula(n_max)) == 0
    # edge case: the empty determinant is 1
    assert rank_one_det_formula(0) == 1
    assert rank_one_det(0) == 1


def test_weighted_gram_determinant_critical_line():
    # s = 1/2 gives rational weights d_n = 1/(n+2), so the check is exact.
    for n_max in (1, 2):
        for s in (sp.Rational(1, 2), sp.Integer(1)):
            assert (
                sp.simplify(
                    weighted_gram_det(n_max, s) - weighted_gram_det_formula(n_max, s)
                )
                == 0
            )
    # edge case: empty product
    assert weighted_gram_det_formula(0, sp.Rational(1, 2)) == 1
    assert weighted_gram_det(0, sp.Rational(1, 2)) == 1


def test_critical_line_modulus():
    tolerance = mp.mpf("1e-30")
    for n in (1, 2, 7):
        for t in (0.0, 0.5, 14.134725):
            modulus, expected = critical_line_modulus(n, t)
            assert abs(modulus - expected) < tolerance
    with pytest.raises(ValueError):
        critical_line_modulus(0, 1.0)


def test_canonical_kernel_is_not_symmetric():
    # The source calls K symmetric, but K = I + |a><b| with a != b is not:
    # the (1,2) and (2,1) entries differ by a_1 b_2 - a_2 b_1.
    defect = sp.simplify(symmetry_defect(2))
    expected = sp.simplify(a(1) * b(2) - a(2) * b(1))
    assert sp.simplify(defect - expected) == 0
    assert defect.is_positive
    # a single index has no off-diagonal entry, so the defect vanishes
    assert symmetry_defect(1) == 0
    with pytest.raises(ValueError):
        symmetry_defect(0)
