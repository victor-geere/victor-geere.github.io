# C6 — Z(L) = 1 iff L ∈ [N − a_m − 1, N − 1], equivalently #{L : Z(L)=1} = a_m + 1

**Kind:** Claim
**Status:** VERIFIED (numerical; exact profile on 1/π, exact count on `(10,20,40,80)`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C6

## Statement

> `Z(L) = 1` **iff** `L ∈ [N − a_m − 1, N − 1]`; equivalently `#{L : Z(L)=1} = a_m + 1`

## Hypotheses and notation

- `Z(L) = |F(L)| − #{prefixes of F(L+1)}` (register row C3).
- `N` the truncation length, `a_m` the last support position of `w`.

## Proof / evidence

Register row C6's evidence cell reads: "`verify_agentB.py` B-a/B-b: exact profile on 1/π (792…1399) and exact count on `(10,20,40,80)` (81 = 80+1)".

## Dependencies and related results

- Register row C3 (`Z`'s definition), C5 (`Z ∈ {0,1}`), C4 (the identity that uses `Z`).
- Register row D4 (the terminal-window lemma: `Z(L) = 1` iff the terminal window realises a unique factor).
- Register row E5 (the decay law on exactly `L ∈ [N − a_m − 1, N − 1]`), which is the same interval.

## Notes

- The source records that the mediator's first count, `#{L : Z(L)=1} = a_m`, was off by one; the range `[N − a_m − 1, N − 1]` has `a_m + 1` elements (ledger rows 6 and 7 of `ledger.md`).
