# B8 — plateau value not a function of (m, span, N)

**Kind:** Claim
**Status:** VERIFIED (numerical, confirmed; witness `(0,)→2` vs `(11,)→10` at m=1, span=0, N=20)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.1 "From Agent B", verdict-table row B8

## Statement

> plateau value not a function of `(m, span, N)`

## Hypotheses and notation

- `m` is the index of the last support position, `span = a_m − a_0`, `N` the truncation length.
- The plateau value is `max_L p(L) = a_m + 2` (row B5).

## Proof / evidence

The verdict-table row's mediator check reads: "confirmed; witness `(0,)→2` vs `(11,)→10` at m=1, span=0, N=20".

## Dependencies and related results

- Register row E3 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), harvested as [tpp-rh40-rounds-truths-e3-plateau-not-function-of-m-span-n.md](tpp-rh40-rounds-truths-e3-plateau-not-function-of-m-span-n.md).
- Row M7 of the same table (the exhaustive N=20 dataset that decided this row).

## Notes

- **Restatement.** This row restates register entry E3 of `truths.md` (round 1 of the rh40 dialogue).
