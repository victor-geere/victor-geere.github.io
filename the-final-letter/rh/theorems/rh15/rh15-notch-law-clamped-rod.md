# The notch law: λ_min ≈ (Δ/16π⁴)·(ζ(4)ln(1/Δ) − ζ′(4))/π · λ_min(R_n)

**Kind:** Proposition
**Status:** VERIFIED (numerical; parameter-free law derived from the notch picture; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §3 "The first tail: the instrument's own null", equation (3)

## Statement

> λ<sub>min</sub> ≈ (Δ/16π⁴) · (ζ(4)ln(1/Δ) − ζ′(4))/π · λ<sub>min</sub>(R<sub>*n*</sub>), &nbsp;&nbsp; R<sub>*n*</sub>[j,k] = ∫<sub>−π</sub><sup>π</sup> θ⁴e<sup>−*i*(j−k)θ</sup>dθ
>
> with no free constant anywhere — the mesh, the clamped rod, ζ(4) and ζ′(4), and nothing else. Against 17 measured slices spanning four decades it lands with geometric mean ratio **0.585** and a spread of 0.14–1.59.

## Hypotheses and notation

- The slice's quadratic form is x<sup>T</sup>Gx = ∑<sub>γ</sub>|B(γ)|²·|P(γ)|², P(r) = ∑<sub>j</sub>x<sub>j</sub>e<sup>*irj*Δ</sup>; the mesh profile is |B(r)|² = Δ²sinc⁴(rΔ/2), which vanishes to fourth order at r = 2πk/Δ (the mesh's own nulls).
- Near the k-th null, |B(2πk/Δ + s)|² = Δ⁶s⁴/(16π⁴k⁴); the symbol restricted to one period is a trigonometric polynomial of degree m ≈ a/Δ; minimising ∑s⁴|P|² against the zero density at the nulls is the fourth-moment problem on the circle, whose Toeplitz bottom eigenvalue tends to 2πκ₁⁴/n⁴ with κ₁ = 4.730040… the clamped-rod constant.
- R<sub>n</sub> is the Toeplitz matrix of the symbol θ⁴ on the circle.

## Proof / evidence

The source derives the law from the notch picture ("The law follows from the same picture with no fitting") and tests it: against 17 measured slices spanning four decades it lands with geometric mean ratio 0.585 and a spread of 0.14–1.59; the ratio λ<sub>min</sub>(R<sub>n</sub>)/(2πκ₁⁴n<sup>−4</sup>) runs 0.607, 0.761, 0.886, 0.941, 0.970, 0.985 as n goes 11 → 399. The closing audit gives "the law's geometric mean ratio 0.585 over the support ladder and 0.669 over the mesh sweep, and the scatter widening from 3.2× to 6.7× across the predicted crossover a* = ln(1/Δ)/2".

## Dependencies and related results

- [The crossing form: signature (25, 0, 0)](../rh13/rh13-crossing-form-signature.md) and [the nested-slice exhaustion is positive](../rh14/rh14-nested-slice-exhaustion-positive.md) — the λ<sub>min</sub> ladder the law describes.
- [The merged kernel: one function, two theories](../rh14/rh14-merged-kernel-one-function.md) — E, whose slices carry the nulls.
- rh16 §4 re-runs this law on Poisson, GUE-like and rigid processes and finds it cannot tell which process it is looking at.

## Notes


- The law describes the instrument (the hat / the mesh's own null), not ζ; the source's reading: "Any observable read off the bottom of a slice's spectrum is reading the sampling scheme. That is worth knowing before one reads too much into a 10⁻¹³."
- The derivation is heuristic (the fourth-moment reduction with the zero density at the nulls); the status records the numerical comparison rather than a proof.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
