# The safe zone: why rh31 never saw it

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh32.html`](../../html/rh32.html) — §5 "The safe zone: why rh31 never saw it", lines 721–760 and boxed summary at lines 732–743

## Statement

> If the constant dies on voids, rh31's measured 1/1.81 across 336 points means its material has no voids. Measure that directly: for each of the sixteen families at each mesh, compute the emptiness profile — for every arc width, the minimum of μ(arc) relative to the uniform share — and define K<sub>10</sub> as the widest arc that is 10%-empty or worse, in kernel units at the point's own depth. Across all 207 bulk points of rh31's grid:
>
> max K<sub>10</sub> = **1.45** — the envelope's worst point, whose widest thin arc runs 1.45 kernel widths at depth 1.5% of mean density.
> Number of bulk points with K<sub>10</sub> ≥ 2, where the cliff begins: **zero**.
> Number of bulk points with ratio above 1.4: **one** — that same envelope point, at 1.81, which sits between the crystal boundary's 1/c = 1.38 at K = 1.5 and 5.2 at K = 2.1.
>
> That is the resolution of rh31's constant: the material's widest emptiness reaches K ≈ 1.45, the death curve at that width allows ratios up to a factor of a few, and the grid maximum 1.81 is exactly such a value. Beyond K = 2 the certificates would collapse outright — and no window built from zeta ordinates on this grid ever gets there, because the wrapped ordinates equidistribute (rh31 §6: they ride the Poisson band at every mesh tried). **The certificate floor is an equidistribution statement.**

The source's negative result inside the zone:

> Against ln(C<sub>n</sub>/λ<sub>min</sub>) over the 207 bulk points, the width statistic correlates at +0.70, the depth of the emptiest kernel-width arc at −0.71, the smeared floor itself at −0.71, and rh30's n/N<sub>eff</sub> at +0.60 — no single coordinate tried reaches 0.72 (fig. 3). The sub-1.4 fluctuations are genuinely multi-factor.

## Hypotheses and notation

- The emptiness profile of a measure: for every arc width, the minimum of μ(arc) relative to the uniform share.
- K<sub>10</sub> is the widest arc that is 10%-empty or worse, in kernel units at the point's own depth.
- The bulk is 207 points of rh31's 336-point grid (16 families × meshes × depths).

## Proof / evidence

Numerical: max K<sub>10</sub> = 1.45 across all 207 bulk points; zero points with K<sub>10</sub> ≥ 2; one point with ratio above 1.4 (the envelope at 1.81). The source reads this against the crystal death curve's boundary values 1/c = 1.38 at K = 1.5 and 5.2 at K = 2.1.

## Dependencies and related results

- [rh32-death-of-the-constant](rh32-death-of-the-constant.md) — the death curve the safe-zone boundary is read against.
- [rh31-wrapped-ordinates-ride-poisson-band](../rh31/rh31-wrapped-ordinates-ride-poisson-band.md) — the equidistribution that keeps the material out of the death zone.
- [rh32-envelope-anomaly-resolved](rh32-envelope-anomaly-resolved.md) — the one outlying point's anatomy.

## Notes


- The source states the texture inside the zone is *not* explained by any single coordinate tried (best correlation +0.70); that multi-factor texture is left as rh32 §8(b)'s open question and is not harvested.
- Conditional on RH (the ordinates come from rh29's zero-side table).

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
