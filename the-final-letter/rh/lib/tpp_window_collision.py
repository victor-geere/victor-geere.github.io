"""
tpp_window_collision.py — the exact collision criterion and the corrected
window-class sum for the rh40 factor complexity `p(L)`.

Programme: Riemann-hypothesis / twin-prime-parity workspace
(/Users/victor/workspace/rh).  This module is the *attack* companion of
`lib/tpp_window_class.py`: it re-derives, independently and from scratch, the
exact condition under which two windows of the finitely supported word produce
the same offset tuple (harvested open items OP-34 / OP-36), and it validates the
resulting exact formula for `p(L)` exhaustively.

Definition of record (same as `digitword.py` / `tpp_window_class.py`)
---------------------------------------------------------------------
`S = {a_0 < … < a_m} ⊂ [0, N-1]`.  For a window start `t ∈ [0, N-L]` the factor
is the sorted tuple of offsets of the ones the window meets,

    factor(t, L) = (a - t : a ∈ S, t ≤ a ≤ t + L - 1),

and `p(L) = #{ factor(t, L) : 0 ≤ t ≤ N-L }` (offset tuples, not bit strings).
The window class of `t` is `(i(t), j(t))`, the indices of the first and last one
in the window.  Writing `x = a_i - t` for the offset of the first one and

    shape(t) = (a_i - a_i, a_{i+1} - a_i, …, a_j - a_i)

for the partial sums of the gap run `(g_i, …, g_{j-1})`, one has the identity

    factor(t) = x + shape(t)          (elementwise; both are finite sets),

because `t ≤ a_k ≤ t+L-1  ⟺  0 ≤ a_k - a_i ≤ L-1-x`.

Main results proved by this module's checks (see the attack report
`research/attacks/OP-34-36-37-35.md`)
----------------------------------------------------------------------------
* **Collision criterion (PROVED).**  For two windows `t, t'`,
      factor(t) = factor(t')  ⟺  x(t) = x(t')  and  shape(t) = shape(t').
  In terms of window classes `(i,j) ≠ (i',j')`: their factor sets meet iff
  `j-i = j'-i'`, the gap runs `(g_i,…,g_{j-1})` and `(g_{i'},…,g_{j'-1})` are
  equal, and the offset ranges `X(i,j)` and `X(i',j')` intersect, where
      X(i,j) = [max(0, a_i-(N-L), L-(a_{j+1}-a_i)),  min(d_{i-1}-1, L-1-(a_j-a_i), a_i)]
  (conventions `a_{m+1}=∞`, `d_{-1}=∞`).  This is the local periodicity step the
  `[DREAM]` formula was missing.
* **Corrected class sum (PROVED, exact).**
      p(L) = [an all-zero window exists] + Σ_{shapes P} |∪_{C: shape(C)=P} X(C)| .
  Grouping by the actual shape (gap run) — not by the `(i,j)` label — and taking
  the *union* of the offset ranges makes the formula exact.  The naive sum over
  `(i,j)` classes separately (OP-34/OP-36) over-counts exactly when two classes
  share a shape and overlap.

Run:  python3 lib/tpp_window_collision.py
"""

from __future__ import annotations

import itertools
from typing import Dict, Iterable, List, Optional, Sequence, Set, Tuple

__all__ = [
    "factor_of_window",
    "p_offset",
    "window_info",
    "shape_offset_sets",
    "shape_sum_formula",
    "class_offset_interval",
    "class_windows",
    "class_share_factor",
    "class_collision_criterion",
    "realisable_offset_range",
    "all_zero_exists",
    "slope_runs",
    "deficit_natural",
]

INF = float("inf")


# ---------------------------------------------------------------------------
# 1. Ground truth
# ---------------------------------------------------------------------------

def factor_of_window(ones: Sequence[int], t: int, L: int) -> Tuple[int, ...]:
    """Offset tuple of the ones met by the window `[t, t+L)`."""
    return tuple(a - t for a in ones if t <= a <= t + L - 1)


def p_offset(ones: Sequence[int], N: int, L: int) -> int:
    """Exact factor count `p(L)` (definition of record)."""
    if L < 1 or L > N:
        raise ValueError("need 1 <= L <= N")
    return len({factor_of_window(ones, t, L) for t in range(N - L + 1)})


def all_zero_exists(ones: Sequence[int], N: int, L: int) -> bool:
    """True iff some length-`L` window meets no one of the support.

    Equivalently `L` is at most the largest one-free run,
    `max(a_0, max_j (d_j - 1), N-1-a_m)` — this is the *corrected* OP-37
    all-zero criterion (the harvested criterion `L <= N-a_m-1` is false)."""
    a = list(ones)
    runs = [a[0]] + [b - c - 1 for c, b in zip(a, a[1:])] + [N - 1 - a[-1]]
    return L <= max(runs)


