# J5 (refuted) — B's triple (index of first 1, its offset, number of further 1s) classifies factors

**Kind:** Claim
**Status:** REFUTED (`{19,50,83}`, `L = 1`: triple gives 4, truth 2)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J5

## Statement

> B's triple `(index of first 1, its offset, number of further 1s)` classifies factors

## Hypotheses and notation

- The triple is read off a window: the index of the first 1 inside it, that 1's offset within the window, and the number of further 1s in the window.
- "Classifies" means it is injective on factors.

## Proof / evidence

Register row J5's verdict cell reads: "`REFUTED`"; its witness cell reads: "`{19,50,83}`, `L = 1`: triple gives 4, truth 2". The section preamble: "Each was refuted by exact enumeration."

## Dependencies and related results

- Register row B1 (the offset-tuple encoding, which *is* the working one) — not harvested, the source labels it a definition; rows B2, B3, C9.
- The ledger records the related encoding refutation (row 25 of `ledger.md`: the `(i, x, jmax)` and `(i, x)` encodings are not injective).

## Notes

- Do not re-propose this classification.
