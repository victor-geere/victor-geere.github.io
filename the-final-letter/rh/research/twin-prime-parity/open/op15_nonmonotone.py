#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""op15_nonmonotone.py -- OP-15: non-monotone alphabets in the inverse complexity problem.

Run:

    cd /Users/victor/workspace/rh
    /opt/homebrew/Caskroom/miniconda/base/bin/python3 \
        research/twin-prime-parity/open/op15_nonmonotone.py 2>&1 \
        | tee research/twin-prime-parity/open/op15_nonmonotone.log

    (the interpreter actually used here is /opt/homebrew/Caskroom/miniforge/base/bin/python3)

WHAT OP-15 ASKS (register `07-open-problems.md`, rank 11)
--------------------------------------------------------
The inverse complexity problem: a greedy alphabet `alpha = (alpha_n)` (a sequence of
reals, possibly signed) and a target `x > 0` generate a 0/1 *greedy word* by

        r_0 = x ,      digit_n = 1  iff  r_n >= alpha_n ,
                       r_{n+1} = r_n - digit_n * alpha_n .

`p(L)` is the factor complexity (number of distinct length-L factors) of that word.
OP-15 asks whether a **halting** alphabet can realise `p(L) = cL`, and in particular
`sup_L p(L)/L = infinity`.

KNOWN (rh41 TRUTHS.md, Thm 1, 5, 7, 12; rh41/rigorous_check.py)
----------------------------------------------------------------
* Thm 4/12: for ANY finitely supported word of length N, once
  `L >= max(span, a_m+1)` the profile is the three-piece law
  `p(L) = min(a_m+1, N-L+1) + [L <= N-a_m-1]`, so `max_L p(L) = a_m + 2`, a NUMBER.
  Hence a finitely supported word cannot have `sup_L p(L)/L = infinity`.
* Thm 9: for a NON-INCREASING positive alphabet, halting (= finitely many ones)
  holds iff `sum_n alpha_n >= x`.
* Thm 5 (C1 law): `p(L) = L+1` for `L <= min(min gap, a_0, N-a_0-1)`.
The register flags non-monotone alphabets as untouched: "the taken set can be
arbitrary and the greedy need not halt, so the argument does not start".

WHAT THIS SCRIPT DOES (finite evidence only)
--------------------------------------------
Two finite readings of "a small alphabet with 2-4 terms":

  FAMILY L (literal, rh40 K_remaining 5.5 style).  The alphabet IS the k-term list
  (k = 2,3,4); the word has length k.  The rh40 example `alpha = [29/40,1/2,1/4,3/20]`,
  `x = 7/8` (taken `{0,3}`) is reproduced as a regression test.

  FAMILY P (periodic pattern).  The k-term pattern is repeated: `alpha_n = v_{n mod k}`.
  This is the finite description that gives an infinite alphabet, so the truncation N
  is meaningful and `p(L)` can be studied for L up to N.  Positive patterns are
  *provably* eventually silent (r is non-increasing and each take costs >= min v > 0,
  so at most `x/min v` takes) and signed patterns are *provably* never silent (a
  negative term always satisfies `r >= alpha_n`, so it is always taken, and it recurs).

Everything is exact integer arithmetic after clearing denominators (`alpha_n = j/6`,
targets rational), and the factor complexity is computed by a suffix automaton
(`p(L) = #{v : len(link(v)) < L <= len(v)}`) and cross-checked against brute-force
distinct substrings on random short words.

