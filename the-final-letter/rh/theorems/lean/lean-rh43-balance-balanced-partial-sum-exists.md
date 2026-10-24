# Main theorem: a balanced partial sum exists

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §6 "The answer: a balanced partial sum exists", lines 354–361

## Statement

> **Main theorem.** Some non-empty truncation of the zeta Dirichlet series on the critical line has a balanced real part: the witness is `N = 3` at the `t` produced by the intermediate value theorem, where `posRe 3 t = -negRe 3 t`.

```lean
theorem exists_balanced_partial_sum : ∃ (N : ℕ) (t : ℝ), 0 < N ∧ balanced N t := by
  obtain ⟨t, _, ht⟩ := exists_zero_realPartial_three
  exact ⟨3, t, by norm_num, (balanced_iff_realPartial_eq_zero 3 t).mpr ht⟩
```

## Hypotheses and notation

- `balanced N t := posRe N t = -negRe N t` (the positive and negative totals of `realPartial N t` have equal magnitude).
- The witness is `N = 3` and any `t ∈ [0, 5/2]` with `realPartial 3 t = 0`; the truncation is `zetaPartial 3 t = 1 + 2^{-it} + 3^{-it}`, an ordinary finite sum.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `exists_balanced_partial_sum` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 359–361). It takes the zero of `realPartial 3` from [the IVT step](lean-rh43-balance-zero-of-real-partial-three-in-interval.md) and converts it with [the accounting theorem `balanced 3 t ↔ realPartial 3 t = 0`](lean-rh43-balance-accounting-theorem-balanced-iff-real-part-zero.md); `0 < 3` is discharged by `norm_num`. The `t = 5/2` sign that the IVT step rests on is decided by fully explicit rational bounds on `log 2`, `log 3` and `π`, with no numerical axiom (the source's remark).

## Dependencies and related results

- [A zero of `realPartial 3` in `[0, 5/2]`](lean-rh43-balance-zero-of-real-partial-three-in-interval.md).
- [Accounting theorem: `balanced N t ↔ realPartial N t = 0`](lean-rh43-balance-accounting-theorem-balanced-iff-real-part-zero.md).
- Harvested counterpart from the round's README: [Existence of a balanced partial sum (`exists_balanced_partial_sum`)](../tpp/tpp-rh43-lean-readme-exists-balanced-partial-sum.md).

## Notes

- The source states plainly that nothing is claimed for `N ≥ 4`; that case is open here. The theorem is an existence statement — no explicit value of `t` is produced.
