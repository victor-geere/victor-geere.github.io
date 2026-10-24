# Negative budget at weight four: N(4) = π⁴/96 − 1

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean) — `tsum_odd_zeta_four` (lines 98–106), `hasSum_odd_zeta_four` (lines 115–118), `negativeBudget_four` (lines 149–156)

## Statement

> The negative (odd-denominator) half of the rh42 signed alphabet has `p`-mass
> `N(p) = Σ`<sub>`k ≥ 1`</sub>` (2k+1)`<sup>`−p`</sup>, and at weight four
> **`N(4) = π⁴/96 − 1`**.
>
> Lean form including the `k = 0` term (`tsum_odd_zeta_four`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 4) = Real.pi ^ 4 / 96`
>
> `HasSum` form of the same series (`hasSum_odd_zeta_four`):
>
> `HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 4) (Real.pi ^ 4 / 96)`
>
> Lean form indexed from the denominator `3` on (`negativeBudget_four`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) + 1 : ℕ) : ℝ) ^ 4) = Real.pi ^ 4 / 96 - 1`

## Hypotheses and notation

- `k` ranges over `ℕ`; the odd denominators are `2k + 1`, and `2(k+1) + 1 = 2k + 3` for the budget indexed from `k ≥ 1`.
- `N(p) = Σ`<sub>`k ≥ 1`</sub>` (2k+1)`<sup>`−p`</sup> (module docstring). The `k = 0` term is the denominator `1`, contributing exactly `1`; hence the two values differ by `1`.
- The series is summed in `ℝ`; `π` is `Real.pi`.

## Proof / evidence

Machine-checked in `Rh42/Budget.lean`.

- `summable_odd_zeta_four` obtains summability of the odd fourth-power subseries from `hasSum_zeta_four.summable` by `Summable.comp_injective` with `injective_two_mul_add_one`.
- `tsum_odd_zeta_four` splits `ζ(4)` with `tsum_even_add_odd`, substitutes `hasSum_even_zeta_four.tsum_eq` and `hasSum_zeta_four.tsum_eq`, and finishes by `linarith`: `π⁴/1440 + Σ_odd = π⁴/90`, so `Σ_odd = π⁴/96`.
- `hasSum_odd_zeta_four` rewrites `summable_odd_zeta_four.hasSum` with `tsum_odd_zeta_four`.
- `negativeBudget_four` drops the `k = 0` term with `hasSum_nat_add_iff'` and `Finset.sum_range_one`, giving `π⁴/96 − 1`.

No `sorry`, no `admit`; the file's header states: "The development is complete: no unsolved goals, and no axioms beyond Mathlib's own."

## Dependencies and related results

- Mathlib: `hasSum_zeta_four`, `tsum_even_add_odd`, `Summable.comp_injective`, `hasSum_nat_add_iff'`.
- Uses the even budget [`lean-rh42-budget-positive-four.md`](lean-rh42-budget-positive-four.md) in the split of `ζ(4)`.

## Notes

- Declaration kinds: `tsum_odd_zeta_four` and `negativeBudget_four` are Lean `theorem`s, `hasSum_odd_zeta_four` is a Lean `lemma`; the Kind given above is that of the headline declarations.
- The source states the odd series both with and without the `k = 0` term (`π⁴/96` versus `π⁴/96 − 1`); the two are the same statement up to the explicitly counted term `1`, and the `HasSum`/`tsum` forms are equivalent. All three declarations are folded into this one file.
- `summable_odd_zeta_four` is a proof ingredient and is not harvested separately.
