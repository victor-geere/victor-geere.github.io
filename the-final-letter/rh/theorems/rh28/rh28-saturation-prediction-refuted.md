# (c) What saturates — a prediction, refuted

**Kind:** Claim
**Status:** REFUTED (prediction)
**Area:** rh-html
**Source:** [`rh28.html`](../../html/rh28.html) — §4 "(c) What saturates — a prediction, refuted"

## Statement

> rh27c measured λ<sub>min</sub>/E<sub>h</sub>(0) at five supports — 0.041, 0.115, 0.285, 0.273, 0.299 — and called it out as a climb that stops: "what limits the narrow end is not the archimedean ceiling but something about the section's own spectrum, and this document does not know what."
>
> **The prediction.** rh27c varied the support and the mesh together, taking the mesh equal to the support at depth 18. So its n was 18/Δ′ + 1 and grew as the support narrowed: 39, 76, 151, 301, 601. Two variables moved at once, and the obvious reading is that the flattening is a section-length effect … so the ratio should rise and settle for reasons that have nothing to do with the support.
>
> **The test.** Take the single support Δ′ = 0.03 and slice its own row to the same five lengths, 39, 76, 151, 301 and 601. If the effect is section length, the curve should reappear.
>
> ```
> n =  39   v = 1.14    λ_min = 8.6831×10⁻²   λ_min/min F_n = 0.997
> n =  76   v = 2.25    λ_min = 8.3874×10⁻²   λ_min/min F_n = 0.992
> n = 151   v = 4.50    λ_min = 7.2728×10⁻²   λ_min/min F_n = 0.951
> n = 301   v = 9.00    λ_min = 5.0013×10⁻²   λ_min/min F_n = 0.958
> n = 601   v = 18.00   λ_min = 2.8347×10⁻²   λ_min/min F_n = 0.886
> ```
>
> **It does not.** The ratio is flat and near 1 where the cross-support version climbed from 0.363, and it moves the *other* way — the Fejér ceiling is tightest on the shallowest slice and loosens as the section deepens, where across supports at fixed depth it tightens as the mesh refines. The prediction was wrong, and it was wrong in the informative direction: the two variables are not interchangeable, and a short section on a fine mesh is a completely different object from a short section on a coarse one.

## Hypotheses and notation

- The single support Δ′ = 0.03, sliced to n = 39, 76, 151, 301, 601 at depths v = 1.14, 2.25, 4.50, 9.00, 18.00.
- λ<sub>min</sub>/min F<sub>n</sub> is the eigenvalue divided by the Fejér minimum of the same section.
- rh27c's cross-support measurements were 0.041, 0.115, 0.285, 0.273, 0.299 (a climb that flattens).

## Proof / evidence

Numerical: the five sliced ratios 0.997, 0.992, 0.951, 0.958, 0.886 are flat and near 1, against the cross-support climb from 0.363; the source reports the prediction refuted. It also records that "rh27c ruled out the archimedean ceiling; this document rules out the section length", leaving the third obvious answer — that it is a property of the mesh itself — untested.

## Dependencies and related results

- [rh28-fejer-ceiling](rh28-fejer-ceiling.md) — the ceiling used to measure λ<sub>min</sub>/min F<sub>n</sub>.
- [rh27c-power-law-refuted](../rh27c/rh27c-power-law-refuted.md) — the earlier refutation of a different explanation of the same saturation.

## Notes

- The source flags a post-hoc correspondence: three independent quantities (both ceiling ratios and the depth secant) flatten at Δ′ = 0.12. It states plainly that "three flat points are not evidence, and no mechanism is proposed".
- The source is explicit that the honest statement is two separate results: §3 gives a much better ceiling, §4 does not explain the saturation.
