import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    remainder,
    selects,
    total_weight,
    total_weight_closed_form,
    transfer,
    transfer_iterate,
    transfer_sequence,
    weight,
)


def test_weight_exact_and_domain():
    """C1: the weights are exact rationals with a rejected negative index."""
    assert weight(0) == sp.Rational(1, 2)
    assert weight(3) == sp.Rational(1, 5)
    assert weight(100) == sp.Rational(1, 102)
    with pytest.raises(ValueError):
        weight(-1)


def test_weight_strictly_decreasing_and_bounded():
    """C2: 0 < weight(n) < weight(n-1) <= 1/2, checked exactly."""
    assert weight(0) == sp.Rational(1, 2)
    for n in range(40):
        assert sp.Integer(0) < weight(n) <= sp.Rational(1, 2)
        if n > 0:
            assert weight(n) < weight(n - 1)


def test_transfer_positivity():
    """C3: a pointwise non-negative sequence stays non-negative."""
    seq = [sp.Integer(1), sp.Integer(0), sp.Rational(2, 3), sp.Integer(0)]
    transferred = transfer_sequence(seq)
    assert transferred == [
        sp.Integer(0),
        sp.Rational(2, 9),
        sp.Integer(0),
    ]
    assert all(x >= 0 for x in transferred)

    # Edge case: empty and singleton sequences have no image.
    assert transfer_sequence([]) == []
    assert transfer_sequence([sp.Integer(7)]) == []


def test_transfer_monotonicity():
    """C4: pointwise order is preserved by one transfer step."""
    a = [sp.Integer(0), sp.Rational(1, 4), sp.Rational(1, 2), sp.Integer(1)]
    b = [sp.Integer(1), sp.Rational(1, 2), sp.Integer(1), sp.Integer(2)]
    ta = transfer_sequence(a)
    tb = transfer_sequence(b)
    assert len(ta) == len(tb) == 3
    assert all(x <= y for x, y in zip(ta, tb))
    # The strict inequality at index 1 is preserved exactly.
    assert ta[1] == sp.Rational(1, 6)
    assert tb[1] == sp.Rational(1, 3)
    assert ta[1] < tb[1]


def test_transfer_iterate_positivity_and_edge():
    """C5: all iterates preserve non-negativity; over-iteration is empty."""
    seq = [sp.Integer(1), sp.Integer(2), sp.Rational(3, 2), sp.Integer(1)]
    for k in range(6):
        image = transfer_iterate(seq, k)
        assert all(x >= 0 for x in image)
        assert len(image) == max(len(seq) - k, 0)
    assert transfer_iterate(seq, 0) == seq
    assert transfer_iterate(seq, 4) == []
    with pytest.raises(ValueError):
        transfer_iterate(seq, -1)


def test_total_weight_exact_and_closed_form():
    """C6: the finite mass is exactly H_{N+1} - 1."""
    assert total_weight(0) == 0
    assert total_weight(1) == sp.Rational(1, 2)
    assert total_weight(2) == sp.Rational(5, 6)
    for n_max in range(25):
        assert total_weight(n_max) == total_weight_closed_form(n_max)
    assert total_weight_closed_form(10) == sp.Rational(55991, 27720)
    with pytest.raises(ValueError):
        total_weight(-1)


def test_remainder_and_selection_edge():
    """C7: the threshold is selected exactly and the remainder vanishes."""
    for n in range(8):
        threshold = weight(n)
        assert remainder(threshold, n) == 0
        assert selects(threshold, n) is True
        below = threshold - sp.Rational(1, 10**6)
        assert selects(below, n) is False
        assert remainder(below, n) < 0
        above = threshold + sp.Rational(1, 10**6)
        assert selects(above, n) is True
        assert remainder(above, n) > 0
    with pytest.raises(IndexError):
        transfer([sp.Integer(1)], 0)
