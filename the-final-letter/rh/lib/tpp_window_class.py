"""
tpp_window_class.py — window-class / factor-complexity checks for the rh40 word.

Programme: Riemann-hypothesis / twin-prime-parity workspace
(/Users/victor/workspace/rh).  Ground truth for the exact factor count `p(L)` is
`research/twin-prime-parity/rounds/rh40/code/digitword.py`; this module
re-implements it independently and adds the checks that the harvested open items
OP-34 (A7), OP-35 (A8), OP-36 (Agent A's `[DREAM]` window-class sum) and OP-37
(the `(i,x)` repair) are about.

Definitions (definition of record, `digitword.py` docstring)
------------------------------------------------------------
For a finitely supported word with ones `0 <= a_0 < ... < a_m < N`, and a window
start `t`, the factor is the tuple of offsets of the ones it meets:

    f(t, L) = (a - t for a in ones if t <= a <= t + L - 1)

and `p(L) = #{ f(t, L) : 0 <= t <= N - L }` (offset-tuples, not bit strings).

Findings reproduced here
------------------------
* **OP-37, realisability half — CORRECT.**  The pairs actually realised as
  `(first-1 index i, offset x = a_i - t)` are *exactly* those with
  `0 <= x <= min(d_{i-1}-1, a_i, L-1)` (convention `d_{-1} = inf`) and
  `a_i - x <= N - L`.  The all-zero criterion in the same statement is FALSE
  (counterexample below); the correct criterion is the max-run form.
* **OP-37, injectivity half — FALSE as stated.**  `(i, x)` does **not** determine
  the factor; e.g. support `(12, 20)`, `N = 26`, `L = 12`: both `(0, 7)` and
  `(1, 7)` give the factor `(7,)`.  The collision happens when a window sees a
  single one.  The claim survives **on the plateau under `N >= 2*a_m + 3`**:
  0 violations in an exhaustive scan (15087 plateau cases, small supports).
  The all-zero criterion in the same OP-37 statement is **also FALSE**:
  support `(0,4)`, `N = 6`, `L = 3` has an all-zero window, yet `L = 3` exceeds
  `N - a_m - 1 = 1`.  Correct form: an all-zero window exists iff `L` is at most
  the largest one-free run, `max(a_0, max_j (d_j - 1), N - 1 - a_m)`.
* **OP-34 / OP-36 — the class decomposition is not the sum.**  Grouping windows
  by `(first index, last index)` gives factor sets that **overlap** below the
  saturation range, so `1 + #{empty} + Sum_{i<=j} |T(i,j)|` over-counts `p(L)`
  (drastically, not 1-2 %); the class-disjointness step is the missing content.
* **OP-35 — not testable as stated**: `S_{1,k}` is never defined anywhere in the
  corpus (grep: only mentioned, in `rounds/round01_agentA.md` and
  `rounds/round01.md`).

Run:  python3 lib/tpp_window_class.py
"""

from __future__ import annotations

import itertools
import random
from typing import Dict, Iterable, List, Sequence, Set, Tuple

__all__ = [
    "factor_of_window",
    "p_offset",
    "window_classes",
    "class_disjoint",
    "class_sum_formula",
    "claimed_pairs",
    "realised_pairs",
    "injectivity_violations",
    "all_zero_iff",
]

ONES_1_OVER_PI: Tuple[int, ...] = (2, 13, 607)


# ---------------------------------------------------------------------------
# 1. Ground truth
# ---------------------------------------------------------------------------

def factor_of_window(ones: Sequence[int], t: int, L: int) -> Tuple[int, ...]:
    """Offset-tuple of the ones met by window `[t, t+L)`."""
    return tuple(a - t for a in ones if t <= a <= t + L - 1)


def p_offset(ones: Sequence[int], N: int, L: int) -> int:
    """Exact factor count `p(L)` (definition of record)."""
    if L < 1 or L > N:
        raise ValueError("need 1 <= L <= N")
    return len({factor_of_window(ones, t, L) for t in range(N - L + 1)})


# ---------------------------------------------------------------------------
# 2. The window-class decomposition (OP-34 / OP-36)
# ---------------------------------------------------------------------------

