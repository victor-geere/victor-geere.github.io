import sys
from fractions import Fraction as F
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import programme as P  # noqa: E402


def test_sector_angle_sum():
    assert P.sector_angle_sum(0) == 0
    assert P.sector_angle_sum(1) == 1
    assert P.sector_angle_sum(4) == F(15, 8)
    for n in range(0, 12):
        assert P.sector_angle_sum(n) == P.sector_angle_closed_form(n)
        assert P.sector_angle_sum(n) <= 2


def test_normalized_half_turn_sum():
    assert P.half_turn_sum(0) == 0
    assert P.half_turn_sum(1) == F(1, 2)
    assert P.half_turn_sum(4) == F(15, 16)
    for n in range(0, 12):
        assert P.half_turn_sum(n) == P.half_turn_closed_form(n)
        assert P.half_turn_sum(n) < 1


def test_self_similar_total():
    assert P.self_similar_total(F(1), F(1, 2)) == 2
    assert P.self_similar_total(F(3), F(1, 3)) == F(9, 2)
    assert P.self_similar_total(F(0), F(1, 2)) == 0


def test_geometric_partial_sum():
    for n in range(0, 10):
        assert P.geometric_partial(F(1), F(1, 2), n) == P.geometric_closed_form(
            F(1), F(1, 2), n
        )
    assert P.geometric_closed_form(F(1), F(1, 2), 3) == F(7, 4)


def test_reciprocal_weights_not_geometric():
    weights = P.reciprocal_weights(5)
    assert weights == [F(1), F(1, 2), F(1, 3), F(1, 4), F(1, 5)]
    assert not P.is_constant_ratio(weights)
    assert P.reciprocal_weights_not_geometric()
    # A genuine geometric sequence is constant-ratio.
    assert P.is_constant_ratio([F(1, 2**k) for k in range(6)])


def test_invalid_ratio_rejected():
    with pytest.raises(P.NotSelfSimilar):
        P.self_similar_total(F(1), F(1))
    with pytest.raises(P.NotSelfSimilar):
        P.geometric_closed_form(F(1), F(1), 3)


def test_rational_cake_value():
    assert P.rational_cake_value(F(3, 2), F(2, 3)) == F(9, 2)
    assert P.rational_cake_value(F(1), F(9, 10)) == 10


def test_edge_cases():
    with pytest.raises(ValueError):
        P.sector_angle_terms(-1)
    with pytest.raises(ValueError):
        P.geometric_partial(F(1), F(1, 2), -1)
    with pytest.raises(ZeroDivisionError):
        P.successive_ratios([F(0), F(1)])


def test_squared_radii_encode_weights():
    weights = [F(1, 2), F(1, 4), F(1, 8)]
    r2 = P.squared_tail_radii(weights)
    assert r2 == [F(7, 8), F(3, 8), F(1, 8), F(0)]
    assert P.weights_from_squared_radii(r2) == weights
    assert P.annular_weights_sum(r2) == F(7, 8)


def test_annular_telescope():
    r2 = [F(9), F(4), F(1), F(0)]
    assert P.annular_telescope(r2) == 9
    assert P.weights_from_squared_radii(r2) == [F(5), F(3), F(1)]
    assert P.annular_weights_sum(r2) == 9


def test_annular_weights_sum():
    weights = [F(1, 3), F(1, 3), F(1, 3)]
    r2 = P.squared_tail_radii(weights)
    assert P.annular_weights_sum(r2) == 1
    assert r2[0] == 1
    assert r2[-1] == 0
    with pytest.raises(ValueError):
        P.squared_tail_radii([F(1), F(-1, 2)])
    with pytest.raises(ValueError):
        P.weights_from_squared_radii([F(1), F(2)])


def test_complex_tail_telescope():
    terms = [(F(1, 2), F(0)), (F(0), F(1, 2)), (F(-1, 4), F(0))]
    assert P.complex_tail(terms, 0) == (F(1, 4), F(1, 2))
    assert P.complex_tail(terms, 3) == (F(0), F(0))
    for n in range(4):
        assert P.coil_telescope(terms, n)
    assert P.coil_radius_squared(P.complex_tail(terms, 0)) == F(5, 16)


def test_unit_coil():
    terms = [(F(1, 2), F(0)), (F(0), F(1, 2)), (F(-1, 4), F(0))]
    assert P.unit_coil(terms, 0) == (F(1), F(0))
    assert P.unit_coil(terms, 3) == (F(0), F(0))
    with pytest.raises(ZeroDivisionError):
        P.unit_coil([(F(1), F(0)), (F(-1), F(0))], 0)


def test_phase_carrying_tuple():
    terms = [(F(3, 5), F(4, 5))]
    tail = P.complex_tail(terms, 0)
    assert P.coil_radius_squared(tail) == 1
    assert P.unit_coil(terms, 1) == (F(0), F(0))
    with pytest.raises(ZeroDivisionError):
        P.cdiv((F(1), F(0)), (F(0), F(0)))