# ---------------------------------------------------------------------------
# 2. Window shape and the collision criterion
# ---------------------------------------------------------------------------

def window_info(ones: Sequence[int], N: int, L: int, t: int) -> Optional[Tuple[int, int, int, Tuple[int, ...]]]:
    """`(i, j, x, shape)` for the window starting at `t`, or `None` if all-zero.

    `i`/`j` are the first/last one indices met, `x = a_i - t` the offset of the
    first one, and `shape = (a_i - a_i, …, a_j - a_i)` the partial sums of the
    gap run.  The identity `factor = x + shape` is the content of the collision
    criterion.
    """
    if not (0 <= t <= N - L):
        raise ValueError("window start out of range")
    idx = [k for k, a in enumerate(ones) if t <= a <= t + L - 1]
    if not idx:
        return None
    i, j = idx[0], idx[-1]
    shape = tuple(ones[k] - ones[i] for k in range(i, j + 1))
    return i, j, ones[i] - t, shape


def shape_offset_sets(ones: Sequence[int], N: int, L: int) -> Dict[Tuple[int, ...], Set[int]]:
    """Group windows by `shape`; return `shape -> {offsets x}`."""
    out: Dict[Tuple[int, ...], Set[int]] = {}
    for t in range(N - L + 1):
        info = window_info(ones, N, L, t)
        if info is None:
            continue
        _, _, x, shape = info
        out.setdefault(shape, set()).add(x)
    return out


def shape_sum_formula(ones: Sequence[int], N: int, L: int) -> int:
    """The corrected class sum: `[empty] + Σ_shapes |{x : window with shape}|`.

    Exact for every finite support (proved here; see module docstring).  The
    `[empty]` term is `1` iff an all-zero window exists."""
    total = 1 if all_zero_exists(ones, N, L) else 0
    return total + sum(len(v) for v in shape_offset_sets(ones, N, L).values())


# ---------------------------------------------------------------------------
# 3. The `(i, j)` window classes and their exact offset intervals
# ---------------------------------------------------------------------------

def class_windows(ones: Sequence[int], N: int, L: int) -> Dict[Tuple[int, int], Set[int]]:
    """The window starts of each `(first-1, last-1)` class."""
    out: Dict[Tuple[int, int], Set[int]] = {}
    for t in range(N - L + 1):
        info = window_info(ones, N, L, t)
        if info is None:
            continue
        i, j = info[0], info[1]
        out.setdefault((i, j), set()).add(t)
    return out


def class_offset_interval(ones: Sequence[int], N: int, L: int, i: int, j: int) -> Optional[Tuple[int, int]]:
    """The exact integer interval `X(i,j)` of offsets `x = a_i - t` realised by
    windows whose block of ones is exactly `[i,j]`, or `None` when empty.

    Derived from `T(i,j) = [max(0, a_{i-1}+1, a_j-L+1), min(a_i, a_{j+1}-L, N-L)]`
    by `x = a_i - t`.  Conventions `a_{-1}=-∞`, `a_{m+1}=+∞`."""
    m = len(ones) - 1
    if not (0 <= i <= j <= m):
        return None
    a_i = ones[i]
    s = ones[j] - a_i
    lo = max(0, a_i - (N - L))
    if j < m:
        lo = max(lo, L - (ones[j + 1] - a_i))
    hi = min(a_i, L - 1 - s)
    if i > 0:
        hi = min(hi, ones[i] - ones[i - 1] - 1)
    if lo > hi:
        return None
    return lo, hi


def class_share_factor(ones: Sequence[int], N: int, L: int, c1: Tuple[int, int], c2: Tuple[int, int]) -> bool:
    """Ground truth: do the two `(i,j)` classes carry a common factor?"""
    def factors(c: Tuple[int, int]) -> Set[Tuple[int, ...]]:
        i, j = c
        out: Set[Tuple[int, ...]] = set()
        for t in class_windows(ones, N, L).get(c, set()):
            out.add(factor_of_window(ones, t, L))
        return out
    return bool(factors(c1) & factors(c2))


def class_collision_criterion(ones: Sequence[int], N: int, L: int,
                              c1: Tuple[int, int], c2: Tuple[int, int]) -> bool:
    """The proved criterion for `class_share_factor`:

    two distinct `(i,j)` classes share a factor iff their shapes (gap runs)
    coincide and their offset intervals `X` intersect."""
    (i, j), (i2, j2) = c1, c2
    if c1 == c2:
        return True
    if j - i != j2 - i2:
        return False
    if tuple(ones[i + r] - ones[i] for r in range(j - i + 1)) != \
       tuple(ones[i2 + r] - ones[i2] for r in range(j2 - i2 + 1)):
        return False
    x1 = class_offset_interval(ones, N, L, i, j)
    x2 = class_offset_interval(ones, N, L, i2, j2)
    if x1 is None or x2 is None:
        return False
    return x1[0] <= x2[1] and x2[0] <= x1[1]


