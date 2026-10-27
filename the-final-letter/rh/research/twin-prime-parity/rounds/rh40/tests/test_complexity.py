"""rh40 — the regression gate (HANDOFF.md §8.2, extended).

Run:  cd /Users/victor/workspace/rh && python3 -m pytest -q rh40/tests/
Slow mpmath / large-census tests are marked `slow`; deselect with
      python3 -m pytest -q rh40/tests/ -m "not slow"

Every test here is a *regression* test: each one encodes either a verified fact
from HANDOFF.md, a refuted law that must keep failing (§5), or a correction the
mediator established in this session.  Numbers were recomputed exactly with
`rh40/code/digitword.py` before the tests were written.
"""

from __future__ import annotations

import sys
from fractions import Fraction
from itertools import combinations
from math import gcd
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))

def pytest_configure(config):
    config.addinivalue_line("markers", "slow: long mpmath / large-census test")


from digitword import (  # noqa: E402
    SUPPORT_1_OVER_PI,
    SUPPORT_PI_EXACT,
    factor_set,
    first_difference_check,
    gaps,
    greedy_termination_index,
    greedy_word_rational,
    p_bruteforce,
    p_offset,
    right_special_count,
    slopes,
    span,
    word_from_ones,
)

N_PI = 1400
PI_ONES = SUPPORT_1_OVER_PI  # (2, 13, 607)

DIALOGUE_WORDS = [
    ("1/pi", (2, 13, 607), 1400),
    ("log2", (0, 4, 36, 6069), 13000),
    ("sqrt2-1", (1, 11, 251), 2000),
    ("e-2", (10, 20, 40, 80), 500),
]


# --------------------------------------------------------------------------- #
# 1.  the definition of record equals the bit-string definition
# --------------------------------------------------------------------------- #


def test_offset_tuple_equals_bruteforce():
    """§8.2(1): offset-tuple count == distinct bit-string factors, all words
    of length 12 with 0-4 ones, all L."""
    N = 12
    for m in range(0, 5):
        for ones in combinations(range(N), m):
            w = word_from_ones(ones, N)
            for L in range(1, N + 1):
                assert p_offset(ones, N, L) == p_bruteforce(w, L), (ones, L)


def test_offset_tuple_equals_bruteforce_decay_regime():
    """Mediator's M4: the two definitions also agree in the right-edge decay
    regime, where a lossy sparse encoding could plausibly diverge."""
    ones, N = PI_ONES, N_PI
    w = word_from_ones(ones, N)
    for L in (700, 791, 792, 793, 795, 800, 805, 900, 1000, 1200, 1390, 1397, 1398, 1399):
        assert p_offset(ones, N, L) == p_bruteforce(w, L), L


# --------------------------------------------------------------------------- #
# 2.  the prefix (C1) regime
# --------------------------------------------------------------------------- #


def test_base_case():
    """§8.2(2): p(L) = L + 1 for L <= min gap."""
    cases = [
        ((2, 13, 607), 1400),
        ((0, 4, 36, 6069), 13000),
        ((1, 11, 251), 2000),
        ((10, 20, 40, 80), 500),
    ]
    for ones, N in cases:
        dmin = min(gaps(ones)) if len(ones) > 1 else N
        for L in range(1, min(dmin, N) + 1):
            assert p_offset(ones, N, L) == L + 1, (ones, N, L)

    # A single one at a is fully solved in the non-degenerate regime
    # N >= 2a + 4 (the same eligibility condition as the plateau law a_m + 2):
    #     p(L) = min(L, a+1) + 1     for L <= N - a - 1
    #     p(L) = N - L + 1           for L >= N - a - 1
    # Both halves are verified by exhaustive enumeration in
    # verify/single_one_law_verify.py (log: verify/single_one_law_verify.log),
    # added 2025-10-06 because the enumeration this comment used to assert had no
    # enumerator anywhere in the repository: the first half is exact on all
    # 1 <= a < 60, N < 120 (239 599 cases); the combined law has ZERO
    # counterexamples for 1 <= a < 40 and N >= 2a + 4.  The spot checks below are
    # the fast regression gate for that census.  In the degenerate sliver
    # N < 2a + 4 the closed form needs care that is not worth the programme's time.
    for a, N in ((5, 40), (10, 40), (30, 34)):
        if N < 2 * a + 4:
            continue
        for L in range(1, N + 1):
            pred = min(L, a + 1) + 1 if L <= N - a - 1 else N - L + 1
            assert p_offset((a,), N, L) == pred, (a, N, L)
    # a = 30, N = 34 is degenerate on purpose: check the half that is regime-free
    for L in range(1, 34 - 30):
        assert p_offset((30,), 34, L) == min(L, 31) + 1, L


