# Lean formal core — phase interference

## Build

```bash
cd the-final-letter/topics/phase-interference
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The script wraps the shared checker at [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed `BUILD.log` records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) defines

- `PhaseInterference.phase n t = exp(−i t log(n+2))`, the critical-line phase `w_n(t)`;
- `PhaseInterference.weighted K n m t = K · w_n(t) · w_m(t)`, the weighted kernel entry of Definition 2.6 at `s = 1/2 + it`.

It proves seven facts:

| Name | Statement |
|---|---|
| `phase_norm` | `‖phase n t‖ = 1` |
| `phase_zero` | `phase n 0 = 1` |
| `phase_conj` | `conj (phase n t) = phase n (−t)` |
| `weighted_comm` | `weighted K n m t = weighted K m n t` |
| `weighted_conj` | `conj (weighted K n m t) = weighted K n m (−t)` |
| `weighted_norm` | `‖weighted K n m t‖ = |K|` |
| `phase_add_norm_le` | `‖phase n t + phase m t‖ ≤ 2` |

There is no `sorry`, no `axiom`, and no `admit`.

These are the elementary facts the phase-interference argument actually uses: the phases lie on the unit circle, time reversal conjugates them, and a symmetric kernel gives a complex-symmetric phase-weighted entry. The triangle bound is the sharp trivial bound on two-term interference and is attained at `t = 0` (constructive alignment).

## What is not formalised

1. **The greedy recursion and the kernel.** The true recursive supports and the exact integrals `K(n,m)` are implemented and tested in [`../python/programme.py`](../python/programme.py), not in Lean. A formal treatment would require a piecewise indicator on `[0,π]`, interval integration, and a proof that the resulting matrix is the Gram matrix of the centred functions.
2. **Positive semidefiniteness of the kernel.** Established structurally in the dossier and tested exactly in Python (C3), but not a Lean theorem here.
3. **Destructive interference.** The exact cancellation `w_0(t)+w_1(t)=0` at `t = π/log(3/2)` is a Python computation (C6), not a Lean theorem; the Lean file proves only the general bound `≤ 2`.
4. **The spectral argument and GRH.** The source's hybrid operator `M_χ`, its Fredholm determinant, the trace-norm bounds, the monotonicity of the determinant argument, and the deformation argument are not given in a checkable form. They are recorded as archived claims in the [programme README](../README.md), not as Lean theorems.

## Why the formal core is small

The archived note is a compressed duplicate of the GHD corpus, and its novel content is a phase-weighting recipe plus a claimed spectral mechanism. There is no precise statement of the mechanism to formalise. Rather than invent one and prove a theorem about the invention, this file formalises the phase algebra that the recipe genuinely determines, and leaves the mechanism as a source claim. The kernel constants that *can* be checked are checked exactly in the Python layer.

[Back to the programme](../README.md) · [Topic index](../../README.md)
