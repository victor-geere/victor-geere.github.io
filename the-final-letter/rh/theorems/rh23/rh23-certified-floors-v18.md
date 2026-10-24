# (4) Nine certificates at v = 18, and the deepest floor in the arc

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — certified interval arch, binned comb radius, backend α)
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §5 "The certificates", equation (4)

## Statement

> Nine certificates: three windows at three section sizes, none missing.
>
> (4) m₀ at v = 18: 1.285×10<sup>-10</sup> (hat) → 3.470×10<sup>-3</sup> (8 coeff.) → 2.696×10<sup>-2</sup> (16 coeff.).
>
> The interval arch is narrow: width below 9.0×10<sup>-22</sup> at every window, so the radius is entirely the comb's, as it has been since rh17. The deepest certified floor in the arc is now 2.5778×10<sup>-1</sup>, against rh22's 1.3894×10<sup>-1</sup>.

## Hypotheses and notation

- Three windows — the triangle hat, the 8-coefficient (rh22) optimum and the 16-coefficient (rh23) optimum — at the three section sizes rh19 certified: n = 18, 51, 76.
- The rows are a direct certified interval arch at the Δ = 0.24 nodes with an interval table for A(r)² = (Σ<sub>k</sub>a<sub>k</sub>cos(krδ))² at the 12001 quadrature nodes; the comb radius is [equation (3)](rh23-binned-radius.md); the trapezoid aliasing radius is inherited from rh22 and scaled by Σ|w<sub>d</sub>|.
- The floor is s − ‖residual‖ − ρ<sub>round</sub> − ρ<sub>D</sub> (rh19's backend α).

## Proof / evidence

The certificate lane, quoted verbatim:

> Everything above is a float measurement until it goes through rh19's backend α. The rows are built the way rh22 §7 asked and §2 explains: the archimedean integral and pole are computed *directly* at the Δ = 0.24 nodes in certified interval arithmetic, which needs one new object — an interval table for A(r)² = (Σ<sub>k</sub>a<sub>k</sub>cos(krδ))² at the 12001 quadrature nodes — and costs seventy-six rows instead of the six hundred and seventeen the δ-basis route needs.

Two regressions, quoted verbatim:

> The hat's certified floor at n = 18 and n = 51 reproduces rh19's own to within 3% — through a third independent route, since rh19 computed Δ = 0.24 rows directly with the hat's own kernel, rh22 recombined certified δ = 0.03 rows, and this document computes a direct interval arch with an A(r)² table and a binned comb radius. Three routes, three implementations, the same two numbers.

## Dependencies and related results

- [The binned radius (3)](rh23-binned-radius.md); [the triangle hat certified at n = 76](rh23-certified-hat-n76.md).
- [rh22 m₀ certified — (4)](../rh22/rh22-certified-floors-m0.md) for the 8-coefficient values; rh19's backend α and Δ = 0.24 rows.
- rh22 §7's request for the direct route (corrected in [rh23-direct-vs-recombined-bounds.md](rh23-direct-vs-recombined-bounds.md)).

## Notes

- The three v = 18 figures are quoted exactly; the deepest floor 2.5778×10<sup>-1</sup> and rh22's 1.3894×10<sup>-1</sup> are the source's own comparison.
- The interval-arch width bound 9.0×10<sup>-22</sup> is quoted exactly.
