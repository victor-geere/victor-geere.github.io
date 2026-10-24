# Lean formal core — Harmonic–Geometric Unified Theory plan

## Build

```bash
cd the-final-letter/topics/harmonic-geometric-unified-theory && ./lean/check.sh
```

The wrapper calls the shared checker at `../../tools/check-lean.sh`, which elaborates the file against the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is formalised

The archived source is a research **plan**. It names the transfer operator `L_s`, the Fredholm determinant, the Harmonic Sine Transform, Greedy–Egyptian modular tensor categories, and the Quantum–Egyptian Functional Equations, but it defines none of them and proves nothing about them. There is therefore no analytic object in the source that can honestly be transcribed into Lean.

What the plan's harmonic/Egyptian vocabulary does presuppose is elementary arithmetic. [`Topic.lean`](Topic.lean) formalises that:

| Definition | Meaning |
|---|---|
| `HGU.egyptWeight n` | `1/(n + 1)`, the unit fraction / Egyptian weight |
| `HGU.harmonicAngle n` | `π/(n + 2)`, the greedy harmonic angle |
| `HGU.harmonicSum N` | `Σ_{n<N} 1/(n + 1)`, the finite harmonic sum |

and proves:

| Name | Statement |
|---|---|
| `egyptWeight_pos` | `0 < egyptWeight n` for every `n` |
| `egyptWeight_strictAnti` | `egyptWeight` is strictly antitone |
| `egyptWeight_tendsto_zero` | `egyptWeight n → 0` as `n → ∞` |
| `harmonicAngle_scaled` | `(n + 2) * harmonicAngle n = π` |
| `harmonicSum_succ` | `harmonicSum (N+1) = harmonicSum N + egyptWeight N` |
| `harmonicSum_mono` | `harmonicSum` is monotone |
| `harmonicSum_four` | `harmonicSum 4 = 25/12` |

No `sorry`, no `axiom`, no `admit`. None of the declarations is a `rfl`-only tautology: T1/T2/T3 establish the order and limit properties needed for a greedy unit-fraction algorithm to make progress; T4 fixes the harmonic angle normalisation; T5–T7 establish the finite-sum recursion, monotonicity, and an exact rational value.

## What is not formalised

The following source claims remain **outside** the formal core and are recorded in the programme dossier as source claims or open items:

- the definition and trace-class property of `L_s`;
- the Fredholm determinant identity and the regularised determinant on the critical line;
- the equivalence `det_(2)(I − L_{1/2+it}) = 0 ↔ ζ(1/2 + it) = 0` and the Spectral Riemann Hypothesis;
- zero-freeness of `e^{P(s)}` in the critical strip;
- the twisted operator `L_{s,χ}`, the monotonicity inequality, and the derivation of GRH;
- the Greedy–Egyptian modular tensor categories;
- the Quantum–Egyptian Functional Equations (v1–v8);
- convergence of the greedy Egyptian algorithm for every rational (the finite algorithm and its exact behaviour are tested in Python, not proved in Lean);
- the plan's schedule arithmetic.

These are not Lean theorems here. In most cases the source does not supply a precise statement, so formalisation would first require a definition that the archived page does not contain.

## Relation to the neighbouring topic

The companion folder [`../../greedy-harmonic-decomposition`](../../greedy-harmonic-decomposition/README.md) formalises the greedy harmonic angle expansion and its correlation kernel. This folder formalises the harmonic/Egyptian *weight* arithmetic that the unified plan presupposes, plus the plan's duration data; the two cores are deliberately different.

[Back to the programme](../README.md) · [Topic index](../../README.md) · [Scraps](../../../scraps.html)
