# B13 — "the naive RS(L) − LS(L+1) holds 0/18895 cases"

**Kind:** Claim
**Status:** OPEN (UNSUBSTANTIATED / imprecise — B's count is not reproducible; the substance of B4 survives, the count does not)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.1 "From Agent B", verdict-table row B13

## Statement

> "naive `RS(L) − LS(L+1)` holds 0/18895 cases"

## Hypotheses and notation

- `RS(L)` right-special count, `LS(L+1)` left-special count of length `L + 1`; `Z(L)` the terminal-uniqueness indicator of row B1.
- The claim is a *count* of cases over some corpus of 18 895.

## Proof / evidence

The verdict-table row's verdict reads: "**UNSUBSTANTIATED / imprecise**"; its mediator check reads: "the mediator finds it holds on the **pre-decay** range and fails only in decay. B's count is not reproducible; the substance of B4 survives, the count does not. Recorded in the ledger against B".

## Dependencies and related results

- Row B4 of the same table (the claim whose count this is), and register rows C7 and J8 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md).
- The ledger records the same count as an Agent B error (row 13 of `ledger.md`).

## Notes

- Harvested with the source's own verdict: the formula's failure is confined to the decay regime, so the "0/18895" denominator is wrong; the substantive point of B4 stands.
