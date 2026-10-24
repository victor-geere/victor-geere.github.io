# The notch-free windows fail one refinement earlier (prediction refuted)

**Kind:** Claim
**Status:** REFUTED (prediction)
**Area:** rh-html
**Source:** [`rh26.html`](../../html/rh26.html) — §3 "(b) The wall was the cut", eq. (3)

## Statement

> rh25 §3 built windows with no notch. Û<sub>c</sub>(r) ≥ 2c(cosh cδ − 1)/(sinh cδ (c² + r²)) > 0 at every real r, the coefficients constrained by Fejér–Riesz so that A = |B|² has no real zero either, and the resulting windows lose nothing on the Δ lattice. If rh18's diagnosis were the whole story they should walk through the sub-lattice. **They do not.** At equal depth v = 18, with the archimedean integral cut at R₀ = 600 exactly as every certificate in the arc has cut it:
>
> ```
> triangle hat      Δ/2 4.104×10⁻¹¹  ·  Δ/4 8.739×10⁻¹²  ·  Δ/8 -3.673×10⁻⁷
> notch-free M = 8  Δ/2 2.863×10⁻⁴  ·  Δ/4 -3.439×10⁻⁴  ·  Δ/8 -7.708×10⁻⁴
> notch-free M = 16 Δ/2 1.096×10⁻³  ·  Δ/4 -1.865×10⁻³  ·  Δ/8 -5.717×10⁻³
> ```
>
> The notch-free windows, which are eight orders better than the hat on the Δ lattice, fail one refinement *earlier* than it. The prediction that brought this document here is refuted, and refuted in the direction that says the notch was not what was in the way.

The source's own summary of the refuted prediction: "The prediction that took this document there — that rh25's notch-free windows would survive where the hat did not — is <i>refuted</i>; at R₀ = 600 they fail one level sooner."

## Hypotheses and notation

- R₀ = 600, the archimedean cut used by every certificate in the arc.
- Equal depth v = 18 for all five windows.
- Δ is the base mesh; the sub-lattices are Δ/2, Δ/4, Δ/8.
- The five windows: triangle hat, rh25's searched spline optima at M = 8 and M = 16, and rh25's searched notch-free optima at the same two meshes.
- The tabulated number at each (window, sub-lattice) is λ<sub>min</sub> of the certified kernel; a negative entry is an indefinite section.

## Proof / evidence

The source computes (3) from the same pass over the 6,448,870 prime powers below 112,672,958 that rh22–rh25 used, through rh25's tabulated generators, and states that the prediction is reported as refuted and carries its own assertion in the check suite ("a future change which quietly made it true would fail the suite"). No proof of the refutation beyond the computation is offered.

## Dependencies and related results

- [rh26-one-sided-cut](rh26-one-sided-cut.md) — the lemma that explains why the cut manufactures the negative eigenvalues seen here.
- rh18's sub-lattice closure and its diagnosis that the mesh's own notch r* = 2π/Δ was the cause; rh25 §3's notch-free windows.

## Notes

- This is a refuted prediction, not a theorem the source asserts; it is harvested as a stated result because the source reports it as one of the document's findings and marks it refuted.
- The same table is also summarised in rh26's abstract with the numbers listed above.
