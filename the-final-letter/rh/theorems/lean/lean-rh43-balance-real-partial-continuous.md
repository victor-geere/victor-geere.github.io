# Continuity of the real partial sum

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §1, lines 93–101

## Statement

> `realPartial N ·` is continuous, being a finite sum of continuous functions.

```lean
theorem realPartial_continuous (N : ℕ) : Continuous (fun t : ℝ => realPartial N t)
```

with the summand-level input

> Each summand `cos (t log n)` is continuous in `t`.

```lean
theorem continuous_cos_mul_log (n : ℕ) :
    Continuous (fun t : ℝ => Real.cos (t * Real.log n))
```

## Hypotheses and notation

- `N : ℕ`, `n : ℕ`; `realPartial N t = ∑_{k<N} cos (t log (k+1))` is a finite sum.
- Both statements are about continuity on `ℝ` in the variable `t`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declarations `continuous_cos_mul_log` (lines 94–96) and `realPartial_continuous` (lines 99–101) in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean). The first composes `Real.continuous_cos` with `t ↦ t * log n`; the second unfolds `realPartial` and closes with `fun_prop`.
- These are the continuity inputs for the intermediate value theorem in [the IVT zero step](lean-rh43-balance-zero-of-real-partial-three-in-interval.md).

## Dependencies and related results

- [A zero of `realPartial 3` in `[0, 5/2]`](lean-rh43-balance-zero-of-real-partial-three-in-interval.md) — where `(realPartial_continuous 3).continuousOn` is used.
- Harvested counterpart from the round's README: [`realPartial_continuous` — continuity of the real partial sum](../tpp/tpp-rh43-lean-readme-realpartial-continuous.md).

## Notes

- The two declarations are folded into one file: `continuous_cos_mul_log` is the summand-level statement that `realPartial_continuous` sums over a finite range.