def window_classes(ones: Sequence[int], N: int, L: int) -> Dict[Tuple[int, int], Set[Tuple[int, ...]]]:
    """Group windows by `(first-1 index, last-1 index)`; return class -> factors."""
    out: Dict[Tuple[int, int], Set[Tuple[int, ...]]] = {}
    for t in range(N - L + 1):
        idx = [k for k, a in enumerate(ones) if t <= a <= t + L - 1]
        if not idx:
            continue
        key = (idx[0], idx[-1])
        out.setdefault(key, set()).add(factor_of_window(ones, t, L))
    return out


def class_disjoint(ones: Sequence[int], N: int, L: int) -> bool:
    """True iff distinct `(i,j)` classes carry disjoint factor sets.

    This is exactly the missing step of Agent A's `[DREAM]` union-cardinality
    claim (OP-34 / OP-36): if it holds then `p(L)` *is* the sum over classes,
    factors counted with multiplicity one per class.
    """
    seen: Set[Tuple[int, ...]] = set()
    for factors in window_classes(ones, N, L).values():
        if seen & factors:
            return False
        seen |= factors
    return True


def class_sum_formula(ones: Sequence[int], N: int, L: int) -> int:
    """`1 + #{all-zero windows} + Sum_{i<=j} |class factors|` (Agent A's claim)."""
    classes = window_classes(ones, N, L)
    empty = any(
        not [a for a in ones if t <= a <= t + L - 1] for t in range(N - L + 1)
    )
    return (1 if empty else 0) + sum(len(v) for v in classes.values())


def all_zero_iff(ones: Sequence[int], N: int, L: int) -> bool:
    """Ground truth: does an all-zero window of length `L` exist?

    A length-`L` window avoids the support iff it fits inside a run of positions
    with no one.  The runs are the initial run `a_0` (positions `0..a_0-1`), the
    internal runs of size `d_j - 1`, and the final run `N - 1 - a_m`.  So the
    all-zero window exists iff

        L <= max(a_0, max_j (d_j - 1), N - 1 - a_m).

    NOTE: the harvested OP-37 statement claims the criterion is
    `L <= N - a_m - 1`; that is **false** (counterexample: support `(0, 4)`,
    `N = 6`, `L = 3` has an all-zero window but `3 > 6 - 4 - 1 = 1`).  Use
    `all_zero_criterion_source` to exhibit the discrepancy.
    """
    a = list(ones)
    runs = [a[0]]
    runs += [b - c - 1 for c, b in zip(a, a[1:])]
    runs.append(N - 1 - a[-1])
    return L <= max(runs)


def all_zero_criterion_source(ones: Sequence[int], N: int, L: int) -> bool:
    """The harvested OP-37 criterion `L <= N - a_m - 1` (known false in general)."""
    return L <= N - ones[-1] - 1


# ---------------------------------------------------------------------------
# 3. The (i, x) repair (OP-37)
# ---------------------------------------------------------------------------

def claimed_pairs(ones: Sequence[int], N: int, L: int) -> Set[Tuple[int, int]]:
    """The pairs asserted realisable: `0 <= x <= min(d_{i-1}-1, a_i, L-1)`,
    `a_i - x <= N - L`."""
    out: Set[Tuple[int, int]] = set()
    m = len(ones) - 1
    for i in range(m + 1):
        d_prev = float("inf") if i == 0 else ones[i] - ones[i - 1]
        for x in range(0, min(d_prev - 1, ones[i], L - 1) + 1):
            if ones[i] - x <= N - L:
                out.add((i, int(x)))
    return out


def realised_pairs(ones: Sequence[int], N: int, L: int) -> Set[Tuple[int, int]]:
    """The pairs `(i, x)` actually realised by some window."""
    out: Set[Tuple[int, int]] = set()
    for t in range(N - L + 1):
        idx = [k for k, a in enumerate(ones) if t <= a <= t + L - 1]
        if idx:
            i = idx[0]
            out.add((i, ones[i] - t))
    return out


