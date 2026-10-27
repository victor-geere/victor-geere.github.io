"""018 round 4 — tests for the corrected singular series and the exact cubic count."""
import os
import sys

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
import singular_series as SS
import qrime as Q
import fast_twin as F


def buggy_S(q, D=60):
    """The round-2 evaluation: numerically catastrophic for large d."""
    import math
    s = 0.0
    for d in range(1, D + 1):
        I = Q.qrime_count_mobius(q, d)
        s += I * math.log((1 - 2 / q ** d) / (1 - 1 / q ** d) ** 2)
    return math.exp(s)


@pytest.mark.parametrize("q,val", [(3, 0.3961042817), (5, 0.7095443303), (7, 0.8127060034)])
def test_S_values(q, val):
    assert abs(SS.S(q) - val) < 1e-9


def test_bug_is_real():
    # the naive product drifts by O(1e-2) because log(1+eps)*I(d) is amplified
    assert abs(buggy_S(3) - SS.S(3)) > 0.05
    assert abs(buggy_S(7) - SS.S(7)) > 1e-2


def test_exact_vs_high_precision():
    for q in (3, 5):
        ex = float(SS.S_exact(q, 6))
        sy = float(SS.S_sym(q, 6, digits=25))
        assert abs(ex - sy) < 1e-12 * max(1.0, abs(ex))


def test_bounds_contain_value():
    for q in (3, 5, 7):
        lo, up = SS.S_bounds(q, 30)
        s = SS.S(q)
        assert lo <= s <= up
        assert up - lo < 1e-10


def test_tail_bound_small():
    assert SS.tail_log_bound(3, 20) < 1e-9
    assert SS.tail_log_bound(5, 20) < 1e-14


@pytest.mark.parametrize("q", [5, 11, 17, 23, 29])
def test_cubic_exact_formula_q_2_mod_3(q):
    # Bary-Soroker–Stix, degree 3: T(3) = q(q-2)(q+1)/9 for q = 2 (mod 3)
    assert q % 3 == 2
    assert F.twin_count_fast(q, 3) == q * (q - 2) * (q + 1) // 9


@pytest.mark.parametrize("q,n", [(3, 8), (5, 5), (7, 4), (11, 3)])
def test_fast_matches_brute(q, n):
    assert F.twin_count_fast(q, n) == len(Q.twin_qrimes(q, n))
