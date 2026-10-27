# The `N = 3` truncation never vanishes

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §7, lines 476–584

## Statement

> **`N = 3` never vanishes.** For every real `t`, `zetaPartial 3 t ≠ 0`.

```lean
theorem zetaPartial_three_ne_zero (t : ℝ) : zetaPartial 3 t ≠ 0
```

The source's own proof summary of the statement:

> Suppose `1 + x + y = 0` with `x = exp(-i t log 2)`, `y = exp(-i t log 3)`. Comparing real parts gives `1 + cos (t log 2) + cos (t log 3) = 0` and comparing imaginary parts gives `sin (t log 2) = -sin (t log 3)`, hence `cos (t log 2)² = cos (t log 3)²`; the real-part equation then forces `cos (t log 2) = cos (t log 3) = -1/2`. By `Real.cos_three_mul` this gives `cos (3 t log 2) = cos (3 t log 3) = 1`, so `Real.cos_eq_one_iff` produces integers `n, m` with `3 t log 2 = 2πn`, `3 t log 3 = 2πm`. If `t = 0` the real-part equation reads `3 = 0`, so `t ≠ 0` and then `m log 2 = n log 3` with `n, m ≠ 0`; taking absolute values gives `3^|n| = 2^|m|` (using `Real.log_pow` and the injectivity of `Real.log` on the positive reals), which is impossible because `3 ∣ 2^|m|` would force `3 ∣ 2`.

## Hypotheses and notation

- `t : ℝ` arbitrary; `zetaPartial 3 t = 1 + 2^{-it} + 3^{-it} = 1 + exp(-i t log 2) + exp(-i t log 3)` (the expansion `zetaPartial_three`, line 470).
- The proof uses `Real.cos_three_mul`, `Real.cos_eq_one_iff`, `Real.log_pow`, `Real.exp_log`, and the auxiliary integer fact `abs_intCast_eq_natAbs`.
- Nothing is claimed for `N ≥ 4`; the source says that case is open here.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `zetaPartial_three_ne_zero` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 489–584), following exactly the reduction quoted above, ending with the divisibility contradiction `3 ∣ 2`.
- The auxiliary expansion `zetaPartial_three` and the integer-cast normalisation `abs_intCast_eq_natAbs` are proof plumbing and are not harvested separately.

## Dependencies and related results

- [The complex partial sum vanishes at `N = 2`, `t = π / log 2`](lean-rh43-balance-zeta-partial-two-vanishes-at-pi-log-two.md) — the contrast showing no blanket non-vanishing holds.
- [The blanket non-vanishing claim is false](lean-rh43-balance-blanket-nonvanishing-claim-refuted.md).
- Harvested counterpart from the round's README: [`zetaPartial_three_ne_zero` — S_3(t) ≠ 0 for every real t](../tpp/tpp-rh43-lean-readme-zetapartial-three-ne-zero.md).

## Notes

- The source flags the case `N ≥ 4` as open; this theorem covers `N = 3` only. The README-derived harvest of the same development additionally records an axiom audit `[propext, Classical.choice, Quot.sound]`; the present source file itself states only that no numerical axiom is used in the `t = 5/2` bounds.
