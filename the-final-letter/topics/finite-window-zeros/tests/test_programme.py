import math
import sys
from pathlib import Path

import mpmath as mp
import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from python.programme import (  # noqa: E402
    Box,
    alt_partial,
    factor_enclosure,
    pair_partial,
    pair_tail_bound,
    pair_term,
    zeta_enclosure,
)


def test_finite_regrouping_is_exact():
    mp.mp.dps = 40
    for s in (2, 3, mp.mpf(3) / 2, mp.mpf(2) + 1j / 3):
        left = alt_partial(s, 20)
        right = pair_partial(s, 10)
        assert abs(left - right) < mp.mpf("1e-30")


def test_pair_estimate_holds():
    mp.mp.dps = 30
    for s_re in (0.5, 1.0, 2.0):
        for m in (0, 1, 10, 100):
            s = mp.mpf(s_re) + mp.mpf("0.7") * 1j
            lhs = abs(pair_term(s, m))
            rhs = abs(s) * mp.mpf(2 * m + 1) ** (-s_re - 1)
            assert lhs <= rhs + mp.mpf("1e-25")


def test_tail_bound_positive_and_decreasing():
    b10 = pair_tail_bound(0.5, 5.0, 10)
    b100 = pair_tail_bound(0.5, 5.0, 100)
    assert b10 > 0 and b100 > 0 and b100 < b10


def test_tail_bound_edge_cases():
    assert pair_tail_bound(1.0, 0.0, 5) == 0.0
    with pytest.raises(ValueError):
        pair_tail_bound(0.0, 1.0, 5)
    with pytest.raises(ValueError):
        pair_tail_bound(0.5, 1.0, -1)


def test_point_enclosure_excludes_zero():
    mp.mp.dps = 40
    s = mp.mpf(1) / 2 + 5j
    box, radius = zeta_enclosure(0.5, 0.5, 5.0, 5.0, M=2000, dps=40)
    assert radius > 0
    assert box.contains(complex(mp.zeta(s)), tol=1e-12)
    assert box.distance_to_zero() > 0


def test_enclosure_at_two_contains_pi_squared_over_six():
    box, _ = zeta_enclosure(2.0, 2.0, 0.0, 0.0, M=3000, dps=40)
    assert box.contains(float(mp.pi) ** 2 / 6, tol=1e-9)


def test_factor_contains_zero_at_one():
    f = factor_enclosure(1.0, 1.0, 0.0, 0.0)
    assert f.distance_to_zero() == 0.0
    with pytest.raises(ValueError):
        zeta_enclosure(1.0, 1.0, 0.0, 0.0, M=10)


def test_invalid_inputs():
    with pytest.raises(ValueError):
        pair_term(2.0, -1)
    with pytest.raises(ValueError):
        pair_partial(2.0, -1)
    with pytest.raises(ValueError):
        zeta_enclosure(0.0, 0.5, 0.0, 1.0, M=10)


def test_box_distance_and_width():
    b = Box(1.0, 2.0, -1.0, 1.0)
    assert b.distance_to_zero() == 1.0
    assert b.width() == 2.0
