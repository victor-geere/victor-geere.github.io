import math
import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    eml,
    exp_via_eml,
    harmonic_sine,
    log_via_eml,
    selection_count,
    source_fusion_step,
    source_harmonic_sine,
    source_python_sine,
    sqrt_via_eml,
)


def test_eml_exp_identity_exact():
    z = sp.symbols("z", real=True)
    assert sp.simplify(exp_via_eml(z) - sp.exp(z)) == 0
    assert sp.simplify(exp_via_eml(PI) - sp.exp(PI)) == 0
    assert sp.simplify(exp_via_eml(0) - 1) == 0


def test_eml_log_identity_exact():
    z = sp.symbols("z", positive=True)
    assert sp.simplify(log_via_eml(z) - sp.log(z)) == 0
    for value in (1, sp.Rational(2, 3), sp.E, sp.exp(sp.E)):
        assert sp.simplify(log_via_eml(value) - sp.log(value)) == 0


def test_eml_sqrt_identity_exact():
    u = sp.symbols("u", positive=True)
    assert sp.simplify(sqrt_via_eml(u) - sp.sqrt(u)) == 0
    for value in (1, 4, sp.Rational(9, 16), 2):
        assert sp.simplify(sqrt_via_eml(value) - sp.sqrt(value)) == 0


def test_eml_rejects_nonpositive_second_argument():
    for bad in (0, -1, sp.Float("-0.5"), sp.I):
        with pytest.raises(ValueError):
            eml(1, bad)
    # A symbolic positive argument is accepted (positivity is undecidable here).
    y = sp.symbols("y", positive=True)
    assert sp.simplify(eml(0, y) - (1 - sp.log(y))) == 0


def test_source_fusion_rule_counterexample():
    theta = 5 * math.pi / 12  # two harmonic angles are selected
    error_recurrence = abs(source_harmonic_sine(theta, 1000) - math.sin(theta))
    error_listing = abs(source_python_sine(theta, 1000) - math.sin(theta))
    assert error_recurrence > 0.3
    assert error_listing > 0.05
    assert abs(harmonic_sine(theta, 1000) - math.sin(theta)) < 1e-12
    # The printed step is also not the sine-addition step at symbolic level.
    s, h = sp.symbols("s h", positive=True)
    assert sp.simplify(
        source_fusion_step(s, h, 1)
        - (s * sp.sqrt(1 - h**2) + h * sp.sqrt(1 - s**2))
    ) != 0


def test_corrected_reconstruction_error_bound():
    n_max = 120
    bound = math.pi / (n_max + 2)
    for k in range(18):
        theta = k / 17 * (math.pi / 2)
        error = abs(harmonic_sine(theta, n_max) - math.sin(theta))
        assert error <= bound + 1e-12


def test_reconstruction_endpoints():
    assert harmonic_sine(0.0, 500) == pytest.approx(0.0, abs=1e-15)
    assert harmonic_sine(math.pi / 2, 500) == pytest.approx(1.0, abs=1e-15)
    assert harmonic_sine(math.pi, 500) == pytest.approx(0.0, abs=1e-12)


def test_selection_count_boundary_cases():
    assert selection_count(0.0, 200) == 0
    assert selection_count(math.pi / 2, 200) == 1
    assert selection_count(math.pi, 200) == 3
    for k in range(21):
        assert 0 <= selection_count(k / 20 * math.pi, 200) <= 201
    # At an exact harmonic angle no earlier angle is selected.
    for n in range(1, 30):
        assert selection_count(math.pi / (n + 2), n) == 1
    with pytest.raises(ValueError):
        selection_count(math.pi / 4, -1)
