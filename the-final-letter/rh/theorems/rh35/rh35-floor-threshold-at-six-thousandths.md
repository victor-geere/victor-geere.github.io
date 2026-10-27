# The floor has a scale: a displacement of 0.006 in log doubles it

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh35.html`](../../html/rh35.html) — §3 "What sets the floor"

## Statement

> rh34 §6 found the multiplicative sampling worse conditioned than the lattice and blamed bunching, on one number. (a) asked for that priced. Slide the integers' log-positions linearly towards equispaced over the same range, so that nothing changes but the spacing.

> At the integers λ<sub>min</sub>(G)/mass is 0.2939. At θ = 10<sup>−4</sup> it is 0.2938 — unchanged, so this is not a discontinuity, and the *exactness* of the integers' multiplicative relations is not the mechanism. At θ = 10<sup>−2</sup> it has doubled, to 0.589, while the positions have moved by 0.006 in log and the smallest gap has gone from 0.04256 to 0.04352. Past 5% the curve saturates, wobbling inside a factor 1.06 rather than climbing.

> So the effect has a scale — about 0.006 in log, a seventh of the smallest gap — and the next question is whether any simple statistic is sensitive at it.

## Hypotheses and notation

- The slide: the integers' log-positions are moved linearly towards equispaced over the same range, parameter θ, so only the spacing changes.
- The smallest rate gap of the integer ladder at length 24 is 0.04256; it becomes 0.04352 at θ = 10<sup>−2</sup>.
- λ<sub>min</sub>(G)/mass is computed by Cholesky inertia bisection and by cyclic Jacobi.

## Proof / evidence

Numerical: 0.2939 at the integers, 0.2938 at θ = 10<sup>−4</sup> (unchanged), 0.589 at θ = 10<sup>−2</sup>, saturation inside a factor 1.06 past 5%.

## Dependencies and related results

- [rh34-lattice-conditioning-versus-multiplicative-structure](../rh34/rh34-lattice-conditioning-versus-multiplicative-structure.md) — the bunching explanation this section replaces with a measurement.
- [rh35-statistics-do-not-predict-the-floor](rh35-statistics-do-not-predict-the-floor.md) — the statistics tested at that scale.
- [rh36-threshold-is-a-crossing](../rh36/rh36-threshold-is-a-crossing.md) — the later reading: the threshold is a level crossing, not a length scale.

## Notes


- The source is explicit that the section leaves a measured phenomenon with no mechanism; §7 (a) names the missing instrument as the spectrum of G rather than its smallest eigenvalue.
- rh36 §3 later explains the doubling as an avoided crossing between the bottom two levels, so the "scale" is a crossing rather than a length.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
