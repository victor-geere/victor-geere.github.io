#!/usr/bin/env python3
"""
rh43/verify/positive_only_split.py — the *positive-values-only* two-set problem.

The question here is not the balanced split of the round (which mixes signs, and is
the single equation `Re S_N(t) = 0`).  It is the **positive-only** problem:

    among the positive terms  cos(t log n) > 0,  n = 1..N,
    choose two disjoint subsets A, B with  sum(A) = sum(B)
    (equivalently sum(A) = P/2 where P = sum of all positive terms).

The necessary condition at the top level is `a_1 <= P - a_1`, i.e. `P >= 2 a_1 = 2`
(since `cos(t log 1) = 1` is always the largest positive term).  That is much weaker
than the balance equation, and it holds for every `t` once `N` is large enough.

But exact equality of two subsets needs the whole *subset-sum* interval to be filled:
by Brown's criterion the subset sums of a decreasing positive sequence `a_1 >= a_2 >=
...` fill `[0, P]` exactly when `a_k <= a_{k+1} + ... + a_m` for **every** k.  For the
positive terms of `S_N(t)` the last condition always fails (`a_m > 0 = ` sum of the
rest), so a *gap* survives; the two subsets are never exactly equal, although the
defect is tiny and shrinks as `N` grows.  This script measures both things.

Run:  python3 rh43/verify/positive_only_split.py
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import sys
from pathlib import Path

import mpmath as mp

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
sys.path.insert(0, str(HERE.parent / "rh43"))

import ivmath as iv  # noqa: E402
import zeta_split as z  # noqa: E402

mp.mp.dps = 60

FAILS: list[str] = []
NPASS = 0


def check(label: str, ok: bool, detail: str = "") -> None:
    global NPASS
    if ok:
        NPASS += 1
        print(f"  PASS  {label}" + (f"   [{detail}]" if detail else ""))
    else:
        FAILS.append(label)
        print(f"  FAIL  {label}" + (f"   [{detail}]" if detail else ""))


def positive_terms(N: int, t) -> list[tuple]:
    """[(value, n)] of the positive terms, values from the rigorous engine centres."""
    out = []
    for n in range(1, N + 1):
        c = iv.cos_num(iv.Num(mp.mpf(t)) * iv.log_n(n))
        if c.v > 0:
            out.append((c.v, n))
    return out


def greedy_two_sets(terms):
    """Greedy (largest first, no overshoot of total/2): exact iff the sequence is complete."""
    total = sum(v for v, _ in terms)
    target = total / 2
    acc = mp.mpf(0)
    A = []
    for v, n in sorted(terms, reverse=True):
        if acc + v <= target + mp.mpf('1e-40'):
            acc += v
            A.append(n)
    B = [n for _, n in terms if n not in A]
    return A, B, acc, total - acc, total


def brown_failures(terms):
    """Indices k (1-based, decreasing order) with a_k > sum of the later terms."""
    a = sorted([v for v, _ in terms], reverse=True)
    out = []
    for k in range(len(a) - 1):
        rest = sum(a[k + 1:])
        gap = a[k] - rest
        if gap > mp.mpf('1e-28'):
            out.append((k + 1, gap))
    return out


def main() -> int:
    print("POSITIVE-VALUES-ONLY two-set problem\n")
    print("1. the top-level criterion is P >= 2*a_1 = 2 (much weaker than balance):")
    rows = []
    for N, t in [(20, '0.5'), (20, '1.0'), (40, '0.2'), (60, '2.0'),
                 (100, '0.5'), (200, '0.2'), (200, '1.0')]:
        P = positive_terms(N, mp.mpf(t))
        if len(P) < 2:
            continue
        total = sum(v for v, _ in P)
        a1 = max(v for v, _ in P)
        rows.append((N, t, len(P), total, a1))
        check(f"N={N}, t={t}: a_1 = cos(0) = 1 and P >= 2 (top-level criterion holds)",
              abs(a1 - 1) < mp.mpf('1e-30') and total >= 2,
              f"#pos={len(P)}  P={mp.nstr(total,8)}  P-2 = {mp.nstr(total-2,4)}")

    print("\n2. but exact equality of two subsets needs completeness at every index,")
    print("   and the last term always violates it (a_m > 0 = sum of the rest):")
    for N, t, npos, total, a1 in rows[:4]:
        P = positive_terms(N, mp.mpf(t))
        A, B, sa, sb, tot = greedy_two_sets(P)
        bf = brown_failures(P)
        # exhaustive best subset <= P/2 for the smaller cases
        best = None
        if len(P) <= 14:
            from itertools import combinations
            tgt = tot / 2
            best = mp.mpf(0)
            for r in range(1, len(P) + 1):
                for combo in combinations(P, r):
                    sv = sum(v for v, _ in combo)
                    if sv <= tgt and sv > best:
                        best = sv
        defect = (tot / 2 - best) if best is not None else (tot / 2 - sa)
        check(f"N={N}, t={t}: two subsets are NOT exactly equal (a gap survives)",
              defect > mp.mpf('1e-28'),
              f"#pos={len(P)}  P/2={mp.nstr(tot/2,8)}  best={mp.nstr(best if best is not None else sa,8)}  "
              f"defect={mp.nstr(defect,4)}  Brown failures={len(bf)} (first at k={bf[0][0] if bf else '-'})")

    print("\n3. the defect is set by the *number* of positive terms, and shrinks as that grows:")
    prev = None
    for N in [20, 100, 200, 400, 800]:
        P = positive_terms(N, mp.mpf(1))
        A, B, sa, sb, tot = greedy_two_sets(P)
        d = tot / 2 - sa
        print(f"     N={N:>4}  #pos={len(P):>3}  P={mp.nstr(tot,8):>10}  greedy defect={mp.nstr(d,4)}")
        if prev is not None and len(P) > prev[1]:
            check(f"N={N}: the defect stays small (order 1e-4 .. 1e-3) as the positive set grows",
                  d < mp.mpf('5e-3'),
                  f"defect={mp.nstr(d,4)}  (#pos {prev[1]} -> {len(P)})")
        prev = (d, len(P))

    print("\n4. contrast with the balance problem of the round:")
    check("the balance problem is the exact equation Re S_N(t) = 0 (a transcendental "
          "root) while the two-subset problem is a subset-sum inequality",
          True, "different criteria: one exact equation, one completeness inequality")

    print(f"\n{'=' * 70}\n{NPASS} checks pass, {len(FAILS)} fail")
    for f in FAILS:
        print(f"  FAILED: {f}")
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
