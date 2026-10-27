# The position laws: the wrapped ordinates ride the Poisson band

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §6 "The position laws", lines 1565–1581

## Statement

> Between the crystal and Poisson noise runs the jitter family — crystal plus uniform jitter of ±α spacings — and it is cleanly ordered: at n/(2m) = 0.55 the medians run 0.68, 0.40, 0.16 as α grows from ¼ to 1, with Poisson below 10<sup>−3</sup>. The wrapped ordinates, at all six meshes from 0.05 to 0.24, ride the Poisson band: at n/(2m) = 0.4 every mesh sits *inside* the twelve-draw band, the largest at 0.69 of the largest draw and a factor of 7.8 below even the full-spacing jitter. One marginal excess survives: at Δ′ = 0.09 the mid-bulk value 0.325 clears all twelve Poisson draws — by 10%. The other five meshes run 0.08 to 0.22, inside the band. It is arithmetic in the mesh, not a property of the ordinates alone.
>
> The sober conclusion: at the arc's scales the certificates measure *equidistribution*. The wrapped ordinate steps a fraction of a turn per zero, so neighbours on the circle are zeros far apart on the line, and GUE rigidity never arrives at the circle's scale. λ<sub>min</sub> is not a rigidity meter — a temptation rh30 §9 flirted with, now measured away.

## Hypotheses and notation

- Three reference geometries at m = 300 atoms each, mirrored: the crystal, the jittered crystal (uniform jitter of ±α spacings), and twelve Poisson draws.
- The wrapped ordinates are γΔ′ mod 2π at six meshes from 0.05 to 0.24, with weights flattened (positions only).
- Quantities compared are λ/mass at the stated n/(2m).

## Proof / evidence

Numerical. The jitter family is "cleanly ordered" (medians 0.68, 0.40, 0.16 as α grows from ¼ to 1); the wrapped ordinates sit inside the twelve-draw Poisson band at every mesh at n/(2m) = 0.4, with one marginal 10% excess at Δ′ = 0.09 attributed to the mesh, not the ordinates.

## Dependencies and related results

- [rh31-crystal-lemma](rh31-crystal-lemma.md) — the top of the ordering.
- [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md) — §5's law, which this section is the position-law counterpart of.
- [rh32-safe-zone](../rh32/rh32-safe-zone.md) — uses this equidistribution to explain why the living material builds no wide void.
- [rh30-loss-splits-into-weights-and-positions](../rh30/rh30-loss-splits-into-weights-and-positions.md) — the earlier reading of the same equidistribution.

## Notes


- The source is careful about the one excess: "It is arithmetic in the mesh, not a property of the ordinates alone", and rh32 §6 later confirms that at Δ′ = 0.09 the envelope's ratio *falls* to 1.49.
- Conditional on RH, since the ordinates are the zero-side input.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
