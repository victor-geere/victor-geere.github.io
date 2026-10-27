# A6 — three new-word predictions {0,3,17}→19, {2,9,44}→46, {1,6,31,200}→202 at L = span+1

**Kind:** Claim
**Status:** VERIFIED (numerical; all three exact)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.2 "From Agent A", verdict-table row A6

## Statement

> three new-word predictions `{0,3,17}→19`, `{2,9,44}→46`, `{1,6,31,200}→202` at `L = span+1`

## Hypotheses and notation

- Each pair is support → predicted plateau value; the prediction is made at `L = span + 1`.
- `span = a_m − a_0`.

## Proof / evidence

The verdict-table row's mediator check reads: "all three exact; and each also equals `p(N − a_m − 1)`, as A predicted".

## Dependencies and related results

- Rows A5, B5 and B6 of the same table; register rows E1, E2, E7 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md).
- The ledger's attributed-results narrative records these three predictions as Agent A's support for the `a_m + 2` observation.

## Notes

- The three values `19, 46, 202` equal `a_m + 2` for the three supports (`17 + 2`, `44 + 2`, `200 + 2`), which is why the source treats them as an independent prediction of the plateau value.
