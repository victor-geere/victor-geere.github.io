"""Finite checks for the Riemann–Roch-square note."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import riemann_roch_square as R  # noqa: E402


def test_curve_level_dimension():
    # a = log((3^k - 1)/2) gives dim = k; a = 0,1,2,3 give 1,2,3,4.
    assert [R.rr_dimension(a) for a in (0.0, 1.0, 2.0, 3.0)] == [1, 2, 3, 4]
    assert R.rr_chi(0.0) == 1
    assert R.rr_chi(1.0) == 2
    assert R.rr_chi(2.0) == 3


def test_exceptional_set():
    # a = log(3/2) is in L, a = 1 is not.
    assert R.indicator_L(0.0) == 0
    assert R.indicator_L(0.5) == 1
    assert R.indicator_L(1.0) == 0


def test_local_torus_hrr():
    assert R.torus_hrr(0.0) == 0.0
    assert R.torus_hrr(2.0) == 1.0
    assert R.torus_hrr(4.0) == 2.0
    for d2 in (2, 4, 6):
        assert R.torus_hrr(d2).is_integer()


def test_periodic_local_term_is_finite_and_decaying():
    f = lambda x: __import__("math").exp(-x * x)
    values = [R.periodic_local_term(f, p) for p in (2, 3, 5, 7)]
    assert all(v > 0 for v in values)
    assert values[0] > values[-1]


def test_dimension_inequalities():
    # Subadditivity holds on a grid (Castelnuovo-type inequality).
    for i in range(0, 40):
        for j in range(0, 40):
            assert R.dimension_subadditive(i / 10, j / 10)
    # Submodularity fails: D = E = {∞}.
    assert R.rr_dimension(2.0) + R.rr_dimension(1.0) > \
        R.rr_dimension(1.0) + R.rr_dimension(1.0)
    # Log-concavity fails: D = 0.6{∞}, E = 0.1{∞}.
    assert R.rr_dimension(0.6) ** 2 < \
        R.rr_dimension(0.7) * R.rr_dimension(0.5)
