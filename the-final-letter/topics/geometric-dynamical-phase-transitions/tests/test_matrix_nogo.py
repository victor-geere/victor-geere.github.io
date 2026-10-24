import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from matrix_nogo import (  # noqa: E402
    all_entries_nonneg,
    eta_two_neg_one,
    mat_prod,
    nonnegative_contraction,
)


def test_eta_two_neg_one():
    assert eta_two_neg_one() == -2


def test_nonnegative_product_stays_nonnegative():
    mats = [
        sp.Matrix([[2, 1], [0, 3]]),
        sp.Matrix([[1, 4], [2, 1]]),
        sp.Matrix([[0, 1], [1, 1]]),
    ]
    assert all_entries_nonneg(mat_prod(mats))


def test_nonnegative_contraction_is_nonnegative():
    mats = [
        sp.Matrix([[2, 1], [0, 3]]),
        sp.Matrix([[1, 4], [2, 1]]),
    ]
    value = nonnegative_contraction(mats, [1, 2], [3, 1])
    assert value >= 0


def test_nonnegative_contraction_cannot_hit_minus_two():
    mats = [sp.Matrix([[1, 2], [2, 1]]) for _ in range(4)]
    value = nonnegative_contraction(mats, [1, 1], [1, 1])
    assert value >= 0
    assert value != eta_two_neg_one()


def test_invalid_inputs_rejected():
    with pytest.raises(ValueError):
        mat_prod([])
    with pytest.raises(ValueError):
        nonnegative_contraction([sp.Matrix([[1, -1], [0, 1]])], [1, 0], [1, 0])
    with pytest.raises(ValueError):
        nonnegative_contraction([sp.eye(2)], [-1, 0], [1, 0])
