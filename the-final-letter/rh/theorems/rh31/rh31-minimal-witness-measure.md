# The dual witness at c = λ<sub>min</sub>

**Kind:** Proposition
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §2 "The uniform content", lines 365–382 and boxed table at lines 373–377

## Statement

> At the extreme c = λ<sub>min</sub> the matrix T<sub>n</sub> − λI is singular, and the representing measure ν is supported on the circle roots of its kernel vector's polynomial. Constructed at Δ′ = 0.12: at n = 24 the minimal eigenpolynomial has 23 roots on the circle; they come in mirror pairs because the row is real, and fold to 12 atoms on the half-circle. Solving the moment equations on those atoms:
>
> n = 12   11 circle roots → 6 folded atoms   min weight 6.8×10<sup>−4</sup>   mass 0.018830 = E<sub>h</sub>(0) − λ<sub>min</sub>   moment residual 3.6×10<sup>−15</sup>
> n = 24   23 circle roots → 12 folded atoms   min weight 2.0×10<sup>−3</sup>   mass 0.061929 = E<sub>h</sub>(0) − λ<sub>min</sub>   moment residual 6.1×10<sup>−16</sup>
> n = 40   39 circle roots → 20 folded atoms   min weight 2.4×10<sup>−3</sup>   mass 0.112653 = E<sub>h</sub>(0) − λ<sub>min</sub>   moment residual 1.2×10<sup>−15</sup>
>
> Every weight strictly positive — no pruning, no sign repair, once the mirror fold is made. Moments matched to machine. Mass exactly E<sub>h</sub>(0) − λ<sub>min</sub>.

The source's geometric reading:

> The witness's atoms sit on the heavy atoms of μ — median distance 0.018 against a heavy-atom spacing of 0.105 — because ν must reproduce the oscillating moments, and those come from where μ's mass is. What is left over after ν has claimed the atoms it can resolve is uniform, and that remainder is the certificate.

## Hypotheses and notation

- T<sub>n</sub> − cI with c = λ<sub>min</sub> is singular; its kernel vector's polynomial has its roots on the circle, in mirror pairs, folding to atoms on the half-circle.
- ν is the representing positive measure of the remainder row, with total mass E<sub>h</sub>(0) − λ<sub>min</sub>.
- Constructed at Δ′ = 0.12 with the arc's search window; the moment residual is the mismatch of the first n moments.
- "heavy atoms of μ" refers to the atoms of rh29's measure.

## Proof / evidence

Paper argument (the construction) plus numerical verification: all weights strictly positive after the mirror fold, moments matched to machine (residuals 3.6×10<sup>−15</sup>, 6.1×10<sup>−16</sup>, 1.2×10<sup>−15</sup>), and the mass exactly E<sub>h</sub>(0) − λ<sub>min</sub> in all three cases.

## Dependencies and related results

- [rh31-carathodory-toeplitz-restated](rh31-carathodory-toeplitz-restated.md) — supplies the singular T<sub>n</sub> − λI and the representing-measure reading.
- [rh29-symbol-is-an-atomic-measure](../rh29/rh29-symbol-is-an-atomic-measure.md) — the measure μ whose heavy atoms the witness sits on.
- [rh31-fejer-ceiling-dominates-lambda-min](rh31-fejer-ceiling-dominates-lambda-min.md) — §5's density reading of the same remainder.

## Notes

- The source presents this as the finite-n content missing from the Carathéodory–Toeplitz theorem: "What was missing is what the draining looks like at finite n, and that is constructible."
- The numbers depend on the arc's zero-side (RH-conditional) measure, even though the Carathéodory–Toeplitz theorem itself is unconditional.
