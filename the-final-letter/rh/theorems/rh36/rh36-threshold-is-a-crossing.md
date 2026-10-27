# The threshold is not a scale but a level crossing

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh36.html`](../../html/rh36.html) — §3 "The threshold is a crossing"

## Statement

> The floor doubles from 0.2939 to 0.5893, as rh35 reported. But nothing deforms into anything. Hold the θ = 0 minimiser fixed and push it through the slide and its own Rayleigh quotient climbs monotonically from 0.2939 to 0.9888: the vector that carried the floor is not made a little dearer, it is destroyed. The floor that replaces it is a *different* vector — the two minimisers overlap 0.088, near enough orthogonal — and the height it lands at was already sitting in the matrix at θ = 0 as the second eigenvalue, 0.5727 against the 0.5893 it arrives at, 2.9%.

> So there is no length scale to find. There is a level that climbs, a level that does not, and an avoided crossing between them at θ = 0.007 where they pass within 0.0426. The "threshold" is where the climbing level overtakes the stationary one, and its height is read off the unperturbed spectrum.

## Hypotheses and notation

- θ is the linear slide of the twenty-four gear rates towards equispaced, rh35 §3's deformation.
- The minimiser at θ = 0 is the unit vector carrying the floor; its Rayleigh quotient is followed with the vector held fixed.
- Levels are eigenvalues of G/E(0)-type normalisation; the floor is λ<sub>min</sub>/mass.

## Proof / evidence

Numerical: the floor doubles from 0.2939 to 0.5893; the held-fixed θ = 0 minimiser's Rayleigh quotient climbs monotonically 0.2939 → 0.9888; the two minimisers overlap 0.088; the new level's height was already present as the second eigenvalue, 0.5727 against 0.5893 (2.9%); the avoided crossing is at θ = 0.007 with a minimum separation of 0.0426.

## Dependencies and related results

- [rh35-floor-threshold-at-six-thousandths](../rh35/rh35-floor-threshold-at-six-thousandths.md) — the measured threshold this section explains.
- [rh35-statistics-do-not-predict-the-floor](../rh35/rh35-statistics-do-not-predict-the-floor.md) — why no statistic saw it.
- [rh36-reciprocal-reach-prediction-refuted](rh36-reciprocal-reach-prediction-refuted.md) — the registered prediction this section's measurement refutes.

## Notes


- The source's conclusion is a negative one about the search: "there is no length scale to find", so the missing mechanism is a property of the matrix, not of the measure.
- This is one of the two facts the source says are facts about a single eigenvector rather than statistics of the gear set.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
