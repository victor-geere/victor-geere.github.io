"""Tests for the quaternion–cosine computation layer."""

import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    alignment_energy,
    detector,
    detector_on_divisors,
    displacement_quaternion,
    divisors_exact,
    is_divisor,
    phase,
    quaternion_mul,
    quaternion_norm_sq,
    warp_factor,
    warped_height,
    PI,
)


def test_quaternion_units_are_exact():
    i = (sp.Integer(0), sp.Integer(1), sp.Integer(0), sp.Integer(0))
    j = (sp.Integer(0), sp.Integer(0), sp.Integer(1), sp.Integer(0))
    k = (sp.Integer(0), sp.Integer(0), sp.Integer(0), sp.Integer(1))
    minus_one = (sp.Integer(-1), sp.Integer(0), sp.Integer(0), sp.Integer(0))
    assert quaternion_mul(i, i) == minus_one
    assert quaternion_mul(j, j) == minus_one
    assert quaternion_mul(k, k) == minus_one
    assert quaternion_mul(i, j) == k
    assert quaternion_mul(j, i) == (-k[0], -k[1], -k[2], -k[3])


def test_phase_norm_matches_alignment_energy():
    for x, p in [(1, 12), (3, 12), (sp.Rational(7, 2), 12), (5, 12)]:
        q = phase(x, p)
        d = displacement_quaternion(x, p)
        assert sp.simplify(quaternion_norm_sq(q) - (q[1] ** 2 + q[2] ** 2)) == 0
        assert sp.simplify(quaternion_norm_sq(d) - alignment_energy(x, p)) == 0


def test_detector_vanishes_at_all_divisors():
    assert divisors_exact(12) == [1, 2, 3, 4, 6, 12]
    for value in detector_on_divisors(12):
        assert sp.simplify(value) == 0
    for d in divisors_exact(12):
        assert is_divisor(12, d)


def test_detector_negative_off_divisors():
    # 5 does not divide 12 and 7/2 is not an integer divisor.
    for x in (5, sp.Rational(7, 2)):
        value = sp.simplify(detector(x, 12))
        assert value.is_negative is True
        assert is_divisor(12, x) is False


def test_alignment_energy_zero_at_divisors_and_positive_off():
    for d in divisors_exact(12):
        assert sp.simplify(alignment_energy(d, 12)) == 0
    # x = 1/2, p = 1: cos(2π p/x) = cos(4π) = 1 and cos(2πx) = -1.
    assert sp.simplify(alignment_energy(sp.Rational(1, 2), 1)) == 4
    assert sp.simplify(detector(sp.Rational(1, 2), 1)) == -2


def test_warp_factor_vanishing_and_warped_height():
    assert sp.simplify(warp_factor(sp.Rational(1, 2))) == 0
    assert sp.simplify(warp_factor(sp.Rational(3, 4)) - sp.Rational(1, 2)) == 0
    assert sp.simplify(warped_height(14, sp.Rational(3, 4)) - 28) == 0
    with pytest.raises(ValueError):
        warped_height(14, sp.Rational(1, 2))


def test_edge_cases_reject_nonpositive_inputs():
    for bad in (0, -1):
        with pytest.raises(ValueError):
            phase(bad, 12)
        with pytest.raises(ValueError):
            detector(1, bad)
        with pytest.raises(ValueError):
            divisors_exact(bad)
    with pytest.raises(ValueError):
        is_divisor(12, 0)
    # p = 1 is the smallest admissible modulus; its only divisor is 1.
    assert divisors_exact(1) == [1]
    assert sp.simplify(detector(1, 1)) == 0
