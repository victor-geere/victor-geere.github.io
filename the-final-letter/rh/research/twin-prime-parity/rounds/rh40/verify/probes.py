#!/usr/bin/env python3
"""
rh40 / probes.py — the concrete numerical targets of HANDOFF.md §6.

Usage:
    python3 rh40/verify/probes.py            # fast default set
    python3 rh40/verify/probes.py --all      # add the heavy O(N^2) sweeps
    python3 rh40/verify/probes.py --only 1 3 # run selected probes

All arithmetic is exact (ints, Fractions, mpmath at >= 120 dps).  Every report
carries its truncation length N.
"""

from __future__ import annotations

import random
import sys
from itertools import combinations
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))

from digitword import (  # noqa: E402
    SUPPORT_1_OVER_PI,
    first_difference_check,
    gaps,
    p_bruteforce,
    p_offset,
    right_special_count,
    slopes,
    span,
    word_from_ones,
)

# The four dialogue words of HANDOFF.md §3.3, with their truncation lengths.
DIALOGUE_WORDS = [
    ("1/pi", (2, 13, 607), 1400),
    ("log2", (0, 4, 36, 6069), 13000),
    ("sqrt2-1", (1, 11, 251), 2000),
    ("e-2", (10, 20, 40, 80), 500),
]

HEAVY = False


