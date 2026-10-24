# Corollary — a family that generates has infimum 0

**Kind:** Corollary
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/positivity-generator.md`](../../xi-horn/positivity-generator.md) — §4, immediately after Theorem 2

## Statement

> **Corollary.** A family that generates has infimum 0. Equivalently: **a
> certificate with a positive floor is, by exactly that floor, blind above a
> computable height.**

## Hypotheses and notation

- Same setting as [Theorem 2](xihorn-positivity-generator-t2-no-finite-family.md): V a finite-dimensional span of test
  functions with each `F_i = f̂_i` entire and `F_i(z) → 0` as `|Re z| → ∞`
  uniformly on `|Im z| ≤ ½`; `λ_min(V) > 0` the smallest eigenvalue of W
  restricted to V.
- "Floor" = a positive lower bound `λ_min` certified for the restricted form;
  "generates" = positivity on the family implies positivity on the whole
  admissible cone.
- The blindness height is the `T*(V)` of Theorem 2, above which an off-line zero
  quadruple at `γ = ±a ± iδ` does less damage than the floor.

## Proof / evidence

Immediate from [Theorem 2](xihorn-positivity-generator-t2-no-finite-family.md): the rank-2 perturbation contributed by
the quadruple has operator norm at most
`4N·max_i sup_{|Im z| ≤ ½, |Re z| = a} |F_i(z)|² → 0` as `a → ∞`, so above the
finite `T*(V)` it is smaller than any positive `λ_min(V)`, and the form stays
positive definite while the zero configuration is off the line. A family that
does generate therefore cannot have a positive floor.

The source adds the computed price of the corollary (§4.1, σ = 0.05,
lattice spacing Δ = 0.5, floor = `λ_min` of the section):

```
  n    v_max   floor          δ = 0.10 (β = 0.60)   δ = 0.25 (β = 0.75)   δ = 0.40 (β = 0.90)
   6   2.5     1.1128e−02     blind at every γ      blind above γ = 7.75  blind above γ = 21.5
  10   4.5     2.2730e−03     blind above γ = 24.25 blind above γ = 37.75 blind above γ = 41.25
```

## Dependencies and related results

- [Theorem 2 (no finite family)](xihorn-positivity-generator-t2-no-finite-family.md), of which this is the immediate
  corollary.
- Reappears in §7 as the explanation of the moment tower's decaying floors:
  "Theorem 2's corollary again, in the coordinates where the tower is a moment
  problem rather than a Toeplitz section."
- Dictionary entry "the margin is the blindness": "a finite family with floor
  λ_min > 0 survives any zero quadruple whose damage is smaller — so it is blind
  above a computable height, and a family that generates must have infimum 0. A
  bigger certified floor is a smaller reach."

## Notes

- The source states the corollary without a separate proof beyond the sentence
  "Hence `W|_V ⪰ 0` is compatible with off-line zeros, and no finite family
  generates" following Theorem 2's proof; the argument above is that proof read
  as a corollary.
- The two sentences of the corollary are presented by the source as equivalent
  formulations, the second being the operational reading: a positive floor *is*
  a computable blindness height.
