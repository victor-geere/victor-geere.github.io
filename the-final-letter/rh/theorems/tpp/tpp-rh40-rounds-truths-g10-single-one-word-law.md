# G10 — single-one word law

**Kind:** Claim
**Status:** VERIFIED (numerical; first half exact on all 239 599 cases, combined law 0 counterexamples on its stated range)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.3 "Single-one words", register row G10

## Statement

> For one 1 at position `a` with `N ≥ 2a + 4`: `p(L) = min(L, a+1) + 1` for `L ≤ N − a − 1`, and `p(L) = N − L + 1` for `L ≥ N − a − 1`

## Hypotheses and notation

- The word has a single 1 at position `a`; `N` is the truncation length, and the hypothesis is `N ≥ 2a + 4`.
- `p(L)` is the distinct-factor count; the second branch is the decay law (register row E5) with `a_m = a`.

## Proof / evidence

Register row G10's evidence cell reads: "first half exact on **all** `1 ≤ a < 60, N < 120` (239 599/239 599); combined law has **zero** counterexamples for `1 ≤ a < 40, N ≥ 2a + 4`".

## Dependencies and related results

- Register rows C1, E5, G11.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) row B10's neighbourhood and the ledger row 16 (a test that asserted the wrong single-one base case).

## Notes

- The ledger records (row 16) that a test suite asserted `p(L) = L + 1` "up to the min gap" for a single-one word, which is false: the law above is `p(L) = min(L, a+1) + 1`.
