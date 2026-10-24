# The floor is a power law, v<sup>−5.741</sup>

**Kind:** Claim
**Status:** VERIFIED (numerical, a factor 25 in v at Δ = 0.24; R² = 0.993 for the power law against 0.843 for the exponential; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh21.html`](../../html/rh21.html) — §3 "The decay law, corrected", equation (2)

## Statement

> (2)  λ<sub>min</sub>(v) ~ v<sup>−5.741</sup>  (R² = 0.993),   against   e<sup>−0.170v</sup> (R² = 0.843)   at Δ = 0.24.

The source's framing: "rh19 measured its floor at nine horizons between v = 4 and v = 19.92, fitted ln λ<sub>min</sub> against v, got e<sup>−0.528v</sup> with a good R², and built its 'arithmetic ceiling' on that law. The fit was sound; the range was not. A factor of three in v cannot distinguish an exponential from a power law, and over a factor 25 the answer is clear."

## Hypotheses and notation

- v = (n−1)Δ is the horizon; λ<sub>min</sub>(v) is the certified floor at Δ = 0.24, extended to v = 100 using the zeros-side kernel of §2 under RH.
- The zeros-side instrument: E<sub>Δ</sub>(v) = 2 Σ<sub>γ &gt; 0</sub> |B<sub>Δ</sub>(γ)|² cos(γv), B<sub>Δ</sub>(r) = Δ·sinc²(rΔ/2) — rh14's identity, checked before use (pointwise agreement to 8.6×10⁻⁵ relative; λ<sub>min</sub> agreement to better than 4.4% at Δ = 0.24 and 0.12 at all twenty-six points rh19 computed).
- The instrument's bias: "the ratio itself drifts only as v<sup>+0.0071</sup>, so it shifts any power-law exponent by less than 0.02 against a measured −5.741."
- Other meshes: v<sup>−5.42</sup> (R² = 0.944) at Δ = 0.12, v<sup>−5.87</sup> (R² = 0.942) at Δ = 0.06.

## Proof / evidence

The source fits both laws over the extended ladder and reports the R² values above; the document's 32 named checks in 57 s include "the power-versus-exponential verdict" and "the range-dependence of that verdict". The warning recorded with the result: restricted to v ≤ 20 every mesh still fits an exponential well (Δ = 0.24 at R² = 0.915), and at Δ = 0.06 the ladder reaches only a factor 5.5 where the exponential still wins (0.954 against 0.942) — "the reach needed to tell the two apart scales like 1/Δ".

## Dependencies and related results

- **Corrects** [rh19's ceiling](../rh19/rh19-horizon-ceiling.md) and its exponential law m₀(v) ~ e<sup>−0.528v</sup>, e<sup>−0.601v</sup>, e<sup>−0.639v</sup>; the source calls rh19's rate "an artifact of fitting over a factor of three".
- Uses the zeros-side kernel of §2 (RH assumed), which is where the longer ladder comes from.
- The mesh-dependence rh19 saw is reported to be the same range artifact: −5.741, −5.423, −5.872 across a factor four in Δ.
- [The σ² power law](rh21-sigma-squared-power-law.md) is the companion constant result from the same ladder.

## Notes


- Harvested as a stated result of the round (the abstract's answer to successor (iii)), not labelled a theorem.
- The exponents are explicitly *measured, not derived*: "What this does not do is explain either exponent. −5.741 for λ<sub>min</sub> and −2 for σ² are measured, not derived."
- Hypothesis: RH itself for the zeros-side kernel of §2 — "this document measures the construction, not the zeros."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
