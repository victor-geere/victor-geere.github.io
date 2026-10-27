# Lean formal core — Global Harmonic Framework

## Build

```bash
the-final-letter/topics/proof-99-global-harmonic-framework/lean/check.sh
```

The wrapper calls the shared `tools/check-lean.sh`, which elaborates against the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is defined

`Topic.lean` opens the namespace `GHF` and defines:

| Name | Definition |
|---|---|
| `GHF.a` | `a n = 1 / sqrt(n(n+1))` |
| `GHF.b` | `b n = 1 / (n+1)` |

These are the two coefficient sequences from Definition 2.1 of the source. The kernel `K = I + |a⟩⟨b|`, the diagonal weighting `D(s)`, and the weighted Gram operator `M(s)` are used through their finite matrix instantiations (`Matrix.replicateCol`/`replicateRow`, `Matrix.diagonal`) rather than as new definitions.

## What is proved

| Lean name | Statement |
|---|---|
| `GHF.a_pos` | `0 < a n` for `n ≥ 1` |
| `GHF.b_pos` | `0 < b n` for every `n` |
| `GHF.b_lt_a` | `b n < a n` for `n ≥ 1` |
| `GHF.telescoping` | `Σ_{k=1}^{N} 1/(k(k+1)) = N/(N+1)` |
| `GHF.telescoping_tendsto` | that sum tends to `1` as `N → ∞` |
| `GHF.det_rank_one` | `det(I + |a⟩⟨b|) = 1 + Σ bᵢaᵢ` |
| `GHF.det_diagonal_sq_pos` | `D = diag(d)`, all `dᵢ > 0` ⇒ `det(D·D) > 0` |

The determinant lemma is Mathlib’s `Matrix.det_one_add_replicateCol_mul_replicateRow` (the `A = I` case of the matrix determinant lemma), applied to the source’s rank-one kernel. `det_diagonal_sq_pos` is the finite form of the statement that the diagonal factor of `det(I − M(s))` is a positive real on the critical line.

No `sorry`, `axiom`, or `admit` occurs in the file. There is no vacuous `rfl` padding: each theorem is an inequality, a telescoping identity, a limit, or a determinant computation used by the source’s construction.

## What is **not** formalised, and why

The source’s substantive claims are global analytic statements. They are outside this formal core and are recorded in the programme dossier as **Source claim** or **Open**:

1. **Trace class of `M(s)`** on `ℓ²(ℕ)`. The source’s estimate `Σ (n+2)^(−(2Re(s)+1)) < ∞` is elementary, but formalising trace-class operators and Fredholm determinants was not attempted here.
2. **The Mayer–Ruelle similarity theorem** `U M(s) U* = 𝓛_s`. The source admits the appendix only reaches the equality “up to a diagonal trace-class correction”, and the cited Technical Report is not available.
3. **The determinant identity** `det(I − 𝓛_s) = ζ(s)/ζ(2s) e^{Q(s)}`. This is an external classical theorem; neither `ζ` nor `𝓛_s` is formalised.
4. **Self-adjointness of `M̃_t`.** The source asserts that `K` is symmetric. For the `K` it defines, this is false: `K₁₂ − K₂₁ = a₁b₂ − a₂b₁`, which is strictly positive by `GHF.b_lt_a` together with `GHF.a_pos`/`GHF.b_pos`. The Python test `test_canonical_kernel_is_not_symmetric` computes this defect exactly. Thus the route from `M_t` to a self-adjoint operator is not merely unformalised — the stated construction does not have the required symmetry.
5. **Birman–Krein, the mismatch function, the argument principle, and `N₀(T) = N(T)`.** These are analytic and conditional; the source’s own `O(log T)` integer argument is not a proof as written.
6. **The Riemann Hypothesis.** Recorded as an archived claim only. Nothing in this file asserts or implies it.

The formal core therefore represents the finite spectral/algebraic bookkeeping of Sections 3–4 and 8.3 of the source, not its global conclusion.

[Back to the programme](../README.md) · [Topic index](../../README.md)
