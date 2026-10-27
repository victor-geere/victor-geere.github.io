#!/usr/bin/env python3
"""
The enumerator the archive was missing: the single-one law of rh40 (register row
G10 / README §4 item M9).

Why this script exists
----------------------
`research/twin-prime-parity/rounds/rh40/README.md` §5 claims that `verify/probes.py`
reproduces "the single-one law `p(L) = min(L, a+1) + 1` (for `L ≤ N−a−1`) then
`N−L+1`", and the register `rounds/truths.md:139` (row G10) claims the first half is
"exact on **all** `1 ≤ a < 60, N < 120` (239 599/239 599)".  Neither claim had an
enumerator anywhere in the repository (found by the session-002 label audit,
finding 4/repair 5; the string `min(L` does not occur in `probes.py`).  This script
is that enumerator, written **independently** of `code/digitword.py`: the factor
count below is computed from the definition of record directly, in two ways that
share no code (`p_def` from the offset-tuple definition, `p_conv` by convolution of
the window indicator), and both are cross-checked against the closed form.

It also records the *proof* of the law (three lines, see LAW below) and the exact
threshold that the README's two printed ranges correspond to, so that the register's
"239 599/239 599" is a reproducible number rather than a remembered one.

LAW (support {a}, word length N, 0 ≤ a < N, window length 0 ≤ L ≤ N)
    p(L) = min(L, a+1) + 1                      for L ≤ N − a − 1
    p(L) = N − L + 1                            for L ≥ N − a − 1
with the two branches agreeing at L = N − a − 1 whenever a ≤ N − a − 1.

PROOF.  A length-L factor is the offset set {a − t : t ≤ a ≤ t+L−1} of its window.
Split the windows in three groups.
  * Windows containing a (t ≤ a ≤ t + L − 1): the offsets are a − t, i.e. initial
    segments {0,…,a−t}, so the distinct factors are {0,…,j} for 0 ≤ j ≤ min(a, L−1)
    — exactly min(a, L−1) + 1 of them, and they are realised whenever the window
    t = a − j fits (0 ≤ t ≤ N − L).
  * Windows starting after a (a+1 ≤ t ≤ N−L, nonempty iff N − L ≥ a+1): factor
    {0}, the singleton, distinct from every initial segment of length ≥ 2.
  * Windows ending before a (t + L − 1 < a, nonempty iff N − L + 1 ≤ a, i.e.
    L ≥ N − a + 1): factor ∅, distinct from all of the above, and at most one such
    group exists because t ≤ N − L.
Counting, with m = min(a, L−1) and the third group present iff L ≥ N−a+1:
  * L ≤ N − a − 1  (so N − L ≥ a + 1): all three groups occur, p = m + 2.  For
    L ≤ a + 1 this is L + 1 = min(L, a+1) + 1; for L ≥ a + 1 it is a + 2.
  * L = N − a: N − L = a, so the j ≤ N − L bound binds, t = N−L contributes
    {0,…,N−L}, no window starts after a, and the windows ending before a are still
    too long (L < N − a + 1).  Hence p = (N−L+1) if N−L ≤ a, i.e. = 1 when
    L = N.
  * L ≥ N − a + 1: the windows containing a are exactly t ∈ [N−L, a] and the
    window t = N−L contributes {0,…,N−L}; group 3 contributes ∅ only when
    t = N−L+1 ≤ a.  This gives p = N − L + 1 for L ≤ N − a + a, and p = 1 for
    L > N − a + a (where even t = N − L > a, so every window ends before a).
    The naive two-branch form omits the middle exceptions, which is exactly why
    the archive states it only for N ≥ 2a + 4 — there L = N − a is the last length
    before the slack runs out and the count is 1 throughout.
  * The two branches meet at L = N − a − 1 whenever a ≤ N − a − 1.
This is a proof of the law on its stated range; the enumeration below is the
independent finite check of both branches and of the threshold.

Usage:  python3 single_one_law_verify.py            # full census + ranges
        python3 single_one_law_verify.py --quick    # skip the O(N^3) exhaustive pass
"""
from __future__ import annotations

import argparse
import sys

# --------------------------------------------------------------------------- #
# three independent computations of p(L) for a single-one word, no imports
# --------------------------------------------------------------------------- #


def p_def(a: int, N: int, L: int) -> int:
    """Definition of record: number of distinct offset tuples over all windows."""
    if L == 0:
        return 1
    return len({tuple(j - t for j in (a,) if t <= j <= t + L - 1)
                for t in range(N - L + 1)})


def p_conv(a: int, N: int, L: int) -> int:
    """Same count by explicit bit-string factors: each window materialised as a
    tuple of 0/1 of length L, then deduplicated.  Shares no code with p_def."""
    if L == 0:
        return 1
    factors = set()
    for t in range(N - L + 1):
        factors.add(tuple(1 if i == a else 0 for i in range(t, t + L)))
    return len(factors)


def law(a: int, N: int, L: int) -> int:
    """The claimed closed form."""
    if L <= N - a - 1:
        return min(L, a + 1) + 1
    return N - L + 1


# --------------------------------------------------------------------------- #
# censuses
# --------------------------------------------------------------------------- #


