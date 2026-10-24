# A8 — deficit form D(L) = max_j (L − d_j − 1 − S_{1,j−2})_+ explains the 2→1

**Kind:** Claim
**Status:** **REFUTED / ill-posed (2026-10-11 attack; OP-35).** `S_{1,k}` is undefined corpus-wide; under the natural reading `S_{1,k} = Σ_{i≤k} d_i`, `D(L) = (L−12)_+` switches on at `L = 13` while the measured `2→1` slope drop is at `L = 14` (`p(13)=16, p(14)=18, p(15)=19`); no partial-sum convention repairs it, and the natural `D` is unbounded whereas a cancelled-pair deficit must be bounded. See `research/attacks/OP-34-36-37-35.md`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.2 "From Agent A", verdict-table row A8

## Statement

> deficit form `D(L) = max_j (L − d_j − 1 − S_{1,j−2})_+` explains the 2→1

## Hypotheses and notation

- `D(L)` is the claimed deficit; `d_j` are the consecutive gaps; `S_{1,j−2}` is the partial sum of the first `j − 2` entries as used by the source; `(·)_+` is the positive part.
- "The 2→1" is the slope decrease from `2` to `1` at `L = 14` for 1/π (register row G2 of `truths.md`).

## Proof / evidence

The verdict-table row's verdict reads: "**UNSUBSTANTIATED**"; its mediator check reads: "plausible and testable; not tested this round. **Round 2's sharpest target for A**".

## Dependencies and related results

- Register rows G2 and F3 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md); row A7 of the same table.
- The round-2 agenda in §5 of the same file ("test the deficit form … The mediator will recompute").

## Notes

- Harvested because it is a labelled claim in the verdict table, with status honestly recorded as untested. The statement's notation `S_{1,j−2}` is copied verbatim from the source.
