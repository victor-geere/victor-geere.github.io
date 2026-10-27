import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from signed_f4 import (  # noqa: E402
    S,
    SINV,
    gauge,
    gauge_contraction_preserved,
    gauge_product,
    signed_reg_mat,
    signed_represents_polygon,
)


def test_signed_gauge_inverse():
    assert S * SINV == sp.eye(2)
    assert SINV * S == sp.eye(2)


def test_gauged_matrix_is_non_upper_triangular():
    A = signed_reg_mat(2, 1)
    B = gauge(A)
    assert B[1, 0] == -1
    assert B[1, 0] != 0


def test_gauge_product_preserves_contraction():
    mats = [signed_reg_mat(2, m) for m in range(1, 5)]
    for u in ([1, 0], [1, 2], [3, -1]):
        for w in ([1, 0], [0, 1], [2, 3]):
            assert gauge_contraction_preserved(mats, u, w)


def test_signed_representation_matches_polygon():
    for N in (2, 3, 4):
        assert signed_represents_polygon(N)


def test_invalid_reg_matrix():
    with pytest.raises(ValueError):
        signed_reg_mat(1, 1)
    with pytest.raises(ValueError):
        signed_reg_mat(2, 0)
