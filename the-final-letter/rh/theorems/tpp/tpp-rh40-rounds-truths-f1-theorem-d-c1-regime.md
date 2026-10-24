# F1 — Theorem D: p(L) = L + 1 for L ≤ min(min_j d_j, a_0, N − a_0 − 1)

**Kind:** Theorem
**Status:** PROVED (paper argument; verified unconditionally on 399 486 cases, 0 counterexamples)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §F "The C1 / prefix regime", register row F1

## Statement

> **Theorem D.** `p(L) = L + 1` for `L ≤ min(min_j d_j, a_0, N − a_0 − 1)`, i.e. the C1 law in the regime where `#{j : d_j < L} = 0`

## Hypotheses and notation

- `N` = truncation length; `a_0 < … < a_m` = support positions; `d_j = a_j − a_{j−1}` the consecutive gaps.
- `min_j d_j` is the smallest gap; the added bounds `a_0` and `N − a_0 − 1` cut the prefix regime at both ends.

## Proof / evidence

Register row F1's evidence cell reads: "`probes.py` probe 3: 2 000/2 000 random trials"; the status cell reads "**`PROVED`** — verified unconditionally on 399 486 cases, 0 counterexamples". The written proof is [Theorem D — the C1 regime boundary (PROVED)](tpp-rh40-k-remaining-theorem-d-c1-regime.md).

## Dependencies and related results

- Register rows C1, F2, F3, F4, F5, J13.
- [Theorem D — the C1 regime boundary (PROVED)](tpp-rh40-k-remaining-theorem-d-c1-regime.md).

## Notes

- The ledger records a correction to this bound (row 23 of `ledger.md`): the bound must be `a_0`, not `a_0+1`; the corrected Theorem D is exact on 399 486 cases.
