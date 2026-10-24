# The triangle hat certified at n = 76, floor 1.285×10<sup>-10</sup>

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — certified interval rows, binned comb radius (3))
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §2 "(ii) The radius, and what governs it", paragraph "What it buys"

## Statement

> rh22 could not certify the triangle hat at n = 76: its λ<sub>min</sub> there is 1.558×10<sup>-10</sup> and the recombined radius was 2.539×10<sup>-10</sup>, a margin of 0.61× — below one, so the Cholesky had nothing to spend. With (3) the radius is 2.568×10<sup>-11</sup> and the margin is 6.1×. The section is certified, floor 1.285×10<sup>-10</sup>. That is rh22's own loose end, closed by arithmetic that was available all along.

## Hypotheses and notation

- The window is the triangle hat; the section is Δ = 0.24 at n = 76 (v = 18).
- λ<sub>min</sub> = 1.558×10<sup>-10</sup>; the recombined radius was 2.539×10<sup>-10</sup> (margin 0.61×); with [the binned radius (3)](rh23-binned-radius.md) the radius is 2.568×10<sup>-11</sup> (margin 6.1×).
- The floor is s − ‖residual‖ − ρ<sub>round</sub> − ρ<sub>D</sub> through rh19's backend α.

## Proof / evidence

The source computes the row directly at the Δ = 0.24 nodes in certified interval arithmetic and uses radius (3); §5 records that the certificate lane changed accordingly:

> Everything above is a float measurement until it goes through rh19's backend α. The rows are built the way rh22 §7 asked and §2 explains: the archimedean integral and pole are computed *directly* at the Δ = 0.24 nodes in certified interval arithmetic, which needs one new object — an interval table for A(r)² = (Σ<sub>k</sub>a<sub>k</sub>cos(krδ))² at the 12001 quadrature nodes — and costs seventy-six rows instead of the six hundred and seventeen the δ-basis route needs.

and that "The hat's certified floor at n = 18 and n = 51 reproduces rh19's own to within 3% — through a third independent route."

## Dependencies and related results

- [The binned radius (3)](rh23-binned-radius.md) supplies the radius.
- [rh22 Lemma L1](../rh22/rh22-lemma-l1-any-window.md) carries the archimedean truncation over.
- rh22's failure to certify the hat at n = 76 is in [rh22 m₀ certified — (4)](../rh22/rh22-certified-floors-m0.md).
- Certified floors at v = 18 for all three windows: [equation (4)](rh23-certified-floors-v18.md).

## Notes

- This closes "rh22's own loose end" — a section that was out of reach at the recombined radius. The source notes the fix costs no new computation, "only a better accounting".
- The floor 1.285×10<sup>-10</sup> and the radii are quoted exactly.
