# G5 — p(L) = N − L + 1 on exactly L ∈ [792, 1399] for 1/π

**Kind:** Claim
**Status:** VERIFIED (numerical; `verify_agentB.py` B-b)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.1 "x = 1/π — support `(2, 13, 607)`, `N = 1400`", register row G5

## Statement

> `p(L) = N − L + 1` on exactly `L ∈ [792, 1399]`; `p(1398) = 3`, `p(1399) = 2`

## Hypotheses and notation

- Word: 1/π, support `(2, 13, 607)`, `N = 1400`; hence `N − a_m − 1 = 792`.
- The equality is the decay law of register row E5.

## Proof / evidence

Register row G5's evidence cell reads: "`verify_agentB.py` B-b".

## Dependencies and related results

- Register rows D1, E5, G2, G4.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) row B7 (the same range).

## Notes

- The values `p(1398) = 3`, `p(1399) = 2` are the bottom of the decay, matching `p(N−1) = 2` of register row D1.
