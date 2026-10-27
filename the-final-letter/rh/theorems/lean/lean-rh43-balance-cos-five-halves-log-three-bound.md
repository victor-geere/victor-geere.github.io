# The bound `cos ((5/2) log 3) < -0.92`

**Kind:** Theorem
**Status:** PROVED (Lean, from Mathlib's explicit rational bounds on `log 3` and `π` and Taylor inequalities; no numerical axiom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §4 "The numerical bounds at `t = 5/2`", lines 277–300

## Statement

> `cos ((5/2) log 3) < -0.92`: the argument `(5/2) log 3 ≈ 2.74653` lies below `π`, at distance less than `0.39506194` from it, and `cos` is decreasing on `[0, π]` with `cos 0.39506194 ≥ 1 - 0.39506194²/2`.

```lean
theorem cos_two_mul_log_three_lt : Real.cos ((5 / 2 : ℝ) * Real.log 3) < -0.92
```

## Hypotheses and notation

- `Real.log` is the natural logarithm and `5 / 2 : ℝ`.
- The proof uses Mathlib's explicit decimal bounds `Real.pi_lt_d20`, `Real.pi_gt_d20`, `Real.log_three_gt_d9`, `Real.log_three_lt_d9` (`log 3` to 9 decimals), the Taylor bound `Real.one_sub_sq_div_two_le_cos`, the identity `Real.cos_pi_sub`, and `Real.cos_lt_cos_of_nonneg_of_le_pi`.
- The auxiliary quantity is the distance `π - (5/2) log 3`, bounded by `0.39506194`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `cos_two_mul_log_three_lt` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 280–300). The chain bounds `0 ≤ π - (5/2) log 3 < 0.39506194 ≤ π`, so `cos 0.39506194 < cos (π - (5/2) log 3) = -cos ((5/2) log 3)`, and `cos 0.39506194 ≥ 1 - 0.39506194²/2 > 0.92` gives the claim. No numerical axiom is used.

## Dependencies and related results

- [The bound `cos ((5/2) log 2) < -0.16`](lean-rh43-balance-cos-five-halves-log-two-bound.md) — the companion estimate at the same point.
- [The key sign: `realPartial 3 (5/2) < 0`](lean-rh43-balance-real-partial-three-at-five-halves-negative.md) — the result these bounds feed.
- Harvested counterpart from the round's README: [The two trigonometric bounds at `t = 5/2`](../tpp/tpp-rh43-lean-readme-cos-bounds-at-five-halves.md) (which folds this bound and the `log 2` bound into one entry).

## Notes

- The constants are quoted exactly as in the source: the bound is strict (`< -0.92`), and `0.39506194` is the source's own rational distance bound.
