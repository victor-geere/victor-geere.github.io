"""Finite-level checks for the modular-tower candidate."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import modular_tower as M  # noqa: E402


def test_level11_known_coefficients():
    coeffs = M.level11_form(20)
    assert coeffs[1:8] == [1, -2, -1, 2, 1, 2, -2]
    assert coeffs[13] == 4


def test_hecke_eigenvalues():
    a = M.hecke_eigenvalues(20)
    assert a[2] == -2
    assert a[3] == -1
    assert a[5] == 1
    assert a[7] == -2
    assert a[13] == 4


def test_ramanujan_petersson_bound():
    assert M.ramanujan_bound_ok(300)
