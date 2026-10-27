# (d) The depth, and it is not a power law

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh28.html`](../../html/rh28.html) — §6 "The depth, and it is not a power law"

## Statement

> End to end the decay is a factor 3.4 at Δ′ = 0.12 over a factor 18.8 in depth, which as a single exponent is v<sup>−0.414</sup>; across the five supports the endpoint secants are 0.972, 0.703, 0.414, 0.440, 0.394. Taken at face value that would be reassuring — a power below 1 never reaches zero — and it is the first quantitative statement the arc has about the one direction the conjunction requires infinitely much of.
>
> **It is not a power law, and the direction of the error matters.** The curves in Figure 4 are not straight. At Δ′ = 0.12 the local slope over the six segments runs 0.04, 0.45, 0.49, 0.52, 0.73, 0.77 — nearly flat where the section is shallow and steepening throughout, by a factor of 18 end to end. The same happens at every support. So the endpoint secant is not an exponent, it is an average dominated by the shallow segments where almost nothing is happening, and the decay past v = 18 is *steeper* than the secant, not equal to it. An extrapolation built on 0.414 is therefore optimistic, and the extrapolated costs — 2.0 to reach v = 100, 5.3 to reach 1000 — are lower bounds on what it would actually cost, not estimates.

## Hypotheses and notation

- λ<sub>min</sub> against depth v, one curve per support, at each support's own mesh; every prefix of an already-built row is a section.
- The endpoint secant over [1, 18]: 0.972 (Δ′ = 0.48), 0.703 (0.24), 0.414 (0.12), 0.440 (0.06), 0.394 (0.03) — the source's Figure 4 labels the same quantities with signs, e.g. Δ′ = 0.12, −0.41.
- The local slopes at Δ′ = 0.12 over the six segments: 0.04, 0.45, 0.49, 0.52, 0.73, 0.77.
- End to end at Δ′ = 0.12: a factor 3.4 over a factor 18.8 in depth, i.e. v<sup>−0.414</sup>.

## Proof / evidence

Numerical: the depth curve is computed from rows the arc already has (no new sieve), at five supports; the source reports the curvature directly rather than fitting an exponent. It states that whether the local slope tends to a finite limit or grows without bound "is not decided by six points over one decade, and this document does not decide it", and adds: "The cheapest measurement in the arc, and nobody had made it."

## Dependencies and related results

- rh19's horizon at v = 18; rh27a's restored cut; rh28 §4's slice test on the same rows.
- rh27b's fitted exponent and rh27c's refutation of it are the analogous earlier episode; this section "declines to make the same mistake and reports the curvature instead of the fit".

## Notes


- The source's own verdict: the previous silent assumption "that going deeper is a matter of arithmetic, is not supported by the only measurement of it".
- The extrapolated costs 2.0 (to v = 100) and 5.3 (to v = 1000) are stated by the source as lower bounds, not estimates.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