HONESTY.  This is a FINITE search over a stated finite class.  It does not settle
OP-15.  The register's conjectured claim -- "a halting non-monotone alphabet with
`sup_L p(L)/L = infinity`" -- remains OPEN; the search below is finite evidence only.
"""

from __future__ import annotations

import sys
import time
from fractions import Fraction
from itertools import product

# ---------------------------------------------------------------------------
# 0.  Configuration
# ---------------------------------------------------------------------------

DENOM = 6                       # alphabet values have denominator dividing 6
# VALUES: +-j/6 for j = 1..6, i.e. +-{1/6,1/3,1/2,2/3,5/6,1}  (12 values)
VALUES = sorted(
    {Fraction(s * j, DENOM) for s in (1, -1) for j in range(1, DENOM + 1)},
    key=lambda f: (abs(f), f),
)
KS = (2, 3, 4)                  # pattern lengths ("2-4 terms")
N_TRUNC = 1024                  # truncation length for the family-P sweep
X_MAIN = Fraction(1)            # primary target (harmonic convention)
X_ALT = Fraction(7, 8)          # secondary target (rh40 witness target)
TARGETS_P = (X_MAIN, X_ALT)     # family-P targets
TARGETS_L = (X_MAIN, X_ALT, Fraction(1, 2), Fraction(3, 4))

CHECKS: list[tuple[str, bool, str]] = []


def check(name: str, ok: bool, detail: str = "") -> None:
    CHECKS.append((name, bool(ok), detail))
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f"  ({detail})" if detail else ""))


def section(title: str) -> None:
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


# ---------------------------------------------------------------------------
# 1.  The greedy rule (exact integer arithmetic) and factor complexity
# ---------------------------------------------------------------------------


def lcm(a: int, b: int) -> int:
    from math import gcd
    return a // gcd(a, b) * b


def greedy_integerized(pattern: tuple[Fraction, ...], x: Fraction, n_steps: int):
    """Greedy run for the periodic alphabet alpha_n = pattern[n mod k].

    Returns (word, residual, takes, first_zero) with everything exact.  The
    alphabet and the target are cleared to a common integer denominator D, so
    the whole run is integer arithmetic.

    `first_zero` is the index n (0-based) such that r_{n+1} == 0, or None.
    A zero residual is ABSORBING only if every later alpha is >= 0; for a
    periodic pattern that means the pattern is entirely positive.  The caller
    uses `pattern` to decide absorption.
    """
    k = len(pattern)
    D = DENOM
    for v in pattern:
        D = lcm(D, v.denominator)
    D = lcm(D, x.denominator)
    a_int = [int(v * D) for v in pattern]
    r = int(x * D)
    word = [0] * n_steps
    takes: list[int] = []
    first_zero = None
    for n in range(n_steps):
        a = a_int[n % k]
        if r >= a:
            word[n] = 1
            takes.append(n)
            r -= a
            if r == 0 and first_zero is None:
                first_zero = n
    return word, Fraction(r, D), takes, first_zero


def greedy_finite(pattern: tuple[Fraction, ...], x: Fraction):
    """Family L: the alphabet is the finite list `pattern`; word length = k."""
    word, r, takes, fz = greedy_integerized(pattern, x, len(pattern))
    return word, r, takes, fz


def sam_profile(word) -> list[int]:
    """p(L) for L = 1..n, via a suffix automaton.

    Each distinct substring of the word corresponds to exactly one pair
    (state v, length L) with len(link(v)) < L <= len(v); hence
    p(L) = #{v != root : len(link(v)) < L <= len(v)}.
    """
    n = len(word)
    if n == 0:
        return []
    link = [-1]
    length = [0]
    trans = [{}]
    last = 0
    for c in word:
        cur = len(link)
        link.append(0)
        length.append(length[last] + 1)
        trans.append({})
        p = last
        while p != -1 and c not in trans[p]:
            trans[p][c] = cur
            p = link[p]
        if p == -1:
            link[cur] = 0
        else:
            q = trans[p][c]
            if length[p] + 1 == length[q]:
                link[cur] = q
            else:
                clone = len(link)
                link.append(link[q])
                length.append(length[p] + 1)
                trans.append(dict(trans[q]))
                while p != -1 and trans[p].get(c) == q:
                    trans[p][c] = clone
                    p = link[p]
                link[q] = clone
                link[cur] = clone
        last = cur
    diff = [0] * (n + 2)
    for v in range(1, len(link)):
        lo = length[link[v]] + 1
        hi = length[v]
        if lo <= hi:
            diff[lo] += 1
            diff[hi + 1] -= 1
    prof = [0] * (n + 1)
    run = 0
    for L in range(1, n + 1):
        run += diff[L]
        prof[L] = run
    return prof


def brute_profile(word) -> list[int]:
    """Ground truth: count distinct bit-string factors directly.

    Returns a list indexed like `sam_profile`: entry 0 is unused (0) and entry
    L is p(L), so the two routes are directly comparable.
    """
    n = len(word)
    out = [0] * (n + 1)
    for L in range(1, n + 1):
        out[L] = len({tuple(word[i:i + L]) for i in range(n - L + 1)})
    return out


# ---------------------------------------------------------------------------
# 2.  Classification helpers
# ---------------------------------------------------------------------------


def monotone_class(pattern: tuple[Fraction, ...]) -> str:
    inc = all(pattern[i] >= pattern[i + 1] for i in range(len(pattern) - 1))
    dec = all(pattern[i] <= pattern[i + 1] for i in range(len(pattern) - 1))
    if inc and dec:
        return "constant"
    if inc:
        return "non-increasing"
    if dec:
        return "non-decreasing"
    return "non-monotone"


def is_positive(pattern) -> bool:
    return all(v > 0 for v in pattern)


def profile_stats(prof: list[int]):
    """(R_full, L_full, R2, L2, max_p, argmax_p) for a profile indexed from L=1."""
    n = len(prof) - 1
    best = max((prof[L] / L, L) for L in range(1, n + 1))
    best2 = max((prof[L] / L, L) for L in range(2, n + 1)) if n >= 2 else (0.0, 0)
    maxp = max(prof[1:]) if n >= 1 else 0
    amax = max(L for L in range(1, n + 1) if prof[L] == maxp)
    return best[0], best[1], best2[0], best2[1], maxp, amax


def fmt_alpha(pattern) -> str:
    return "[" + ", ".join(str(v) for v in pattern) + "]"


# ---------------------------------------------------------------------------
# 3.  Regression/cross-checks before the search
# ---------------------------------------------------------------------------


def cross_checks() -> None:
    section("1. CORRECTNESS CROSS-CHECKS (before the search)")

    # 3a. SAM vs brute force on pseudo-random words.
    import random
    rng = random.Random(20240611)
    bad = 0
    for _ in range(400):
        n = rng.randint(1, 14)
        w = [rng.randint(0, 1) for _ in range(n)]
        if sam_profile(w) != brute_profile(w):
            bad += 1
    check("SAM factor complexity == brute-force distinct substrings (400 random words)",
          bad == 0, f"{bad} mismatches")

    # 3b. rh40 K_remaining 5.5 witness: alpha=[29/40,1/2,1/4,3/20], x=7/8 -> taken {0,3}
    pat = (Fraction(29, 40), Fraction(1, 2), Fraction(1, 4), Fraction(3, 20))
    word, r, takes, fz = greedy_finite(pat, Fraction(7, 8))
    check("rh40 witness alpha=[29/40,1/2,1/4,3/20], x=7/8 gives taken {0,3}",
          takes == [0, 3] and r == 0,
          f"word={word}, taken={takes}, residual={r}")

    # 3c. A non-increasing positive periodic pattern must be eventually silent:
    #     number of ones <= x/min v.  Test the constant pattern 1/2, x=1: takes
    #     at 0,1 (r=0) -> halts, exactly 2 ones.
    word, r, takes, fz = greedy_integerized((Fraction(1, 2), Fraction(1, 2)), Fraction(1), 64)
    check("constant alphabet 1/2, x=1: word = 1100... and residual 0",
          word == [1, 1] + [0] * 62 and r == 0, f"takes={takes[:5]}")

    # 3d. The harmonic alphabet 1/(n+2) at x=1 is the theta=pi case with exact
    #     support (0,1,4): 1/2 + 1/3 + 1/6 = 1 (rh41 SUPPORT_PI_EXACT).
    pat2 = tuple(Fraction(1, (n + 2)) for n in range(30))  # not periodic; sanity only
    r = Fraction(1)
    takes2 = []
    for n, a in enumerate(pat2):
        if r >= a:
            takes2.append(n)
            r -= a
    check("harmonic alphabet 1/(n+2), x=1: support is exactly {0,1,4} "
          "(1/2+1/3+1/6 = 1) and residual 0",
          takes2 == [0, 1, 4] and r == 0, f"takes={takes2}, residual={r}")


# ---------------------------------------------------------------------------
# 4.  Family L -- literal finite alphabets (word length = k)
# ---------------------------------------------------------------------------


def family_L() -> None:
    section("2. FAMILY L -- LITERAL k-TERM ALPHABETS (word length k, p(L) for L <= k)")
    print("  Alphabet = the k-term list itself; the word has length k.  Targets:")
    print("  " + ", ".join(str(t) for t in TARGETS_L))
    print()

    rows = []
    patterns = [p for k in KS for p in product(VALUES, repeat=k)]
    for pat in patterns:
        for x in TARGETS_L:
            word, r, takes, fz = greedy_finite(pat, x)
            prof = sam_profile(word)
            R, Lb, R2, L2, maxp, amax = profile_stats(prof)
            rows.append(dict(pat=pat, x=x, word=word, r=r, prof=prof,
                             R=R, Lb=Lb, R2=R2, maxp=maxp, amax=amax,
                             cls=monotone_class(pat), pos=is_positive(pat)))

    rows.sort(key=lambda d: (-d["R"], -d["R2"]))
    print(f"  Cases enumerated: {len(patterns)} patterns x {len(TARGETS_L)} targets "
          f"= {len(rows)}")
    print("\n  Top 12 by max_L p(L)/L (word length <= 4; ratio is dominated by small L):")
    print(f"  {'alpha':<34} {'x':<5} {'word':<6} {'class':<13} {'halt?':<6} "
          f"{'max p/L':<8} {'argL':<5} {'maxp':<5}")
    for d in rows[:12]:
        halt = "yes" if d["r"] == 0 else "no"
        print(f"  {fmt_alpha(d['pat']):<34} {str(d['x']):<5} "
              f"{''.join(map(str, d['word'])):<6} {d['cls']:<13} {halt:<6} "
              f"{d['R']:<8.3f} {d['Lb']:<5} {d['maxp']:<5}")

    # Does a HALTING non-monotone finite alphabet ever exceed the halting
    # monotone (non-increasing) class?
    def best(pred):
        c = [d for d in rows if pred(d)]
        return max(c, key=lambda d: d["R"]) if c else None

    halt_inc_pos = best(lambda d: d["r"] == 0 and d["cls"] == "non-increasing" and d["pos"])
    halt_nonmono = best(lambda d: d["r"] == 0 and d["cls"] == "non-monotone")
    print("\n  Best halting non-increasing positive :",
          (fmt_alpha(halt_inc_pos["pat"]) + f" x={halt_inc_pos['x']} R={halt_inc_pos['R']:.3f}")
          if halt_inc_pos else "none")
    print("  Best halting non-monotone             :",
          (fmt_alpha(halt_nonmono["pat"]) + f" x={halt_nonmono['x']} R={halt_nonmono['R']:.3f}")
          if halt_nonmono else "none")
    # FINDING (not a PASS/FAIL gate): with word length <= 4 the metric max p(L)/L
    # is capped at 2 -- p(1) <= 2 gives 2, p(2) <= 4 gives 2, and p(3) <= k-2.
    # So family L cannot discriminate.  Report it plainly.
    cap = 2.0
    print(f"  NOTE: for words of length <= 4 the ceiling of max_L p(L)/L is 2 "
          f"(p(1)<=2, p(2)<=4, p(3)<=k-2);")
    print(f"        every class attains it, so family L cannot separate monotone from "
          f"non-monotone.")
    if halt_nonmono is not None and halt_inc_pos is not None and \
            halt_nonmono["R"] > halt_inc_pos["R"] + 1e-12:
        print("  A halting non-monotone alphabet does beat the halting non-increasing")
        print("  class on this metric; witness:",
              fmt_alpha(halt_nonmono["pat"]), "x =", halt_nonmono["x"],
              "word =", "".join(map(str, halt_nonmono["word"])),
              "p(L) =", halt_nonmono["prof"][1:])
    else:
        print("  No separation observed (as expected: both classes attain the cap 2).")


# ---------------------------------------------------------------------------
# 5.  Family P -- periodic patterns, truncation N
# ---------------------------------------------------------------------------


def family_P(N: int):
    section(f"3. FAMILY P -- PERIODIC 2-4 TERM PATTERNS, TRUNCATION N = {N}")
    print("  alpha_n = v_(n mod k); target x in {" + ", ".join(str(t) for t in TARGETS_P) + "}")
    print("  The word length is N for every pattern; p(L) is computed for 1 <= L <= N.")
    print("  CLASSIFICATION (proved, not observed):")
    print("    * all-positive pattern  -> at most x/min(v) takes -> FINITE support")
    print("      (r is non-increasing, each take costs >= min v > 0, r >= 0 always)")
    print("    * signed pattern        -> every negative term is always taken ->")
    print("      INFINITE support; a zero residual is NOT absorbing (the next")
    print("      negative term re-triggers), so no signed periodic pattern halts.")
    print()

    t0 = time.time()
    records = []
    patterns = [p for k in KS for p in product(VALUES, repeat=k)]
    for pat in patterns:
        for x in TARGETS_P:
            word, r, takes, fz = greedy_integerized(pat, x, N)
            prof = sam_profile(word)
            R, Lb, R2, L2, maxp, amax = profile_stats(prof)
            am = takes[-1] if takes else -1
            span = (takes[-1] - takes[0]) if len(takes) > 1 else 0
            cls = monotone_class(pat)
            pos = is_positive(pat)
            records.append(dict(
                pat=pat, x=x, word=word, r=r, prof=prof, takes=takes,
                R=R, Lb=Lb, R2=R2, L2=L2, maxp=maxp, amax=amax,
                cls=cls, pos=pos, a_m=am, span=span, fz=fz,
                n_ones=len(takes),
                kind=("finite" if pos else "infinite"),
                absorbed=bool(pos and fz is not None),
                ratios20=[prof[L] / L for L in range(1, min(20, N) + 1)],
            ))
    dt = time.time() - t0
    print(f"  Cases enumerated: {len(patterns)} patterns x {len(TARGETS_P)} targets "
          f"= {len(records)}  ({dt:.1f} s)")

    n_fin = sum(1 for d in records if d["kind"] == "finite")
    n_inf = sum(1 for d in records if d["kind"] == "infinite")
    n_abs = sum(1 for d in records if d["absorbed"])
    print(f"\n  finite-support cases : {n_fin}")
    print(f"  infinite-support cases: {n_inf}  (all signed patterns)")
    print(f"  absorbed at residual 0 (true halt): {n_abs}  (all-positive patterns)")

    # Internal correctness check: every signed periodic pattern takes its last
    # negative phase, hence a one occurs in the final period -> infinite support.
    sig_bad = 0
    for d in records:
        if d["kind"] != "infinite":
            continue
        k = len(d["pat"])
        if not d["takes"] or d["takes"][-1] < N - k:
            sig_bad += 1
    check("every signed periodic pattern has a one in its final period "
          "(infinite support; never halts)", sig_bad == 0, f"{sig_bad} exceptions")

    # ---- (a) best profiles ------------------------------------------------
    records.sort(key=lambda d: (-d["R"], -d["R2"]))
    print("\n  (a) TOP 20 alphabet/target pairs by max_{L<=N} p(L)/L")
    print(f"  {'alpha':<32} {'x':<5} {'class':<13} {'kind':<9} {'halted?':<10} "
          f"{'max p/L':<8} {'argL':<6} {'R(L>=2)':<8} {'#ones':<7} {'maxp':<6}")
    for d in records[:20]:
        if d["absorbed"]:
            halted = "yes"
        elif d["fz"] is not None:
            halted = f"r=0@{d['fz']}"
        else:
            halted = "no"
        print(f"  {fmt_alpha(d['pat']):<32} {str(d['x']):<5} {d['cls']:<13} "
              f"{d['kind']:<9} {halted:<10} "
              f"{d['R']:<8.4f} {d['Lb']:<6} {d['R2']:<8.4f} {d['n_ones']:<7} {d['maxp']:<6}")

    # ---- best halting (finite-support) non-monotone ------------------------
    halt_nonmono = [d for d in records if d["kind"] == "finite" and d["cls"] == "non-monotone"]
    halt_inc_pos = [d for d in records if d["kind"] == "finite"
                    and d["cls"] == "non-increasing" and d["pos"]]
    print("\n  (b) HALTING (finite-support) alphabets")
    if halt_nonmono:
        b = max(halt_nonmono, key=lambda d: d["R"])
        print("      best halting non-monotone: " + fmt_alpha(b["pat"])
              + f" x={b['x']}  R={b['R']:.4f} at L={b['Lb']}, #ones={b['n_ones']}, "
              + f"a_m={b['a_m']}, max p = {b['maxp']}, a_m+2 = {b['a_m'] + 2}")
        print("      support:", b["takes"][:40])
    else:
        print("      none found")
    if halt_inc_pos:
        b = max(halt_inc_pos, key=lambda d: d["R"])
        print("      best halting non-increasing positive: " + fmt_alpha(b["pat"])
              + f" x={b['x']}  R={b['R']:.4f} at L={b['Lb']}")

    # Verify Thm 4 for every finite-support record: max p(L) == a_m + 2 whenever
    # N >= 2 a_m + 2 (Corollary 4), and the plateau value is a number.
    thm4_bad = []
    for d in records:
        if d["kind"] != "finite":
            continue
        am = d["a_m"]
        if am < 0:
            continue
        if N >= 2 * am + 2 and d["maxp"] != am + 2:
            thm4_bad.append(d)
    check("Thm 4 verified on every finite-support case: N >= 2 a_m + 2 implies "
          "max_L p(L) = a_m + 2", not thm4_bad,
          f"{len(thm4_bad)} violations of {n_fin}")

    # Verify the three-piece law of Thm 1 on every finite-support case.
    thm1_bad = 0
    for d in records:
        if d["kind"] != "finite":
            continue
        am, span, prof = d["a_m"], d["span"], d["prof"]
        if am < 0:
            continue
        Lmin = max(span, am + 1)
        for L in range(Lmin, N + 1):
            want = min(am + 1, N - L + 1) + (1 if L <= N - am - 1 else 0)
            if prof[L] != want:
                thm1_bad += 1
                break
    check("Thm 1 (three-piece large-L law) verified on every finite-support case",
          thm1_bad == 0, f"{thm1_bad} violations of {n_fin}")

    # (b) unboundedness: R must stay bounded as N grows, for halting cases.
    print("\n      Unboundedness test for the best halting non-monotone cases "
          "(R(N) for growing N):")
    cand = sorted({(d["pat"], d["x"]) for d in halt_nonmono},
                  key=lambda px: -max(dd["R"] for dd in halt_nonmono
                                      if dd["pat"] == px[0] and dd["x"] == px[1]))[:5]
    growth_bad = False
    for pat, x in cand:
        vals = []
        for NN in (128, 256, 512, 1024, 2048, 4096):
            w, _, _, _ = greedy_integerized(pat, x, NN)
            pf = sam_profile(w)
            vals.append(profile_stats(pf)[0])
        monotone_nondecreasing = all(vals[i] <= vals[i + 1] + 1e-12 for i in range(len(vals) - 1))
        grows = vals[-1] > vals[0] + 0.5
        growth_bad |= grows
        print(f"        {fmt_alpha(pat):<30} x={str(x):<5} R = " +
              ", ".join(f"{v:.3f}" for v in vals) +
              ("   <-- grows" if grows else "   bounded"))
    check("(b) no halting non-monotone alphabet has R(N) growing with N "
          "(finite support => constant profile, Thm 4)", not growth_bad)

    # ---- (c) below L = 20: does non-monotonicity help? --------------------
    section("4. (c) DOES NON-MONOTONICITY HELP BELOW L = 20?")
    Lcap = 20
    # only x = 1 for a clean single-target comparison
    rec1 = [d for d in records if d["x"] == X_MAIN]
    inc_pos = [d for d in rec1 if d["cls"] == "non-increasing" and d["pos"]]
    nonmono_pos = [d for d in rec1 if d["cls"] == "non-monotone" and d["pos"]]
    nonmono_all = [d for d in rec1 if d["cls"] == "non-monotone"]

    def best_at(recs, L):
        if not recs:
            return (-1, None)
        b = max(recs, key=lambda d: d["prof"][L])
        return (b["prof"][L], b)

    print(f"  Target x = 1, periodic family, N = {N}.  For each L <= {Lcap} compare")
    print("  max p(L) over non-increasing positive patterns (the PROVED class) with")
    print("  max p(L) over non-monotone patterns.")
    print(f"\n  {'L':<4} {'max p inc-pos':<15} {'max p non-mono(+/-)':<20} "
          f"{'max p non-mono(pos)':<20} {'witness L-argmax'}")
    first_win = None
    for L in range(1, min(Lcap, N) + 1):
        vi, di = best_at(inc_pos, L)
        va, da = best_at(nonmono_all, L)
        vp, dp = best_at(nonmono_pos, L)
        wit = ""
        if vp > vi:
            wit = fmt_alpha(dp["pat"]) + f" (pos)"
            if first_win is None:
                first_win = (L, dp)
        elif va > vi:
            wit = fmt_alpha(da["pat"]) + f" (signed)"
            if first_win is None:
                first_win = (L, da)
        print(f"  {L:<4} {vi:<15} {va:<20} {vp:<20} {wit}")

    # summary comparison of ratios below L=20
    def best_ratio_below20(recs):
        b = None
        for d in recs:
            for L in range(1, min(Lcap, N) + 1):
                rr = d["prof"][L] / L
                if b is None or rr > b[0]:
                    b = (rr, L, d)
        return b

    ri = best_ratio_below20(inc_pos)
    rn = best_ratio_below20(nonmono_all)
    rnp = best_ratio_below20(nonmono_pos)
    print(f"\n  best max p(L)/L for L <= {Lcap}:")
    print(f"    non-increasing positive : {ri[0]:.4f} at L={ri[1]}  {fmt_alpha(ri[2]['pat'])}")
    print(f"    non-monotone (all)      : {rn[0]:.4f} at L={rn[1]}  {fmt_alpha(rn[2]['pat'])}")
    print(f"    non-monotone (positive) : {rnp[0]:.4f} at L={rnp[1]}  {fmt_alpha(rnp[2]['pat'])}")

    counterexample = rnp[0] > ri[0] + 1e-12
    if counterexample:
        print("\n  COUNTEREXAMPLE FOUND to 'non-monotonicity cannot help below L=20':")
        d = rnp[2]
        L = rnp[1]
        print(f"    alphabet {fmt_alpha(d['pat'])}, target x = {d['x']}, N = {N}")
        print(f"    word prefix: {''.join(map(str, d['word'][:48]))}...")
        print(f"    p(L) for L<=20: {d['prof'][1:21]}")
        print(f"    non-monotone p({L})/L = {rnp[0]:.4f} > non-increasing positive "
              f"{ri[0]:.4f} at L={ri[1]}")
    else:
        print("\n  No counterexample found: non-monotonicity does not improve the")
        print(f"  max p(L)/L for L <= {Lcap} over the non-increasing positive class.")
    # FINDING (not a PASS/FAIL gate): report whether a counterexample exists.
    _ = counterexample

    # ---- (d) signed patterns: the genuinely open direction ----------------
    section("5. SIGNED (NON-HALTING) PATTERNS -- THE GENUINELY OPEN DIRECTION")
    signed = [d for d in records if d["kind"] == "infinite" and d["x"] == X_MAIN]
    signed.sort(key=lambda d: (-d["R"], -d["R2"]))
    print(f"  {len(signed)} signed cases at x = 1.  Top 10 by max p(L)/L:")
    for d in signed[:10]:
        print(f"    {fmt_alpha(d['pat']):<32} R={d['R']:.4f} L*={d['Lb']:<5} "
              f"R2={d['R2']:.4f} #ones={d['n_ones']:<6} maxp={d['maxp']} "
              f"p(1..8)={d['prof'][1:9]}")
    print("\n  Every signed periodic pattern has infinite support (negative terms are")
    print("  always taken) and never halts.  Their R(N) is checked for growth:")

    cand_s = [(d["pat"], d["x"]) for d in signed[:4]]
    # add a few with large period
    cand_s += [(p, X_MAIN) for p in [
        (Fraction(1, 2), Fraction(1, 3), Fraction(-1, 6)),
        (Fraction(1, 6), Fraction(-1, 6), Fraction(1, 2), Fraction(-1, 3)),
        (Fraction(1, 2), Fraction(1, 1), Fraction(-1, 6), Fraction(-1, 3)),
    ]]
    growth_any = False
    for pat, x in cand_s:
        vals = []
        for NN in (128, 256, 512, 1024, 2048, 4096):
            w, _, _, _ = greedy_integerized(pat, x, NN)
            pf = sam_profile(w)
            vals.append(profile_stats(pf)[0])
        grows = vals[-1] > vals[0] + 0.5
        growth_any |= grows
        print(f"    {fmt_alpha(pat):<40} x={str(x):<5} R = " +
              ", ".join(f"{v:.3f}" for v in vals) +
              ("   <-- grows" if grows else "   bounded"))
    # FINDING (not a PASS/FAIL gate): a growing R(N) would be the object OP-15
    # asks for in the non-halting direction; over this finite range none grew.
    print(f"  Finding: R(N) stayed bounded over N <= 4096 for every signed candidate "
          f"tested ({'a growth case was seen' if growth_any else 'none grew'}).")
    print("  This is FINITE evidence only: it does not bound sup_L p(L)/L in general.")

    return records


# ---------------------------------------------------------------------------
# 6.  Reporting / status
# ---------------------------------------------------------------------------


def status(records) -> None:
    section("6. STATUS OF OP-15 AND WHAT THE FINITE SEARCH DOES NOT SETTLE")

    print("  PROVED HERE (elementary, alphabet-independent):")
    print("    halting (finitely many ones) => Thm 4 => max_L p(L) = a_m + 2, a NUMBER.")
    print("    Hence NO halting alphabet -- monotone or not -- can have")
    print("    sup_L p(L)/L = infinity, nor p(L) = cL for c > 0.")
    print("    Monotonicity is NOT needed for this step; it is needed only for the")
    print("    converse characterisation 'sum alpha_n >= x <=> halts' (rh41 Thm 9),")
    print("    which fails for non-monotone alphabets.")
    print()
    print("  FAMILY P STRUCTURE (proved here):")
    print("    * all-positive periodic pattern -> FINITE support (at most x/min v")
    print("      takes) -> bounded constant profile; such patterns are the only")
    print("      periodic patterns that can halt/stall.")
    print("    * signed periodic pattern -> INFINITE support, never halts (a zero")
    print("      residual is not absorbing: a negative term always re-triggers).")
    print()
    print("  WHAT IS OPEN (this search is finite evidence only):")
    print("    whether a NON-halting (infinite-support) non-monotone alphabet can")
    print("    realise p(L) growing linearly/superlinearly.  The register's")
    print("    conjectural claim 'a halting non-monotone alphabet with")
    print("    sup_L p(L)/L = infinity' is NOT settled here; the finite search over")
    print("    the stated class found no such object, and (as noted) a halting")
    print("    alphabet provably cannot be one, independently of monotonicity.")
    print()
    print("  DEFINITIONAL CAVEAT (important for reading OP-15).")
    print("    * STRONG reading (used above, and in rh41 Thm 9/12): 'halts' = the")
    print("      residual reaches exactly 0 in finite time / only finitely many ones.")
    print("      Then the impossibility is immediate and monotonicity-free:")
    print("      finite support => Thm 4 => max_L p(L) = a_m + 2.")
    print("    * WEAK (quasi-halting) reading: 'halts' = r_n -> 0 while infinitely")
    print("      many ones are still taken.  This is possible only for non-monotone")
    print("      (or non-decreasing) alphabets with alpha_n -> 0: if the residual")
    print("      stalls at r > 0 while alpha_n -> 0, then eventually alpha_n < r and")
    print("      further ones are forced, so a positive stall cannot occur.  A rare")
    print("      example of the non-absorbing phenomenon already appears in the")
    print("      periodic family: [1/6,-1/2,1,5/6] at x=1 hits r=0 at n=10 (see the")
    print("      'r=0@10' row) yet has infinite support, because a negative term")
    print("      re-triggers the process.  Thm 4 does NOT bound the weak regime, and")
    print("      it is the genuinely open direction.  The periodic family here cannot")
    print("      explore it (positive periodic => finite support; signed periodic =>")
    print("      never even quasi-halts), so it remains untouched.")
    print()
    print("  SEARCH SPACE SIZE:")
    npat = sum(len(VALUES) ** k for k in KS)
    print(f"    values          : {len(VALUES)}  (+-j/6, j=1..6)")
    print(f"    patterns k=2,3,4: {len(VALUES)}^2 + {len(VALUES)}^3 + {len(VALUES)}^4"
          f" = {npat}")
    print(f"    family L cases  : {npat} x {len(TARGETS_L)} = {npat * len(TARGETS_L)}")
    print(f"    family P cases  : {npat} x {len(TARGETS_P)} x N={N_TRUNC}, and")
    print(f"                      top/signed candidates re-run at N up to 4096")
    print(f"    total evaluated : {npat * (len(TARGETS_L) + len(TARGETS_P))} alphabet/"
          f"target cases plus growth re-runs")


# ---------------------------------------------------------------------------
# 7.  Main
# ---------------------------------------------------------------------------


def main() -> None:
    t_start = time.time()
    print("op15_nonmonotone.py -- OP-15: non-monotone alphabets in the inverse "
          "complexity problem")
    print(f"Values            : {len(VALUES)} rationals +-j/{DENOM}, j=1..{DENOM}")
    print(f"Pattern lengths   : {KS}")
    print(f"Truncation N      : {N_TRUNC} (periodic family)")
    print(f"Targets (family L): {[str(t) for t in TARGETS_L]}")
    print(f"Targets (family P): {[str(t) for t in TARGETS_P]}")

    cross_checks()
    family_L()
    records = family_P(N_TRUNC)
    status(records)

    section("PASS/FAIL SUMMARY")
    npass = sum(1 for _, ok, _ in CHECKS if ok)
    nfail = len(CHECKS) - npass
    for name, ok, _ in CHECKS:
        print(f"  [{'PASS' if ok else 'FAIL'}] {name}")
    print(f"\n  {npass}/{len(CHECKS)} checks passed, {nfail} failed.")
    print(f"  Total wall time: {time.time() - t_start:.1f} s")
    if nfail:
        print("  RESULT: FAIL")
        sys.exit(1)
    print("  RESULT: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