def test_c1_holds_beyond_min_gap_and_ends_below_next_gap():
    """Mediator's M6: C1 `p(L) = L + 1 + #{d_i < L}` is NOT confined to
    L <= min gap; it extends to a boundary strictly below the next gap.
    Exact measured first-failure points, which any corrected theory must hit."""
    expected_first_failure = {
        ("1/pi", (2, 13, 607), 1400): 13,
        ("log2", (0, 4, 36, 6069), 13000): 34,
        ("sqrt2-1", (1, 11, 251), 2000): 12,
        ("e-2", (10, 20, 40, 80), 500): 12,
    }
    for (name, ones, N), want in expected_first_failure.items():
        g = gaps(ones)
        # the first failure is always close to the small gaps, so bound the
        # search by the second-smallest gap + 8 rather than by max(g): scanning
        # to 4*max(g)+8 would be O(N^2) on the N = 13000 word.
        gs = sorted(g)
        hi = min(N - 1, (gs[1] if len(gs) > 1 else gs[0]) + 8)
        fails = [L for L in range(1, hi)
                 if L + 1 + sum(1 for d in g if L > d) != p_offset(ones, N, L)]
        assert fails[0] == want, (name, fails[:3])


# --------------------------------------------------------------------------- #
# 3.  the true slope structure  (correction to HANDOFF.md §3.1)
# --------------------------------------------------------------------------- #


def test_slope_change_points():
    """§8.2(3), corrected by M1/M2: the slope sequence for 1/pi is
    1 -> 2 -> 1 -> 0 -> -1, NOT 1 -> 2 -> 3, and there is no range with
    slope 3.  §3.1's `3L - 603` and `2L - 10 on [12,593]` are both false."""
    runs = slopes(PI_ONES, N_PI)
    assert runs == [
        (1, 10, 1),      # p(L+1)-p(L) = 1 on L in [1,10]
        (11, 13, 2),     # = 2 on [11,13]
        (14, 604, 1),    # = 1 on [14,604]  <-- the 2 -> 1 decrease
        (605, 791, 0),   # = 0 on [605,791]  <-- plateau
        (792, 1399, -1),  # = -1 on [792,1399] <-- decay
    ]


def test_handoff_31_closed_forms_are_false():
    """M1: §3.1's extrapolated closed forms must keep failing."""
    assert p_offset(PI_ONES, N_PI, 15) == 19    # 2L-10 would give 20
    assert p_offset(PI_ONES, N_PI, 20) == 24    # 2L-10 would give 30
    assert p_offset(PI_ONES, N_PI, 100) == 104  # 2L-10 would give 190
    assert p_offset(PI_ONES, N_PI, 593) == 597  # 2L-10 would give 1176
    assert p_offset(PI_ONES, N_PI, 594) == 598  # 3L-603 would give 1179


def test_handoff_31_table_of_measured_values_is_right():
    """The §3.1 TABLE is correct even though its closed forms are not."""
    table = {1: 2, 5: 6, 10: 11, 11: 12, 12: 14, 13: 16, 14: 18,
             15: 19, 20: 24, 50: 54, 100: 104, 300: 304,
             593: 597, 594: 598, 605: 609}
    for L, want in table.items():
        assert p_offset(PI_ONES, N_PI, L) == want, L


# --------------------------------------------------------------------------- #
# 4.  saturation values and their exact L-ranges
# --------------------------------------------------------------------------- #


def test_saturation_values():
    """§8.2(4): the four measured plateau values.

    Fast half only: the exact §3.3 values at the ORIGINAL truncations are
    asserted in `test_saturation_values_full` (slow — the N = 13000 sweep is
    O(N^2), ~5 min).  Here the same law is checked where it is cheap, plus the
    exact value at L = N - a_m - 1 for the N = 13000 word without a sweep.
    """
    assert max(p_offset((2, 13, 607), 1400, L) for L in range(1, 1401)) == 609
    assert max(p_offset((1, 11, 251), 2000, L) for L in range(1, 2001)) == 253
    assert max(p_offset((10, 20, 40, 80), 500, L) for L in range(1, 501)) == 82
    # log 2 is a_m + 2 = 6071; check the plateau point directly, no sweep
    o2, N2 = (0, 4, 36, 6069), 13000
    assert p_offset(o2, N2, N2 - o2[-1] - 1) == 6071
    assert p_offset(o2, N2, o2[-1] + 1) == 6071


