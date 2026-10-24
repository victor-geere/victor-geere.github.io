# Positive budget at weight two: P(2) = π²/24

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean) — `hasSum_even_zeta_two` (lines 42–53) and `positiveBudget_two` (lines 122–129)

## Statement

> The positive (even-denominator) half of the rh42 signed alphabet has `p`-mass
> `P(p) = Σ`<sub>`k ≥ 1`</sub>` (2k)`<sup>`−p`</sup>, and at weight two
> **`P(2) = π²/24`**.
>
> Lean form over all `k : ℕ` (`hasSum_even_zeta_two`):
>
> `HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 2) (Real.pi ^ 2 / 24)`
>
> Lean form indexed from `k ≥ 1` (`positiveBudget_two`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 24`

## Hypotheses and notation

- `k` ranges over `ℕ`; the even denominators are `2k`, and `2(k+1)` in the `k ≥ 1` indexing.
- `P(p) = Σ`<sub>`k ≥ 1`</sub>` (2k)`<sup>`−p`</sup> is the positive half of the alphabet's `p`-mass; the negative half is `N(p) = Σ`<sub>`k ≥ 1`</sub>` (2k+1)`<sup>`−p`</sup> (module docstring).
- The series is summed in `ℝ`; `π` is `Real.pi`.
- In `hasSum_even_zeta_two` the `k = 0` even term is `1 / 0 = 0` under Lean's field convention, so the two forms assert the same value.

## Proof / evidence

Machine-checked in `Rh42/Budget.lean` by the two declarations named above; both are `theorem`s with complete proofs.

- `even_term_two` rewrites `1 / (2k)^2 = (1/4) * (1/k^2)` for every `k : ℕ` (the `k = 0` case uses `1 / 0 = 0`).
- `hasSum_even_zeta_two` applies `HasSum.mul_left (1/4)` to Mathlib's `hasSum_zeta_two` and rewrites `(1/4) * (π²/6) = π²/24` by `ring`.
- `positiveBudget_two` shifts the index to `k ≥ 1` with `hasSum_nat_add_iff'` and `Finset.sum_range_one`, then takes `tsum_eq`.

No `sorry`, no `admit`; the file's own header states: "The development is complete: no unsolved goals, and no axioms beyond Mathlib's own."

## Dependencies and related results

- Mathlib: `hasSum_zeta_two` (`ζ(2) = π²/6`), `HasSum.mul_left`, `hasSum_nat_add_iff'`.
- The negative budget at weight two is [`lean-rh42-budget-negative-two.md`](lean-rh42-budget-negative-two.md); the balance `P(2) + N(2) = π²/6 − 1` is [`lean-rh42-budget-two-sum.md`](lean-rh42-budget-two-sum.md).
- The rh42 Lean README lists this row as: `P(2) = π²/24` ↔ `hasSum_even_zeta_two`, `positiveBudget_two`.

## Notes

- `even_term_two` is the arithmetic ingredient of the proof and is not harvested separately.
- The source states the closed form in two indexings; they are mathematically the same statement and are folded into this one file.
