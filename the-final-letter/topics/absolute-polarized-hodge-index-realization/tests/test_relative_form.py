"""Tests for the indefinite relative modular form."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import relative_form as R  # noqa: E402
from kms_transverse import random_density  # noqa: E402


def test_relative_form_is_not_always_nonnegative():
    rho = random_density(2, seed=0)
    psi = random_density(2, seed=10)
    assert R.relative_values(rho, psi).min() < -1e-9


def test_relative_form_can_be_positive():
    rho = random_density(2, seed=2)
    psi = random_density(2, seed=12)
    assert R.relative_values(rho, psi).max() > 1e-9


def test_mixed_signs_exist_at_n3():
    rho = random_density(3, seed=2)
    psi = random_density(3, seed=12)
    assert R.is_indefinite(rho, psi)


def test_symmetrized_form_is_also_indefinite():
    rho = random_density(3, seed=17)
    psi = random_density(3, seed=117)
    v = R.symmetric_values(rho, psi)
    assert v.max() > 1e-9
    assert v.min() < -1e-9
