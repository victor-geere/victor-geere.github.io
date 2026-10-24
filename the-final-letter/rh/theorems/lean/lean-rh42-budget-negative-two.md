# Negative budget at weight two: N(2) = π²/8 − 1

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean) — `tsum_odd_zeta_two` (lines 88–96), `hasSum_odd_zeta_two` (lines 109–112), `negativeBudget_two` (lines 131–138)

## Statement

> The negative (odd-denominator) half of the rh42 signed alphabet has `p`-mass
> `N(p) = Σ`<sub>`k ≥ 1`</sub>` (2k+1)`<sup>`−p`</sup>, and at weight two
> **`N(2) = π²/8 − 1`**.
>
> Lean form including the `k = 0` term (`tsum_odd_zeta_two`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 8`
>
> `HasSum` form of the same series (`hasSum_odd_zeta_two`):
>
> `HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 2) (Real.pi ^ 2 / 8)`
>
> Lean form indexed from the denominator `3` on (`negativeBudget_two`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) + 1 : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 8 - 1`

## Hypotheses and notation

- `k` ranges over `ℕ`; the odd denominators are `2k + 1`, and `2(k+1) + 1 = 2k + 3` for the budget indexed from `k ≥ 1`.
- `N(p) = Σ`<sub>`k ≥ 1`</sub>` (2k+1)`<sup>`−p`</sup> (module docstring). The `k = 0` term of the first two statements is the denominator `1`, contributing exactly `1`; hence the two values differ by `1`.
- The series is summed in `ℝ`; `π` is `Real.pi`.

## Proof / evidence

Machine-checked in `Rh42/Budget.lean`.

- `injective_two_mul_add_one` shows `k ↦ 2k + 1` is injective (by `omega`), and `summable_odd_zeta_two` obtains summability of the odd subseries from `hasSum_zeta_two.summable` by `Summable.comp_injective`.
- `tsum_odd_zeta_two` splits `ζ(2)` with `tsum_even_add_odd` over the even and odd subseries, substitutes `hasSum_even_zeta_two.tsum_eq` and `hasSum_zeta_two.tsum_eq`, and finishes by `linarith`: `π²/24 + Σ_odd = π²/6`, so `Σ_odd = π²/8`.
- `hasSum_odd_zeta_two` rewrites `summable_odd_zeta_two.hasSum` with `tsum_odd_zeta_two`.
- `negativeBudget_two` drops the `k = 0` term with `hasSum_nat_add_iff'` and `Finset.sum_range_one`, giving `π²/8 − 1`.

No `sorry`, no `admit`; the file's header states: "The development is complete: no unsolved goals, and no axioms beyond Mathlib's own."

## Dependencies and related results

- Mathlib: `hasSum_zeta_two`, `tsum_even_add_odd`, `Summable.comp_injective`, `hasSum_nat_add_iff'`.
- Uses the even budget [`lean-rh42-budget-positive-two.md`](lean-rh42-budget-positive-two.md) in the split of `ζ(2)`.
- The balance `P(2) + N(2) = π²/6 − 1` is [`lean-rh42-budget-two-sum.md`](lean-rh42-budget-two-sum.md).

## Notes

- Declaration kinds: `tsum_odd_zeta_two` and `negativeBudget_two` are Lean `theorem`s, `hasSum_odd_zeta_two` is a Lean `lemma`; the Kind given above is that of the headline declarations.
- The source states the odd series both with and without the `k = 0` term (`π²/8` versus `π²/8 − 1`); the two are the same statement up to the explicitly counted term `1`, and the `HasSum`/`tsum` forms are equivalent. All three declarations are folded into this one file.
- `injective_two_mul_add_one` and `summable_odd_zeta_two` are proof ingredients and are not harvested separately.
