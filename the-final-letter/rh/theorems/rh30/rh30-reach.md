# The reach

**Kind:** Proposition
**Status:** PROVED (paper argument, via Gershgorin; growth exponent VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §7 "The reach", lines 1420–1463 and boxed table at lines 1433–1439

## Statement

> Turn the Gershgorin estimate around. For a certificate at depth n to be capable of noticing a single quadruple at height γ, that quadruple's contribution must exceed the floor it would have to eat: 4·ĥ(γ)<sup>2</sup>·cosh(σV)·(2n−1) > λ<sub>min</sub>. Since ĥ(γ)<sup>2</sup> falls like γ<sup>−4</sup>, that is a height:
>
> Δ′ = 0.48   n = 39 (v = 18.24)   blind above γ = 3,477
> Δ′ = 0.24   n = 76 (v = 18)   blind above γ = 3,901
> Δ′ = 0.12   n = 151 (v = 18)   blind above γ = 6,334
> Δ′ = 0.06   n = 301 (v = 18)   blind above γ = 11,067
> Δ′ = 0.03   n = 601 (v = 18)   blind above γ = 18,580
>
> Above those heights a certificate is blind, and below them the zeros have been on the line since Gram. Worse, at shallow depth the reach is nothing at all: up to n = 20 at Δ′ = 0.12 the threshold exceeds even the heaviest atom, so a certificate to depth v = 2.3 cannot see a single zero of ζ.
>
> How fast does the reach grow? Measured across the depth ladder at Δ′ = 0.12, the exponent over the last three doublings is 1.17, 1.30, 1.11 — call it n<sup>1.2</sup>. That is a real growth rate, and it is nowhere near enough. Extrapolating it, the section needed to see as high as the zeros are *already known* to be on the line is of order n = 1.8×10<sup>10</sup>, against the 601 the arc has reached and the 601 that already took §3's largest computation.

## Hypotheses and notation

- V is the depth; n the section length; λ<sub>min</sub> the certified floor; σ the abscissa distance of an off-line quadruple.
- The estimate is Gershgorin's (2n−1)ε perturbation bound turned around.
- "blind above γ" means a certificate at that support and depth cannot notice a single quadruple at that height.

## Proof / evidence

Paper argument (a Gershgorin bound turned around), with the growth exponent measured. The source hedges the scope explicitly: "It is a statement about *this* family of windows, whose transform decays like r<sup>−4</sup>; a window with slower decay would see higher, at the cost of being less smooth, and the trade is the Paley–Wiener one. It is also a statement about detection through a Gershgorin estimate, which is conservative — rh29's sharper single-quadruple test reached γ = 107 at σ = 0.33, well inside these heights, by using the actual optimal vector rather than a bound."

## Dependencies and related results

- [rh30-conspiracy-bound](rh30-conspiracy-bound.md) — the same Gershgorin estimate used in the other direction.
- [rh29-offline-quadruple-exclusion-test](../rh29/rh29-offline-quadruple-exclusion-test.md) — the sharper test the source compares against.
- rh30 §9 uses γ = 6,334 against the 3×10<sup>12</sup> verified on the line ("8.7 decades higher").

## Notes

- The source's own framing: "The same decay that makes §6 easy is a ceiling on the method, and this is the part I would rather not report." and "the reach could be pushed. It could not plausibly be pushed by eight decades."
- The growth exponent n<sup>1.2</sup> is a measured quantity, not a proved rate.
