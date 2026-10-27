import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    amgm_bound_holds,
    amgm_slack,
    curvature_torsion_inversion,
    frenet_curvature,
    frenet_torsion,
    helix,
    helix_curvature,
    helix_torsion,
    source_torsion_formula,
    torsion_scale_law,
)

R, c, lam, k = sp.symbols("R c lambda k", positive=True)


def test_frenet_torsion_matches_closed_form():
    """C1: the direct Frenet torsion of the helix equals c/(R² + c²)."""
    assert sp.simplify(frenet_torsion(helix(R, c)) - c / (R**2 + c**2)) == 0


def test_frenet_curvature_matches_closed_form():
    """C2: the direct Frenet curvature equals R/(R² + c²)."""
    assert sp.simplify(frenet_curvature(helix(R, c)) - R / (R**2 + c**2)) == 0


def test_source_torsion_formula_disagrees():
    """C3: the archived display is not the helix torsion.

    For constant φ' = k (φ'' = φ''' = 0) the source formula gives
    k/(1 + k²)², while direct computation gives k/(1 + k²).  The
    difference is exactly −k³/(1 + k²)².
    """
    source = sp.simplify(source_torsion_formula(k, 0, 0))
    correct = k / (1 + k**2)
    diff = sp.simplify(source - correct)
    assert sp.simplify(diff + k**3 / (1 + k**2) ** 2) == 0
    assert sp.simplify(diff) != 0


def test_torsion_scale_law():
    """C4: uniform scaling by λ scales torsion by 1/λ."""
    assert torsion_scale_law(lam, R, c) == 0
    assert sp.simplify(helix_torsion(lam * R, lam * c) - helix_torsion(R, c) / lam) == 0


def test_scaling_changes_torsion():
    """C5: the source's scaling inference fails.

    In the constant-rate family the radius-1/2, pitch-1 helix has
    torsion 4/5, not 1/2.  Even a uniform scaling changes torsion,
    and the source's C_{1/2} is not a uniform scaling (z stays t).
    """
    unit = helix_torsion(1, 1)
    half_radius = helix_torsion(sp.Rational(1, 2), 1)
    double = helix_torsion(2, 2)
    assert unit == sp.Rational(1, 2)
    assert half_radius == sp.Rational(4, 5)
    assert double == sp.Rational(1, 4)
    assert half_radius != unit
    assert double != unit


def test_curvature_torsion_inversion():
    """C6: κ² + τ² = 1/(R² + c²) and the exact recovery of R and c."""
    s, recovered_r, recovered_c = curvature_torsion_inversion(R, c)
    assert sp.simplify(s - 1 / (R**2 + c**2)) == 0
    assert sp.simplify(recovered_r - R) == 0
    assert sp.simplify(recovered_c - c) == 0


def test_amgm_bound():
    """C7: exact AM–GM slack and the bound τ ≤ 1/(2R)."""
    slack = amgm_slack(R, c)
    assert sp.simplify(slack - (R - c) ** 2 / (2 * R * (R**2 + c**2))) == 0
    for r in (sp.Rational(1, 3), 1, sp.Rational(5, 2)):
        for cc in (sp.Rational(1, 7), 2, sp.Rational(9, 4)):
            assert amgm_bound_holds(r, cc)
            assert sp.simplify(1 / (2 * r) - helix_torsion(r, cc)) >= 0


def test_zero_radius_edge_case():
    """C8: R = 0 is a straight line, not a helix with torsion 1/c.

    The closed form is undefined as a Frenet torsion there (curvature
    is zero); the module's AM–GM check rejects the degenerate input.
    """
    assert helix_curvature(0, 1) == 0
    assert sp.simplify(frenet_torsion(helix(0, 1))) is sp.nan
    with pytest.raises(ValueError):
        amgm_bound_holds(0, 1)
