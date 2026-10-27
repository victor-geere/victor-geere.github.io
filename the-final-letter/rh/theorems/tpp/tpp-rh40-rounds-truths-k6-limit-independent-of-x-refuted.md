# K6 (refuted) — the limit is independent of x

**Kind:** Claim
**Status:** REFUTED (by K6f)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6

## Statement

> the limit is independent of `x`

The source strikes the row through and records its state as "**`REFUTED`** (K6f)".

## Hypotheses and notation

- "The limit" is `(1/K)Σ_{k<K} log c_k` as `K → ∞`, with `c_k` the greedy coefficient.
- `x` is the target of the greedy process.

## Proof / evidence

Register row K6's state cell reads: "**`REFUTED`** (K6f)"; the refuting construction is register row K6f (`q_0 = 4`, `q_{k+1} = 2q_k²`, limit `log(1/2) = −0.693147… ≠ −1`).

## Dependencies and related results

- Register row K6f (the proof), K6g, K6h, K6i, K6j, I4, I8.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- The row is listed in the register's "Open problems" table but is struck through and marked closed negatively; it is harvested because it states a definite (refuted) mathematical claim.