@pytest.mark.slow
def test_saturation_values_full():
    """The exact §3.3 truncations, including the O(N^2) N = 13000 sweep."""
    assert max(p_offset((2, 13, 607), 1400, L) for L in range(1, 1401)) == 609
    assert max(p_offset((0, 4, 36, 6069), 13000, L) for L in range(1, 13001)) == 6071
    assert max(p_offset((1, 11, 251), 2000, L) for L in range(1, 2001)) == 253
    assert max(p_offset((10, 20, 40, 80), 500, L) for L in range(1, 501)) == 82


def test_plateau_is_an_interval_and_decay_starts_at_N_minus_am_minus_1():
    """Mediator's M3, measured: max p is attained on a contiguous interval and
    the decay p(L) = N - L + 1 holds for exactly L in [N - a_m - 1, N - 1].
    Fast half: the two small words plus the four dialogue words at reduced N.
    The full N = 13000 sweep is @pytest.mark.slow."""
    cases = [w for w in DIALOGUE_WORDS if w[2] <= 2000]
    cases += [("1/pi small", (2, 13, 607), 1300)]
    # the log 2 word is exercised in test_plateau_full_dialogue_words (slow)
    for name, ones, N in cases:
        vals = [p_offset(ones, N, L) for L in range(1, N + 1)]
        P = max(vals)
        idx = [i + 1 for i, v in enumerate(vals) if v == P]
        assert idx == list(range(idx[0], idx[-1] + 1)), name  # contiguous
        # decay law
        eq = [L for L in range(1, N) if p_offset(ones, N, L) == N - L + 1]
        assert eq == list(range(min(eq), N)), (name, min(eq))
        assert min(eq) == N - ones[-1] - 1, (name, min(eq), N - ones[-1] - 1)


@pytest.mark.slow
def test_plateau_full_dialogue_words():
    """The full dialogue-word sweep (includes N = 13000).  ~170 s: this is why
    it is marked slow.  Run with: pytest -q rh40/tests/ -m slow"""
    for name, ones, N in DIALOGUE_WORDS:
        vals = [p_offset(ones, N, L) for L in range(1, N + 1)]
        P = max(vals)
        idx = [i + 1 for i, v in enumerate(vals) if v == P]
        assert idx == list(range(idx[0], idx[-1] + 1)), name
        assert P == ones[-1] + 2, (name, P, ones[-1])
        assert idx[-1] == N - ones[-1] - 1, (name, idx[-1], N - ones[-1] - 1)
        eq = [L for L in range(1, N) if p_offset(ones, N, L) == N - L + 1]
        assert eq == list(range(min(eq), N)), (name, min(eq))


def test_plateau_value_is_not_a_function_of_m_span_N_alone():
    """§6.2 / C2a, decided on the exhaustive N = 20 table: (m, span, N) does
    NOT determine the plateau value."""
    N = 20
    key2val: dict[tuple, set] = {}
    for m in (1, 2, 3, 4):
        for ones in combinations(range(N), m):
            P = max(p_offset(ones, N, L) for L in range(1, N + 1))
            key2val.setdefault((m, span(ones), N), set()).add(P)
    collisions = {k: v for k, v in key2val.items() if len(v) > 1}
    assert collisions, "expected (m, span, N) to be insufficient"


# --------------------------------------------------------------------------- #
# 4b.  K1 THEOREM: the tree large-L law and the plateau value a_m + 2
#      (proof in rh40/K1_plateau_theorem.md; these are the regression locks)
# --------------------------------------------------------------------------- #


def _theorem_a(ones, N, L):
    """p(L) = min(a_m+1, N-L+1) + [L <= N-a_m-1]  for L >= max(span, a_m+1)."""
    a_m = ones[-1]
    return min(a_m + 1, N - L + 1) + (1 if L <= N - a_m - 1 else 0)


def test_plateau_theorem_exhaustive():
    """K1: Theorem A over ALL supports with m+1 <= 4 and N <= 22, every L from
    max(span, a_m+1).  The published exhaustive run (N <= 31) is
    verify/plateau_theorem.py; this is the fast in-gate version."""
    from itertools import combinations as _c
    ncase = 0
    for N in range(3, 23):
        for m in range(1, min(4, N)):
            for ones in _c(range(0, N), m):
                sp, a_m = span(ones), ones[-1]
                lo = max(sp, a_m + 1, 1)
                if lo > N - 1:
                    continue
                for L in range(lo, N):
                    ncase += 1
                    assert p_offset(ones, N, L) == _theorem_a(ones, N, L), (ones, N, L)
                # plateau value, on the plateau's own range
                for L in range(lo, N - a_m):
                    assert p_offset(ones, N, L) == a_m + 2, (ones, N, L, a_m)
    assert ncase > 10_000, ncase


