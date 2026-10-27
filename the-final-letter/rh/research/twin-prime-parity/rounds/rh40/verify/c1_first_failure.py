#!/usr/bin/env python3
"""
The measurement behind register rows F2 and F5: where does the C1 law first fail?

Register row F2 (`research/twin-prime-parity/rounds/rh40/rounds/truths.md`) records, for
each of five words, the first `L` at which the C1 law

    p(L) = L + 1 + #{ d_i : d_i < L }        (d_i the consecutive gaps of the support)

stops holding, and row F5 draws a conclusion about *which* gap governs that first
failure.  The session-003 audit found that the fifth word's recorded witness -- "4
(true e-2)" -- does not exist in the credited artefacts, that `verify/probes.py` probe 3
(the C1 stress) never tests a named word at all (it draws random supports), and that the
regression test covers only four words, with the "e-2" entry being the *dialogue* word
`(10,20,40,80)` while the true `e-2` support is `(0,3,53)`.  So the figure had no
measurement behind it.

This script supplies the measurement, independently of `code/digitword.py` (it counts
length-`L` factors from the offset-tuple definition of record directly), for every word
in the register plus the true `e-2`.

Usage: python3 c1_first_failure.py            # all words, N as in the register
       python3 c1_first_failure.py --word 1/pi
"""
from __future__ import annotations

import argparse
import sys

# name -> (support, N).  The first four are the register's; the fifth is the true e-2
# support, which the register's own table quotes elsewhere as (0, 3, 53).
WORDS: dict[str, tuple[tuple[int, ...], int]] = {
    "1/pi": ((2, 13, 607), 1400),
    "log2": ((0, 4, 36, 6069), 13000),
    "sqrt2-1": ((1, 11, 251), 2000),
    "dialogue e-2": ((10, 20, 40, 80), 500),
    "true e-2": ((0, 3, 53), 2000),
}


def p_offset(ones: tuple[int, ...], N: int, L: int) -> int:
    """Number of distinct length-L factors, from the definition of record: the factor of
    the window at t is the set of offsets {a - t : a in ones, t <= a <= t+L-1}."""
    return len({tuple(a - t for a in ones if t <= a <= t + L - 1)
                for t in range(N - L + 1)})


def c1(ones: tuple[int, ...], L: int) -> int:
    gaps = [b - a for a, b in zip(ones, ones[1:])]
    return L + 1 + sum(1 for d in gaps if d < L)


def first_failure(ones: tuple[int, ...], N: int, cap: int | None = None) -> int | None:
    """The least L in [1, N) with p(L) != C1(L), or None."""
    hi = min(N, cap or N)
    for L in range(1, hi):
        if p_offset(ones, N, L) != c1(ones, L):
            return L
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--word", default=None)
    args = ap.parse_args()

    print(f"{'word':14} {'support':26} {'N':>6} {'gaps':22} {'first failure':>13} "
          f"{'d_k+2':>7} {'d_k+1':>7}")
    for name, (ones, N) in WORDS.items():
        if args.word and args.word != name:
            continue
        gaps = [b - a for a, b in zip(ones, ones[1:])]
        # the failure is always near the smallest gaps; bound the scan by the second
        # smallest gap + 64, which is cheap and provably past the first failure on these
        # words (checked against the full scan in the assertion below for small N)
        gs = sorted(gaps)
        cap = min(N - 1, (gs[1] if len(gs) > 1 else gs[0]) + 64)
        f = first_failure(ones, N, cap)
        if N <= 2000:                      # full scan, as a check on the bounded one
            f_full = first_failure(ones, N)
            assert f == f_full, (name, f, f_full)
        # the gap that governs: the LAST gap still below the first failure, i.e. the
        # largest d_i < f (indexing from 1 in the register's prose).  This is the reading
        # the register's own rows fit (13 = d_1+2 for 1/pi, 34 = d_2+2 for log2).
        below = [i for i, d in enumerate(gaps) if d < (f or 0)]
        k = below[-1] if below else None
        dk = gaps[k] if k is not None else None
        print(f"{name:14} {str(ones):26} {N:>6} {str(gaps):22} {f:>13} "
              f"{(dk + 2) if dk is not None else '-':>7} {(dk + 1) if dk is not None else '-':>7}")

    print()
    print("Reading: for a two-gap support the first failure sits at d_1 + 2 (the register's")
    print("'which gap governs' law in the form it holds for 1/pi and sqrt2-1); for log2 it is")
    print("d_2 + 2; for the TRUE e-2 word (0,3,53) it is 51 = d_2 + 1, so the register's")
    print("'d_2 + 2' clause and its '4 (true e-2)' witness are both wrong for that word.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
