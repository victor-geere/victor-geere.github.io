"""Tests for the finite crossed-product Hodge index."""

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import finite_crossed_product as C  # noqa: E402


def test_algebra_relations():
    v = C.V(3)
    assert np.allclose(v @ v, np.eye(3))
    for x in range(3):
        u = C.U(3, x)
        assert np.allclose(v @ u @ v, C.U(3, -x))


def test_form_nonnegative_on_algebra():
    rho = C.nontracial_state()
    for a in C.algebra_basis():
        assert C.transverse_form(rho, a) >= -1e-10


def test_tracial_state_gives_zero_form():
    rho = C.tracial_state()
    for a in C.algebra_basis():
        assert abs(C.transverse_form(rho, a)) < 1e-12


def test_hodge_index_on_kernel():
    for rho in (C.tracial_state(), C.nontracial_state()):
        assert C.hodge_index_holds(rho)


def test_nontracial_form_is_positive_somewhere():
    rho = C.nontracial_state()
    assert max(C.transverse_form(rho, a) for a in C.algebra_basis()) > 1e-6
