# Theorem 4 (existence of a balanced partial sum)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`, no numerical axiom); VERIFIED (numerical, certified sign change)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §1.2 "The explicit IVT witness at `N = 3` (and `N = 4`)" (ledger row T5)

## Statement

> **Theorem 4 (existence of a balanced partial sum).** There is `t` in `(0, 5/2)` with `Re S_3(t) = 0`; hence `balanced 3 t` holds. Indeed
>
> ```
> Re S_3(t) = 1 + cos(t log 2) + cos(t log 3)
> Re S_3(0) = 3 > 0
> Re S_3(5/2) < 0 ,     the certified value being -0.08433575829842532…
> ```
>
> and `Re S_3` is continuous, so the intermediate value theorem gives a root.

## Hypotheses and notation

- `t` real; `S_3(t) = 1 + 2^{-it} + 3^{-it}`; `Re S_3(t) = 1 + cos(t log 2) + cos(t log 3)`.
- The bracket is the closed interval `[0, 5/2]`; `Re S_3(0) = 3 > 0` and `Re S_3(5/2) < 0`, with certified value `-0.08433575829842532…`.
- `balanced N t` is the Lean predicate `posRe N t = -negRe N t`.

## Proof / evidence

- **PROVED** in Lean — [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean), theorems `realPartial_three_at_zero`, `realPartial_three_five_halves_neg`, `exists_zero_realPartial_three`, `exists_realPartial_three_eq_zero`, `exists_balanced_partial_sum` — with the two trigonometric bounds `cos((5/2) log 2) < -0.16` and `cos((5/2) log 3) < -0.92`, derived from Mathlib's `Real.log_two_gt_d9`, `Real.log_three_gt_d9`, `Real.pi_gt_d20`/`lt_d20` and `Real.sin_ge_sub_cube`/`one_sub_sq_div_two_le_cos`. **No numerical axiom is used.**
- The Lean declarations for the two bounds are `cos_two_mul_log_two_lt`, `cos_two_mul_log_three_lt`; the intermediate-value statement is `exists_zero_realPartial_three : ∃ t ∈ Icc 0 (5/2), realPartial 3 t = 0`.
- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §3 (a certified sign change of the enclosure of `Re S_3` across `[2.42, 2.43]`, and the certified value `Re S_3(5/2)`).

## Dependencies and related results

- Mathlib inputs: `Real.log_two_gt_d9`, `Real.log_three_gt_d9`, `Real.pi_gt_d20`, `Real.pi_lt_d20`, `Real.sin_ge_sub_cube`, `Real.one_sub_sq_div_two_le_cos`, `Real.cos_lt_cos_of_nonneg_of_le_pi`, `Real.cos_pi_sub`, `Real.cos_add_pi_div_two` (Lean README notes).
- Related: [The same route at N = 4](tpp-rh43-truths-n4-ivt-witness.md) (T6); [The certified root table](tpp-rh43-truths-certified-root-table.md) (T7); [Existence for every N >= 3](tpp-rh43-truths-existence-every-n.md) (T8).
- Combined with T4 this gives the round's answer: a balanced split exists for every `N >= 2`.

## Notes

- The source gives the bracket as `(0, 5/2)` for the existence statement and cites the certified value `Re S_3(5/2) < 0` (Lean: `realPartial 3 (5/2) < 0`).
