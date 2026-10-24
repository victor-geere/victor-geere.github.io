"""
rh40 / digitword.py — the ground-truth layer for the factor-complexity law.

Programme: HANDOFF.md (workspace root /Users/victor/workspace/rh).
Everything here follows HANDOFF.md §2 (the object), §3.2 (the definition of
record) and §8.1 (exactness requirements).

DEFINITION OF RECORD (HANDOFF.md §3.2)
--------------------------------------
A factor of the word w at window start t of length L is determined by the SET
of offsets of the ones it contains:

    window t, length L   <->   { a - t : a in ones, t <= a <= t + L - 1 }

Two windows give the same factor iff these offset-tuples agree, hence

    p(L) = # { { a - t : a in ones, t <= a <= t+L-1 } : 0 <= t <= N - L }.

This is exact by construction and is the ground truth against which every
candidate law must be checked.  Factors are tuples of offsets, NOT bit
strings: a bit-string factor of a sparse word cannot distinguish two windows
whose ones sit at the same offsets, and (equally) the all-zero factor is a
single factor however many windows realise it.

EXACTNESS RULES (HANDOFF.md §8.1)
---------------------------------
* The digit word is built by exact rational arithmetic (fractions.Fraction)
  for rational x, and at >= 120 dps of mpmath for irrational x.  Never a
  binary float: a float run once produced the spurious support [0,1,5,41,1805]
  for theta = pi instead of the exact [0,1,4].
* Every number reported must carry its truncation length N.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Dict, Iterable, List, Sequence, Set, Tuple

__all__ = [
    "greedy_word_rational",
    "greedy_word_mpmath",
    "factor_set",
    "p_offset",
    "p_bruteforce",
    "right_special_factors",
    "right_special_count",
    "first_difference_check",
    "word_from_ones",
    "gaps",
    "span",
    "slopes",
    "SUPPORT_1_OVER_PI",
]

# ---------------------------------------------------------------------------
# 1. The greedy digit word
# ---------------------------------------------------------------------------

#: Exact support for theta = pi (x = 1): 1/2 + 1/3 + 1/6 = 1.
#: HANDOFF.md §2 — verified with exact rational arithmetic.  A float run gives
#: the spurious [0, 1, 5, 41, 1805].
SUPPORT_PI_EXACT: Tuple[int, ...] = (0, 1, 4)


def greedy_word_rational(x: Fraction, N: int, max_n: int = 5_000_000) -> List[int]:
    """First N symbols of the greedy harmonic digit word for rational x > 0.

    r_0 = x; if r_n >= 1/(n+2) take 1 and subtract, else take 0.

    Exact: all arithmetic in Fraction.  x = 1 is allowed and is the theta = pi
    case: the greedy rule then gives exactly {0, 1, 4} (1/2 + 1/3 + 1/6 = 1).
    The word terminates when r_n == 0, after which the remaining symbols are 0.

    max_n guards against a pathological rational that terminates extremely deep:
    e.g. 4/17 terminates only at n = 3 039 344 and 14/19 at n = 2 359 419.
    If max_n is reached with r > 0 the function raises, rather than silently
    returning a truncated word as if it had terminated.
    """
    if x <= 0:
        raise ValueError("need x > 0")
    r = Fraction(x)
    out: List[int] = []
    for n in range(N):
        c = Fraction(1, n + 2)
        if r >= c:
            out.append(1)
            r -= c
            if r == 0:
                out.extend([0] * (N - len(out)))
                break
        else:
            out.append(0)
        if n >= max_n:
            raise RuntimeError(
                f"no termination within n = {max_n} (residual {r}); "
                "raise max_n or use greedy_termination_index")
    return out


def greedy_termination_index(p: int, q: int, cap: int = 5_000_000) -> "int | None":
    """Exact termination index for x = p/q, or None if not found below `cap`.

    Returns n such that r_n = 0, i.e. the last index tested (the word has 1s
    only among 0 .. n-1).  Every rational does terminate, but the index can be
    enormous: for q <= 30 the deepest is 19/23 at n = 138 459, while 4/17 needs
    n = 3 039 344.  A small cap therefore produces false "non-terminating"
    verdicts — see HANDOFF.md §8.2 test 8.
    """
    r = Fraction(p, q)
    n = 0
    while r > 0 and n < cap:
        c = Fraction(1, n + 2)
        if r >= c:
            r -= c
        n += 1
    return n if r == 0 else None


def greedy_word_mpmath(x_str: str, N: int, dps: int = 120) -> List[int]:
    """First N symbols for an irrational target given as a *string*.

    x_str is parsed at the working precision (dps), never as a binary float;
    pass e.g. "1/pi" via mpmath's expression evaluator or a decimal string.
    All arithmetic at dps digits.

    Returns the word, and (for census use) leaves the residuals to the caller.
    """
    import mpmath as mp

    old = mp.mp.dps
    try:
        mp.mp.dps = dps
        r = mp.mpf(x_str) if not _looks_like_expr(x_str) else mp.mpf(eval(x_str, {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}))  # noqa: S307
        if not (0 < r < 1):
            raise ValueError("need 0 < x < 1")
        out: List[int] = []
        one = mp.mpf(1)
        for n in range(N):
            c = one / (n + 2)
            if r >= c:
                out.append(1)
                r = r - c
            else:
                out.append(0)
        return out
    finally:
        mp.mp.dps = old


def _looks_like_expr(s: str) -> bool:
    return any(ch in s for ch in "+-*/()")


def word_from_ones(ones: Iterable[int], N: int) -> List[int]:
    """The finitely-supported 0/1 word of length N with 1s exactly at `ones`."""
    w = [0] * N
    for a in ones:
        if not (0 <= a < N):
            raise ValueError(f"support position {a} outside [0,{N})")
        w[a] = 1
    return w


# ---------------------------------------------------------------------------
# 2. Exact complexity — the definition of record
# ---------------------------------------------------------------------------


def factor_set(word: Sequence[int], L: int) -> Set[Tuple[int, ...]]:
    """Distinct length-L factors of `word`, as offset-tuples of their ones.

    For window start t the factor is (a - t for a in support, t <= a < t+L).
    This is the definition of record (HANDOFF.md §3.2) and it agrees exactly
    with the bit-string enumeration on every case tested (see
    tests/test_complexity.py::test_offset_tuple_equals_bruteforce).
    """
    N = len(word)
    if L < 1:
        raise ValueError("need L >= 1")
    if L > N:
        raise ValueError(f"need L <= N = {N}; a length-{L} factor of a "
                         "length-N word does not exist (p_offset raises too)")
    support = [i for i, s in enumerate(word) if s]
    out: Set[Tuple[int, ...]] = set()
    for t in range(N - L + 1):
        out.add(tuple(a - t for a in support if t <= a <= t + L - 1))
    return out


def p_offset(ones: Sequence[int], N: int, L: int) -> int:
    """p(L) for a finitely-supported word: the support is given directly."""
    if L < 1 or L > N:
        raise ValueError("need 1 <= L <= N")
    out: Set[Tuple[int, ...]] = set()
    for t in range(N - L + 1):
        out.add(tuple(a - t for a in ones if t <= a <= t + L - 1))
    return len(out)


def p_bruteforce(word: Sequence[int], L: int) -> int:
    """Cross-check route: count distinct bit-string factors directly."""
    N = len(word)
    if L > N:
        return 0
    return len({tuple(word[i : i + L]) for i in range(N - L + 1)})


# ---------------------------------------------------------------------------
# 3. Cassaigne's first-difference identity (HANDOFF.md §3.4) — a theorem
# ---------------------------------------------------------------------------


def right_special_factors(word: Sequence[int], L: int) -> List[Tuple[int, ...]]:
    """Length-L factors f such that both f.0 and f.1 occur in `word`.

    A factor of length L is the offset-tuple f of a window of length L.
    Its extension by 0 is the same offset-tuple f (no new one appears);
    its extension by 1 is f + (L,) (a one at the new last position, offset L).
    So f is right-special iff f and f + (L,) are both factors of length L+1.
    Returned as offset-tuples, sorted for determinism.
    """
    fL = factor_set(word, L)
    fL1 = factor_set(word, L + 1)
    return sorted(f for f in fL if f in fL1 and (f + (L,)) in fL1)


def right_special_count(word: Sequence[int], L: int) -> int:
    """#{ right-special factors of length L } — the RHS of Cassaigne's identity."""
    return len(right_special_factors(word, L))


