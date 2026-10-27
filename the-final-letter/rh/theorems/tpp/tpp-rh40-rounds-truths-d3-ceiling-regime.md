# D3 — the ceiling regime: for L ≥ N − a_m − 1 every window meets the support and exactly one factor is lost per unit increase of L

**Kind:** Claim
**Status:** PROVED (paper argument; K1 Theorem A (Corollary))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D3

## Statement

> **Ceiling regime.** For `L ≥ N − a_m − 1` every window meets the support and exactly one factor is lost per unit increase of `L`

## Hypotheses and notation

- `N` = truncation length; `a_m` = last support position; `L` the factor length.
- "Every window meets the support" means every window start `0 ≤ t ≤ N − L` satisfies `t ≤ a_m ≤ t + L − 1`.

## Proof / evidence

Register row D3's evidence cell reads: "K1 Theorem A (Corollary); G2, E5". The proof is the corollary of K1's Theorem A, harvested as [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the formula this is a corollary of.
- Register row D5 (the crossover), E5 (the decay law), E6 (the plateau end), G2 (the measured slope runs for 1/π).

## Notes

- Status in the source is **`PROVED`**; the proof lives in `K1_plateau_theorem.md`, not in `truths.md`.
