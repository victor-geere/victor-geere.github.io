# The Beurling–Nyman criterion: RH ⟺ d_N → 0

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §4 "The ruler: writing 1 with fractional parts", equation (4)

## Statement

> d<sub>*N*</sub> = dist<sub>L²</sub>&#8202;(1, span{ρ(1/*nx*) : *n* ≤ *N*}), &nbsp;&nbsp; RH &nbsp;⟺&nbsp; d<sub>*N*</sub> → 0
>
> (Nyman 1950, Beurling 1955; the restriction to *n* ≤ *N* is Báez-Duarte's).

The scoreboard row states it as "the ruler (Beurling–Nyman): d<sub>*N*</sub> → 0 ⟺ RH".

## Hypotheses and notation

- The ambient space is L²(0,1); 1 is the constant function; ρ(1/*nx*) are the fractional-part dilates.
- span{ρ(1/*nx*) : *n* ≤ *N*} is the *N*-term span; d<sub>*N*</sub> is the distance from 1 to it.
- Every inner product needed is computed exactly, by piecewise integration between consecutive breakpoints of the fractional parts.

## Proof / evidence

The source cites the criterion (Nyman 1950, Beurling 1955; Báez-Duarte's truncation) without proof. It reports the computation: the classical check ∫₀¹ρ(1/*x*)d*x* = 1 − γ<sub>E</sub> reproduced to 10<sup>−6</sup>; the Gram system gives d₁ = 0.5606, d₂ = 0.4160, d₃ = 0.2745, …, d₂₀ = 0.1269, strictly decreasing. The source also states the conjectured decay law d<sub>*N*</sub>² ~ (2+γ<sub>E</sub>−ln 4π)/ln *N* (Báez-Duarte–Balazard–Landreau–Saias; Burnol) and notes that convergence is logarithmic, so no numerical run approaches 0.

## Dependencies and related results

- [The one constant on three dials](rh10-lambda-one-three-dials.md) — λ₁, whose double 2λ₁ = 2+γ<sub>E</sub>−ln 4π is the conjectured decay constant of this criterion.
- rh5 §6 is the source's earlier treatment; the restriction to *n* ≤ *N* is Báez-Duarte's.
- [Weil positivity criterion](rh10-weil-positivity-criterion.md) — the pairing instrument of the same document.

## Notes

- Classical literature; the source gives no proof.
- The source's reading: "the distance is the gap-filling axiom of the geometry, made into one number."