def first_difference_check(word: Sequence[int]) -> List[Tuple[int, int, int, bool]]:
    """[(L, p(L+1)-p(L), #right-special L, agree?)] for all feasible L."""
    N = len(word)
    rows = []
    for L in range(1, N):
        lhs = p_bruteforce(word, L + 1) - p_bruteforce(word, L)
        rhs = right_special_count(word, L)
        rows.append((L, lhs, rhs, lhs == rhs))
    return rows


# ---------------------------------------------------------------------------
# 4. Small helpers used by the numeric probes
# ---------------------------------------------------------------------------


def gaps(ones: Sequence[int]) -> List[int]:
    """Consecutive gaps of the support."""
    return [b - a for a, b in zip(ones, ones[1:])]


def span(ones: Sequence[int]) -> int:
    """a_m - a_0: the support span (0 for a single one)."""
    return ones[-1] - ones[0] if len(ones) > 1 else 0


def slopes(ones: Sequence[int], N: int) -> List[Tuple[int, int, int]]:
    """[(L_start, L_end, slope)] — maximal runs of constant first difference.

    Convention (this is what makes the run boundaries line up with the gap
    values, cf. HANDOFF.md §3.1): run (a, b, s) means

        p(L+1) - p(L) = s   for every L in [a, b].

    For x = 1/pi, N = 1400 this gives
        (1, 10, 1)    -> p(L+1)-p(L) = 1 on L in [1, 10]
        (11, 13, 2)   -> = 2 on [11, 13]
        (14, 604, 1)  -> = 1 on [14, 604]   <-- the slope DECREASES back to 1
        (605, 791, 0) -> = 0 on [605, 791]  <-- the saturation plateau
        (792, 1399, -1) -> = -1 on [792, 1399] <-- the right-edge decay
    i.e. the sequence is 1 -> 2 -> 1 -> 0 -> -1, NOT 1 -> 2 -> 3, and there is no
    range with slope 3.  Do NOT quote the false runs (11, 592, 2) / (593, 604, 3)
    that appear in HANDOFF.md §3.1: they were never true (see README.md M1/M2 and
    the audit in verify/probes.py probe 6).
    """
    vals = [p_offset(ones, N, L) for L in range(1, N + 1)]
    d = [vals[i + 1] - vals[i] for i in range(len(vals) - 1)]  # d[i] = p(i+2)-p(i+1)
    runs: List[Tuple[int, int, int]] = []
    start = 1
    for i in range(1, len(d)):
        if d[i] != d[i - 1]:
            runs.append((start, i, d[i - 1]))
            start = i + 1
    runs.append((start, len(d), d[-1]))
    return runs


