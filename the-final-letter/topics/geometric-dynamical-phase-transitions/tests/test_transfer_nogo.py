import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from transfer_nogo import (  # noqa: E402
    reg_coeff,
    reg_coupling,
    reg_matrix,
    reg_product_matches_polygon,
    register_couplings_nonnegative,
)


def test_register_coefficient_at_period():
    for N in (2, 3, 7):
        assert reg_coeff(N, N) == 1 - N
        assert reg_coeff(N, N) < 0


def test_register_product_matches_polygon():
    for N in (2, 3, 4, 5):
        for s in (sp.Rational(1, 2), sp.Integer(1), sp.Rational(-1, 2)):
            assert reg_product_matches_polygon(N, s)


def test_register_coupling_at_period_is_negative():
    for N in (2, 3, 7):
        for s in (-2, -sp.Rational(1, 2), 0, sp.Rational(1, 2), 3):
            assert sp.simplify(reg_coupling(N, s, N)) < 0


def test_register_chain_is_not_ferromagnetic():
    for N in (2, 3, 7):
        for s in (0, sp.Rational(1, 2), 2):
            assert not register_couplings_nonnegative(N, s)


def test_register_matrix_structure():
    A = reg_matrix(3, sp.Rational(1, 2), 3)
    assert A[0, 0] == 1
    assert A[1, 0] == 0
    assert A[1, 1] == 1
    assert A[0, 1] < 0
    with pytest.raises(ValueError):
        reg_matrix(1, 0, 1)
