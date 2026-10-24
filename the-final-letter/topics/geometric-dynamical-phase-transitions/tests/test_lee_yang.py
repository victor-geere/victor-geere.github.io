import sys
from pathlib import Path

import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from lee_yang import ising2_partition, ising2_roots, ising2_roots_on_unit_circle  # noqa: E402


def test_ising2_roots_are_on_unit_circle():
    for K in (sp.Rational(1, 2), sp.Integer(1), sp.Integer(2)):
        assert ising2_roots_on_unit_circle(K)


def test_ising2_roots_are_conjugates_and_product_one():
    for K in (sp.Rational(1, 3), sp.Integer(1)):
        roots = ising2_roots(K)
        assert len(roots) == 2
        assert sp.simplify(roots[0] * roots[1] - 1) == 0
        assert sp.simplify(roots[0] - sp.conjugate(roots[1])) == 0


def test_ising2_partition_vanishes_at_its_roots():
    K = sp.Integer(1)
    for root in ising2_roots(K):
        assert sp.simplify(ising2_partition(K, root)) == 0


def test_ising2_no_real_roots_for_positive_coupling():
    x = sp.symbols("x", real=True)
    K = sp.Integer(1)
    assert sp.solve(ising2_partition(K, x), x) == []
