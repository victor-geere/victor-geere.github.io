# Strict positivity and non-negativity of the Cauchy and Gaussian kernels

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §1 "The Cauchy and Gaussian kernels", lines 91–106; declarations `Rh45.cauchyKernel_pos`, `Rh45.gaussKernel_pos`, `Rh45.cauchyKernel_nonneg`, `Rh45.gaussKernel_nonneg`

## Statement

> **Strict positivity of the Cauchy kernel.** `0 < cauchyKernel t` for every `t : ℝ`. The denominator is `1/4 + t² ≥ 1/4 > 0`.
>
> **Strict positivity of the Gaussian kernel.** `0 < gaussKernel t` for every `t : ℝ`.
>
> Non-negativity of the Cauchy kernel: `0 ≤ cauchyKernel t`.
>
> Non-negativity of the Gaussian kernel: `0 ≤ gaussKernel t`.

## Hypotheses and notation

- `t : ℝ`; no hypotheses.
- `cauchyKernel t = 1 / (1/4 + t²)`, `gaussKernel t = Real.exp (-(t²)/2)`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56: "there is no `sorry`, no extra axiom and no computation by reflection"). Declarations in `Rh45/Explicit.lean`: `Rh45.cauchyKernel_pos` (line 93, from `one_div_pos.mpr` and `nlinarith [sq_nonneg t]`), `Rh45.gaussKernel_pos` (line 98, from `Real.exp_pos`), `Rh45.cauchyKernel_nonneg` (line 103) and `Rh45.gaussKernel_nonneg` (line 106), the last two being the `.le` of the strict statements. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- [Evenness of the Cauchy and Gaussian kernels](lean-rh45-explicit-kernel-evenness.md).
- Mathlib `one_div_pos`, `sq_nonneg`, `Real.exp_pos`.

## Notes

- The two non-negativity declarations are the `.le` of the corresponding strict positivity declarations — their content is already captured by the positivity statements, and they are recorded here rather than harvested as separate files.
- The source itself presents the non-negativity lines without separate docstrings; they are the source's own derived statements.
