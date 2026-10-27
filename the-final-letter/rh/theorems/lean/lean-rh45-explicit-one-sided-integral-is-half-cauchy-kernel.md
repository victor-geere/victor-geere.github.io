# The one-sided integral `∫₀^∞ e^{−u/2} cos (t u) du = 2/(1 + 4t²)`, half the Cauchy kernel

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §8 "The elementary integral behind the Cauchy kernel", lines 376–439; declarations `Rh45.integral_exp_neg_half_mul_cos`, `Rh45.integral_exp_neg_half_mul_cos_eq`

## Statement

> **The elementary integral of the round.** The one-sided Laplace/cosine integral
> `∫_0^∞ e^{-u/2} cos (t u) du = 2/(1 + 4 t²)`.
>
> **The one-sided integral is half the Cauchy kernel.** With `cauchyKernel t = 1/(1/4 + t²) = 4/(1+4t²)`, the value `2/(1+4t²)` of `integral_exp_neg_half_mul_cos` is exactly `cauchyKernel t / 2`.

## Hypotheses and notation

- `t : ℝ`; no hypotheses.
- The integral is over `Set.Ioi 0`, i.e. `∫_0^∞`, of `Real.exp (-u/2) * Real.cos (t * u)`.
- `cauchyKernel t = 1 / (1/4 + t²)`; equivalently `4/(1 + 4t²)`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations in `Rh45/Explicit.lean`: `Rh45.integral_exp_neg_half_mul_cos` (lines 394–427) and `Rh45.integral_exp_neg_half_mul_cos_eq` (lines 435–439, which rewrites the first via `cauchyKernel_def` and `field_simp`/`ring`). The proof of the first uses Mathlib's improper integral of the complex exponential, `MeasureTheory.integral_exp_mul_complex_Ioi`, applied to `a = -(1/2 + it)`, and takes real parts with `MeasureTheory.integral_re`. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- [The Cauchy kernel is the Fourier transform of the exponential weight](lean-rh45-explicit-cauchy-kernel-as-fourier-transform.md) — folds the two halves and uses this one-sided value.
- [Exact values of the Cauchy kernel](lean-rh45-explicit-cauchy-kernel-exact-values.md).
- Mathlib `MeasureTheory.integral_exp_mul_complex_Ioi`, `MeasureTheory.integral_re`, `integral_const_mul`.

## Notes

- The source warns that the brief's literal two-sided Laplace statement at `s = 1/2 + it`, `∫_ℝ (π/2) e^{-|u|/2} e^{-(1/2+it)u} du = 1/(1/4 + t²)`, is **not** correct: the factor `e^{-(1/2+it)u}` does not decay as `u → -∞`, so the two-sided integral diverges on the line `Re s = 1/2`. That divergent statement is *not* asserted here. The source records that the two-sided exponential weight has Laplace transform `1/(1/4 - s²)` in the strip `|Re s| < 1/2`, and that the honest one-sided statement proved here is exactly the real part of the transform at `s = 1/2 + it`.
- `integral_exp_neg_half_mul_cos_eq` is the Cauchy-kernel form of the same integral, and is recorded in this file rather than harvested separately.
