# B3 — #{L : Z(L) = 1} = a_m + 1, i.e. Z = 1 on exactly L ∈ [N−a_m−1, N−1]

**Kind:** Claim
**Status:** VERIFIED (numerical; holds on every word tested)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.1 "From Agent B", verdict-table row B3

## Statement

> `#{L : Z(L) = 1} = a_m + 1` (i.e. `Z = 1` on exactly `L ∈ [N−a_m−1, N−1]`)

## Hypotheses and notation

- `Z(L) = |F(L)| − #prefixes(F(L+1))`; `N` = truncation length, `a_m` = last support position.
- The interval `[N − a_m − 1, N − 1]` has `a_m + 1` elements.

## Proof / evidence

The verdict-table row's mediator check reads: "holds on every word tested; the mediator's first count (`= a_m`) was itself off by one".

## Dependencies and related results

- The same statement as register row C6 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), harvested as [tpp-rh40-rounds-truths-c6-z-l-one-exact-range.md](tpp-rh40-rounds-truths-c6-z-l-one-exact-range.md).
- Rows B1, B2, B6, B7 of the same table; ledger attributed-results row 6; ledger error rows 6 and 7.

## Notes

- **Restatement.** This row restates register entry C6 of `truths.md` (round 1 of the rh40 dialogue). The mediator's own `= a_m` count is logged as an error in §4 of the same file.
