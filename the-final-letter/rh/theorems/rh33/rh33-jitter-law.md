# The crystal is not fragile: no Kadec threshold

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §3 "The crystal is not fragile", lines 389–428

## Statement

> Before attacking the lemma it is worth knowing whether the crystal's exactness is a knife edge. Jitter each atom independently by up to α of a spacing and measure ρ. The classical expectation is Kadec's quarter — perturb a lattice by less than a quarter of its spacing and the exponentials stay a Riesz basis; beyond it, no guarantee.
>
> Nothing happens at a quarter. ρ falls in a straight line from 1, reaching 0.978 at α = ¼ and 0.957 at α = 0.49, where neighbouring atoms are nearly on top of each other, and the fall is linear to 0.3% of the total loss across the whole range. Three seeds agree to 0.0021. A destroyed lattice costs 4.3% of the constant.
>
> The slope of that line depends on the grid only through n/M — the inverse of the oversampling — once M is large enough: at n/M = 0.1 the (M = 600, n = 60) and (M = 1200, n = 120) grids agree to 0.6%, and at n/M = 0.2 the (600, 120) and (1200, 240) grids agree to 0.3%. The smaller grids sit below the limit — M = 150 is 35% under at the same n/M — so the drift with M is finite size and not a second variable. The collapsed curve is not a power: its local exponent slides from 1.86 between n/M = 0.05 and 0.1, through 1.67, to 1.22 between 0.2 and 0.4. The tidy guess (n/M)<sup>3/2</sup> is an average over that range, not a law.
>
> The reading is that oversampling is what protects the constant, and it protects it robustly: positions can be wrong by half a spacing and the loss is a few percent, provided there are enough atoms per kernel width.

## Hypotheses and notation

- The crystal is the mirrored equispaced lattice of [rh32-crystal-atom-sum-identity](../rh32/rh32-crystal-atom-sum-identity.md); each atom is jittered independently by up to α of a spacing.
- ρ is [rh33-loss-constant-identification](rh33-loss-constant-identification.md)'s loss constant; M is the crystal size; n the degree.
- Kadec's quarter is the classical Riesz-basis threshold, cited.

## Proof / evidence

Numerical. The straight-line fall (linear to 0.3% of the total loss, three seeds agreeing to 0.0021), the n/M collapse (0.6% and 0.3% agreement at n/M = 0.1 and 0.2; M = 150 sits 35% under) and the sliding local exponents (1.86, 1.67, 1.22) are all measurements.

## Dependencies and related results

- [rh33-loss-constant-identification](rh33-loss-constant-identification.md) — the quantity measured.
- [rh33-quadrature-lemma-refuted](rh33-quadrature-lemma-refuted.md) — §4, where the "good sign for a lemma with gap hypotheses" stops being one.
- [rh32-safe-zone](../rh32/rh32-safe-zone.md) — the later document's reading of the same robustness.

## Notes


- The source notes the result is only a sign, not a proof: "That is a good sign for a lemma with gap hypotheses — and §4 is where it stops being one."
- Unconditional: the crystal is synthetic, "equispaced atoms, no arithmetic input".

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
