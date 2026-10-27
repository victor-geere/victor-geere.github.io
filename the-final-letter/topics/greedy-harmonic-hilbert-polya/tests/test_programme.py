import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    block_constant,
    block_trace,
    disc0,
    discriminant,
    discriminant_closed_form,
    eigenvalue_ordering_holds,
    partial_determinant,
    partial_determinant_closed_form,
    partial_trace,
    partial_trace_closed_form,
    q0,
    q_n,
    roots0,
    roots_n,
    vieta_product,
    vieta_sum,
)


def test_q0_exact_roots_and_coefficients():
    low, high = roots0()
    assert sp.simplify(q0(low)) == 0
    assert sp.simplify(q0(high)) == 0
    assert sp.simplify(low + high - sp.Rational(3, 2)) == 0
    assert sp.simplify(low * high - sp.Rational(1, 4)) == 0
    assert disc0() == sp.Rational(5, 4)
    # The two roots are distinct: the discriminant really is positive.
    assert sp.simplify(high - low) != 0


def test_qn_discriminant_closed_form():
    for n in range(1, 51):
        assert sp.simplify(discriminant(n) - discriminant_closed_form(n)) == 0
    with pytest.raises(ValueError):
        discriminant_closed_form(0)


def test_qn_closed_form_roots_satisfy_quadratic():
    for n in range(1, 41):
        low, high = roots_n(n)
        assert sp.simplify(q_n(n, low)) == 0
        assert sp.simplify(q_n(n, high)) == 0
        assert sp.simplify(high - low) != 0


def test_qn_vieta_bookkeeping():
    for n in range(1, 51):
        low, high = roots_n(n)
        assert sp.simplify(low + high - vieta_sum(n)) == 0
        assert sp.simplify(low * high - vieta_product(n)) == 0
        assert block_trace(n) == vieta_sum(n)
        assert block_constant(n) == vieta_product(n)


def test_eigenvalue_ordering_and_tolerance_edge():
    # Source ordering 0 < λₙ,₋ < 1 < λₙ,₊, checked to 40 digits.
    assert eigenvalue_ordering_holds(150)
    low, high = roots0()
    assert float(low) == pytest.approx(0.19098300562505255, abs=1e-15)
    assert float(high) == pytest.approx(1.3090169943749475, abs=1e-15)
    with pytest.raises(ValueError):
        eigenvalue_ordering_holds(-1)


def test_partial_trace_closed_form():
    # 2N + 1 - H_{N+1}, exact for the first N blocks.
    for n_blocks in range(0, 31):
        assert sp.simplify(
            partial_trace(n_blocks) - partial_trace_closed_form(n_blocks)
        ) == 0
    assert partial_trace(0) == 0
    assert partial_trace(1) == sp.Rational(3, 2)


def test_partial_determinant_closed_form():
    for n_blocks in range(0, 16):
        assert sp.simplify(
            partial_determinant(n_blocks)
            - partial_determinant_closed_form(n_blocks)
        ) == 0
    assert partial_determinant(0) == 1
    assert partial_determinant(1) == sp.Rational(1, 4)


def test_index_and_edge_cases():
    s = sp.symbols("s")
    with pytest.raises(ValueError):
        q_n(0, s)  # Q₀ is defined separately, not by the general formula
    with pytest.raises(ValueError):
        q_n(-1, s)
    with pytest.raises(ValueError):
        discriminant(0)
    with pytest.raises(ValueError):
        partial_trace(-1)
    with pytest.raises(ValueError):
        partial_determinant(-1)
    with pytest.raises(TypeError):
        q_n(1.5, s)  # type: ignore[arg-type]
    # A near-miss is not a root.
    low, _ = roots_n(4)
    assert sp.simplify(q_n(4, low + sp.Rational(1, 1000))) != 0
