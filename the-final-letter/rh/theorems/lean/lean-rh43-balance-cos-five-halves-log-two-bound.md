# The bound `cos ((5/2) log 2) < -0.16`

**Kind:** Theorem
**Status:** PROVED (Lean, from Mathlib's explicit rational bounds on `log 2` and `π` and Taylor inequalities; no numerical axiom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §4 "The numerical bounds at `t = 5/2`", lines 252–275

## Statement

> `cos ((5/2) log 2) < -0.16`: the argument `(5/2) log 2 ≈ 1.73287` lies beyond `π/2 + 0.162`, where the cosine is at most `-sin 0.162 ≤ -0.162 + 0.162³/6`.

```lean
theorem cos_two_mul_log_two_lt : Real.cos ((5 / 2 : ℝ) * Real.log 2) < -0.16
```

## Hypotheses and notation

- `Real.log` is the natural logarithm and `5 / 2 : ℝ`.
- The proof uses Mathlib's explicit decimal bounds `Real.pi_lt_d20`, `Real.pi_gt_d20` (π to 20 decimals), `Real.log_two_gt_d9`, `Real.log_two_lt_d9` (`log 2` to 9 decimals), the Taylor bound `Real.sin_ge_sub_cube`, and the monotonicity lemma `Real.cos_lt_cos_of_nonneg_of_le_pi`.
- The interval used is `[0, π]`, on which `cos` is decreasing.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `cos_two_mul_log_two_lt` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 254–275). The chain is `π/2 + 0.162 < (5/2) log 2 ≤ π` (from `Real.pi_lt_d20` and `Real.log_two_gt_d9`/`Real.log_two_lt_d9`), hence `cos ((5/2) log 2) < cos (π/2 + 0.162) = -sin 0.162 ≤ -0.162 + 0.162³/6 < -0.16`. No numerical axiom is used.

## Dependencies and related results

- [The bound `cos ((5/2) log 3) < -0.92`](lean-rh43-balance-cos-five-halves-log-three-bound.md) — the companion estimate at the same point.
- [The key sign: `realPartial 3 (5/2) < 0`](lean-rh43-balance-real-partial-three-at-five-halves-negative.md) — the result these bounds feed.
- Harvested counterpart from the round's README: [The two trigonometric bounds at `t = 5/2`](../tpp/tpp-rh43-lean-readme-cos-bounds-at-five-halves.md) (which folds this bound and the `log 3` bound into one entry).

## Notes

- The constants are quoted exactly as in the source: the bound is strict (`< -0.16`, not `≤`), and the auxiliary arguments `0.162` and the decimal bounds are the source's own.
