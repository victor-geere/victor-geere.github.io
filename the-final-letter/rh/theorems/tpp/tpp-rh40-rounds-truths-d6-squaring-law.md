# D6 — squaring law: r_{k+1} = (1−f)r_k²/(1+(1−f)r_k) with f = {1/r_k}

**Kind:** Claim
**Status:** VERIFIED (numerical, to `|dev| < 1e-45` at dps 60 over 60 steps, six irrational targets)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D6

## Statement

> **Squaring law.** `r_{k+1} = (1−f)r_k²/(1+(1−f)r_k)` with `f = {1/r_k}`

## Hypotheses and notation

- `r_k` is the residual after `k` greedy steps; `{·}` is the fractional part, so `f = {1/r_k}`.
- Arithmetic is exact/multiprecision (`mpmath` at ≥ 120 dps per the register's notation paragraph).

## Proof / evidence

Register row D6's evidence cell reads: "`tests/...::test_greedy_squaring_law`" and the status cell: "`VERIFIED` to `\|dev\| < 1e-45` at dps 60 over 60 steps, six irrational targets".

## Dependencies and related results

- Register row A3 (the index law `n_{k+1} = ⌈1/r_k⌉ − 2`), A4/A4b (the bounds on `A(N)` that this law would make two-sided).
- Register rows K6a–K6e, whose exact `u`- and `s`-maps are the algebraic form of the same recursion.
- [Theorem F — the lower bound on `A(N)`](tpp-rh40-k-remaining-theorem-f-an-lower-bound.md).

## Notes

- The register's honest summary says D6 is "verified to 45 digits but not proved symbolically" — the only numerical exception among the otherwise computed entries.
