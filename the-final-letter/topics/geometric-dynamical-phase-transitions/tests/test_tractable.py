import sys
from pathlib import Path

import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from tractable import (  # noqa: E402
    BOURGAIN_THRESHOLD,
    bourgain_exponent,
    bourgain_threshold_holds,
    threshold_equivalence,
)


def test_bourgain_threshold_is_exact():
    assert BOURGAIN_THRESHOLD == sp.Rational(13, 194)
    assert sp.Rational(13, 194) < sp.Rational(1, 6)
    assert sp.Rational(13, 194) > 0


def test_bourgain_threshold_equivalence_on_samples():
    for eps in (
        sp.Rational(1, 20),
        sp.Rational(13, 194),
        sp.Rational(14, 194),
        sp.Rational(1, 10),
        sp.Rational(1, 6) - sp.Rational(1, 1000),
    ):
        assert threshold_equivalence(eps)


def test_bourgain_exponent_above_threshold():
    eps = sp.Rational(14, 194)
    assert bourgain_threshold_holds(eps)
    assert sp.simplify(bourgain_exponent(eps) - eps) < 0


def test_bourgain_exponent_below_threshold():
    eps = sp.Rational(12, 194)
    assert not bourgain_threshold_holds(eps)