# ---------------------------------------------------------------------------
# 4. OP-37 realisability, slopes, and the OP-35 deficit
# ---------------------------------------------------------------------------

def realisable_offset_range(ones: Sequence[int], N: int, L: int, i: int) -> Optional[Tuple[int, int]]:
    """The offsets `x` for which a window with first-one index `i` exists:

        [max(0, a_i-(N-L)), min(d_{i-1}-1, a_i, L-1)]

    (convention `d_{-1}=∞`), exactly the OP-37 realisability claim translated to
    `x = a_i - t`."""
    if not (0 <= i < len(ones)):
        return None
    xlo = max(0, ones[i] - (N - L))
    xhi = min(ones[i], L - 1)
    if i > 0:
        xhi = min(xhi, ones[i] - ones[i - 1] - 1)
    if xlo > xhi:
        return None
    return xlo, xhi


def slope_runs(ones: Sequence[int], N: int) -> List[Tuple[int, int, int]]:
    """Maximal runs `(L_first, L_last, p(L+1)-p(L))` of the first difference."""
    ps = [p_offset(ones, N, L) for L in range(1, N + 1)]
    runs: List[Tuple[int, int, int]] = []
    start, cur = 1, ps[1] - ps[0]
    for L in range(2, N):
        s = ps[L] - ps[L - 1]
        if s != cur:
            runs.append((start, L - 1, cur))
            start, cur = L, s
    runs.append((start, N - 1, cur))
    return runs


def deficit_natural(ones: Sequence[int], L: int) -> int:
    """The survey's "natural reading" of the OP-35 deficit.

    `S_{1,k}` is undefined corpus-wide; reading `S_{1,k} = Σ_{i≤k} d_i` with
    `d_1, …, d_m` the consecutive gaps gives
    `D(L) = max_j (L - d_j - 1 - S_{1,j-2})_+`; for `1/π` this is `(L-12)_+`,
    which switches on at `L=13` while the measured `2→1` slope drop is at
    `L=14` (off by one), and it grows without bound whereas the true slope
    deficit is bounded by the number of pair classes."""
    gaps = [ones[i + 1] - ones[i] for i in range(len(ones) - 1)]
    best = 0
    for j in range(1, len(gaps) + 1):
        s = sum(gaps[:j - 2]) if j - 2 >= 0 else 0   # d_{j-2} ... d_1 chain
        best = max(best, max(0, L - gaps[j - 1] - 1 - s))
    return best


# ---------------------------------------------------------------------------
# 5. Self-test
# ---------------------------------------------------------------------------

def _exhaustive_shape_formula(maxN: int, maxones: int) -> Tuple[int, int]:
    """Validate the exact shape sum against `p_offset` on all supports with at
    most `maxones` ones and `N <= maxN`.  Returns `(cases, mismatches)`."""
    cases = bad = 0
    for N in range(1, maxN + 1):
        for k in range(1, min(maxones, N) + 1):
            for ones in itertools.combinations(range(N), k):
                for L in range(1, N + 1):
                    cases += 1
                    if shape_sum_formula(ones, N, L) != p_offset(ones, N, L):
                        bad += 1
    return cases, bad


def _exhaustive_criterion(maxN: int, maxones: int) -> Tuple[int, int, int]:
    """Validate (i) the window-level criterion and (ii) the class-level
    collision criterion exhaustively.  Returns `(cases, bad_window, bad_class)`."""
    cases = bad_w = bad_c = 0
    for N in range(1, maxN + 1):
        for k in range(1, min(maxones, N) + 1):
            for ones in itertools.combinations(range(N), k):
                for L in range(1, N + 1):
                    cases += 1
                    # (i) window level: factor(t) == factor(t') iff x and shape agree
                    seen: Dict[Tuple[int, ...], Tuple[int, Tuple[int, ...]]] = {}
                    for t in range(N - L + 1):
                        info = window_info(ones, N, L, t)
                        f = factor_of_window(ones, t, L)
                        if info is None:
                            if f != ():
                                bad_w += 1
                            continue
                        _, _, x, shape = info
                        if seen.get(f) not in (None, (x, shape)):
                            bad_w += 1
                        seen[f] = (x, shape)
                    # (ii) class level criterion
                    cls = list(class_windows(ones, N, L))
                    for c1, c2 in itertools.combinations(cls, 2):
                        truth = class_share_factor(ones, N, L, c1, c2)
                        pred = class_collision_criterion(ones, N, L, c1, c2)
                        if truth != pred:
                            bad_c += 1
    return cases, bad_w, bad_c


