# Evenness of the Cauchy and Gaussian kernels

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §1 "The Cauchy and Gaussian kernels", lines 83–89; declarations `Rh45.cauchyKernel_even`, `Rh45.gaussKernel_even`

## Statement

> **Evenness of the Cauchy kernel.** `cauchyKernel (-t) = cauchyKernel t` for every `t : ℝ`.
>
> **Evenness of the Gaussian kernel.** `gaussKernel (-t) = gaussKernel t` for every `t : ℝ`.

The two kernels of the round are

> `cauchyKernel t = 1 / (1 / 4 + t ^ 2)` and `gaussKernel t = Real.exp (-(t ^ 2) / 2)`.

## Hypotheses and notation

- `t : ℝ` — the imaginary part (`t = Im s`) of the spectral variable; both kernels are functions of `t`, not of `s`.
- `cauchyKernel t = 1 / (1/4 + t²)` (definition, line 72); as a function of the spectral variable `s` it is the shifted/inverted kernel `1/(s(1-s))` evaluated at `s = 1/2 + t`, i.e. `cauchyKernel t = 1/((1/2+it)(1/2-it))`.
- `gaussKernel t = Real.exp (-(t²)/2)` (definition, line 75).
- `ℝ` is Lean's real type, `Real.exp` the real exponential.

## Proof / evidence

Complete Lean proofs, no `sorry`. The file header states "Everything below is proved from Mathlib alone; there is no `sorry`, no extra axiom and no computation by reflection." (lines 55–56). The declarations are `Rh45.cauchyKernel_even` and `Rh45.gaussKernel_even` in `Rh45/Explicit.lean` (lines 84–89); each is proved by rewriting with the defining equation (`cauchyKernel_def` / `gaussKernel_def`) and Mathlib's `neg_sq`. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- Defining equations `Rh45.cauchyKernel_def`, `Rh45.gaussKernel_def` (definitional rewrites, not harvested separately).
- Mathlib `neg_sq`.
- [The `s ↔ 1 − s` symmetry of the shifted kernels about `s = 1/2`](lean-rh45-explicit-shifted-kernels-symmetric-about-half.md) — the statement for which this evenness is the engine.
- [The literal symmetry `cauchyKernel (1 − x) = cauchyKernel x` is false](lean-rh45-explicit-literal-symmetry-refuted.md).

## Notes

- The source states the two evenness facts as a parallel pair for the two kernels of the round; they are harvested as a single file for that reason. They are not near-duplicates from different files: each is a declaration of its own.
- Evenness is stated in `t`; the source is explicit that this is *not* the same as symmetry of the unshifted kernel under `s ↔ 1 - s` (see the refutation file).
