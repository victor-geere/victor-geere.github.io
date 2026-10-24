# The loss is a cancellation across the whole comb

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §6 "The moments are a prime sum", lines 879–886

## Statement

> The tempting next sentence — *so a handful of primes decides the certificate* — is false, and the right panel is the disproof. Switch the comb off entirely and the row still has ρ = 0.762, the archimedean part alone. The twenty heaviest prime powers carry it *past* the truth, down to 0.458. The next sixty bring it back to 0.524. The loss is a cancellation across the whole comb, in the same way §5 found the moments cancelling — which is the same phenomenon seen twice, since the moments are the comb.

## Hypotheses and notation

- The comb is the prime-power sum ∑<sub>m≥2</sub> Λ(m)·m<sup>−1/2</sup>[C<sub>h</sub>(ln m − v) + C<sub>h</sub>(ln m + v)] of [rh33-moments-are-a-prime-sum](rh33-moments-are-a-prime-sum.md).
- ρ is [rh33-loss-constant-identification](rh33-loss-constant-identification.md)'s loss constant, rebuilt from subsets of prime powers.
- "Switch the comb off" leaves the pole and archimedean terms alone.

## Proof / evidence

Numerical, by rebuilding ρ from subsets of the prime-power sum: with the comb off, ρ = 0.762; with the twenty heaviest prime powers, ρ = 0.458 (past the truth); with the next sixty added, ρ = 0.524. The source identifies this as the same cancellation §5 found in the moments.

## Dependencies and related results

- [rh33-moments-are-a-prime-sum](rh33-moments-are-a-prime-sum.md) — supplies the comb whose terms are switched on and off.
- [rh33-moment-bound-vacuous](rh33-moment-bound-vacuous.md) — §5's cancellation, "the same phenomenon seen twice".
- [rh33-loss-constant-identification](rh33-loss-constant-identification.md) — the quantity being rebuilt.

## Notes


- The source states the difficulty this leaves as a target for §8(a): the signed sum needs control, not the triangle inequality, and "the elementary bound is off by a factor of five at Δ = 0.12 and the certified computation is exact; between them is everything."
- Conditional on RH, being the zero-side/prime-side moment comparison.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
