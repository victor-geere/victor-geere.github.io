# None of the three statistics predicts the floor; two die by counterexample

**Kind:** Claim
**Status:** VERIFIED (numerical, five gear sets at N = 24); REFUTED (minimum log-gap and coincidence count as predictors; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh35.html`](../../html/rh35.html) — §3 "What sets the floor"

## Statement

> Five gear sets at matched dimension N = 24 say no.

> The **primes** have the smallest minimum log-gap of the five, 0.0278, and the *highest* floor, 0.790; the integers sit at a gap half again as wide and a floor a third the size. Correlation over the five: +0.36 — too weak to carry a story and pointing the wrong way for this one. The **coincidence count** fares no better: the geometric set has the *fewest* distinct log-differences of all, 0.08 of N², and the highest floor; the primes have the *most*, 0.96, and a high floor too; the integers sit in the middle at 0.62 with the lowest floor of the five (−0.15). Reach does not order it either (−0.20).

> (a) therefore closes in the branch rh34 explicitly allowed for. None of the three predicts the floor; two are refuted outright. What replaces them is not an explanation but a measurement: a displacement of 0.006 in log, invisible to every statistic tried, is worth a factor two.

## Hypotheses and notation

- Five gear sets at matched dimension N = 24: the integers, the primes, a geometric set with ratio e<sup>0.12</sup>, and two further sets.
- The three statistics: the minimum log-gap, the coincidence count (distinct log-differences, as a fraction of N²), and the reach.
- Floors are λ<sub>min</sub>(G)/mass.

## Proof / evidence

Numerical over five gear sets: prime minimum log-gap 0.0278 with the highest floor 0.790; the integers at a gap half again as wide with a floor a third the size; correlations +0.36 (gap), −0.15 (coincidence count), −0.20 (reach). Coincidence counts: geometric 0.08 of N² with the highest floor, primes 0.96 with a high floor, integers 0.62 with the lowest floor of the five.

## Dependencies and related results

- [rh34-lattice-conditioning-versus-multiplicative-structure](../rh34/rh34-lattice-conditioning-versus-multiplicative-structure.md) — rh34 §8 (a)'s three candidate statistics.
- [rh35-floor-threshold-at-six-thousandths](rh35-floor-threshold-at-six-thousandths.md) — the measurement that replaces them.
- [rh36-threshold-is-a-crossing](../rh36/rh36-threshold-is-a-crossing.md) and [rh36-why-log-2-self-map](../rh36/rh36-why-log-2-self-map.md) — the explanation the statistics could not give.

## Notes


- The source's phrasing is that the branch closes "in the branch rh34 explicitly allowed for", i.e. the negative branch; "two are refuted outright" refers to the minimum log-gap and the coincidence count as predictors.
- rh36 §7 adds that rh35 §5 then read its two halves against a statistic (§3) the document had itself already discarded.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
