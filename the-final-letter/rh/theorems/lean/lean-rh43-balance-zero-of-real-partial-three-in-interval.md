# A zero of `realPartial 3` in `[0, 5/2]`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; intermediate value theorem)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §5, lines 336–352

## Statement

> A zero of `realPartial 3` in `[0, 5/2]`, by the intermediate value theorem.

```lean
theorem exists_zero_realPartial_three :
    ∃ t ∈ Set.Icc (0 : ℝ) (5 / 2), realPartial 3 t = 0
```

The source also gives the plain existence form

```lean
theorem exists_realPartial_three_eq_zero : ∃ t : ℝ, realPartial 3 t = 0
```

which is the immediate corollary dropping the interval membership.

## Hypotheses and notation

- `realPartial 3 t = 1 + cos (t log 2) + cos (t log 3)`; the interval is `Set.Icc (0 : ℝ) (5/2)`.
- The two endpoint signs are `realPartial 3 0 = 3 > 0` and `realPartial 3 (5/2) < 0`.
- Continuity of `t ↦ realPartial 3 t` on the interval is the input to `intermediate_value_Icc'`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `exists_zero_realPartial_three` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 337–347), from `(realPartial_continuous 3).continuousOn` and the sign change supplied by `realPartial_three_at_zero` and [the key sign `realPartial 3 (5/2) < 0`](lean-rh43-balance-real-partial-three-at-five-halves-negative.md), via Mathlib's `intermediate_value_Icc'`.
- The corollary `exists_realPartial_three_eq_zero` (lines 350–352) simply discards the interval witness. It is not harvested separately.

## Dependencies and related results

- [The key sign: `realPartial 3 (5/2) < 0`](lean-rh43-balance-real-partial-three-at-five-halves-negative.md).
- [Continuity of the real partial sum](lean-rh43-balance-real-partial-continuous.md) — the continuity input.
- [Main theorem: a balanced partial sum exists](lean-rh43-balance-balanced-partial-sum-exists.md) — the theorem this existence feeds.

## Notes

- The existence is non-constructive: the source does not exhibit the zero, it obtains it from the intermediate value theorem. This is the step that makes the witness for the main theorem existentially quantified in `t`.
