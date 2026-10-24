# G2 — slope runs for 1/π

**Kind:** Claim
**Status:** VERIFIED (numerical; `slopes()` and `probes.py` probe 6)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.1 "x = 1/π — support `(2, 13, 607)`, `N = 1400`", register row G2

## Statement

> Slope runs `(L_start, L_end, p(L+1)−p(L))` = `(1,10,1)`, `(11,13,2)`, `(14,604,1)`, `(605,791,0)`, `(792,1399,−1)`

## Hypotheses and notation

- Word: 1/π, support `(2, 13, 607)`, `N = 1400`; the slope is the first difference `p(L+1) − p(L)`.
- Each triple gives the run's start, end and constant slope.

## Proof / evidence

Register row G2's evidence cell reads: "`slopes()`; `probes.py` probe 6".

## Dependencies and related results

- Register rows D3, D5, G1, G3, G4, G5, E5, E7.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) row A3 (the `1→2` switch at `L = d_1 + 2 = 13`) and row M2 (the slope sequence `1→2→1→0→−1`, no slope-3 range).

## Notes

- The sequence `1 → 2 → 1 → 0 → −1` is the measured form of the ceiling/plateau/decay structure.
