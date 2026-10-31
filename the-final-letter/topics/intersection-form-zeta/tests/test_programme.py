import sys
from fractions import Fraction as F
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import programme as P  # noqa: E402


def test_gram_matrix_entries():
    assert P.dot((1, 0, 0), (0, 1, 0)) == 1
    assert P.dot((1, 0, 0), (0, 0, 1)) == 1
    assert P.dot((0, 1, 0), (0, 0, 1)) == 1
    for v in [(1, 0, 0), (0, 1, 0), (0, 0, 1)]:
        assert P.self_sq(v) == 0


def test_self_intersection_examples():
    assert P.self_sq((1, 1, 0)) == 2
    assert P.self_sq((1, -1, 0)) == -2
    assert P.self_sq(P.ample()) == 6
    assert P.diagonal_self_intersection() == 0


def test_form_is_indefinite():
    assert P.self_sq((1, 1, 0)) > 0
    assert P.self_sq((1, -1, 0)) < 0


def test_hodge_defect_identity():
    for a in range(-3, 4):
        for b in range(-3, 4):
            for c in range(-3, 4):
                v = (a, b, c)
                defect = P.hodge_defect(v)
                rhs = 2 * ((a - b) ** 2 + (b - c) ** 2 + (c - a) ** 2)
                assert defect == rhs
                assert defect >= 0
                assert P.hodge_inequality(v)


def test_hodge_index_negative_on_complement():
    for a in range(-4, 5):
        for b in range(-4, 5):
            c = -a - b
            value = P.self_sq((a, b, c))
            assert value <= 0
            if value == 0:
                assert (a, b, c) == (0, 0, 0)


def test_signature_is_one_two():
    assert P.signature() == (1, 2)


def test_elliptic_point_count_known_value():
    # y^2 = x^3 - x over F_5 has 8 points including infinity.
    assert P.elliptic_point_count(5, -1, 0) == 8
    assert P.frobenius_trace(5, -1, 0) == -2


@pytest.mark.parametrize(
    "p,a,b",
    [(5, -1, 0), (7, -1, 0), (11, -1, 0), (13, 1, 1), (17, -1, 0), (19, 1, 1)],
)
def test_hasse_bound_examples(p, a, b):
    trace = P.frobenius_trace(p, a, b)
    assert trace**2 <= 4 * p
    data = P.reciprocal_root_data(p, a, b)
    assert data["discriminant"] <= 0
    assert data["reciprocal_root_product"] == F(p)


def test_invalid_domain_is_rejected():
    with pytest.raises(ValueError):
        P.elliptic_point_count(2, 1, 1)
    with pytest.raises(ValueError):
        P.elliptic_point_count(9, 1, 1)
    with pytest.raises(ValueError):
        P.elliptic_point_count(5, 0, 0)  # singular: y^2 = x^3


def test_vector_shape_is_rejected():
    with pytest.raises(ValueError):
        P.dot((1, 2), (1, 2, 3))
