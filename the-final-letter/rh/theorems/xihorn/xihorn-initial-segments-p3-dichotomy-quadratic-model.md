# Proposition 3 (dichotomy in the quadratic model)

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §6 "The Turán refinement — what ξ's known coefficient facts do and do not repair"

## Statement

> **Proposition 3 (dichotomy in the quadratic model).** In the family
> (z² + bz + c)e^z with all a(m) > 0: if b ≥ −1 (center x₀ = −b/2 ≤ ½), every
> E(d) is an initial segment.

## Hypotheses and notation

- The family is `f(z) = (z² + bz + c)e^z`, with all Taylor coefficients
  `a(m) > 0`. It is [gorz-gap.md](../../xi-horn/gorz-gap.md)'s exactly solvable family §7.1.
- Center `x₀ = −b/2`; height `β₀`; the closed form is gorz-gap (13), rewritten
  as in [initial-segments.md](../../xi-horn/initial-segments.md) §4: on **alive** shifts
  `D(n) = ⌊r(n)⌋ + 1` with
  ```
  r(n) = 1 + x₀(n)²/β_n² ,   x₀(n) = x₀ − n ,   β_n² = β₀² − n .
  ```
- "Initial segment" as in [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md): n ∈ E(d) and m < n imply
  m ∈ E(d).
- The Turán property of the sequence is `E(2) = ∅` (used by
  [Proposition 4](xihorn-initial-segments-p4-turan-forces-tame-half.md)).

## Proof / evidence

The source's proof, verbatim: "On alive shifts D(n) = ⌊r(n)⌋ + 1 with
r(n) = 1 + x₀(n)²/β_n² (gorz-gap (13), rewritten as in §4). x₀ ≤ ½ makes
x₀(n)² = (x₀ − n)² non-decreasing over integers n ≥ 0, β_n² is strictly
decreasing, so r is strictly increasing, D is non-decreasing, and sublevel sets
of a non-decreasing function are initial segments. ∎"

## Dependencies and related results

- [gorz-gap.md](../../xi-horn/gorz-gap.md) §7.1 (the solvable family) and its closed form (13);
  [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md) (the equivalence with D non-decreasing).
- Combined with [Proposition 4](xihorn-initial-segments-p4-turan-forces-tame-half.md): "positivity + Turán ⟹ b ≥ −1 ⟹
  (Proposition 3) every E(d) is an initial segment: **in the quadratic model,
  the Turán property repairs the initial-segment property.**"
- §6 records that the repair does not survive past the model: over 4 000 random
  log-concave positive sequences, **3 923 have a gap** in some E(d), d ≤ 7
  (gaps are generic among log-concave sequences); and no Turán-respecting gap
  was found inside the class.

## Notes

- The dichotomy's other half is stated separately: "if b ≥ −1 (center
  x₀ = −b/2 ≤ ½), every E(d) is an initial segment"; the complementary regime
  b < −1 is [Proposition 4](xihorn-initial-segments-p4-turan-forces-tame-half.md)'s conclusion (E(2) ≠ ∅).
- The refined class question — "does positivity + genus 1\* + Turán imply every
  E(d) is an initial segment?" — is **open**: "proved in the simplest family,
  false just outside the class, no counterexample inside it."
