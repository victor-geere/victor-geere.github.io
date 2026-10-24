# M2 — slope sequence 1→2→1→0→−1, no slope-3 range

**Kind:** Claim
**Status:** VERIFIED (numerical; `slopes()` and B's hand computation agree)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.3 "From the mediator (own earlier claims, per HANDOFF.md §8.4)", verdict-table row M2

## Statement

> slope sequence `1→2→1→0→−1`, no slope-3 range

## Hypotheses and notation

- The slope is `p(L+1) − p(L)`; the sequence is measured on 1/π, support `(2, 13, 607)`, `N = 1400`.
- "No slope-3 range" means no interval on which the slope equals `3`.

## Proof / evidence

The verdict-table row's verdict reads: "**STANDING**"; its mediator check reads: "`slopes()` and B's hand computation agree". The run table is register row G2 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md): `(1,10,1)`, `(11,13,2)`, `(14,604,1)`, `(605,791,0)`, `(792,1399,−1)`.

## Dependencies and related results

- Register rows G2, D3, D5, E7 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), the last harvested as [tpp-rh40-rounds-truths-g2-one-over-pi-slope-runs.md](tpp-rh40-rounds-truths-g2-one-over-pi-slope-runs.md).
- Row A3 of the same table (the `1→2` switch at `L = 13`).

## Notes

- **Restatement.** This row restates the measured slope runs of register entry G2 of `truths.md` (round 1 of the rh40 dialogue).
