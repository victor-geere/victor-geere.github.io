# The `s ↔ 1 − s` symmetry of the shifted Cauchy and Gaussian kernels about `s = 1/2`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §1 "The Cauchy and Gaussian kernels", lines 122–135; declarations `Rh45.cauchyKernel_symm_about_half`, `Rh45.gaussKernel_symm_about_half`

## Statement

> **The `s ↔ 1 - s` symmetry, Cauchy kernel.** Because `1 - s - 1/2 = -(s - 1/2)` and the kernel is even, the shifted Cauchy kernel is symmetric about `s = 1/2`: `cauchyKernelAt (1 - s) = cauchyKernelAt s` for every `s : ℝ`.
>
> **The `s ↔ 1 - s` symmetry, Gaussian kernel.** `gaussKernelAt (1 - s) = gaussKernelAt s` for every `s : ℝ`.

## Hypotheses and notation

- `s : ℝ` — the *spectral* variable.
- `cauchyKernelAt s = cauchyKernel (s - 1/2)` and `gaussKernelAt s = gaussKernel (s - 1/2)`: the shift `s ↦ cauchyKernel (s - 1/2)` places the point `s = 1/2 + t` over `t`. This is the object for which the symmetry `s ↔ 1 - s` of the explicit formula holds.
- `cauchyKernel t = 1 / (1/4 + t²)`, `gaussKernel t = Real.exp (-(t²)/2)`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations `Rh45.cauchyKernel_symm_about_half` (line 128) and `Rh45.gaussKernel_symm_about_half` (line 133) in `Rh45/Explicit.lean`; each rewrites `1 - s - 1/2 = -(s - 1/2)` (by `ring`) and then applies the corresponding evenness lemma. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- [Evenness of the Cauchy and Gaussian kernels](lean-rh45-explicit-kernel-evenness.md) — `cauchyKernel_even`, `gaussKernel_even`.
- Defining equations `Rh45.cauchyKernelAt_def`, `Rh45.gaussKernelAt_def` (definitional rewrites, not harvested separately).
- [The literal symmetry `cauchyKernel (1 − x) = cauchyKernel x` is false](lean-rh45-explicit-literal-symmetry-refuted.md) — the unshifted literal reading is false.

## Notes

- The source flags this as "the correct form of the brief's `cauchyKernel_symm_about_half`": the literal statement `cauchyKernel (1 - x) = cauchyKernel x` is not true, and the file records the refuting counterexample separately (see the linked refutation file).
- The two declarations are the parallel Cauchy/Gaussian pair and are harvested as one file; they are distinct declarations with distinct kernels.
