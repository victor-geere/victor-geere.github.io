import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    DELTA,
    S,
    chord,
    chord_closed,
    chord_product,
    chord_product_limit,
    north,
    pole_ratio,
    product_sequence,
    south,
)


def test_chord_product_identity_exact():
    """Computation C1: the last-chord product is independent of s."""
    for N in range(2, 9):
        expr = chord_product(N)
        assert sp.simplify(expr - chord_closed(N)) == 0


def test_chord_product_limit_is_quarter():
    """Computation C2: the closed form tends to 1/4."""
    assert chord_product_limit() == sp.Rational(1, 4)
    N = sp.symbols("N", positive=True, integer=True)
    closed = sp.Rational(1, 4) - 1 / (2 * N) + 1 / (4 * N**2)
    assert sp.limit(closed, N, sp.oo) == sp.Rational(1, 4)


def test_product_sequence_increasing_below_quarter():
    """Computation C3: c_N is strictly increasing on N >= 2 and below 1/4."""
    seq = product_sequence(60)
    assert all(seq[i] < seq[i + 1] for i in range(len(seq) - 1))
    assert all(q < sp.Rational(1, 4) for q in seq)
    assert seq[0] == sp.Rational(1, 16)


def test_pole_dichotomy_exact():
    """Computation C4: N^{-2d} * N^{2d} = 1 with one factor below 1."""
    for N in (2, 3, 10, 100):
        n = north(N, DELTA)
        s = south(N, DELTA)
        assert sp.simplify(n * s - 1) == 0
        assert sp.simplify(n.subs(DELTA, sp.Rational(1, 3)) - N ** sp.Rational(-2, 3)) == 0
        assert sp.N(n.subs(DELTA, 1), 30) < 1
        assert sp.N(s.subs(DELTA, 1), 30) > 1


def test_ratio_is_pure_negative_power():
    """Computation C5: H_N(1/2+d)/H_N(1/2-d) = N^{-4d}."""
    for N in (2, 5, 17):
        ratio = pole_ratio(N, DELTA)
        assert sp.simplify(ratio - N ** (-4 * DELTA)) == 0


def test_half_chord_square():
    """Computation C6: H_N(1/2)^2 equals the chord product."""
    for N in range(2, 12):
        half = chord(N, sp.Rational(1, 2))
        assert sp.simplify(half**2 - chord_closed(N)) == 0
        assert half == sp.Rational(1 - N, 2 * N)


def test_degenerate_scale_and_bad_input():
    """Edge case: N = 1 kills the chord; N = 0 is rejected."""
    assert chord(1, S) == 0
    assert chord_closed(1) == 0
    assert chord_product(1, S) == 0
    with pytest.raises(ValueError):
        chord(0, S)
    with pytest.raises(ValueError):
        chord_closed(-3)
    with pytest.raises(ValueError):
        product_sequence(1)
