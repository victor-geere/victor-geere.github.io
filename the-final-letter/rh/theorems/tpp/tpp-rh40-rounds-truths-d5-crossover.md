# D5 — crossover: (a_m + 2) − (N − L + 1) &gt; 0 iff L &gt; N − a_m − 1

**Kind:** Claim
**Status:** PROVED (paper argument; K1 Theorem A)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D5

## Statement

> **Crossover.** `(a_m + 2) − (N − L + 1) > 0` iff `L > N − a_m − 1`; this is exactly why the plateau ends and the decay begins at `N − a_m − 1`

## Hypotheses and notation

- `N` = truncation length, `a_m` = last support position, `L` the factor length.
- The two quantities compared are the plateau value `a_m + 2` (register row E1) and the window-count ceiling `N − L + 1` (register row D1).

## Proof / evidence

Register row D5's evidence cell reads: "K1 Theorem A; E1, E5, E7". The proof is `K1_plateau_theorem.md`'s Theorem A, harvested as [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).

## Dependencies and related results

- Register rows D1, D2, D3, E1, E5, E6, E7.

## Notes

- The source notes this crossover is "the lower end … the whole round is about" (round 1 adjudication).
