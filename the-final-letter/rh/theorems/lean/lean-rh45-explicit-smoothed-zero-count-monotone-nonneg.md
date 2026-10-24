# The smoothed zero count is monotone and non-negative for a non-negative transform

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §5 "The smoothed zero count", lines 248–266; declarations `Rh45.zeroSum_mono`, `Rh45.zeroSum_le_of_le`, `Rh45.zeroSum_nonneg`

## Statement

> **Monotonicity of the smoothed count.** A pointwise non-negative transform makes the partial zero sums monotone in the number of terms — the finite statement that makes the windowed count well defined: `Monotone (fun N => zeroSum F γ N)`.
>
> Monotonicity in the explicit `N ≤ M` form: `N ≤ M → zeroSum F γ N ≤ zeroSum F γ M`.
>
> **Non-negativity of the smoothed count.** `0 ≤ zeroSum F γ N`.

## Hypotheses and notation

- `F : ℝ → ℝ` — the transform, with hypothesis `hF : ∀ x, 0 ≤ F x` (pointwise non-negative) for all three statements; `γ : ℕ → ℝ` — the imaginary parts of the zeros; `N, M : ℕ`.
- `zeroSum F γ N = ∑ k ∈ Finset.range N, F (1/2 + γ k)` — the finite zero sum, i.e. the `N`-term truncation of the zero side of the explicit formula (definition, line 236).
- `Monotone` is monotonicity on `ℕ`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations in `Rh45/Explicit.lean`: `Rh45.zeroSum_mono` (lines 251–255, via `monotone_nat_of_le_succ` and the successor recurrence `zeroSum_succ`), `Rh45.zeroSum_le_of_le` (lines 258–260, the explicit `N ≤ M` form of the same statement), `Rh45.zeroSum_nonneg` (lines 263–266, `Finset.sum_nonneg`). The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- `Rh45.zeroSum_def` (line 240) and the successor recurrence `Rh45.zeroSum_succ` (line 244, "adjoining the `N`-th zero") — used in the proof; the successor recurrence is list/`Finset` bookkeeping and is not harvested.
- Mathlib `monotone_nat_of_le_succ`, `Finset.sum_nonneg`.
- [The prime side of the explicit formula splits into its +log and −log halves](lean-rh45-explicit-prime-side-splits-into-log-halves.md) — the companion finite-algebra fact on the other side of the formula.

## Notes

- `zeroSum_le_of_le` is the same statement as `zeroSum_mono` in explicit form and is recorded here rather than harvested separately.
- These are finite algebraic facts: the source's header describes the file as "the part of that formula which is pure finite algebra, with no analysis and no complex function theory".
