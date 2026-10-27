# Lean formal core — GHD correlation kernel

## Build

```bash
cd the-final-letter/topics/ghd-correlation-kernel
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The wrapper delegates to the shared local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed log records the last successful check.

## What is proved

`Topic.lean` imports Mathlib, opens the `GHD` namespace, and defines:

- `GHD.alpha n = π / (n + 2)`;
- `GHD.Kdiag t = (t³ + (π − t)³) / (3π²)`, the diagonal step-model kernel in threshold form;
- `GHD.Kstep a b = π((a² + b²)/2 − max a b + 1/3)`, the off-diagonal step-model kernel in units `a = t/π`, `b = u/π`.

| Name | Statement |
|---|---|
| `alpha_pos` | `0 < alpha n` |
| `alpha_strictAnti` | `alpha` is strictly antitone |
| `Kdiag_alpha_closed` | `Kdiag (alpha n) = (π/3)(1 + (n+1)³)/(n+2)³` |
| `Kdiag_pos` | `0 < Kdiag t` for `0 < t < π` |
| `Kdiag_symm` | `Kdiag t = Kdiag (π − t)` |
| `Kdiag_half` | `Kdiag (π/2) = π/12` |
| `Kstep_symm` | `Kstep a b = Kstep b a` |

No `sorry`, no `axiom`, no `admit`. Every declaration compiles in the recorded build.

## What is *not* formalised, and why

The Lean core deliberately formalises the **step model** `ψ n = 1[θ ≥ α n] − θ/π`, not the actual greedy kernel. This is the honest boundary of the source's correct mathematics.

1. **The true greedy recursion.** The archive defines `δ n` using the residual `r n(θ)`, and the true kernel is the Gram matrix of `φ n = δ n − θ/π`. The two are not the same: `δ 2(π/4) = 1` but `δ 2(π/2) = 0`, so `δ n` is not a step function. The Lean file does not define `δ n`, cannot identify `Kdiag` with the true kernel, and does not claim to.
2. **The non-monotonicity counterexample.** The Python test `test_actual_greedy_digits_are_not_monotone` records it exactly; formalising the greedy recursion and this counterexample in Lean is a larger development and is left open.
3. **Positive semidefiniteness of finite Gram matrices.** The computation layer checks it exactly for sizes up to 7 (step model) and 6 (true kernel) by principal minors. A general Lean theorem would need an `L²` inner-product argument over the finite-dimensional span, which is outside the elementary core here.
4. **The threshold induction.** The archive's “proof” that `θ n* = α n` and that `δ n` is the indicator of an interval is where the monotonicity error enters. Only the attained instance at `θ = α n` is tested, not promoted to a Lean theorem.
5. **All analytic and GRH claims.** The Fredholm determinant identity, the uniform bound on `P χ`, the monotonicity of the argument, the deformation across conductors, the eigenvalue asymptotics, and GRH itself are source claims or open problems. None is a Lean theorem.

## Why the formal core is small

The overview page is a landing page; the kernel pages contain one genuinely checkable finite object (the centred step functions and their Gram matrix) plus a large number of downstream spectral and GRH assertions. The finite object yields the seven exact facts above. The downstream assertions are not formalisable from the archived material because the archive's own critique and negative-result note contradict the claimed pathway. See [`../README.md`](../README.md) for the full ledger.

[Back to the programme](../README.md) · [Topic index](../../README.md)