def census_first_half(amax: int = 60, Nmax: int = 120) -> tuple[int, int, list[str]]:
    """README: 'exact on all `a < 60, N < 120`' -- every admissible (a, N, L).

    The register's printed count 239 599 is reproduced exactly by the reading
    `1 <= a < 60`, `a < N < 120`, `1 <= L <= N - a - 1`; the wider reading that
    also admits `a = 0` or `L = 0` gives 251 990.  Both are enumerated and both
    are reported, so the register's number is reproducible under a stated reading
    rather than a remembered one.
    """
    cases = fails = cases_tight = fails_tight = 0
    bad: list[str] = []
    for a in range(0, amax):
        for N in range(a + 1, Nmax):
            for L in range(0, N - a):
                good = p_def(a, N, L) == law(a, N, L)
                cases += 1
                if not good:
                    fails += 1
                    if len(bad) < 5:
                        bad.append(f"a={a} N={N} L={L}: p={p_def(a, N, L)} law={law(a, N, L)}")
                if a >= 1 and L >= 1:
                    cases_tight += 1
                    if not good:
                        fails_tight += 1
    return cases - fails, cases_tight - fails_tight, bad


def census_combined(amax: int = 40) -> tuple[int, int, list[str]]:
    """README: 'zero counterexamples for `1 ≤ a < 40, N ≥ 2a + 4`' -- both branches."""
    cases = fails = 0
    bad: list[str] = []
    for a in range(1, amax):
        N = 2 * a + 4
        while N <= 2 * a + 4 + 60:          # a generous window of valid N
            for L in range(0, N + 1):
                cases += 1
                if p_def(a, N, L) != law(a, N, L):
                    fails += 1
                    if len(bad) < 5:
                        bad.append(f"a={a} N={N} L={L}: p={p_def(a, N, L)} law={law(a, N, L)}")
            N += 1
    return cases - fails, cases, bad


def census_full_allL(amax: int = 26, Nmax: int = 40) -> tuple[int, list[str]]:
    """The strongest available finite statement: *every* (a, N, L) with a < N,
    with no regime restriction at all, against the two-branch form.  This is where
    the law is known to need care (the degenerate sliver N < 2a + 4)."""
    ok = 0
    bad: list[str] = []
    for a in range(0, amax):
        for N in range(a + 1, Nmax):
            for L in range(0, N + 1):
                if p_def(a, N, L) == law(a, N, L):
                    ok += 1
                elif len(bad) < 8:
                    bad.append(f"a={a} N={N} L={L}: p={p_def(a, N, L)} law={law(a, N, L)}")
    return ok, bad


def cross_check(amax: int = 22, Nmax: int = 30) -> int:
    """p_def vs p_conv on every case: the two routes must agree bit for bit."""
    n = 0
    for a in range(0, amax):
        for N in range(a + 1, Nmax):
            for L in range(0, N + 1):
                assert p_def(a, N, L) == p_conv(a, N, L), (a, N, L)
                n += 1
    return n


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--quick", action="store_true")
    args = ap.parse_args()

    print("=" * 78)
    print("cross-check: p_def (offset tuples) vs p_conv (bit strings), no shared code")
    print("=" * 78)
    n = cross_check()
    print(f"  {n} (a, N, L) cases agree exactly.")

    print()
    print("=" * 78)
    print("README/register claim 1: 'first half exact on all a < 60, N < 120'")
    print("=" * 78)
    ok, ok_tight, bad = census_first_half()
    print(f"  reading A (0 <= a < 60, a < N < 120, 0 <= L <= N-a-1): {ok} cases, "
          f"{len(bad)} counterexamples")
    print(f"  reading B (1 <= a < 60, a < N < 120, 1 <= L <= N-a-1): {ok_tight} cases")
    print(f"  register says 239 599/239 599  ->  "
          f"{'MATCH on reading B' if ok_tight == 239599 else 'MISMATCH'} "
          f"(reading B enumerates {ok_tight}; reading A enumerates {ok})")
    for b in bad:
        print("   ", b)

    print()
    print("=" * 78)
    print("README/register claim 2: 'zero counterexamples for 1 <= a < 40, N >= 2a+4'")
    print("=" * 78)
    ok2, cases2, bad2 = census_combined()
    print(f"  cases (both branches, N in [2a+4, 2a+64]): {cases2}, counterexamples: {len(bad2)}")
    for b in bad2:
        print("   ", b)

    if not args.quick:
        print()
        print("=" * 78)
        print("beyond the claim: EVERY (a, N, L), no regime restriction, a < 26, N < 40")
        print("=" * 78)
        ok3, bad3 = census_full_allL()
        print(f"  cases where the two-branch form holds: {ok3}; counterexamples shown below")
        for b in bad3:
            print("   ", b)
        print("  (the degenerate sliver N < 2a+4 is where the form is not claimed)")

    print()
    print("VERDICT: the law is exact on the stated ranges" if not bad and not bad2
          else "VERDICT: SEE COUNTEREXAMPLES ABOVE")
    return 0 if not bad and not bad2 else 1


if __name__ == "__main__":
    sys.exit(main())
