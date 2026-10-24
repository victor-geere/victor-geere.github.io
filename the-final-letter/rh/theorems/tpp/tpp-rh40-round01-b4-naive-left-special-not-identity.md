# B4 — the naive RS(L) − LS(L+1) is not the identity

**Kind:** Claim
**Status:** VERIFIED (numerical, mediator-reproduced; false only in the decay regime)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.1 "From Agent B", verdict-table row B4

## Statement

> the naive `RS(L) − LS(L+1)` is not the identity

## Hypotheses and notation

- `RS(L)` is the right-special count, `LS(L+1)` the left-special count of length `L + 1`.
- "The identity" is `p(L+1) − p(L)`; the correct correction is `Z(L)` (row B1).

## Proof / evidence

The verdict-table row's verdict reads: "**STANDING (but for a subtler reason than B gave)**"; its mediator check reads: "it is false *only in the decay regime*; the mediator's first script miscounted it as holding everywhere, see §4 error 3". §3.1 supplies the table: the naive `RS − LS(L+1)` "fails in decay" on all five words.

## Dependencies and related results

- Register row J8 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) (the same repair refuted) and register row C7 (`LS ≡ 0`).
- Rows B1 and B13 of the same table; ledger error row 3 (the mediator's claim M5).

## Notes

- The verdict is qualified in the source's own words: "but for a subtler reason than B gave". The count B13 supported this row with is separately recorded as not reproducible.