def injectivity_violations(ones: Sequence[int], N: int, L: int) -> List[Tuple[Tuple[int, int], Tuple[int, int], Tuple[int, ...]]]:
    """Collisions of `(i, x) -> factor` (the OP-37 injectivity half)."""
    seen: Dict[Tuple[int, ...], Tuple[int, int]] = {}
    bad: List[Tuple[Tuple[int, int], Tuple[int, int], Tuple[int, ...]]] = []
    for t in range(N - L + 1):
        idx = [k for k, a in enumerate(ones) if t <= a <= t + L - 1]
        if not idx:
            continue
        key = (idx[0], ones[idx[0]] - t)
        f = factor_of_window(ones, t, L)
        if f in seen and seen[f] != key:
            bad.append((seen[f], key, f))
        seen[f] = key
    return bad


# ---------------------------------------------------------------------------
# 4. Self-test
# ---------------------------------------------------------------------------

def _self_test() -> int:
    fails = 0

    # (a) p(L) ground truth on the 1/pi word (HANDOFF.md §3.1 table)
    ones, N = ONES_1_OVER_PI, 1400
    table = {1: 2, 5: 6, 10: 11, 11: 12, 12: 14, 13: 16, 14: 18,
             15: 19, 20: 24, 50: 54, 100: 104, 300: 304}
    ok = all(p_offset(ones, N, L) == v for L, v in table.items())
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] p(L) reproduces the HANDOFF §3.1 values "
          f"for x = 1/pi")

    # (b) OP-37 realisability + correct all-zero criterion: exhaustive, 0 mismatches
    def _empty_exists(ones2: Sequence[int], N2: int, L: int) -> bool:
        return any(
            not [a for a in ones2 if t <= a <= t + L - 1]
            for t in range(N2 - L + 1)
        )

    pair_bad = empty_bad = src_bad = cases = 0
    for N2 in range(3, 20):
        for m in range(1, min(3, N2 - 1) + 1):
            for ones2 in itertools.combinations(range(N2), m):
                for L in range(1, N2 + 1):
                    cases += 1
                    if realised_pairs(ones2, N2, L) != claimed_pairs(ones2, N2, L):
                        pair_bad += 1
                    if all_zero_iff(ones2, N2, L) != _empty_exists(ones2, N2, L):
                        empty_bad += 1
                    if all_zero_criterion_source(ones2, N2, L) != _empty_exists(ones2, N2, L):
                        src_bad += 1
    ok = pair_bad == 0 and empty_bad == 0 and src_bad > 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-37 realisability exact ({cases} cases, "
          f"{pair_bad} mismatches); corrected all-zero criterion exact "
          f"({empty_bad} mismatches); source criterion refuted ({src_bad} mismatches)")

    # (c) OP-37 injectivity is FALSE as stated: explicit counterexample
    ce_ones, ce_N, ce_L = (12, 20), 26, 12
    v = injectivity_violations(ce_ones, ce_N, ce_L)
    ok = len(v) > 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-37 injectivity counterexample: support "
          f"{ce_ones}, N={ce_N}, L={ce_L} -> {v[:1]}")

    # (d) OP-37 injectivity holds on the plateau for N >= 2 a_m + 3
    viol = cases = 0
    for N2 in range(6, 26):
        for m in range(1, 4):
            for ones2 in itertools.combinations(range(N2), m):
                if N2 < 2 * ones2[-1] + 3:
                    continue
                mx = max(p_offset(ones2, N2, L) for L in range(1, N2 + 1))
                for L in range(1, N2 + 1):
                    if p_offset(ones2, N2, L) != mx:
                        continue
                    cases += 1
                    if injectivity_violations(ones2, N2, L):
                        viol += 1
    ok = viol == 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-37 injectivity holds on the plateau "
          f"under N >= 2 a_m + 3 ({cases} cases, {viol} violations)")

    # (e) OP-34/OP-36: the class sum over-counts p(L); classes are not disjoint
    bad = sum(1 for L in range(1, N) if class_sum_formula(ones, N, L) != p_offset(ones, N, L))
    disj_bad = sum(1 for L in range(1, N) if not class_disjoint(ones, N, L))
    ok = bad > 0 and disj_bad > 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-34/OP-36 class-sum over-counts on "
          f"{bad}/{N - 1} L-values (non-disjoint classes on {disj_bad})")

    print(f"self-test: {5 - fails}/5 checks pass")
    return fails


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(_self_test())