def test_plateau_value_is_am_plus_2_dialogue():
    """K1 on the four dialogue words: max p = a_m + 2 exactly, and p at the
    plateau right edge N - a_m - 1 is that same value."""
    for name, ones, N in DIALOGUE_WORDS:
        a_m = ones[-1]
        assert p_offset(ones, N, N - a_m - 1) == a_m + 2, name
        # the plateau cannot extend past N - a_m - 1
        if N - a_m <= N - 1:
            assert p_offset(ones, N, N - a_m) == a_m + 1, name


def test_decay_law_is_proved_by_theorem_a():
    """C2b: p(L) = N - L + 1 for every L in [N - a_m - 1, N - 1]."""
    for name, ones, N in DIALOGUE_WORDS:
        a_m = ones[-1]
        assert p_offset(ones, N, N - 1) == 2, name
        for L in (N - a_m - 1, N - a_m, N - 2, N - 1):
            assert p_offset(ones, N, L) == N - L + 1, (name, L)


# --------------------------------------------------------------------------- #
# 4c.  K3 Theorem D, K2 Theorem E, K5 Theorem F
# --------------------------------------------------------------------------- #


def test_theorem_d_c1_regime_exhaustive():
    """K3 Theorem D: p(L) = L + 1 for L <= min(min_j d_j, a_0, N-a_0-1).
    Unconditional; verified on 399 486 cases in the published run (N <= 31),
    here over all supports with m+1 <= 4 and N <= 21."""
    from itertools import combinations as _c
    ncase = 0
    for N in range(3, 22):
        for m in range(1, min(4, N)):
            for ones in _c(range(N), m):
                a0 = ones[0]
                g = [b - a for a, b in zip(ones, ones[1:])]
                dmin = min(g) if g else N
                for L in range(1, min(N - 1, dmin, a0, N - a0 - 1) + 1):
                    ncase += 1
                    assert p_offset(ones, N, L) == L + 1, (ones, N, L)
    assert ncase > 5000, ncase


def test_theorem_e_onset_determinacy():
    """K2: the plateau onset is NOT a function of (gaps, N) but IS a function of
    (gaps, N, a_0).  Both halves are locked here on the small corpus."""
    from itertools import combinations as _c
    from digitword import gaps as _gaps

    def onset(ones, N):
        mx = max(p_offset(ones, N, L) for L in range(1, N + 1))
        return next(L for L in range(1, N + 1) if p_offset(ones, N, L) == mx)

    by_gaps, by_gaps_a0 = {}, {}
    for N in range(6, 21):
        for m in range(1, min(4, N)):
            for ones in _c(range(N), m):
                on = onset(ones, N)
                by_gaps.setdefault((tuple(_gaps(ones)), N), set()).add(on)
                by_gaps_a0.setdefault((tuple(_gaps(ones)), N, ones[0]), set()).add(on)
    # negative half: (gaps, N) must be insufficient
    assert any(len(v) > 1 for v in by_gaps.values())
    # positive half: (gaps, N, a_0) must be sufficient
    assert all(len(v) == 1 for v in by_gaps_a0.values())


def test_theorem_f_lower_bound_on_AN():
    """K5: r_{k+1} <= r_k^2, hence n_k <= (1/x)^{2^{k-1}} + 1, hence
    A(N) >= log2(log N / log(1/x)) - 1.  Checked numerically on six targets."""
    import mpmath as mp
    old = mp.mp.dps
    try:
        mp.mp.dps = 400
        env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
        for expr in ("1/pi", "log(2)", "sqrt(2)-1", "e-2", "sqrt(3)-1", "log(2)/log(10)"):
            x = mp.mpf(eval(expr, env))  # noqa: S307
            x = x - mp.floor(x) if x >= 1 else x
            if not (0 < x < 1):
                continue
            r = x
            for _ in range(8):
                u = 1 / r
                n = int(mp.ceil(u))
                r2 = r - mp.mpf(1) / n
                if r2 <= 0:
                    break
                assert r2 <= r ** 2 * (1 + mp.mpf("1e-30")), (expr, r, r2)
                r = r2
    finally:
        mp.mp.dps = old


