# The recursion prints the zeros: the maximum-entropy spectrum's poles are the ordinates

**Kind:** Theorem
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh16.html`](../../html/rh16.html) — §2 "The recursion prints the zeros", equation (1)

## Statement

> The Levinson recursion produces, along with the reflection coefficients, a prediction filter A(z) = 1 + ∑a<sub>i</sub>z<sup>i</sup> — the polynomial that best annihilates the kernel. Its reciprocal is the maximum-entropy (Burg) spectral estimate,
>
> S(θ) = σ<sub>*n*</sub>²/|A(e<sup>*i*θ</sup>)|², &nbsp;&nbsp; θ = *r*Δ,
>
> and its poles are the frequencies the filter has locked onto. Since the kernel's frequencies *are* the zero ordinates, the poles should be the zeros. They are — and not approximately.

and, quantitatively: "Every one of the 30 ordinates below the band edge is recovered, to a median 4.9×10<sup>−4</sup> — against the slice's own Fourier resolution cell π/a = 0.526, a superresolution of 1081×."

## Hypotheses and notation

- The filter A is the Levinson prediction filter of rh15's recursion on the kernel E; σ<sub>*n*</sub>² is the terminal prediction error; θ = *r*Δ is the frequency variable on the mesh.
- The spectrum is built at mesh Δ = 0.03 (399 nodes) from 18120 prime powers and the Γ-factor — no zero consulted.
- The band edge is r &lt; 103.7; the true ordinates below it number 30.

## Proof / evidence

The source describes the construction and reports the comparison: the recovered lines against the true ordinates, median error 4.9×10<sup>−4</sup> against the Fourier cell π/a = 0.526 (superresolution 1081×), with a zoom on γ₁ = 14.134725 showing the recovered line 5.7×10<sup>−4</sup> away. It also reports the free-run check: fit the filter on v ≤ 6 only, free-run it across 398 steps, and it reproduces the kernel on 6 < v ≤ 12 to 16% of the kernel's own rms, with one-step prediction there exact to 1.7%. The source's own caution is explicit: "this is a reconstruction, not a proof. The recursion recovers the ordinates of the measure whose Fourier transform E is — which is what Verblunsky's theorem promises, and it presupposes that E is the transform of a positive measure on the line. That the recovered ordinates are real is a consequence of the computation, not an independent verification of RH."

## Dependencies and related results

- [The selection rule: precision 1.000, recall 1.000](rh16-selection-rule-precision-recall.md) — how the true lines are told from the ripples, using no zero.
- [The widest positivity certificate](../rh15/rh15-widest-positivity-certificate.md) and [RH ⟺ the Schur sequence never leaves the open unit disc](../rh15/rh15-rh-equivalent-schur-sequence.md) — the recursion being inverted.
- [The merged kernel: one function, two theories](../rh14/rh14-merged-kernel-one-function.md) — the kernel E.

## Notes


- The map from primes to zeros is run numerically in one direction ("to four decimal places, by an O(n²) recursion on 399 numbers"); the source calls the constructive content "genuinely new" but does not present it as a proof of RH.
- The free-run check (16% of rms on unseen ground, one-step prediction to 1.7%) is the source's guard against the estimate flattering itself.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
