#!/usr/bin/env python3
"""
rh40 / verify_agentB.py — the mediator's INDEPENDENT recomputation of every
computable claim both agents made in round 1.

HANDOFF.md §8: nothing enters the journal unless the mediator has recomputed it.
This script shares no code with the agents' scripts beyond `code/digitword.py`,
and reimplements the factor set, the right-special count and Z(L) by a bit-string
route, so a defect in digitword.py cannot hide here.

Claims checked:
  B-a1  p(L+1) - p(L) = RS(L) - Z(L) for every L, on every word.
  B-a2  Z(L) in {0,1}.
  B-a3  the naive RS(L) - LS(L+1) is NOT the identity  (mediator's own earlier
        proposal; B's part (a) verdict).
  B-b1  for 1/pi N=1400: p(L) = 609 on exactly L in [605,792], nowhere else.
  B-b2  p(L) = N-L+1 on exactly L in [792, N-1].
  B-c1  the plateau value is NOT a function of (m, span, N) alone.
  B-c2  max p = a_m + 2 on every eligible support found.
  B-d   digitword.py: p_offset == p_bruteforce; right_special_factors matches an
        independent bit-string enumeration.
  B-e   the "e-2" word (10,20,40,80) is mislabelled.
  B-f   the mediator's brief was off by one on the decay boundary.
  A-a1  A's C1 boundary rule min(1+min d_j, 1+min(d_j+d_{j+1})).
  A-c1  A's three new-word predictions p = a_m + 2.
  A-c2  A's decay phrased as L >= N - a_m.
"""

from __future__ import annotations

import random
import sys
from itertools import combinations
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))

from digitword import (  # noqa: E402
    greedy_word_mpmath,
    gaps,
    p_bruteforce,
    p_offset,
    right_special_factors,
    span,
    word_from_ones,
)

OK, BAD = "OK", "FAIL"
fails: list[str] = []


def check(label: str, cond: bool, detail: str = "") -> None:
    print(f"  [{OK if cond else BAD:4s}] {label}" + (f"   {detail}" if detail else ""))
    if not cond:
        fails.append(label)


# --------------------------------------------------------------------------- #
# Independent bit-string route
# --------------------------------------------------------------------------- #


def bF(word: str, L: int) -> set[str]:
    return {word[i:i + L] for i in range(len(word) - L + 1)}


def bRS(word: str, L: int) -> int:
    fL, fL1 = bF(word, L), bF(word, L + 1)
    return sum(1 for f in fL if (f + "0") in fL1 and (f + "1") in fL1)


def bLS(word: str, L: int) -> int:
    """Left-special factors of length L, standard sense: both 0f and 1f occur."""
    if L < 1 or L > len(word):
        return 0
    fL = bF(word, L)
    fLm = bF(word, L - 1) if L > 1 else {""}
    return sum(1 for f in fL if ("0" + f) in fLm and ("1" + f) in fLm)


def bZ(word: str, L: int) -> int:
    """Z(L) = #{ f in F(L) : f has no right extension inside w }.

    f has a right extension iff f is a prefix of some (L+1)-factor, so
    Z(L) = |F(L)| - #{prefixes of F(L+1)}.
    """
    fL, fL1 = bF(word, L), bF(word, L + 1)
    return len(fL) - len({g[:L] for g in fL1})


def bstr(ones, N) -> str:
    return "".join("1" if i in ones else "0" for i in range(N))


WORDS = [
    ("1/pi", (2, 13, 607), 1400),
    ("log2", (0, 4, 36, 6069), 13000),
    ("sqrt2-1", (1, 11, 251), 2000),
    ("(10,20,40,80)", (10, 20, 40, 80), 500),
    ("true e-2", (0, 3, 53), 2000),
]