# --------------------------------------------------------------------------- #
# 5.  the refuted laws must stay refuted
# --------------------------------------------------------------------------- #


def test_disproven_formulas_fail():
    """§8.2(5) + §5: every law refuted in the dialogue must fail on its
    recorded counterexample.  Regression against re-deriving dead ends."""
    ones, N = PI_ONES, N_PI
    g = gaps(ones)

    # A: p = L + 1 + #pairs at distance <= L
    def law_pairs(L):
        return L + 1 + sum(1 for a, b in combinations(ones, 2) if b - a <= L)
    assert law_pairs(11) != p_offset(ones, N, 11)
    assert law_pairs(13) != p_offset(ones, N, 13)

    # distinct distances <= L  --  HANDOFF §5 cites L = 12, but that does NOT
    # reproduce (dist = 14 = exact).  The true first failure is L = 11.
    def law_dist(L):
        return L + 1 + len({b - a for a, b in combinations(ones, 2) if b - a <= L})
    assert law_dist(12) == p_offset(ones, N, 12)   # §5's cited case is NOT a counterexample
    assert law_dist(11) != p_offset(ones, N, 11)   # the real one: 13 vs 12
    assert law_dist(13) != p_offset(ones, N, 13)

    # sum of (L - d_i)_+
    def law_sumgap(L):
        return L + 1 + sum(max(L - d, 0) for d in g)
    assert law_sumgap(20) == 30 != p_offset(ones, N, 20)

    # model D: min(L + span, N - L + 1)
    o2, N2 = (139, 151), 172
    assert min(13 + span(o2), N2 - 13 + 1) == 25 != p_offset(o2, N2, 13)

    # B's triple (first-1 index, offset, count) overcounts
    assert p_offset((19, 50, 83), 100, 1) == 2

    # a finitely supported word is non-recurrent, so p(L) = L + 1 for all L is
    # impossible: at L = 250 the word {10,20,40,80}, N = 500 has p = 82, far
    # below L + 1 = 251, because by then p has saturated at a_m + 2 = 82.
    assert max(p_offset((10, 20, 40, 80), 500, L) for L in range(1, 501)) == 82
    assert p_offset((10, 20, 40, 80), 500, 250) == 82 < 251
    # and the saturation value is a_m + 2 = 82, not a function of (m, span, N)
    assert 80 + 2 == 82


# --------------------------------------------------------------------------- #
# 6.  Cassaigne's first-difference identity
# --------------------------------------------------------------------------- #


def _cassaigne_assert(name, ones, N, Ls=None):
    """Shared assertion body for the Cassaigne tests."""
    w = word_from_ones(ones, N)
    if Ls is None:
        rows = first_difference_check(w)
    else:
        rows = []
        for L in Ls:
            dp = p_offset(ones, N, L + 1) - p_offset(ones, N, L)
            rs = right_special_count(w, L)
            rows.append((L, dp, rs, dp == rs))
    bad = [r for r in rows if not r[3]]
    assert all(r[3] for r in rows if r[0] <= N - ones[-1] - 2), name
    assert all(r[0] >= N - ones[-1] - 1 and r[2] == 0 for r in bad), name
    # A DENSE sample reaching the crossover must have its first failure exactly
    # at N - a_m - 1.  A SPARSE sample may first fail later, so that case is
    # covered by the slow full sweep instead.
    dense = all(rows[i + 1][0] == rows[i][0] + 1 for i in range(len(rows) - 1))
    if dense and any(r[0] >= N - ones[-1] - 1 for r in rows):
        assert bad and min(r[0] for r in bad) == N - ones[-1] - 1, \
            (name, bad[:1], N - ones[-1] - 1)
    assert rows, name


def test_cassaigne_first_difference():
    """§8.2(6) + M5, fast half.  Cassaigne holds for L <= N - a_m - 2 and
    fails for L >= N - a_m - 1, where the difference is NEGATIVE while the
    right-special count is 0.  The N = 13000 word is sampled; the full sweep is
    in test_cassaigne_full_log2 (slow)."""
    for name, ones, N in DIALOGUE_WORDS:
        if N > 2500:
            continue
        _cassaigne_assert(name, ones, N, Ls=None)
    # log 2: sample the regimes rather than sweeping O(N^2)
    o2, N2 = (0, 4, 36, 6069), 13000
    a = o2[-1]
    Ls = sorted(set(list(range(1, 40)) + [a - 5, a - 2, a, a + 2, a + 5] +
                    [N2 - k for k in range(0, 8) if k < N2]))
    _cassaigne_assert("log2 sampled", o2, N2, Ls=[L for L in Ls if 1 <= L <= N2 - 1])


