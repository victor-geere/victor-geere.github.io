# Non-negativity of the prime side

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §6 "The prime side and its splitting", lines 325–333; declaration `Rh45.primeSide_nonneg`

## Statement

> **Non-negativity of the prime side.** `Λ ≥ 0`, `√n ≥ 0` and a non-negative `g` make every summand non-negative: `0 ≤ primeSide g nmax`.

## Hypotheses and notation

- `g : ℝ → ℝ` with hypothesis `hg : ∀ x, 0 ≤ g x` (pointwise non-negative weight); `nmax : ℕ`.
- `primeSide g nmax = ∑_{n=2}^{nmax} (Λ n / √n) (g (log n) + g (−log n))` (definition, line 274).
- `Λ` is Mathlib's von Mangoldt function `ArithmeticFunction.vonMangoldt`, with `Λ n ≥ 0` (`ArithmeticFunction.vonMangoldt_nonneg`).

## Proof / evidence

Complete Lean proof, no `sorry` (file header, lines 55–56). Declaration `Rh45.primeSide_nonneg` in `Rh45/Explicit.lean` (lines 327–333): `Finset.sum_nonneg` with each summand non-negative from `div_nonneg ArithmeticFunction.vonMangoldt_nonneg (Real.sqrt_nonneg _)` and `add_nonneg` of the weight's values. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- [The prime side of the explicit formula splits into its +log and −log halves](lean-rh45-explicit-prime-side-splits-into-log-halves.md) — the companion structural fact.
- [The smoothed zero count is monotone and non-negative for a non-negative transform](lean-rh45-explicit-smoothed-zero-count-monotone-nonneg.md) — the same non-negativity shape on the zero side.
- Mathlib `ArithmeticFunction.vonMangoldt_nonneg`, `Real.sqrt_nonneg`, `Finset.sum_nonneg`.

## Notes

- This is a finite non-negativity statement about the truncated prime side; it is *not* a statement about convergence of the (divergent) prime sum, and the source makes no such claim.
