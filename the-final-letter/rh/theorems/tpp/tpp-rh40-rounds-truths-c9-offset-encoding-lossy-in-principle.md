# C9 — the offset-tuple encoding is lossy in principle but never diverges on any case tested

**Kind:** Claim
**Status:** VERIFIED (numerical; via register row B3)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C9

## Statement

> The offset-tuple encoding is *lossy* in principle for long `L` (many windows share a sparse offset set) but never actually diverges from the bit-string count on any case tested

## Hypotheses and notation

- The offset-tuple encoding of register row B2: a window's factor is recorded as the set `{a − t : a ∈ ones, t ≤ a ≤ t+L−1}`.
- "Long `L`" means `L` large enough that the offset sets are sparse.

## Proof / evidence

Register row C9's evidence cell reads: "B3" — i.e. all `L ∈ [792, 1399]` at `N = 1400`, 608 cases, 0 divergences.

## Dependencies and related results

- Register row B2 (the equivalence at length 12) and B3 (the equivalence in the decay regime).
- Register row B1 (the definition of record) — not harvested, the source labels it a definition.

## Notes

- The row records an *in-principle* risk that is not realised in any tested case; the source does not claim it can never be realised.
