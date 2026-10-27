# Li's criterion: RH ⟺ λ_n ≥ 0 for all n

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §2 "The carousel: Li's criterion on the rim"

## Statement

> With λ<sub>*n*</sub> = ∑<sub>ρ</sub>[1 − (1−1/ρ)<sup>*n*</sup>], &nbsp; RH &nbsp;⟺&nbsp; λ<sub>*n*</sub> ≥ 0 for all *n* &nbsp;(Li 1997; Bombieri–Lagarias 1999).

The source's scoreboard row states the same criterion as "the carousel (Li): λ<sub>*n*</sub> ≥ 0 for all *n*".

## Hypotheses and notation

- ρ runs over the non-trivial zeros of ζ; the Möbius map of §2, equation (2), is ρ ⟼ *z*<sub>ρ</sub> = 1 − 1/ρ, with |*z*<sub>ρ</sub>| = |ρ−1|/|ρ| = 1 ⟺ Re ρ = ½.
- λ<sub>*n*</sub> are the Li coefficients.
- On the critical line each conjugate pair contributes 2(1 − cos *n*θ<sub>ρ</sub>) ≥ 0; a pair off the line has one image inside and one outside the unit circle, and the outside image's powers grow exponentially and eventually drag λ<sub>*n*</sub> to −∞.

## Proof / evidence

The source cites the criterion (Li 1997; Bombieri–Lagarias 1999) without proof, and reports two independent computations: λ<sub>*n*</sub> by contour integration of log ξ around *s* = 1 (no zero used) and as ∑2(1−cos *n*θ) over the 138 zeros plus an integrated tail, agreeing to a ratio 1.0001 for *n* ≤ 24, with λ₁ hitting the exact arithmetic value 1 + γ<sub>E</sub>/2 − ½ln 4π = 0.0230957… to 10<sup>−10</sup>. A hypothetical pair at σ = 0.7, γ = 2 (images |*z*| = 1.0478 and 0.9544) is exhibited whose joint contribution turns λ negative at *n* = 12.

## Dependencies and related results

- [The one constant on three dials](rh10-lambda-one-three-dials.md) — the same λ₁, harvested where the source states the identity in §5.
- [Weil positivity criterion](rh10-weil-positivity-criterion.md) — the pairing instrument of §1.
- The source's §2 computation is the numerical face of the explicit formula "in coefficient form" (the contour never sees a zero, the zero-sum never sees ζ).

## Notes

- Classical (Li 1997; Bombieri–Lagarias 1999); the source gives no proof.
- The source's own reading: "the criterion's real content is not that the terms are positive but that the arithmetic side (the contour) keeps matching a sum that would be poisoned by a single point off the rim."
