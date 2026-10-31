"""Finite checks for the Frobenius-alternative note.

The Hecke eigenvalues of the weight-12 form ``Delta`` are the algebraic shadow
of the Frobenius correspondence; the Ramanujan--Petersson bound is the
corresponding Riemann hypothesis (Deligne).  The elliptic-curve table
illustrates why no single algebraic correspondence over ``Q`` can specialise
to Frobenius at every prime: the trace ``a_p`` varies.
"""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import frobenius_alternative as F  # noqa: E402


def test_tau_known_values():
    tau = F.ramanujan_tau(12)
    assert tau[0] == 0
    assert tau[1:13] == [
        1, -24, 252, -1472, 4830, -6048, -16744,
        84480, -113643, -115920, 534612, -370944,
    ]


def test_tau_is_multiplicative():
    assert F.tau_multiplicativity_ok(300)


def test_hecke_recurrence_at_prime_powers():
    assert F.hecke_recurrence_ok(500)


def test_ramanujan_petersson_bound():
    result = F.check_ramanujan_bound(500)
    assert result["bad"] == []
    assert result["primes"] == 95
    assert 0.9 < result["worst_ratio"] < 1.0
    assert result["worst_prime"] == 103


def test_elliptic_traces_are_not_a_fixed_trace():
    primes = [p for p in F.primes_upto(120) if p >= 5]
    table = F.elliptic_trace_table(1, 1, primes)
    assert table[5] == -3
    assert table[7] == 3
    assert not F.has_fixed_trace(table)
    assert len(set(table.values())) >= 10


def test_small_field_point_counts():
    # y^2 = x^3 + x + 1 over F_5 has 9 points, so a_5 = 5 + 1 - 9 = -3.
    assert F.point_count(1, 1, 5) == 9
