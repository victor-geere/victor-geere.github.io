# Lean formal core — sinc, sine kernel, moments

## Build

```bash
the-final-letter/topics/sinc-sine-kernel-moments/lean/check.sh
```

The wrapper calls the shared checker at `../../tools/check-lean.sh`, which elaborates `Topic.lean`
against the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`).
The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is formalised

[`Topic.lean`](Topic.lean) defines, in `namespace SincKernel`:

| Definition | Meaning |
|---|---|
| `sincN x` | `Real.sinc (π x)`, i.e. `sin(πx)/(πx)` for `x ≠ 0`, with `sincN 0 = 1` |
| `sineKernel x y` | `sincN (x − y)` |
| `montgomeryF α` | `1 − sincN(α)²` |
| `kostersKernel μ ν` | `exp(−iπ(μ−ν)) · sincN(μ−ν)` as a complex number |

It proves seven elementary facts:

| Name | Statement |
|---|---|
| `SincKernel.sincN_zero` | `sincN 0 = 1` |
| `SincKernel.sincN_half` | `sincN (1/2) = 2/π` |
| `SincKernel.sincN_int_eq_zero` | `sincN n = 0` for every non-zero integer `n` |
| `SincKernel.sincN_pos_of_mem_Ioo` | `0 < sincN x` for `0 < x < 1` |
| `SincKernel.sineKernel_comm` | `sineKernel x y = sineKernel y x` |
| `SincKernel.montgomeryF_nonneg` | `0 ≤ montgomeryF α` |
| `SincKernel.kostersKernel_norm` | `‖kostersKernel μ ν‖ = |sincN (μ − ν)|` |

There is no `sorry`, no `axiom`, and no `admit`. The proofs use only Mathlib's
elementary trigonometric facts (`Real.sinc_of_ne_zero`, `Real.sin_int_mul_pi`,
`Real.abs_sinc_le_one`, `Complex.norm_exp`) together with order and field arithmetic.

## What is not formalised

The archived essays are expository surveys of analytic number theory and random
matrix theory. Their substantive claims need zeta-function analysis that is far
beyond this formal core:

- the Riemann hypothesis;
- Montgomery's pair-correlation conjecture and the GUE/sine-kernel dictionary;
- Kösters' second- and fourth-moment asymptotic theorems;
- Kösters' conjecture for higher even moments and the CFKRS prediction;
- GRH-conditional shifted-moment bounds and theta-function moment conjectures;
- any statement about primes in short intervals.

None of these is proved or assumed here. They are recorded as **Source claim** or
**Open / conjecture** rows in the [programme dossier](../README.md).

One further limitation is textual rather than formal: the source defines
`sinc(x) = sin(πx)/(πx)` but then writes Kösters' right-hand side as
`e^{−iπ(μ−ν)} sinc(π(μ−ν))`. Under the stated definition that would be
`sin(π²(μ−ν))/(π²(μ−ν))`; the intended kernel is the normalised
`sin(π(μ−ν))/(π(μ−ν))`, which is what `sincN` formalises. The inconsistency is
recorded in the dossier rather than silently repaired.

[Back to the programme](../README.md) · [Topic index](../../README.md)
