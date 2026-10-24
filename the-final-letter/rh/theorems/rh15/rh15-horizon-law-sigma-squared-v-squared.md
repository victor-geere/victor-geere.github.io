# The horizon law: σ_k²·v² ≈ 3.9×10⁻³, the same at every mesh

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §5 "The equation: one inequality per node"

## Statement

> And the prediction errors, which do decay, decay according to one law that does not mention the mesh at all: σ<sub>k</sub>² ~ c/k² in the index, which is c/v² in the physical horizon v = kΔ, with measured c = 3.91×10⁻³, 4.23×10⁻³, 3.48×10⁻³ across the three meshes — a 22% spread over an 8× change in Δ.

and, from the figure:

> The three recursions — 198, 398 and 798 steps at three different meshes — fall on one curve of slope −2. The mesh cancels; what is left, σ²v² ≈ 3.9×10⁻³, is a property of E itself.

## Hypotheses and notation

- σ<sub>k</sub>² are the prediction errors of the Schur/Levinson–Durbin recursion of §5, equation (4); k is the index, v = kΔ the physical horizon.
- The three meshes are Δ = 0.06, 0.03, 0.015 (198, 398, 798 steps respectively); the fitted constants are 3.91×10<sup>−3</sup>, 4.23×10<sup>−3</sup>, 3.48×10<sup>−3</sup>.
- The law is stated as one that "does not mention the mesh at all".

## Proof / evidence

The source reports the three recursions falling on one curve of slope −2 when σ<sub>k</sub>² is plotted against the physical horizon v = kΔ, with a 22% spread of the constant over an 8× change in Δ; the closing audit gives "σ<sub>k</sub>²(kΔ)² equal to 3.91×10⁻³, 4.23×10⁻³, 3.48×10⁻³ across the three meshes". Rh16 §4 re-runs the same law on Poisson, GUE-like and rigid processes of the same density: it holds to within 20% for all four (ζ 4.24×10<sup>−3</sup>, Poisson 3.99, GUE 3.54, rigid 3.52), which rh16 flags as "an open item rather than a result" — narrowing what an explanation of the constant would have to explain.

## Dependencies and related results

- [RH ⟺ the Schur sequence never leaves the open unit disc](rh15-rh-equivalent-schur-sequence.md) — the recursion whose prediction errors obey the law.
- [The widest positivity certificate](rh15-widest-positivity-certificate.md) — the certified run at the finest mesh.
- [The notch law cannot tell which process it is looking at](../rh16/rh16-notch-law-process-blind.md) — rh16's surrogate-process test of this law.
- [The detector's sensitivity curve](../rh16/rh16-detector-sensitivity-curve.md) — rh16 uses the 1/v² falloff to explain why inconsistency is visible early.

## Notes


- The law is an empirical regularity of the computed recursions (three meshes, 198/398/798 steps), stated in the source as a property of E; rh16's surrogate test shows it is largely a property of the density.
- The source uses it as the currency for this document's headline numbers: "This document's own headline numbers are stated in the one currency that survived the audit: reflection coefficients, their margins, and the horizon law σ²v² ≈ 3.9×10⁻³."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