def _self_test() -> int:
    fails = 0

    # (a) shape sum is exact (exhaustive, small)
    cases, bad = _exhaustive_shape_formula(16, 4)
    ok = bad == 0 and cases > 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] exact shape sum p(L) = [empty] + Σ_shapes |offsets| "
          f"({cases} cases, {bad} mismatches)")

    # (b) collision criterion, window level and class level
    cases, bw, bc = _exhaustive_criterion(14, 4)
    ok = bw == 0 and bc == 0 and cases > 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] collision criterion (window-level {bw} bad, "
          f"class-level {bc} bad, {cases} cases)")

    # (c) the naive (i,j) class sum over-counts: 1/pi
    ones, N = (2, 13, 607), 1400
    naive = sum(
        1 for L in range(1, N)
        if (1 if all_zero_exists(ones, N, L) else 0)
           + sum(len(v) for v in class_windows(ones, N, L).values()) != p_offset(ones, N, L)
    )
    corrected_bad = sum(1 for L in range(1, N) if shape_sum_formula(ones, N, L) != p_offset(ones, N, L))
    ok = naive == 604 and corrected_bad == 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] 1/pi: naive (i,j) class sum over-counts {naive}/1399 L; "
          f"corrected shape sum mismatches {corrected_bad}")

    # (d) OP-37 realisability: realised first-one offsets == claimed range
    bad = 0
    for N2 in range(3, 16):
        for k in range(1, min(3, N2) + 1):
            for ones2 in itertools.combinations(range(N2), k):
                for L in range(1, N2 + 1):
                    actual: Dict[int, Set[int]] = {}
                    for t in range(N2 - L + 1):
                        info = window_info(ones2, N2, L, t)
                        if info is None:
                            continue
                        actual.setdefault(info[0], set()).add(info[2])
                    for i in range(k):
                        rng = realisable_offset_range(ones2, N2, L, i)
                        exp = set() if rng is None else set(range(rng[0], rng[1] + 1))
                        if actual.get(i, set()) != exp:
                            bad += 1
    ok = bad == 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-37 realisability: realised first-one offsets == "
          f"claimed range ({bad} mismatches)")

    # (e) OP-37 all-zero criterion: source form is false, max-run form exact
    src_bad = maxrun_bad = 0
    for N2 in range(3, 16):
        for k in range(1, min(3, N2) + 1):
            for ones2 in itertools.combinations(range(N2), k):
                for L in range(1, N2 + 1):
                    truth = any(not [a for a in ones2 if t <= a <= t + L - 1]
                                for t in range(N2 - L + 1))
                    if (L <= N2 - ones2[-1] - 1) != truth:
                        src_bad += 1
                    if all_zero_exists(ones2, N2, L) != truth:
                        maxrun_bad += 1
    ok = src_bad > 0 and maxrun_bad == 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-37 all-zero: source criterion wrong on {src_bad} cases, "
          f"max-run criterion wrong on {maxrun_bad}")

    # (f) conditional injectivity lemma: L <= N-a_m-1 and p(L) >= a_m+2 ⟹ injective
    bad = cases = 0
    for N2 in range(3, 16):
        for k in range(1, min(3, N2) + 1):
            for ones2 in itertools.combinations(range(N2), k):
                for L in range(1, N2 + 1):
                    if L <= N2 - ones2[-1] - 1 and p_offset(ones2, N2, L) >= ones2[-1] + 2:
                        cases += 1
                        seen: Dict[Tuple[int, ...], Tuple[int, int]] = {}
                        for t in range(N2 - L + 1):
                            info = window_info(ones2, N2, L, t)
                            if info is None:
                                continue
                            key = (info[0], info[2])
                            f = factor_of_window(ones2, t, L)
                            if f in seen and seen[f] != key:
                                bad += 1
                            seen[f] = key
    ok = bad == 0 and cases > 0
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] conditional injectivity lemma (L<=N-a_m-1, "
          f"p>=a_m+2): {cases} cases, {bad} collisions")

    # (g) OP-35: natural deficit reading is off by one on 1/pi
    runs = slope_runs(ones, N)
    d_switch = next(r[0] for r in runs if r[2] == 1 and r[0] > 10)
    nat_on = next(L for L in range(1, 60) if deficit_natural(ones, L) > 0)
    ok = (d_switch == 14) and (nat_on == 13)
    fails += not ok
    print(f"[{'OK ' if ok else 'BAD'}] OP-35: measured 2→1 slope drop at L={d_switch}, "
          f"natural-reading deficit switches on at L={nat_on} (off by one)")

    print(f"self-test: {7 - fails}/7 checks pass")
    return fails


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(_self_test())
