"""Tests for the exact archimedean symbol."""

import sys
from pathlib import Path

import mpmath as mp

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import arch_symbol as A  # noqa: E402


def test_series_matches_digamma_formula():
    for xi in (0.5, 1.0, 2.0):
        s = A.arch_series(xi, 20000)
        f = A.arch_symbol(xi)
        assert abs(s - f) < 1e-4


def test_symmetry():
    for xi in (0.5, 1.5, 3.0):
        assert abs(A.arch_symbol(-xi) - mp.conj(A.arch_symbol(xi))) < 1e-20


def test_tail_shrinks():
    d1 = abs(A.arch_series(1.0, 10000) - A.arch_symbol(1.0))
    d2 = abs(A.arch_series(1.0, 40000) - A.arch_symbol(1.0))
    assert d2 < d1


def test_archimedean_sign_crossing():
    xc = A.arch_crossing()
    assert abs(xc - 6.2288527370) < 1e-8
    assert A.arch_real(xc - 0.1) > 0
    assert A.arch_real(xc + 0.1) < 0


def test_archimedean_imaginary_part_is_odd():
    for xi in (0.5, 2.0, 5.0):
        assert abs(A.arch_imag(-xi) + A.arch_imag(xi)) < 1e-14
