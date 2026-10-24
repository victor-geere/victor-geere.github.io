# The loss splits into weights and positions

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §5, subsection "Four controls", lines 1094–1114 and boxed table at lines 1100–1105

## Statement

> The loss splits into weights and positions, and the split is decisive. At Δ′ = 0.12 and n = 151, with λ<sub>min</sub> as a fraction of the mass:
>
> grid positions, equal weights — the anchor  —  λ<sub>min</sub>/‖μ‖ = 1.0000
> true positions, equal weights  —  λ<sub>min</sub>/‖μ‖ = 0.7728
> true positions, true weights — the arc  —  λ<sub>min</sub>/‖μ‖ = 0.2846
> grid positions, true weights  —  λ<sub>min</sub>/‖μ‖ = 2.9433×10<sup>−6</sup>
>
> Flattening the *weights* onto the true positions costs a factor of 2.72. Flattening the *positions* onto an exact grid while keeping each weight attached to its own ordinate costs a factor of 9.7×10<sup>4</sup> the wrong way — a catastrophe, because it winds the weights monotonically around the circle instead of scattering them. So it is the scattering that holds the floor up, and the scattering is exactly equidistribution of {γΔ′ mod 2π}, which is known unconditionally (Hlawka).

## Hypotheses and notation

- The four controls at Δ′ = 0.12, n = 151, with λ<sub>min</sub> as a fraction of the total mass ‖μ‖.
- "true positions" are the wrapped ordinates γΔ′ mod 2π; "true weights" are ĥ(γ)<sup>2</sup>; "grid positions" are the exact equally spaced grid.
- Equidistribution of {γΔ′ mod 2π} is Hlawka's, cited and unconditional.

## Proof / evidence

Numerical: the four measured ratios are quoted above, and the source's interpretation is that the scattering of the wrapped ordinates is what holds the floor up. The source's verdict on rh29's reading: "rh29's reading of the obstruction was right. The trouble is turning it into a number."

## Dependencies and related results

- [rh30-anchor-exact-trig-quadrature](rh30-anchor-exact-trig-quadrature.md) — the first row of the table.
- [rh30-koksma-lower-bound](rh30-koksma-lower-bound.md) and [rh30-marcinkiewicz-zygmund-lower-bound](rh30-marcinkiewicz-zygmund-lower-bound.md) — the two routes that try to turn equidistribution into a number.
- [rh31-wrapped-ordinates-ride-poisson-band](../rh31/rh31-wrapped-ordinates-ride-poisson-band.md) — the later measurement of the same equidistribution.

## Notes


- The source's own caveat: "the bound is not losing to the arithmetic of the zeros. It is losing to the window" (said of the Koksma route); the same tension applies to this table.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
