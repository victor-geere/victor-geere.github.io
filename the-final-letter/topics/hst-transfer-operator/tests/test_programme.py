"""Exact tests for the hst-transfer-operator topic."""
from __future__ import annotations

import sys
from fractions import Fraction
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from python.programme import (  # noqa: E402
    branch0,
    branch1,
    constant_action,
    greedy_map,
    weight,
    weight_one_lower,
    weight_sum,
)


def test_branch_inverses_exact() -> None:
    """C1: both branches are exact right inverses on their domains."""
    for n in (0, 1, 5, 17):
        for y in (Fraction(0), Fraction(1, 7), Fraction(1, 2), Fraction(9, 10)):
            assert greedy_map(n, branch0(n, y)) == y
            assert greedy_map(n, branch1(n, y)) == y


def test_k_one_weight_at_least_half() -> None:
    """C2: the k=1 weight is at least 1/2 for every n."""
    for n in range(0, 100):
        assert weight_one_lower(n) >= Fraction(1, 2)


def test_constant_action_matches_direct_sum() -> None:
    """C3: the constant action equals the direct branch sum."""
    for N in (0, 1, 4, 9):
        for k in (1, 3, 5):
            c = Fraction(3, 5)
            direct = sum(
                (weight(n, k) * (c + c) for n in range(N)), Fraction(0)
            )
            assert constant_action(N, k, c) == direct


def test_weight_k3_decreasing_and_tail() -> None:
    """C4: the k=3 weights decrease and the first tail is exact."""
    values = [weight(n, 3) for n in range(12)]
    assert all(values[i] > values[i + 1] for i in range(len(values) - 1))
    assert weight_sum(5, 3) == sum(values[:5], Fraction(0))


def test_greedy_map_endpoints() -> None:
    """C5: T_n(0)=0 and T_n(1)=0."""
    for n in (0, 1, 8):
        assert greedy_map(n, Fraction(0)) == 0
        assert greedy_map(n, Fraction(1)) == 0


def test_negative_indices_rejected() -> None:
    """Edge case: negative indices are rejected."""
    with pytest.raises(ValueError):
        weight(-1, 3)
    with pytest.raises(ValueError):
        branch0(-1, Fraction(0))
