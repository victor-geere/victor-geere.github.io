# M5 (mediator error) — the finite-word fix is RS(L) − LS(L+1)

**Kind:** Claim
**Status:** REFUTED (fails in the decay regime; the correct correction is `Z(L)`, which is not a left-special count)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.3 "From the mediator (own earlier claims, per HANDOFF.md §8.4)", verdict-table row M5

## Statement

> finite-word fix is `RS(L) − LS(L+1)`

## Hypotheses and notation

- `RS(L)` right-special count, `LS(L+1)` left-special count of length `L + 1`; `Z(L) = |F(L)| − #prefixes(F(L+1))`.
- The fix is for the first-difference identity `p(L+1) − p(L)`.

## Proof / evidence

The verdict-table row's verdict reads: "**MEDIATOR ERROR (DISPROVEN)**"; its "What refuted it" column reads: "fails in the decay regime; the correct correction is `Z(L)`, which is *not* a left-special count. B's repair".

## Dependencies and related results

- Rows B1, B4, B13, M5h of the same table; register rows C3, C4, C7, J8 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md).
- Ledger error row 3, and §4 entry 3 of the same file.

## Notes

- The header of §2.3 states these rows are the mediator's "own earlier claims, per HANDOFF.md §8.4", i.e. self-logged errors.
