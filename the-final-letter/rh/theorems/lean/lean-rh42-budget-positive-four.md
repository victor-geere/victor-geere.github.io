# Positive budget at weight four: P(4) = π⁴/1440

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean) — `hasSum_even_zeta_four` (lines 55–66) and `positiveBudget_four` (lines 140–147)

## Statement

> The positive (even-denominator) half of the rh42 signed alphabet has `p`-mass
> `P(p) = Σ`<sub>`k ≥ 1`</sub>` (2k)`<sup>`−p`</sup>, and at weight four
> **`P(4) = π⁴/1440`**.
>
> Lean form over all `k : ℕ` (`hasSum_even_zeta_four`):
>
> `HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 4) (Real.pi ^ 4 / 1440)`
>
> Lean form indexed from `k ≥ 1` (`positiveBudget_four`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) : ℕ) : ℝ) ^ 4) = Real.pi ^ 4 / 1440`

## Hypotheses and notation

- `k` ranges over `ℕ`; the even denominators are `2k`, and `2(k+1)` in the `k ≥ 1` indexing.
- `P(p) = Σ`<sub>`k ≥ 1`</sub>` (2k)`<sup>`−p`</sup> (module docstring).
- The series is summed in `ℝ`; `π` is `Real.pi`.
- The `k = 0` even term of `hasSum_even_zeta_four` is `1 / 0 = 0` under Lean's field convention.

## Proof / evidence

Machine-checked in `Rh42/Budget.lean` by the two declarations named above.

- `even_term_four` rewrites `1 / (2k)^4 = (1/16) * (1/k^4)` for every `k : ℕ`.
- `hasSum_even_zeta_four` applies `HasSum.mul_left (1/16)` to Mathlib's `hasSum_zeta_four` and rewrites `(1/16) * (π⁴/90) = π⁴/1440` by `ring`.
- `positiveBudget_four` shifts the index to `k ≥ 1` with `hasSum_nat_add_iff'` and `Finset.sum_range_one`, then takes `tsum_eq`.

No `sorry`, no `admit`; the file's header states: "The development is complete: no unsolved goals, and no axioms beyond Mathlib's own."

## Dependencies and related results

- Mathlib: `hasSum_zeta_four` (`ζ(4) = π⁴/90`), `HasSum.mul_left`, `hasSum_nat_add_iff'`.
- The negative budget at weight four is [`lean-rh42-budget-negative-four.md`](lean-rh42-budget-negative-four.md).
- The rh42 Lean README lists this row as: `P(4) = π⁴/1440` ↔ `hasSum_even_zeta_four`, `positiveBudget_four`.

## Notes

- `even_term_four` is the arithmetic ingredient of the proof and is not harvested separately.
- The source states the closed form in two indexings; they are the same statement and are folded into this one file.
