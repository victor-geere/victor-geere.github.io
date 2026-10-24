# A constant confirmed: σ²<sub>min</sub> ~ v<sup>−1.777</sup>

**Kind:** Claim
**Status:** VERIFIED (numerical, R² above 0.99 at every mesh, out to v = 100; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh21.html`](../../html/rh21.html) — §3 "The decay law, corrected"

## Statement

> A constant confirmed, not corrected. The same ladder measures the other quantity the arc has been quoting without derivation. rh15 found σ²v² ≈ 3.9×10⁻³ at v = 12 and left it unexplained. It is a power law and it holds: σ²<sub>min</sub> ~ v<sup>−1.777</sup> at R² above 0.99 at every mesh, with σ²v² staying within 3.9×10⁻³ of rh15's value out to v = 100. One of the arc's three unexplained constants is now verified over a decade rather than fitted at a point — still not derived, but no longer suspect.

## Hypotheses and notation

- σ²<sub>min</sub> is the worst one-step prediction error (the minimum prediction error of the Levinson–Durbin recursion), as opposed to λ<sub>min</sub>, the global minimum eigenvalue.
- v = (n−1)Δ is the horizon; the ladder is rh21's zeros-side ladder, out to v = 100.
- rh15's constant: σ²v² ≈ 3.9×10⁻³ at v = 12.

## Proof / evidence

Measured on the same ladder as [the λ<sub>min</sub> power law](rh21-floor-power-law.md): R² above 0.99 at every mesh, with σ²v² staying within 3.9×10⁻³ of rh15's value out to v = 100. The document's 32 named checks in 57 s include "rh15's σ² law".

## Dependencies and related results

- [The floor power law](rh21-floor-power-law.md) is the companion law from the same ladder; the source notes they are "different laws for different quantities".
- rh19 §6 and rh20 §6 both list "the floor's decay rate" (with rh15's σ²v² ≈ 3.9×10⁻³ and rh16's D*) as unexplained constants of the construction; this file confirms one of them over a decade.

## Notes


- Harvested as a stated result of the round, not labelled a theorem.
- The exponent is measured, not derived: "−5.741 for λ<sub>min</sub> and −2 for σ² are measured, not derived." (The source writes −2 as the rounded σ² exponent in that sentence while the fitted law is v<sup>−1.777</sup>; both are quoted here as stated.)
- Hypothesis: RH for the zeros-side kernel of §2.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