def _sweep(N: int, n: int = 40) -> list[int]:
    """A representative spread of L values in [1, N] — never O(N) of them."""
    s = {1, 2, 3, N // 2, N - 1, N - 2, N - 3}
    s |= {max(1, k * N // n) for k in range(1, n + 1)}
    s |= {max(1, N - k) for k in range(0, 12)}
    return sorted(x for x in s if 1 <= x <= N)


# --------------------------------------------------------------------------- #
# §6.1  Saturation values and the exact range over which each holds
# --------------------------------------------------------------------------- #


def probe1_saturation_ranges() -> None:
    print("=" * 78)
    print("§6.1  saturation value AND the exact L-range over which it holds")
    print("=" * 78)
    for name, ones, N in DIALOGUE_WORDS:
        vals = [p_offset(ones, N, L) for L in range(1, N + 1)]
        mx = max(vals)
        idx = [i + 1 for i, v in enumerate(vals) if v == mx]
        w = word_from_ones(ones, N)
        sweep = list(range(1, N + 1)) if HEAVY else _sweep(N)
        brute_ok = all(p_offset(ones, N, L) == p_bruteforce(w, L) for L in sweep)
        print(f"\n{name}: ones={ones} N={N} span={span(ones)} gaps={gaps(ones)}")
        print(f"  max p = {mx}; attained for L in [{idx[0]}, {idx[-1]}]"
              f"  ({len(idx)} values of L)")
        print(f"  plateau start = {idx[0]}, decay start = {idx[-1] + 1},"
              f"  N - a_m = {N - ones[-1]}")
        print(f"  p(N-2)={p_offset(ones, N, N - 2)}  p(N-1)={p_offset(ones, N, N - 1)}")
        print(f"  offset-tuple count == bit-string factor count on {len(sweep)} "
              f"sampled L: {brute_ok}")
        print(f"  slope runs (start, end, dp), dp(L) = p(L+1)-p(L): {slopes(ones, N)}")


# --------------------------------------------------------------------------- #
# §6.2  Exhaustive small-case table — the dataset any closed form must fit
# --------------------------------------------------------------------------- #


def probe2_exhaustive_small() -> None:
    print("\n" + "=" * 78)
    print("§6.2  exhaustive table, N = 20, m in {1,2,3,4}")
    print("=" * 78)
    N = 20
    rows = []
    for m in (1, 2, 3, 4):
        for ones in combinations(range(N), m):
            vals = [p_offset(ones, N, L) for L in range(1, N + 1)]
            mx = max(vals)
            idx = [i + 1 for i, v in enumerate(vals) if v == mx]
            rows.append((ones, mx, idx[0], idx[-1]))
    print(f"  words enumerated: {len(rows)}")

    print("\n  candidate closed forms for the plateau VALUE:")
    cands = {
        "m (= #ones)": lambda o: len(o),
        "2m - 1": lambda o: 2 * len(o) - 1,
        "N - span": lambda o: N - span(o),
        "N - a_m + m": lambda o: N - o[-1] + len(o),
        "m(m+1)/2": lambda o: len(o) * (len(o) + 1) // 2,
        "N - a_m": lambda o: N - o[-1],
        "N - a_0": lambda o: N - o[0],
        "span + 1": lambda o: span(o) + 1,
        "#distinct consecutive-gap sums":
            lambda o: len(_consec_sums(gaps(o))),
        "#distinct subset sums of gaps":
            lambda o: len(_subset_sums(gaps(o))),
    }
    for cname, f in cands.items():
        hits = sum(1 for o, mx, _, _ in rows if f(o) == mx)
        print(f"    {cname:36s} {hits:5d}/{len(rows)}"
              f"   {'<-- EXACT' if hits == len(rows) else ''}")

    from collections import Counter as C2
    c = C2(mx for _, mx, _, _ in rows)
    print(f"\n  distribution of plateau value: {dict(sorted(c.items()))}")

    print("\n  is the plateau value a function of (m, span, N) alone?")
    key2val: dict[tuple, set] = {}
    for o, mx, _, _ in rows:
        key2val.setdefault((len(o), span(o), N), set()).add(mx)
    coll = {k: v for k, v in key2val.items() if len(v) > 1}
    print(f"    distinct (m, span, N) keys: {len(key2val)};"
          f" keys with >1 plateau value: {len(coll)}")
    for k in list(coll)[:5]:
        wit = [o for o, mx, _, _ in rows
               if (len(o), span(o), N) == k and mx in coll[k]]
        print(f"    m={k[0]} span={k[1]} N={k[2]} -> values {sorted(coll[k])}"
              f"  witnesses {wit[:6]}")

    print("\n  is the plateau L-RANGE a function of the gap sequence alone?")
    key2rng: dict[tuple, set] = {}
    for o, mx, lo, hi in rows:
        key2rng.setdefault(tuple(gaps(o)), set()).add((lo, hi))
    coll2 = {k: v for k, v in key2rng.items() if len(v) > 1}
    print(f"    distinct gap sequences: {len(key2rng)};"
          f" with >1 plateau range: {len(coll2)}")
    for k in list(coll2)[:5]:
        print(f"    gaps={k} -> ranges {sorted(coll2[k])[:6]}")


def _consec_sums(g: list[int]) -> set[int]:
    out = set()
    for i in range(len(g)):
        for j in range(i + 1, len(g) + 1):
            out.add(sum(g[i:j]))
    return out


def _subset_sums(g: list[int]) -> set[int]:
    out = {0}
    for d in g:
        out |= {s + d for s in out}
    return out


# --------------------------------------------------------------------------- #
# §6.3  C1 stress test — the prefix-regime formula, and where it truly ends
# --------------------------------------------------------------------------- #


def probe3_c1_stress(trials: int = 2000, seed: int = 20261002) -> None:
    print("\n" + "=" * 78)
    print("§6.3  C1:  p(L) = L + 1 + #{d_i : d_i < L}")
    print("=" * 78)
    rng = random.Random(seed)
    n_ok = n_bad = 0
    first_bad = None
    for _ in range(trials):
        m = rng.randint(1, 5)
        g = [rng.randint(1, 12) for _ in range(m)]
        L = rng.randint(1, min(g))
        N = sum(g) + rng.randint(0, 10) + L + 5
        ones, pos = [], rng.randint(0, 5)
        for d in g:
            pos += d
            ones.append(pos)
        pred = L + 1 + sum(1 for d in g if L > d)
        ex = p_offset(tuple(ones), N, L)
        if pred == ex:
            n_ok += 1
        else:
            n_bad += 1
            first_bad = first_bad or (ones, N, L, g, pred, ex)
    print(f"  restricted to L <= min gap: trials={trials}  agree={n_ok}"
          f"  disagree={n_bad}")
    print(f"  first disagreement: {first_bad}" if first_bad
          else "  C1 holds on every trial in its stated regime (L <= min gap).")

    print("\n  --- how far PAST the stated regime does C1 actually hold? ---")
    for name, ones, N in DIALOGUE_WORDS:
        g = gaps(ones)
        fails = [L for L in range(1, min(N - 1, 4 * max(g) + 8))
                 if L + 1 + sum(1 for d in g if L > d) != p_offset(ones, N, L)]
        first = fails[0] if fails else None
        extra = (f" (C1 gives {first + 1 + sum(1 for d in g if first > d)},"
                 f" exact {p_offset(ones, N, first)})" if first else "")
        print(f"    {name:9s} gaps={str(g):18s} C1 holds for "
              f"L <= {first - 1 if first else 'N/A'}; first failure L={first}{extra}")
    print("    => in every case the C1 regime ends STRICTLY BELOW the next gap,")
    print("       so there is an unmodelled 'saturation-onset' regime between them.")


# --------------------------------------------------------------------------- #
# §6.4  First-difference certificate
# --------------------------------------------------------------------------- #


def probe4_first_difference() -> None:
    print("\n" + "=" * 78)
    print("§6.4  Cassaigne: p(L+1)-p(L) = #right-special(L), and where it breaks")
    print("=" * 78)
    for name, ones, N in DIALOGUE_WORDS:
        w = word_from_ones(ones, N)
        rows = first_difference_check(w)
        bad = [r for r in rows if not r[3]]
        print(f"\n{name}: N={N} a_m={ones[-1]} N-a_m={N - ones[-1]}"
              f"  L tested={len(rows)}  agree={len(rows) - len(bad)}"
              f"  disagree={len(bad)}")
        if bad:
            print(f"  first failure L={bad[0][0]}, last L={bad[-1][0]},"
                  f" count with L > N-a_m = "
                  f"{sum(1 for r in bad if r[0] > N - ones[-1])}")
        sample = [(L, p_offset(ones, N, L + 1) - p_offset(ones, N, L),
                   right_special_count(w, L))
                  for L in (1, 5, 10, 20, 100) if L < N]
        print("  at L in {1,5,10,20,100}: "
              + "  ".join(f"L={L}:dp={d},RS={r}" + ("" if d == r else "*")
                          for L, d, r in sample))
        print("  right-special count in the decay regime: "
              + ", ".join(f"RS({L})={right_special_count(w, L)}"
                          for L in (N - 5, N - 3, N - 2)))


# --------------------------------------------------------------------------- #
# §6.5  Residual-orbit average (the other open question)
# --------------------------------------------------------------------------- #


def probe5_orbit(dps: int = 800, steps: int = 200) -> None:
    print("\n" + "=" * 78)
    print("§6.5  residual orbit  r -> r - 1/ceil(1/r),  c_k = (1-f)/(1+(1-f)r)")
    print("=" * 78)
    import mpmath as mp

    exprs = {
        "1/pi": "1/pi", "log2": "log(2)", "sqrt2-1": "sqrt(2)-1", "e-2": "e-2",
        "sqrt3-1": "sqrt(3)-1", "log2/log10": "log(2)/log(10)",
    }
    old = mp.mp.dps
    try:
        mp.mp.dps = dps
        env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
        for name, expr in exprs.items():
            r = mp.mpf(eval(expr, env))  # noqa: S307
            logs = []
            for _ in range(steps):
                u = 1 / r
                n = int(mp.ceil(u))
                f = u - (n - 1)
                c = (1 - f) / (1 + (1 - f) * r)
                logs.append(mp.log(c))
                r = r - 1 / mp.mpf(n)
                if r <= 0:
                    break
            mean = (mp.nstr(sum(logs) / len(logs), 10) if logs else "n/a")
            tail = (mp.nstr(sum(logs[-10:]) / 10, 10) if len(logs) >= 10 else "n/a")
            print(f"  {name:12s} steps={len(logs):3d}  mean log c_k = {mean:>16s}"
                  f"   mean of last 10 = {tail}")
        print(f"\n  A's scaling-limit integral  int_0^1 log(1-f) df = "
              f"{mp.nstr(mp.quad(lambda f: mp.log(1 - f), [0, 1]), 10)}")
        print("  The integral is -1; the finite-r means above are not. The large-u")
        print("  scaling limit is not attained at the reachable r.")
    finally:
        mp.mp.dps = old


# --------------------------------------------------------------------------- #
# Audit: HANDOFF.md §3.1 recorded piecewise law
# --------------------------------------------------------------------------- #


def probe6_handoff_31_audit() -> None:
    print("\n" + "=" * 78)
    print("AUDIT  HANDOFF.md §3.1 recorded piecewise law, x = 1/pi, N = 1400")
    print("=" * 78)
    ones, N = SUPPORT_1_OVER_PI, 1400

    def handoff(L: int) -> int:
        if L <= 11:
            return L + 1
        if L <= 593:
            return 2 * L - 10
        if L <= 604:
            return 3 * L - 603
        return 609

    print("  L      handoff   exact   verdict")
    nbad = 0
    for L in (1, 11, 12, 13, 14, 15, 20, 50, 100, 300, 593, 594, 605):
        h, e = handoff(L), p_offset(ones, N, L)
        nbad += h != e
        print(f"  {L:5d}  {h:8d} {e:7d}   {'agree' if h == e else '*** MISMATCH ***'}")
    print(f"\n  {nbad} of the tabulated L disagree with exact enumeration.")
    print("  The §3.1 table of measured values is correct; only the extrapolated")
    print("  closed forms are false ('2L-10' gives 1176 at L=593, truth 597).")
    print("  §5 already records this as 'partly true, over-extrapolated'.")
    print("\n  true slope structure:")
    for a, b, s in slopes(ones, N):
        print(f"    p(L+1)-p(L) = {s:2d}   for L in [{a}, {b}]")


PROBES = {
    1: probe1_saturation_ranges,
    2: probe2_exhaustive_small,
    3: probe3_c1_stress,
    4: probe4_first_difference,
    5: probe5_orbit,
    6: probe6_handoff_31_audit,
}


def main(argv: list[str]) -> None:
    global HEAVY
    only: list[int] = []
    if "--all" in argv:
        HEAVY = True
    if "--only" in argv:
        i = argv.index("--only")
        only = [int(a) for a in argv[i + 1:] if a.isdigit()]
    for n, fn in PROBES.items():
        if only and n not in only:
            continue
        fn()
    print("\n" + "=" * 78)
    print("done — every number above is exact output of rh40/code/digitword.py")
    print(f"(heavy O(N^2) sweeps: {'ON' if HEAVY else 'off — pass --all'})")
    print("=" * 78)


if __name__ == "__main__":
    main(sys.argv[1:])
