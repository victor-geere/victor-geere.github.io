# Lean formal core — quaternion–cosine framework

## Build

```bash
cd the-final-letter/topics/quaternion-cosine
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The wrapper calls the shared checker [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which uses the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) defines the quaternion units `I`, `J`, `K` in `ℍ[ℝ]`, the lifted phase `phase a b = a i + b j`, the alignment energy `energy a b`, the scalar detector `detector u v`, and the warping factor `warp σ = 2σ − 1`.

| Name | Statement |
|---|---|
| `quaternion_relations` | `I * I = -1`, `J * J = -1`, `K * K = -1`, `I * J = K`, `J * I = -K`. |
| `phase_normSq` | `normSq (phase a b) = a² + b²`. |
| `cos_two_pi_mul_eq_one_iff` | `cos (2π x) = 1 ↔ ∃ n : ℤ, x = n`. |
| `detector_eq_zero_iff` | For `x ≠ 0`, `detector (2πx) (2πp/x) = 0` iff both `x` and `p/x` are integers. |
| `energy_nonneg` | `0 ≤ energy a b`. |
| `energy_eq_zero_iff` | `energy a b = 0 ↔ cos a = 1 ∧ cos b = 1`. |
| `warp_eq_zero_iff` | `warp σ = 0 ↔ σ = 1/2`. |

No `sorry`, no `axiom`, no `admit`. The proof of `detector_eq_zero_iff` uses `cos_two_pi_mul_eq_one_iff`; `energy_eq_zero_iff` uses only the fact that a sum of two squares of reals is zero exactly when both terms are zero. `phase_normSq` and `quaternion_relations` compute the Hamilton product and the norm from `Quaternion.normSq_def'`.

## What is not formalised

The Lean file deliberately stops at the elementary, checkable core. It does **not** formalise:

- the Riemann xi function, its zeros, or any relation between `ξ` and the energy `E`;
- the claim that `inf_{x>0} E(x) = 0` iff `ξ(σ+it) = 0`;
- the derivation of the warping `t' ~ t/(2σ−1)` from the functional equation;
- the assertion `inf_x E(x) > c > 0` for `σ ≠ 1/2`;
- prime sums, exponential-sum bounds, or the explicit formula;
- the “dyadic condition” of the source’s central conjecture, which is not stated precisely enough to formalise;
- minimisation over `x > 0` and any numerical/spectral input.

Those items are recorded as **Source claim** or **Open / conjecture** in the programme [README](../README.md). In particular, the Riemann hypothesis is not asserted, assumed, or proved anywhere in this Lean file.

## Why the formal core is small

The archived essay is a speculative research proposal, not a paper with a developed theorem chain. Its precise mathematical content is the quaternion lift of two cosine phases, the pointwise divisor detector, the non-negative alignment energy, and the formal warping factor. Those are exactly the statements in the table above. Everything beyond them depends on an unproved bridge to analytic number theory; formalising that bridge would amount to solving (or assuming) the central open problem, so it is left as an open item rather than disguised as a theorem.

## Verification

```bash
cd the-final-letter/topics/quaternion-cosine
./lean/check.sh
```

Recorded result: `[check] OK   Topic.lean (5s)`.

[Back to the programme](../README.md) · [Topic index](../../README.md) · [Scraps](../../../scraps.html)
