# The one constant on three dials: λ₁ = 1 + γ_E/2 − ½ ln 4π = ∑ 1/(¼+γ²)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §5 "One constant, three dials", equation (6)

## Statement

> λ₁ = 1 + γ<sub>E</sub>/2 − ½ ln 4π = ∑<sub>γ>0</sub> 1/(¼+γ²) = 0.0230957… ,
>
> verified here in both directions: the arithmetic value from the contour integral to 10<sup>−10</sup>, and the zero-sum from the 138 ordinates plus an integrated tail to 3×10<sup>−6</sup>.

## Hypotheses and notation

- γ runs over the positive imaginary parts of the non-trivial zeros; γ<sub>E</sub> is Euler's constant.
- λ₁ is the first Li coefficient (§2); 2λ₁ = 2+γ<sub>E</sub>−ln 4π is the conjectured Beurling–Nyman decay constant (§4); the same λ₁ is the total weight ∑1/|ρ|² that sets the overall scale of the pairing's spectral side (§1).

## Proof / evidence

The source gives the arithmetic evaluation (the contour integral of log ξ around *s* = 1, no zero consulted) and the zero-sum (the 138 ordinates plus an integrated tail), which agree in both directions: contour value to 10<sup>−10</sup>, zero-sum to 3×10<sup>−6</sup>. The closing audit of the page states: "λ₁ from the contour equal to 1+γ<sub>E</sub>/2−½ln 4π to 10<sup>−10</sup>" and "the three-dial constant ∑1/(¼+γ²) = λ₁ from zeros plus integrated tail to 3×10<sup>−6</sup>, with 2+γ<sub>E</sub>−ln 4π = 2λ₁ exactly".

## Dependencies and related results

- [Li's criterion](rh10-li-criterion.md) — λ₁ is the first Li coefficient; the same computation appears in §2 (value to 10<sup>−10</sup>).
- [The Beurling–Nyman criterion](rh10-beurling-nyman-criterion.md) — 2λ₁ is the conjectured decay constant 2+γ<sub>E</sub>−ln 4π.
- The source notes the arc "met it before without naming it — it is what the carry-register noise of rh6 §3 integrates to at the bottom of the tower."

## Notes

- The identity is stated and verified in both directions; the source treats the numerical agreement (10<sup>−10</sup> and 3×10<sup>−6</sup>) as its evidence, and does not write out a proof.
- The audit closes with an exact statement for the double: 2+γ<sub>E</sub>−ln 4π = 2λ₁ exactly.
