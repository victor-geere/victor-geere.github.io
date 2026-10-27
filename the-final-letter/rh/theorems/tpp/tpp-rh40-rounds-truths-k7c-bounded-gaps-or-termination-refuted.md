# K7c (refuted) — "bounded gaps OR exact termination, never both"

**Kind:** Claim
**Status:** REFUTED (`α_n = 2^{−(n+1)}`, `x = 1`, verified in exact `Fraction`s: taken `{0,1,2,…}` with max gap 1, residual `2^{−(n+1)} → 0` exactly)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K7c

## Statement

> **"bounded gaps OR exact termination, never both"**

## Hypotheses and notation

- "Bounded gaps" means the selected support has bounded consecutive gaps; "exact termination" means the residual reaches exactly `0`.
- The witness alphabet is `α_n = 2^{−(n+1)}` at `x = 1`.

## Proof / evidence

Register row K7c's state cell reads: "**`REFUTED`** — `α_n = 2^{−(n+1)}`, `x = 1`, verified in exact `Fraction`s: taken `{0,1,2,…}` with max gap 1, residual `2^{−(n+1)} → 0` exactly"; its evidence cell reads: "§5.4" (`K_remaining.md`).

## Dependencies and related results

- [The exponential alphabet gives bounded gaps and termination (the dichotomy is false)](tpp-rh40-k-remaining-exponential-alphabet-dichotomy.md).
- Register rows K7d, K7e, K7f.

## Notes

- Do not re-propose this dichotomy; the exponential alphabet satisfies both halves at once.
