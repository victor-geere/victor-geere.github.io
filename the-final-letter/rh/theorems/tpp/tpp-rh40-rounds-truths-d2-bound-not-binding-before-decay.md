# D2 — the D1 bound is never binding until L ≥ N − a_m − 1

**Kind:** Claim
**Status:** VERIFIED (numerical; from E5 and E6)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D2

## Statement

> The bound D1 is **never binding** until `L ≥ N − a_m − 1`, where it becomes an equality (E5)

## Hypotheses and notation

- D1's bound is `p(L) ≤ N − L + 1`; `a_m` is the last support position, `N` the truncation length.
- "Binding" means `p(L) = N − L + 1`.

## Proof / evidence

Register row D2's evidence cell reads: "E5, E6" — the decay law and the plateau end recorded in the same file.

## Dependencies and related results

- Register row D1 (the bound), D3 (the ceiling regime), D5 (the crossover), E5 (the decay law), E6 (the plateau end).

## Notes

- The row is a corollary of E5/E6 rather than an independent computation.
