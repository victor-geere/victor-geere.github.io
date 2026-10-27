# rh9-lean

A Lean 4 / Mathlib4 formalisation of **rh9.tex**: *The Riemann Hypothesis as a
Purely Geometric Condition on a Space Curve*.

## Mathematical content

The paper proves that RH is equivalent to the equality of two torsion distributions:

| Object | Definition |
|---|---|
| Phase function φ | Smooth, strictly increasing, φ(γₙ) = 2πn |
| Unit helix C₁ | C₁(t) = (cos φ(t), sin φ(t), t) |
| Radius function r | Smooth, r(γₙ) = βₙ |
| Variable-radius helix Cᵣ | Cᵣ(t) = (r·cos φ, r·sin φ, t) |
| τ₀ | Von Mangoldt distribution: Σ log p · δ(t − m log p) |
| **Theorem 3.1** | RH ⟺ ∃ smooth r : tors_r = tors₁ in D'(ℝ) |

## Project structure

```
RH9/
├── Zeros.lean           -- ZeroData: γₙ, βₙ and their properties
├── PhaseFunction.lean   -- φ with φ(γₙ) = 2πn
├── RadiusFunction.lean  -- r with r(γₙ) = βₙ; constHalf for RH case
├── Curves.lean          -- C₁ and Cᵣ; smoothness; zero-encoding properties
├── Torsion.lean         -- Torsion formulas (1) and (2); key scaling lemma
├── Distributions.lean   -- τ₀; distributional limit axioms; Weil formula interface
└── MainTheorem.lean     -- Theorem 3.1: RH ⟺ geometric torsion condition
```

## Status of proofs

| Lemma / Theorem | Status |
|---|---|
| C₁ is smooth | ✓ proved |
| Cᵣ is smooth | ✓ proved |
| C₁(γₙ) = (1, 0, γₙ) | ✓ proved |
| Cᵣ(γₙ) = (βₙ, 0, γₙ) | ✓ proved |
| r constant ⟹ r' = 0 | ✓ proved |
| Functional equation ⟹ c = 1/2 | ✓ proved |
| PhaseFunction.exists | `sorry` — needs interpolation theory |
| RadiusFunction.exists | `sorry` — needs Whitney extension |
| torsionᵣ = torsion₁ when r constant | `sorry` — algebraic computation |
| Distributional limit = τ₀ | `axiom` — Weil explicit formula |
| Extra singularities from non-const r | `axiom` — distribution theory |
| r' = 0 at prime-power logs | `sorry` — uses the axiom above |
| Constant-on-dense ⟹ constant | `sorry` — density of prime-power logs |

## Building

```bash
# Install Lean 4 and Lake (https://leanprover.github.io/lean4/doc/setup.html)
cd rh9-lean
lake update          # downloads Mathlib4 (~2 GB, first time only)
lake build           # compiles all files
```

If the toolchain version in `lean-toolchain` is stale, update it to match the
current Mathlib4 release and re-run `lake update`.

## Filling the gaps

The two `axiom` statements in `Distributions.lean` represent the deepest mathematical
content: the Weil explicit formula connecting torsion₁ to the von Mangoldt distribution,
and the distributional calculus of the extra terms in tors_r.

The `sorry` statements in `Torsion.lean` (the scaling lemma) and `MainTheorem.lean`
(the density argument) are more elementary and could be completed with further work.
