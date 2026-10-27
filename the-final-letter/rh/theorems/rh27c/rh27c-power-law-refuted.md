# (d) The prediction, and the test — the power law is gone

**Kind:** Claim
**Status:** REFUTED (rh27b's Δ′<sup>−1.7111</sup> power law); VERIFIED (numerical, the test exponents)
**Area:** rh-html
**Source:** [`rh27c.html`](../../html/rh27c.html) — §5 "(d) The prediction, and the test"

## Statement

> **The prediction.** (5) bounds λ<sub>min</sub>/C<sub>h</sub>(0) by ln((2+S)/2π) + 4 sinh Δ′ with S = ‖h′‖/‖h‖. For a family at fixed M, S is proportional to 1/Δ′ — measured 352, 714, 1230 at the three supports here — so the ceiling grows like **ln(1/Δ′)**. A power cannot stay under a logarithm. Extrapolating rh27b's law and its ceiling side by side, they cross between Δ′ = 0.06 and 0.03: at 0.06 the law wants 3.15 against a ceiling of 4.98, and at 0.03 it wants 10.30 against 5.40. So the exponent must break by Δ′ = 0.03, whatever the search finds.
>
> **The test.** Twelve more searches, at Δ′ = 0.12 (the anchor), 0.06 and 0.03, four shapes each, all verified notch-free over a whole period, at depth 18 on sections of 301 and 601 nodes. The triangle row, scale-free, across five supports now:
>
> Δ′ = 0.48  λ<sub>min</sub>/C<sub>h</sub>(0) = 0.0897 · Δ′ = 0.24  λ<sub>min</sub>/C<sub>h</sub>(0) = 0.2913 · Δ′ = 0.12  λ<sub>min</sub>/C<sub>h</sub>(0) = 0.9612 · Δ′ = 0.06  λ<sub>min</sub>/C<sub>h</sub>(0) = 1.1652 · Δ′ = 0.03  λ<sub>min</sub>/C<sub>h</sub>(0) = 1.2794
>
> The dyadic exponents, wide end first: 1.6998, 1.7225, then **0.2776** and **0.1349**.
>
> The power law is gone, and it did not bend gently towards the crossing the ceiling forced — it broke at the first new rung. At Δ′ = 0.03 rh27b's law wants 10.30 and the measurement gives 1.2794, short by a factor of 8.1. The increments in λ<sub>min</sub>/C<sub>h</sub>(0) per halving run 0.670, 0.204, 0.114 — roughly halving themselves, which is what a bounded sequence looks like and not what a power law does. **The bound was sufficient to forbid the law and was not tight about where.**

## Hypotheses and notation

- rh27b's law: λ<sub>min</sub>/C<sub>h</sub>(0) ∝ Δ′<sup>−1.7111</sup> at fixed shape, the two dyadic exponents 1.7225 and 1.6998.
- S = ‖h′‖/‖h‖; for a family at fixed M, S ∝ 1/Δ′, measured 352, 714, 1230 at the three supports of §5.
- The triangle row (θ = 0) is the fixed-shape sequence across five supports.
- "Twelve more searches": four shapes at each of Δ′ = 0.12, 0.06, 0.03, at depth 18 on sections of 301 and 601 nodes, all verified notch-free over a whole period.

## Proof / evidence

Numerical: the five scale-free values and the four dyadic exponents are measured; the ceiling's prediction that the exponent must break by Δ′ = 0.03 is a paper argument from (5) plus S ∝ 1/Δ′. The source states the outcome both ways: "the prediction was right, and the mechanism that actually stops the growth stops it earlier and harder than the ceiling requires."

## Dependencies and related results

- [rh27c-family-free-ceiling](rh27c-family-free-ceiling.md) — the bound that forbids the law.
- [rh27b-support-scaling-exponent](../rh27b/rh27b-support-scaling-exponent.md) — the refuted exponent.
- rh28 §4 later refutes a different explanation of the same saturation ([rh28-saturation-prediction-refuted](../rh28/rh28-saturation-prediction-refuted.md)).

## Notes

- The source also reports what still saturates: λ<sub>min</sub>/E<sub>h</sub>(0) is flat (0.251, 0.273, 0.258 on the fixed triangle shape) and the question of why is left open — "this document does not know what."
- The Status above records both the refutation (of rh27b's law) and the confirmation of the ceiling's prediction; no strengthening is intended.
