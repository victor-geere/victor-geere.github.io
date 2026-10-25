import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    PI,
    const_phase_torsion,
    frequency,
    frequency_gap,
    frenet_torsion,
    helix_projection_norm_sq,
    log_prime_power,
    matching_modulus_sq,
    prime_power_cutoff,
    source_torsion,
    torsion_denominator,
    von_mangoldt,
    zeta_coefficient,
)

T = sp.symbols("t", real=True)


def test_helix_lies_on_unit_cylinder():
    for phi in (T, 2 * T + sp.Rational(1, 3), T**2 / 2):
        assert helix_projection_norm_sq(phi) == 1


def test_frenet_torsion_matches_source_formula():
    # φ' > 0 on the test interval, so the helix is regular.
    for phi in (2 * T, T + T**2 / 2, 3 * T + T**2 / 2):
        assert sp.simplify(frenet_torsion(phi, T) - source_torsion(phi, T)) == 0


def test_constant_phase_torsion_exact_and_symmetric():
    assert const_phase_torsion(2) == sp.Rational(2, 5)
    assert const_phase_torsion(sp.Rational(1, 2)) == sp.Rational(2, 5)
    # τ(ω) = τ(1/ω): the same circular helix with reciprocal pitch.
    for omega in (sp.Rational(3, 7), sp.Integer(5)):
        assert sp.simplify(
            const_phase_torsion(omega) - const_phase_torsion(1 / omega)
        ) == 0
    # On a constant phase (q = 0) the denominator factors as p⁴(p² + 1).
    assert sp.simplify(torsion_denominator(3, 0) - 3**4 * (3**2 + 1)) == 0


def test_frequency_gap_and_conjugate_symmetry():
    L = sp.symbols("L", positive=True)
    assert sp.simplify(frequency_gap(L) - 2 * PI / L) == 0
    for k in (-3, -1, 0, 2, 5):
        assert sp.simplify(frequency(L, -k - 1) + frequency(L, k)) == 0


def test_matching_coefficient_has_unit_modulus():
    c = sp.symbols("c", real=True)
    assert sp.simplify(matching_modulus_sq(c)) == 1
    for value in (0, sp.Rational(1, 3), 2 * PI, -sp.Rational(7, 5)):
        assert sp.simplify(matching_modulus_sq(value)) == 1


def test_log_prime_power_and_cutoff_dictionary():
    # Exact identity log(p^m) = m log p for prime powers.
    for p in (2, 3, 5, 7):
        for m in (1, 2, 3, 4):
            assert log_prime_power(p, m) == 0
    # p^m ≤ λ²  ⇔  m log p ≤ 2 log λ, checked on both sides of the cutoff.
    grid = [(2, 1, 2), (2, 3, 3), (3, 2, 9), (5, 2, 25), (7, 1, 49), (11, 2, 120)]
    for p, m, lam in grid:
        arithmetic, logarithmic = prime_power_cutoff(p, m, lam)
        assert arithmetic == logarithmic
    # Tolerance note: prime_power_cutoff compares logarithms at 50 digits;
    # the grid uses distinct small integers whose logarithms differ by > 1e-2.


def test_zeta_arithmetic_coefficients():
    assert sp.simplify(zeta_coefficient(2, 1) - sp.log(2)) == 0
    assert sp.simplify(zeta_coefficient(2, 2) - sp.log(2)) == 0
    assert sp.simplify(zeta_coefficient(101, 1) - sp.log(101)) == 0
    # Λ(n) = log p exactly on prime powers and zero otherwise.
    for n in (2, 3, 4, 5, 8, 9, 16, 30):
        factors = sp.factorint(n)
        if len(factors) == 1:
            p = next(iter(factors))
            assert sp.simplify(von_mangoldt(n) - sp.log(p)) == 0
        else:
            assert von_mangoldt(n) == 0
    # The coefficient matches the von Mangoldt value on every prime power.
    assert sp.simplify(zeta_coefficient(2, 1) - von_mangoldt(2)) == 0
    assert sp.simplify(zeta_coefficient(2, 2) - von_mangoldt(4)) == 0
    assert sp.simplify(zeta_coefficient(3, 3) - von_mangoldt(27)) == 0


def test_edge_cases_reject_degenerate_phase():
    with pytest.raises(ValueError):
        const_phase_torsion(0)
    with pytest.raises(ValueError):
        const_phase_torsion(-1)
    with pytest.raises(ValueError):
        frequency(0, 1)
    with pytest.raises(ValueError):
        log_prime_power(1, 1)
    with pytest.raises(ValueError):
        zeta_coefficient(1, 1)
