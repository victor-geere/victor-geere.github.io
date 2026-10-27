# The key sign: `realPartial 3 (5/2) < 0`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; explicit rational bounds on `log 2`, `log 3`, `π`, no numerical axiom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §5 "The sign of `realPartial 3` at `0` and at `5/2`", lines 328–334

## Statement

> **The key sign.** At `t = 5/2` the truncation at `N = 3` is negative: `1 + cos((5/2) log 2) + cos((5/2) log 3) ≤ 1 - 0.16 - 0.92 < 0`.

```lean
theorem realPartial_three_five_halves_neg : realPartial 3 (5 / 2) < 0
```

## Hypotheses and notation

- `realPartial 3 t = 1 + cos (t log 2) + cos (t log 3)`, the expansion proved as `realPartial_three` (line 306); the first summand comes from `n = 1` where `cos 0 = 1`.
- The point is `t = 5 / 2 : ℝ`, i.e. `t = 5/2`, and `N = 3`.
- At the other endpoint `realPartial 3 0 = 3` (`realPartial_three_at_zero`, line 312).

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `realPartial_three_five_halves_neg` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 330–334). It rewrites by the expansion `realPartial_three` and combines the two explicit bounds [cos ((5/2) log 2) < -0.16](lean-rh43-balance-cos-five-halves-log-two-bound.md) and [cos ((5/2) log 3) < -0.92](lean-rh43-balance-cos-five-halves-log-three-bound.md) by `linarith`.
- The expansion lemmas `realPartial_three` / `realPartial_three_at_zero` that the source uses here are not harvested separately (see Notes).

## Dependencies and related results

- The two cosine bounds above.
- [A zero of `realPartial 3` in `[0, 5/2]`](lean-rh43-balance-zero-of-real-partial-three-in-interval.md) — the IVT step this sign change makes possible.

## Notes

- The source's auxiliary evaluations `realPartial_three` (the three-term expansion), `realPartial_three_at_zero` (`= 3`), `realPartial_two` and `realPartial_two_at_zero` (`= 2`) are definitional unfoldings / evaluations of finite sums; they are folded into this file and into [the counterexample at `t = 0`](lean-rh43-balance-two-not-balanced-at-zero.md) rather than harvested as separate statements.
