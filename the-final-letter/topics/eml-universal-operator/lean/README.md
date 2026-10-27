# Lean formal core — EML universal operator

## Build

```bash
cd the-final-letter/topics/eml-universal-operator
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

`check.sh` is a thin wrapper around [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which uses the shared local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

`Topic.lean` defines

```lean
def eml (x y : ℝ) : ℝ := Real.exp x - Real.log y
```

and proves seven elementary, source-relevant facts:

| Name | Statement |
|---|---|
| `EML.exp_identity` | `eml z 1 = Real.exp z` |
| `EML.unit_identity` | `eml 0 1 = 1` |
| `EML.eml_eq_exp_sub_log` | `eml x y = eml x 1 - Real.log y` |
| `EML.one_le_eml` | `0 ≤ x → 1 ≤ eml x 1` |
| `EML.strictMono_first` | `StrictMono (fun x => eml x 1)` |
| `EML.log_identity` | `0 < z → eml 1 (eml (eml 1 z) 1) = Real.log z` |
| `EML.sqrt_identity` | `0 < u → eml (Real.log u / 2) 1 = Real.sqrt u` |

The headline result is `log_identity`, the source's three-gate expression for the logarithm. Its proof unfolds the three gates, rewrites `exp` of a difference, uses `Real.exp_log` and `Real.log_div`, and closes with `ring`. `sqrt_identity` uses `Real.exp_half` and `Real.exp_log`.

There is no `sorry`, no `axiom`, and no `admit` in the file.

## What is not formalised

The source is fragmentary and partly defective, so the formal core is deliberately small.

- **Functional completeness.** The source asserts that `eml` with `1` generates every elementary function via finite binary trees, citing Odrzywołek (arXiv:2603.21852). There is no inductive eml-tree syntax, evaluation semantics, or closure proof here. Only the three base identities are formalised.
- **The harmonic fusion rule.** The source's printed recurrence is not sine addition, and its Python listing is a third variant. A numerical counterexample at `θ = 5π/12` is recorded as computation C5 in the programme tests. The reconstruction does not formalise the defective rule, nor does it claim the source's `O(1/N)` theorem.
- **The correlation kernel and spectral bounds.** The diagonal closed form, positive semidefiniteness, and the eigenvalue bounds are source claims. They depend on a correct threshold model and are not formalised here.
- **The zeta bridge and the Riemann-hypothesis conjecture.** The functional equation is quoted in the source, the bridge step is motivational, and the RH material is explicitly conjectural. None of it is a Lean theorem, and RH is not assumed anywhere.

These items are recorded as **Source claim** or **Open / conjecture** rows in the [programme README](../README.md). They are not upgraded by the existence of this Lean file.

## Why this is a genuine core

The seven theorems are not vacuous `rfl` padding: `log_identity` and `sqrt_identity` are the source's actual gate constructions, `exp_identity` is the source's first base identity, and the order/positivity lemmas describe the operator as it is used. The file is intentionally small because the source's further claims are either borrowed, defective, or archived.

[Back to the programme](../README.md) · [Topic index](../../README.md)