# ---------------------------------------------------------------------------
# 5. The dialogue words (HANDOFF.md §3.3) and the 1/pi word
# ---------------------------------------------------------------------------

#: x = 1/pi, exact support to index 607; truncation N = 1400 (HANDOFF.md §3.1).
SUPPORT_1_OVER_PI: Tuple[int, ...] = (2, 13, 607)


if __name__ == "__main__":  # pragma: no cover
    # Self-check: reproduce the HANDOFF.md §3.1 table and §3.3 saturation values.
    ones, N = SUPPORT_1_OVER_PI, 1400
    w = word_from_ones(ones, N)
    table = {1: 2, 5: 6, 10: 11, 11: 12, 12: 14, 13: 16, 14: 18,
             15: 19, 20: 24, 50: 54, 100: 104, 300: 304,
             593: 597, 594: 598, 605: 609}
    ok = True
    for L, want in table.items():
        got_o, got_b = p_offset(ones, N, L), p_bruteforce(w, L)
        flag = "OK " if got_o == want == got_b else "BAD"
        ok &= got_o == want == got_b
        print(f"[{flag}] L={L:4d} p={got_o:4d} (expected {want}, bruteforce {got_b})")
    print("piecewise slopes:", slopes(ones, N))
    print("all §3.1 values reproduce:", ok)
