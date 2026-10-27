# The signed alphabet is balanced at weight two: P(2) + N(2) = π²/6 − 1

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean) — `budget_two_sum` (lines 158–162); module docstring lines 17–18

## Statement

> The signed alphabet is balanced at weight two:
> **`P(2) + N(2) = π²/6 − 1`**.
>
> Lean statement (`budget_two_sum`):
>
> `(∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) : ℕ) : ℝ) ^ 2) + (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) + 1 : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 6 - 1`

## Hypotheses and notation

- `P(p) = Σ`<sub>`k ≥ 1`</sub>` (2k)`<sup>`−p`</sup> is the positive budget and `N(p) = Σ`<sub>`k ≥ 1`</sub>` (2k+1)`<sup>`−p`</sup> the negative budget of the signed alphabet (module docstring); both are indexed from `k ≥ 1`, i.e. from the denominators `4, 6, 8, …` and `3, 5, 7, …`.
- The series are summed in `ℝ`; `π` is `Real.pi`.

## Proof / evidence

Machine-checked in `Rh42/Budget.lean` as the `theorem` `budget_two_sum`: rewrite with the two closed forms `positiveBudget_two` and `negativeBudget_two`, then `ring`.

No `sorry`, no `admit`; the file's header states: "The development is complete: no unsolved goals, and no axioms beyond Mathlib's own."

## Dependencies and related results

- [`lean-rh42-budget-positive-two.md`](lean-rh42-budget-positive-two.md) — `P(2) = π²/24`.
- [`lean-rh42-budget-negative-two.md`](lean-rh42-budget-negative-two.md) — `N(2) = π²/8 − 1`.
- The rh42 Lean README lists this row as `P(2) + N(2) = π²/6 − 1` ↔ `budget_two_sum`, "the budget interval's length at `p = 2`".

## Notes

- This is a direct corollary of the two weight-two closed forms; it is the total `p`-mass of the alphabet at `p = 2`, excluding the two `k = 0` boundary terms (`1/0` and `1/1`).
- The module docstring states the balance at weight two only; no analogous balance statement for weight four is made in this source.