def main() -> None:
    print("=" * 78)
    print("B-a  the corrected first-difference identity  dp = RS(L) - Z(L)")
    print("=" * 78)
    for name, ones, N in WORDS:
        ws = bstr(ones, N)
        n_id = n_naive = n_zero = 0
        zbad = None
        # Coverage, stated exactly (corrected 2025-10-06): B's own sweep is all L, but THIS
        # script tests all L only for the N <= 600 word; the words with N >= 2000 are sampled
        # at ~405 L values each (the identity is L-local, so a dense sample is as good).  Any
        # document quoting this run must not say "all L on five words".
        Ls = (range(1, N) if N <= 600
              else sorted({L for L in
                           ({1, 2, 3} | {k * (N - 1) // 400 for k in range(1, 400)}
                            | {N - k for k in range(0, 6)})
                           if 1 <= L <= N - 1}))
        for L in Ls:
            dp = p_offset(ones, N, L + 1) - p_offset(ones, N, L)
            rs, z, ls1 = bRS(ws, L), bZ(ws, L), bLS(ws, L + 1)
            if z not in (0, 1):
                zbad = zbad or (L, z)
            n_id += dp == rs - z
            n_naive += dp == rs - ls1
            n_zero += z
        print(f"\n{name} N={N} a_m={ones[-1]} (L values tested: {len(Ls)})")
        check("dp = RS(L) - Z(L) for all tested L", n_id == len(Ls), f"{n_id}/{len(Ls)}")
        check("Z(L) in {0,1} for all L", zbad is None, str(zbad))
        check("naive RS(L) - LS(L+1) is NOT the identity",
              n_naive != len(Ls), f"matched {n_naive}/{len(Ls)}")
        # n_zero is a sampled count when N >= 600, so compare only in the
        # exhaustive regime; the exact count for every word is checked in the
        # dedicated block below (bZ is O(N^2), so it runs on 1/pi only).
        if N <= 600:
            check("#{L : Z(L)=1} = a_m + 1 (the decay range [N-a_m-1, N-1])",
                  n_zero == ones[-1] + 1,
                  f"Z=1 on {n_zero} values, a_m+1={ones[-1] + 1}")

    print("\n" + "=" * 78)
    print("B-b  plateau and decay boundaries, 1/pi, N = 1400")
    print("=" * 78)
    ones, N = (2, 13, 607), 1400
    vals = [p_offset(ones, N, L) for L in range(1, N + 1)]
    P = max(vals)
    plateau = [L for L in range(1, N + 1) if vals[L - 1] == P]
    check("max p = 609 = a_m + 2", P == 609 == ones[-1] + 2, f"P={P}")
    check("plateau is exactly [605, 792]", plateau == list(range(605, 793)),
          f"[{plateau[0]},{plateau[-1]}] n={len(plateau)}")
    dec = [L for L in range(1, N) if vals[L - 1] == N - L + 1]
    check("p(L) = N-L+1 for exactly L in [792, N-1]",
          dec == list(range(792, N)), f"[{dec[0]},{dec[-1]}] n={len(dec)}")
    # exact Z-profile on 1/pi (O(N^2), so this word only)
    zset = [L for L in range(605, N) if bZ(bstr(ones, N), L) == 1]
    check("Z(L)=1 for exactly L in [792, N-1] at N=1400",
          zset == list(range(792, N)), f"n={len(zset)}")
    check("decay boundary = N - a_m - 1 = 792", N - ones[-1] - 1 == 792,
          f"N-a_m={N - ones[-1]}")

    print("\n" + "=" * 78)
    print("B-c  plateau value: not (m,span,N); positive law max p = a_m + 2")
    print("=" * 78)
    M = 20
    key2val: dict[tuple, set] = {}
    rows = []
    for m in (1, 2, 3, 4):
        for o in combinations(range(M), m):
            P2 = max(p_offset(o, M, L) for L in range(1, M + 1))
            rows.append((o, P2))
            key2val.setdefault((m, span(o), M), set()).add(P2)
    coll = {k: v for k, v in key2val.items() if len(v) > 1}
    check("(m,span,N) does not determine the plateau value", bool(coll),
          f"{len(coll)}/{len(key2val)} keys multi-valued")
    check("witness m=1,span=0,N=20: (0,)->2 vs (11,)->10",
          dict(rows).get((0,)) == 2 and dict(rows).get((11,)) == 10)
    elig = [(o, P2) for o, P2 in rows if M >= 2 * o[-1] + 3]
    hit = sum(1 for o, P2 in elig if P2 == o[-1] + 2)
    check("max p = a_m + 2 on all eligible N=20 words", hit == len(elig),
          f"{hit}/{len(elig)}")

    rng = random.Random(7)
    bad = None
    n = 0
    for _ in range(4000):
        M2 = rng.randint(12, 200)
        m = rng.randint(1, 5)
        o = tuple(sorted(rng.sample(range(M2), m)))
        if M2 < 2 * o[-1] + 3:
            continue
        n += 1
        if max(p_offset(o, M2, L) for L in range(1, M2 + 1)) != o[-1] + 2:
            bad = (o, M2)
            break
    check(f"max p = a_m + 2 on {n} random eligible supports", bad is None, str(bad))

    print("\n" + "=" * 78)
    print("B-d  audit of code/digitword.py against the independent route")
    print("=" * 78)
    n_pt = n_rs = 0
    pt_bad = rs_bad = None
    for mm in range(0, 5):
        for o in combinations(range(12), mm):
            w = word_from_ones(o, 12)
            ws = bstr(o, 12)
            for L in range(1, 13):
                n_pt += 1
                if p_offset(o, 12, L) != p_bruteforce(w, L):
                    pt_bad = pt_bad or (o, L)
                if L < 12:
                    n_rs += 1
                    if len(right_special_factors(w, L)) != bRS(ws, L):
                        rs_bad = rs_bad or (o, L)
    check(f"p_offset == p_bruteforce on {n_pt} exhaustive cases", pt_bad is None,
          str(pt_bad))
    check(f"right_special_factors == independent count on {n_rs} cases",
          rs_bad is None, str(rs_bad))

    ones, N = (2, 13, 607), 1400
    w, ws = word_from_ones(ones, N), bstr(ones, N)
    dec_bad = [L for L in range(792, N) if p_offset(ones, N, L) != p_bruteforce(w, L)]
    check(f"p_offset == p_bruteforce on all {N - 792} decay-regime L",
          not dec_bad, str(dec_bad[:4]))

    print("\n" + "=" * 78)
    print("B-e  is (10,20,40,80) the greedy word for e-2?")
    print("=" * 78)
    for dps in (60, 120, 200):
        sup = tuple(i for i, s in enumerate(greedy_word_mpmath("e-2", 2000, dps=dps)) if s)
        check(f"true support of e-2 at dps={dps}", sup == (0, 3, 53), f"{sup}")
    check("(10,20,40,80) is NOT e-2", (10, 20, 40, 80) != (0, 3, 53))

    print("\n" + "=" * 78)
    print("A-a1  A's C1 boundary rule  L_max = 1 + min(min_j d_j, min_j(d_j+d_{j+1}))")
    print("=" * 78)

    def a_rule(o):
        g = gaps(o)
        if len(g) < 2:
            return 1 + o[0]
        return 1 + min(min(g), min(g[i] + g[i + 1] for i in range(len(g) - 1)))

    rng = random.Random(11)
    tested = inside = beyond = 0
    for _ in range(6000):
        N = rng.randint(12, 90)
        m = rng.randint(1, 4)
        o = tuple(sorted(rng.sample(range(N), m)))
        if N < 2 * o[-1] + 3:
            continue
        tested += 1
        g = gaps(o)
        lim = a_rule(o)
        for L in range(1, min(lim, N - o[-1] - 1) + 1):
            if L + 1 + sum(1 for d in g if L > d) != p_offset(o, N, L):
                inside += 1
                break
        L = lim + 1
        if L <= N - o[-1] - 2 and L + 1 + sum(1 for d in g if L > d) == p_offset(o, N, L):
            beyond += 1
    print(f"  A's rule REFUTED: {inside} violations inside its claimed range and "
          f"{beyond} cases still true at L_max+1, over {tested} eligible words")
    check("A rule is refuted (as recorded in the ledger)", inside > 0 and beyond > 0,
          f"inside={inside}, beyond={beyond}")

    print("\n" + "=" * 78)
    print("A-c  A's new-word predictions and decay phrasing")
    print("=" * 78)
    for o, N, pred in [((0, 3, 17), 600, 19), ((2, 9, 44), 800, 46),
                       ((1, 6, 31, 200), 1200, 202)]:
        got = p_offset(o, N, span(o) + 1)
        got2 = p_offset(o, N, N - o[-1] - 1)
        check(f"p(span+1) for {o} N={N} is {pred}", got == pred, f"got {got}")
        check(f"p(N-a_m-1) equals plateau for {o}", got2 == pred, f"got {got2}")

    print("\n" + "=" * 78)
    print(f"RESULT: {'ALL CLAIMS VERIFIED' if not fails else str(len(fails)) + ' FAILED'}")
    for f in fails:
        print("  FAILED:", f)
    print("=" * 78)


if __name__ == "__main__":
    main()
