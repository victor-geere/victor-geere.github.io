# A ceiling

**Kind:** Theorem
**Status:** VERIFIED (numerical, from the fitted laws (3); see Notes — rh21 corrects the decay law this ceiling is built on; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh19.html`](../../html/rh19.html) — §5 "The escape, and the theorem", theorem box "What is proven"; §4 equation (3)

## Statement

> A ceiling. With the row radius (2), no horizon beyond v ≈ 19.0 is certifiable at Δ = 0.24, nor beyond 14.6 at Δ = 0.06 — by the crossing of (3), not by any failure of positivity.

Supporting laws, as stated in §4:

> (3)  m₀(v) ~ e<sup>−0.528v</sup>, e<sup>−0.601v</sup>, e<sup>−0.639v</sup>   at Δ = 0.24, 0.12, 0.06;   ρ(v) ~ e<sup>+0.502v</sup> at all three.

> Setting the two equal gives a ceiling for this arithmetic: v = 19.0 at Δ = 0.24, 17.3 at 0.12, 14.6 at 0.06.

## Hypotheses and notation

- v = (n−1)Δ is the horizon.
- m₀(v) is the certified floor; ρ(v) is the proven row radius from rh19's lane (§3, equation (2)); both are exponential in v and run in opposite directions.
- "the row radius (2)" is rad<sub>k</sub> ≤ M<sub>k</sub>·[(2/3)·δu(kΔ) + Δ·7.8×10⁻¹⁶], M<sub>k</sub> = Σ|ln m − kΔ| ≤ 2ΔΛ(m)m<sup>−1/2</sup>.
- The ceilings v ≈ 19.0 (Δ = 0.24), 17.3 (0.12), 14.6 (0.06).

## Proof / evidence

The source fits both exponentials across the measured ladder and sets them equal. It notes the radius rate is +0.50 at every mesh to three digits, "exactly right: the gear mass in a window of fixed width at height v grows like e<sup>v/2</sup>, by the prime number theorem", while the floor rate steepens as the mesh refines (−0.528, −0.601, −0.639). The source's interpretation: "Beyond the ceiling the certificate does not fail because positivity fails; it fails because the proven radius of a 37,422,901-gear comb has grown past the margin the section still has. That is a statement about arithmetic, and it is the first time the arc has been able to price its own limit." The source also records what the ceiling is not: not the sieve (v = 19.92 streams in under three minutes) and not backend α (n = 199 takes seconds).

## Dependencies and related results

- [The rungs](rh19-the-rungs.md) supplies the certified floors the fit uses.
- rh20 §6 and rh21 §4 take this item up; rh21 §4 concludes the sieve, not the arithmetic, is the end of the method (a day of sieving reaches v = 26.5, a month 30.1).
- rh21's [floor power law](../rh21/rh21-floor-power-law.md) corrects the exponential law (3) on which this ceiling rests.

## Notes


- The source lists this under "What is proven", but the two laws (3) are fits over rh19's ladder (nine horizons, v ≤ 19.92). The status above is therefore VERIFIED (numerical) rather than PROVED.
- **Correction from a later round:** rh21 §3 reports that over a factor 25 in the horizon the floor is a power law, v<sup>−5.741</sup> (R² = 0.993) against the exponential's 0.843 — "the exponential rh19 published was an artifact of fitting over a factor of three". The exponential ceiling of this file is therefore superseded as a model; rh21 §4 gives the replacement (arithmetic ceiling v = 49.8 once both radius terms are fixed, with the sieve ending the method at v ≈ 26.5–30.1).
- The source's own caveat on the mechanism: the floor rate "depends on Δ, and nothing here explains why".

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
