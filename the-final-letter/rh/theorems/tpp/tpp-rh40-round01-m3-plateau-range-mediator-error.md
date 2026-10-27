# M3 (mediator error) — plateau is L ∈ [605, 791]; decay begins at N − a_m

**Kind:** Claim
**Status:** REFUTED (truth: plateau `[605, 792]`; the decay law holds from `L = N − a_m − 1 = 792`; caught by Agent B)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.3 "From the mediator (own earlier claims, per HANDOFF.md §8.4)", verdict-table row M3

## Statement

> plateau is `L ∈ [605, 791]`; decay begins at `N − a_m`

## Hypotheses and notation

- Word: 1/π, support `(2, 13, 607)`, `N = 1400`, so `N − a_m = 793` and `N − a_m − 1 = 792`.
- The plateau is the range on which `p(L) = a_m + 2 = 609`.

## Proof / evidence

The verdict-table row's verdict reads: "**MEDIATOR ERROR**"; its "What refuted it" column reads: "truth: plateau `[605, 792]`; decay law holds from `L = N − a_m − 1 = 792`. B caught this". The correct values are in register rows G4 and G5 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), and in rows B6 and B7 of the same table.

## Dependencies and related results

- Rows B6, B7, A4 of the same table; ledger error rows 4, 5 and 14.
- §4 of the same file gives the round's own error ledger (entries 1 and 2 are this claim and its repetition in the agent-facing brief).

## Notes

- The source's own vocabulary word is `MEDIATOR ERROR`; the row is a refuted claim with two off-by-one corrections bundled in it.
