# The Cauchy kernel is the Fourier transform of the exponential weight

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §8 "The elementary integral behind the Cauchy kernel", lines 441–472; declaration `Rh45.integral_expWeight_mul_cos`

## Statement

> **The Cauchy kernel is the Fourier transform of the exponential weight.** This is the correct, convergent form of the brief's target 11: the two-sided integral of the *even* weight against `cos (t u)`,
> `∫_ℝ (π/2) e^{-|u|/2} cos (t u) du = (π/2) · cauchyKernel t`,
> i.e. `∫_ℝ expWeight u · cos (t u) du = (π/2) · cauchyKernel t` for every `t : ℝ`.

## Hypotheses and notation

- `t : ℝ`; no hypotheses.
- `expWeight u = (π/2) exp (-|u|/2)` — the two-sided exponential weight (definition, line 183).
- `cauchyKernel t = 1 / (1/4 + t²) = 4/(1 + 4t²)`.
- The integral is over all of `ℝ`.

## Proof / evidence

Complete Lean proof, no `sorry` (file header, lines 55–56). Declaration `Rh45.integral_expWeight_mul_cos` in `Rh45/Explicit.lean` (lines 452–472). The proof folds the two halves `u > 0` and `u < 0` into one by writing the integrand as `g |u|` for `g y = (π/2) e^{-y/2} cos (t y)` (`Real.cos` is even, so `cos (t |u|) = cos (t u)`) and applying Mathlib's `integral_comp_abs`, `∫ x, f |x| = 2 ∫_{x > 0} f x`, together with [`integral_exp_neg_half_mul_cos`](lean-rh45-explicit-one-sided-integral-is-half-cauchy-kernel.md). The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- [The one-sided integral `∫₀^∞ e^{−u/2} cos (t u) du = 2/(1 + 4t²)`](lean-rh45-explicit-one-sided-integral-is-half-cauchy-kernel.md) — `integral_exp_neg_half_mul_cos`.
- [The two-sided exponential weight `(π/2) exp (−|u|/2)`](lean-rh45-explicit-exp-weight-even-positive-at-zero.md) — definition, evenness and value at the origin.
- Mathlib `integral_comp_abs`, `Real.cos_neg`, `integral_const_mul`.

## Notes

- The source presents this as the correct, convergent form of the brief's target 11, replacing the brief's divergent two-sided Laplace statement at `s = 1/2 + it` (see the notes of the one-sided integral file). This is a *cosine* (Fourier) pairing, not the Laplace statement.
- The source also records, in the docstring of the one-sided integral, that the two-sided exponential weight has Fourier transform `∫_ℝ e^{-|u|/2} e^{-itu} du = 4/(1+4t²)`, i.e. the Cauchy kernel; that is the same content as this theorem up to the constant `π/2`.
