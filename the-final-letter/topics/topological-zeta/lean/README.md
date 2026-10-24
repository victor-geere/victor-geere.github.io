# Lean formal core — topological zeta

## Build

```bash
cd the-final-letter/topics/topological-zeta
./lean/check.sh
```

The wrapper calls the shared checker at [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates `Topic.lean` against the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). [`BUILD.log`](BUILD.log) records the last successful check: `[check] OK Topic.lean`.

## What is proved

`Topic.lean` imports Mathlib and opens the namespace `TopologicalZeta`. It states the finite modular-data algebra that the archived MTC paper actually defines, and proves:

| Name | Statement |
|---|---|
| `egyptian_identity` | For `d2 : ι → ℝ` with `D² = ∑ i, d2 i ≠ 0`, `∑ i, d2 i / D² = 1`. |
| `egyptian_nonunit` | If the unit object has `d2 i0 = 1`, then `∑ i ∈ univ.erase i0, d2 i / D² = 1 − 1/D²`. |
| `isingS_symm` | The Ising S-matrix `½ [[1,√2,1],[√2,0,−√2],[1,−√2,1]]` is symmetric. |
| `isingS_mul_self` | `S * S = 1`, i.e. the Ising modular data is unitary (S is real symmetric). |
| `isingPsi_factor` | For real `s`, `2·4^{−s} − 2^{−s} = 2^{−s}(2^{1−s} − 1)`. |
| `isingPsi_one` | `2·4^{−1} − 2^{−1} = 0`. |
| `su2_4_egyptian` | `1/12 + 1/4 + 1/3 + 1/4 + 1/12 = 1`. |

There is no `sorry`, `axiom`, or `admit`. The proofs use only elementary finite-sum, order, field, real-power, and `3 × 3` matrix facts; `isingS_mul_self` is checked entrywise with `Real.sq_sqrt`.

## What is not formalised

The formal core stops deliberately at the finite algebra. The following are recorded as source claims or open items in the [programme dossier](../README.md), and are **not** Lean theorems here:

- **Category theory / MTC axioms.** There is no formal definition of a modular tensor category, ribbon structure, braiding, fusion rules, or the `S`-matrix of a general MTC. The Egyptian identity is stated for an arbitrary finite family of positive squared dimensions; it does not derive those dimensions from category axioms.
- **Reshetikhin–Turaev invariants.** The braid family `B_N(s)`, the invariant `RT_k`, the normalised limit `Z_k(s)`, and Conjecture 1 (`Z_k → ζ`) are not defined or formalised.
- **The Riemann zeta function and RH.** Nothing about `ζ`, its zeros, the critical line, or the Riemann Hypothesis is formalised. The source's “Topological Zeta Rigidity” is a conditional statement whose hypotheses are open.
- **Galois action and characters.** The permutation `φ_σ`, sign character `ε_σ`, and Galois character `χ_σ` on modular data are not formalised. The Ising polynomial is stated with its character `(1, −1, 1)` already fixed.
- **Completions and functional equations.** The gamma-factor completion `Λ(s)` and the claimed `Λ(s) = εΛ(1−s)` are not formalised. The Python layer shows the source's stated completion does not satisfy the stated equation, so there is nothing correct to formalise at present.
- **The infinite-rank limit.** `SU(2)_k` as `k → ∞`, and the floor/error analysis, are not formalised.
- **Greedy-Egyptian MTCs.** The “hybrid family” of the `greedy-egyptian-mtcs.html` paper has no construction in the source, so it cannot be formalised as stated.

## Why the core is small

The source corpus is mostly a conditional narrative: its central “theorem” assumes Conjecture 1 and an asymmetry lemma that are themselves open, and its claimed numerical verification of the functional equation is not reproducible. Formalising the narrative would amount to axiomatising the conclusion. Instead, this file formalises the genuinely finite statements that the corpus defines precisely — the Egyptian identity and the Ising modular data — and leaves the rest explicitly open. That is the honest boundary of the reconstruction, not a placeholder.

[Back to the programme](../README.md) · [Topic index](../../README.md)
