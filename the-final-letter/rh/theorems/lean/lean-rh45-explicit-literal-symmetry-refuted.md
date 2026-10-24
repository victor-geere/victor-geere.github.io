# The literal symmetry `cauchyKernel (1 − x) = cauchyKernel x` is false

**Kind:** Theorem
**Status:** REFUTED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §2 "The exact values of the Cauchy kernel", lines 164–178; declarations `Rh45.cauchyKernel_not_symm_about_half`, `Rh45.gaussKernel_not_symm_about_half`

## Statement

> **The literal symmetry `cauchyKernel (1 - x) = cauchyKernel x` is false.** At `x = 0` it would say `cauchyKernel 1 = cauchyKernel 0`, i.e. `4/5 = 4`. The kernels are functions of the imaginary part `t = Im s`; the symmetry `s ↔ 1 - s` is the symmetry of the *shifted* kernels about `s = 1/2` (`cauchyKernel_symm_about_half`), equivalently the evenness in `t`.
>
> The analogous false statement for the Gaussian kernel: `gaussKernel 1 ≠ gaussKernel 0`.

Formally, the refuting statements are

> `cauchyKernel (1 - 0) ≠ cauchyKernel 0` and `gaussKernel (1 - 0) ≠ gaussKernel 0`.

## Hypotheses and notation

- `cauchyKernel t = 1 / (1/4 + t²)`, `gaussKernel t = Real.exp (-(t²)/2)`.
- The refutation is at the single point `x = 0`, where `1 - x = 1`; `cauchyKernel 1 = 4/5` and `cauchyKernel 0 = 4`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations in `Rh45/Explicit.lean`: `Rh45.cauchyKernel_not_symm_about_half` (line 169, rewriting with `cauchyKernel_one` and `cauchyKernel_zero` and closing by `norm_num`) and `Rh45.gaussKernel_not_symm_about_half` (line 174, using `Real.exp_injective` on the assumed equality and `norm_num`). The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

This refutes the brief's literal reading; the correct shifted statement is [the `s ↔ 1 − s` symmetry of the shifted kernels about `s = 1/2`](lean-rh45-explicit-shifted-kernels-symmetric-about-half.md).

## Dependencies and related results

- [Exact values of the Cauchy kernel](lean-rh45-explicit-cauchy-kernel-exact-values.md) — `cauchyKernel 1 = 4/5`, `cauchyKernel 0 = 4`.
- [The `s ↔ 1 − s` symmetry of the shifted Cauchy and Gaussian kernels about `s = 1/2`](lean-rh45-explicit-shifted-kernels-symmetric-about-half.md) — the correct form.
- Mathlib `Real.exp_injective`.

## Notes

- The status `REFUTED` refers to the source's literal symmetry claim `cauchyKernel (1 - x) = cauchyKernel x`: the source states it is *false*, and the Lean declarations prove the negation. The mathematical content (the kernels are functions of `t = Im s`, so the symmetry lives on the shifted kernels) is stated by the source, not inferred here.
- The two declarations are the parallel Cauchy/Gaussian refutations and are harvested as one file.
