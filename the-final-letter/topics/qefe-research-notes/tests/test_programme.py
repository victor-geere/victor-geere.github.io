import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    ISING,
    SU2_4,
    Datum,
    categorical_psi,
    nonunit_mass,
    normalisation_ratio,
    qefe_prefactor,
)


def test_ising_finite_egyptian_core():
    assert ISING.D2 == 4
    assert ISING.denominators == (4, 2, 4)
    assert sp.simplify(ISING.total_mass - 1) == 0
    assert sp.simplify(ISING.nonunit_mass - sp.Rational(3, 4)) == 0
    assert sp.simplify(ISING.nonunit_mass - nonunit_mass(4)) == 0
    assert sp.simplify(nonunit_mass(4) + ISING.reciprocals[0] - 1) == 0


def test_su2_4_finite_egyptian_core():
    assert SU2_4.D2 == 12
    assert SU2_4.denominators == (12, 4, 3, 4, 12)
    assert sp.simplify(SU2_4.total_mass - 1) == 0
    assert sp.simplify(SU2_4.nonunit_mass - sp.Rational(11, 12)) == 0
    assert sp.simplify(SU2_4.nonunit_mass - nonunit_mass(12)) == 0


def test_psi_at_zero_and_one():
    # Both worked examples have a finite Dirichlet polynomial satisfying
    # Ψ(0) = Σ χ(m_i) = 1 and Ψ(1) = Σ χ(m_i)/m_i = 0 exactly.
    for datum in (ISING, SU2_4):
        assert sp.simplify(categorical_psi(datum, 0) - 1) == 0
        assert sp.simplify(categorical_psi(datum, 1)) == 0
    assert sp.simplify(categorical_psi(ISING, sp.Rational(1, 2))) != 0


def test_two_mellin_normalisations_disagree_off_centre():
    # §2.4 uses Γ(s) π^{-s} D^{2s}; §5.3 silently replaces it by
    # Γ((s+a)/2) π^{-(s+a)/2} D^s.  The ratio is not 1.
    ratio = normalisation_ratio(4, 0, sp.Rational(3, 10))
    value = float(sp.N(ratio, 25))
    assert abs(value - 1.0) > 0.5
    assert abs(value - 2.0052748027723841) < 1e-12


def test_centre_prefactor_degenerates_exactly():
    # The archived QEFE is automatic at s = 1/2: the prefactor is 1.
    for datum, parity in ((ISING, 0), (SU2_4, 1)):
        assert sp.simplify(qefe_prefactor(datum.D2, parity, sp.Rational(1, 2)) - 1) == 0
    # Away from the centre it is not 1, so the central check is not evidence.
    assert sp.simplify(qefe_prefactor(4, 0, sp.Rational(3, 10)) - 1) != 0


def test_egyptian_edge_cases():
    # The trivial category: one unit object, no non-unit mass.
    trivial = Datum("trivial", (sp.Integer(1),), (1,))
    assert trivial.total_mass == 1
    assert trivial.nonunit_mass == 0
    assert nonunit_mass(1) == 0

    with pytest.raises(ValueError):
        nonunit_mass(0)
    with pytest.raises(ValueError):
        Datum("empty", (), ())
    with pytest.raises(ValueError):
        Datum("no unit", (sp.Integer(2), sp.Integer(2)), (1, -1))
    with pytest.raises(ValueError):
        Datum("zero dim", (sp.Integer(1), sp.Integer(0)), (1, 1))
    with pytest.raises(ValueError):
        Datum("bad sign", (sp.Integer(1), sp.Integer(2)), (1, 2))
    with pytest.raises(ValueError):
        Datum("mismatch", (sp.Integer(1), sp.Integer(2)), (1,))
