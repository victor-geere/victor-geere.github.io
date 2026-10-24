# The death of the constant

**Kind:** Proposition
**Status:** VERIFIED (numerical; composed prediction reproduces the death curve to 6.2% over five decades; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh32.html`](../../html/rh32.html) — §4 "The death of the constant", lines 581–623 and boxed statements at lines 589–593 and 598–606

## Statement

> rh31's conjecture compares λ<sub>min</sub> with the emptiest-arc ceiling C<sub>n</sub>. On the punctured crystal the ceiling is also one integral: centred mid-void, the Fejér translate sees only the two tails that leak past the void edges, and the tail integral gives
>
> C<sub>n</sub> ≈ (2/π<sup>2</sup>)·mass/K = 0.2026·mass/K,   measured to 6.2% for all K ≥ 2 (the residual is the sinc<sup>2</sup> tail's own oscillation about its mean).
>
> Divide the identity by the ceiling law and the fate of rh31's constant is decided:
>
> c(K) = λ<sub>min</sub>/C<sub>n</sub> = (π<sup>2</sup>K/2)·(1 − l<sub>1</sub>(K)).
>
> Composed from the two independently measured quantities of §3 and this section, this reproduces the directly measured death curve to 6.2% over five decades, K = 2.1 to 6.1 — and the worst point is the ceiling law's own oscillation, not the tail's.
>
> The numbers along the curve (fig. 2): c is still 0.72 at K = 1.5; it is 0.19 at K = 2.1 — a factor 3.8 lost across 0.6 of width, the cliff — and 3.7×10<sup>−6</sup> by K = 6.1. There is no absolute constant; there is a function of the void width, and it dies at the prolate rate.

The zeta-side confirmation:

> The crystal proves the mechanism; the arc's own material confirms it is not a crystal artefact. Take the wrapped ordinates at mesh 0.12, depth n = 61 — equal weights (positions only) or the full searched-0.12 window — and cut the same arc out of the wrapped circle. With no cut, both sit at ratios 0.97 and 0.93, rh31's regime. With the cut, both death curves track the crystal's within a factor 1.9 while c falls six decades (fig. 2). At K = 6 the searched window's own atoms, with one arc removed, give c = 3.5×10<sup>−6</sup>.

## Hypotheses and notation

- C<sub>n</sub> is §5-of-rh31's emptiest-arc Fejér density; on the punctured crystal, centred mid-void, the Fejér translate sees only the tails past the void edges.
- c(K) = λ<sub>min</sub>/C<sub>n</sub> is the ratio at void width K = nW/2π; l<sub>1</sub>(K) is the top concentration eigenvalue of [rh32-void-identity](rh32-void-identity.md).
- "mass" is the crystal's total mass.

## Proof / evidence

Numerical: the ceiling law measured to 6.2% for all K ≥ 2, and the composed prediction c(K) = (π<sup>2</sup>K/2)(1 − l<sub>1</sub>(K)) reproducing the directly measured death curve to 6.2% over K = 2.1 to 6.1. Confirmed on zeta material (wrapped ordinates at mesh 0.12, n = 61) within a factor 1.9 of the crystal while c falls six decades.

## Dependencies and related results

- [rh32-void-identity](rh32-void-identity.md) and [rh32-prolate-deficit-collapse](rh32-prolate-deficit-collapse.md) — the two ingredients composed here.
- [rh31-emptiest-arc-law](../rh31/rh31-emptiest-arc-law.md) and [rh31-localisation-conjecture](../rh31/rh31-localisation-conjecture.md) — rh31's conjecture this re-prices.
- [rh32-absolute-constant-refuted](rh32-absolute-constant-refuted.md) — the refutation this law replaces.
- [rh33-loss-constant-identification](../rh33/rh33-loss-constant-identification.md) — rh33 recasts the same curve as its loss constant ρ.

## Notes


- The source's own headline: "There is no absolute constant; there is a function of the void width, and it dies at the prolate rate."
- The values 0.72, 0.19 and 3.7×10<sup>−6</sup> are read off the measured curve; the composition is claimed to 6.2%, not exactly.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
