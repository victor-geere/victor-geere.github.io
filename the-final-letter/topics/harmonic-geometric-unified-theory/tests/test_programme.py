import sys
from pathlib import Path

import pytest
import sympy as sp

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    egyptian_total,
    egyptian_weight,
    greedy_egyptian,
    harmonic_sum,
    milestones,
    open_problems,
    overlap_required,
    phase_duration_totals,
    phase_table,
    timeline_months,
)


def test_egyptian_weight_exact_and_edge():
    assert egyptian_weight(0) == 1
    assert egyptian_weight(1) == sp.Rational(1, 2)
    assert egyptian_weight(3) == sp.Rational(1, 4)
    # strictly decreasing
    values = [egyptian_weight(n) for n in range(12)]
    assert all(a > b for a, b in zip(values, values[1:]))
    with pytest.raises(ValueError):
        egyptian_weight(-1)


def test_harmonic_sum_exact():
    assert harmonic_sum(0) == 0
    assert harmonic_sum(1) == 1
    assert harmonic_sum(3) == sp.Rational(11, 6)
    assert harmonic_sum(4) == sp.Rational(25, 12)
    # monotone in the number of terms
    sums = [harmonic_sum(n) for n in range(8)]
    assert all(a < b for a, b in zip(sums, sums[1:]))
    with pytest.raises(ValueError):
        harmonic_sum(-1)


def test_greedy_egyptian_known_values():
    # 4/13 = 1/4 + 1/18 + 1/468
    assert greedy_egyptian(sp.Rational(4, 13)) == [4, 18, 468]
    assert greedy_egyptian(sp.Rational(1, 2)) == [2]
    assert egyptian_total(greedy_egyptian(sp.Rational(4, 13))) == sp.Rational(4, 13)


def test_greedy_egyptian_is_greedy_and_distinct():
    for k in range(1, 17):
        r = sp.Rational(k, 17)
        if not (0 < r < 1):
            continue
        denoms = greedy_egyptian(r)
        # first denominator is exactly ceil(1/r)
        assert denoms[0] == int(sp.ceiling(1 / r))
        # strictly increasing and distinct
        assert all(a < b for a, b in zip(denoms, denoms[1:]))
        # exact reconstruction
        assert egyptian_total(denoms) == r
        # every step removes at least half of the remainder at most
        rem = r
        for d in denoms:
            assert sp.Rational(1, d) <= rem
            rem = sp.simplify(rem - sp.Rational(1, d))
            assert 0 <= rem < sp.Rational(1, d)
        assert rem == 0


def test_greedy_egyptian_edge_cases():
    for bad in (sp.Integer(0), sp.Integer(1), sp.Rational(-1, 3), sp.Rational(3, 2)):
        with pytest.raises(ValueError):
            greedy_egyptian(bad)
    # an exact unit fraction terminates in one step
    assert greedy_egyptian(sp.Rational(1, 7)) == [7]
    # a large denominator is accepted and reconstructed exactly
    denoms = greedy_egyptian(sp.Rational(63, 64))
    assert denoms[0] == 2
    assert egyptian_total(denoms) == sp.Rational(63, 64)


def test_phase_table_arithmetic():
    table = phase_table()
    assert len(table) == 7
    assert [p.number for p in table] == list(range(1, 8))
    assert all(p.min_months <= p.max_months for p in table)
    assert phase_duration_totals() == (72, 108)
    assert timeline_months() == 36
    # the plan's own durations exceed a sequential three-year horizon
    assert overlap_required()
    assert sum(p.max_months for p in table) > timeline_months()


def test_milestones_and_open_problems():
    ms = milestones()
    assert sorted(ms) == [1, 2, 3]
    covered = [p for year in ms.values() for p in year]
    assert sorted(covered) == [1, 2, 3, 4, 5, 6]
    # Phase 7 is not assigned to a milestone year; it overlaps them
    assert 7 not in covered
    problems = open_problems()
    assert len(problems) == 4
    assert "Monotonicity" in problems[1]
    assert all(isinstance(p, str) and p for p in problems)
