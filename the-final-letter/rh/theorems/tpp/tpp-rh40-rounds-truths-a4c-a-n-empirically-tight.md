# A4c — ⌊log₂ log₂ n_k⌋ = k + O(1), i.e. A(N) = log₂ log N + O(1) empirically tight

**Kind:** Claim
**Status:** VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §A "The object", register row A4c

## Statement

> `⌊log₂ log₂ n_k⌋ = k + O(1)`, i.e. `A(N) = log₂ log N + O(1)` empirically tight

## Hypotheses and notation

- `n_k` is the index selected at greedy step `k`; `A(N) = #{n ≤ N : δ_n = 1}`.
- "Empirically tight" is the source's own hedge: the `O(1)` is measured, not proved.

## Proof / evidence

Register row A4c's evidence cell reads: "six targets, first 10 indices". The source states this without proof.

## Dependencies and related results

- Register row A4 (the proved lower bound) and row A4b (the upper bound, `OPEN`); A4c is the measurement that makes them look tight.
- Register row I5/I6 on how fast the residual orbit runs out of digits.

## Notes

- The `O(1)` term is not proved; the source calls the asymptotic "empirically tight", and the row's status is `VERIFIED` (a finite measurement), not `PROVED`.