@pytest.mark.slow
def test_cassaigne_full_log2():
    """The full O(N^2) Cassaigne sweep for the N = 13000 word (~4 min)."""
    _cassaigne_assert("log2 full", (0, 4, 36, 6069), 13000, Ls=None)


def test_greedy_squaring_law():
    """§8.2(7): r' = (1-f) r^2 / (1 + (1-f) r) to 30 digits, six targets."""
    import mpmath as mp

    old = mp.mp.dps
    try:
        mp.mp.dps = 60
        env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
        for expr in ("1/pi", "log(2)", "sqrt(2)-1", "e-2", "sqrt(3)-1",
                     "log(2)/log(10)"):
            r = mp.mpf(eval(expr, env))  # noqa: S307
            for _ in range(60):
                if r <= 0:
                    break
                u = 1 / r
                n = int(mp.ceil(u))
                f = u - (n - 1)
                pred = (1 - f) * r ** 2 / (1 + (1 - f) * r)
                r = r - 1 / mp.mpf(n)
                assert abs(pred - r) < mp.mpf("1e-45"), (expr, mp.nstr(abs(pred - r), 5))
    finally:
        mp.mp.dps = old


# --------------------------------------------------------------------------- #
# 8.  rational termination
# --------------------------------------------------------------------------- #


def test_rational_termination():
    """§8.2(8): 268 of 277 reduced p/q with q <= 30 terminate; theta = pi
    (x = 1) gives exactly {0,1,4}; the nine named slow ones are exactly the
    non-terminating-within-cap cases.  NOTE: a small cap produces FALSE
    'non-terminating' verdicts — 4/17 needs n = 3 039 344."""
    CAP = 5_000_000
    terminating, total = 0, 0
    stall = set()
    for q in range(2, 31):
        for p in range(1, q):
            if gcd(p, q) != 1:
                continue
            total += 1
            t = greedy_termination_index(p, q, cap=CAP)
            if t is None:
                stall.add(f"{p}/{q}")
            else:
                terminating += 1
    # HONEST STATEMENT: the count is CAP-DEPENDENT.  HANDOFF §8.2's "268 of 277"
    # is reproduced at cap = 2e6; at cap = 5e6 there are 275.  Every one of the
    # 277 does terminate (the map is the Sylvester/Engel greedy map on
    # rationals); the cap only bounds how deep we look.
    assert total == 277
    assert terminating + len(stall) == 277
    assert terminating >= 268, (terminating, sorted(stall))
    if CAP >= 5_000_000:
        assert (terminating, sorted(stall)) == (275, ["27/29", "4/25"]), \
            (terminating, sorted(stall))
    # the seven deep-but-reachable ones must be in the terminating set
    assert stall <= {"4/25", "27/29"}

    # theta = pi  <=>  x = 1
    w = greedy_word_rational(Fraction(1), 20)
    assert tuple(i for i, s in enumerate(w) if s) == SUPPORT_PI_EXACT == (0, 1, 4)


def test_rational_termination_deep_cases():
    """The exact termination index of two of the 'slow' rationals, which is
    why the cap matters (this is a fast exact-Fraction loop, not a search)."""
    assert greedy_termination_index(19, 23, cap=1_000_000) == 138459
    assert greedy_termination_index(4, 17, cap=4_000_000) == 3039344


# --------------------------------------------------------------------------- #
# 9.  known constants
# --------------------------------------------------------------------------- #


@pytest.mark.slow
def test_known_constants():
    """§8.2(9): zeta(3)/zeta(6), p* with zeta(p*) = 2, Mertens to 1e6."""
    import mpmath as mp

    old = mp.mp.dps
    try:
        mp.mp.dps = 25
        assert abs(mp.zeta(3) / mp.zeta(6) - mp.mpf("1.1815649490")) < mp.mpf("1e-9")
        pstar = mp.findroot(lambda p: mp.zeta(p) - 2, 1.7)
        assert abs(pstar - mp.mpf("1.728647239")) < mp.mpf("1e-8")
        import sympy
        s = sum(mp.log(1 - mp.mpf(1) / p) + mp.mpf(1) / p
                for p in sympy.primerange(2, 10 ** 6 + 1))
        mertens = mp.euler + s
        assert abs(mertens - mp.mpf("0.2614972467")) < mp.mpf("1e-7")
    finally:
        mp.mp.dps = old
