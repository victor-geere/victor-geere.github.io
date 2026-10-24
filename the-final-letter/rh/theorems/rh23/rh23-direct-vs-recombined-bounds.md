# (2) The direct radius bound, and the correction that it is a property of the hat

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §2 "(ii) The radius, and what governs it", equation (2) and the paragraph "The inference was wrong"

## Statement

> (2) ρ<sup>dir</sup><sub>p</sub> = [ sup|C<sub>h</sub>′|·δu + sup|C<sub>h</sub>|·1.17×10⁻¹⁵ ] · M<sub>Δ</sub>(p).
>
> **The inference was wrong.** (1) and (2) are governed by different norms — Σ|w<sub>d</sub>| in one, sup|C<sub>h</sub>′| in the other — and which is smaller depends on the window. For the triangle hat sup|C<sub>h</sub>′| is exactly 2/3, rh19's own constant, and (2) beats (1) by 4.64×, which is the number rh22 measured. For the searched window C<sub>h</sub> oscillates and sup|C<sub>h</sub>′| = 11.95, 18× the hat's, so (2) is 2.29× *worse*. rh22 read a property of the hat as a property of the route.

## Hypotheses and notation

- ρ<sup>dir</sup><sub>p</sub> is the proven radius of the prime comb at node p when the rows are built directly at Δ = 0.24 nodes.
- δu is the shared error in ln m; 1.17×10⁻¹⁵ is the direct rounding constant; M<sub>Δ</sub>(p) is the gear mass at node p.
- sup|C<sub>h</sub>′| is the supremum of the slope of the composite spline over the support; for the triangle hat it is exactly 2/3 (rh19's constant), for the searched window 11.95 (18× the hat's).
- The two norms that govern: Σ|w<sub>d</sub>| (recombined, [equation (1)](rh23-recombined-radius-bound.md)) against sup|C<sub>h</sub>′| (direct).

## Proof / evidence

The source states the bound and then the correction, quoted verbatim above. The check on the hat's constant is also recorded in rh23 §6: "the hat's sup|C<sub>h</sub>′| comes out at exactly 2/3, rh19's own constant, which is the check that §2's machinery and rh19's agree where they must."

## Dependencies and related results

- [The recombined radius bound (1)](rh23-recombined-radius-bound.md) is the bound compared against.
- rh19's own direct Δ = 0.24 rows and Lipschitz constant 2/3.
- rh22 §7 proposed the direct route; [the binned radius (3)](rh23-binned-radius.md) is the bound that beats both.

## Notes

- This file records a *correction*: the 4.64× advantage rh22 measured is a property of the triangle hat's transform, not of the direct route. The source says plainly "rh22 read a property of the hat as a property of the route."
- The exact figures quoted are 4.64× (hat) and 2.29× (searched window), with sup|C<sub>h</sub>′| = 11.95 = 18× the hat's 2/3.
