# (5) The certified floor of the 64-coefficient optimum at v = 18, a factor 1.91×10<sup>9</sup> over the hat

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — direct certified interval arch with the 768-bin radius)
**Area:** rh-html
**Source:** [`rh24.html`](../../html/rh24.html) — §5 "The certificates", equation (5)

## Statement

> Six, through rh23's route unchanged: a direct certified interval arch at the Δ = 0.24 nodes with an interval table for A(r)², the exact recombination for the comb midpoint, and (1) at 768 bins for its radius. The triangle hat and the 64-coefficient optimum, at each of the three section sizes rh19 certified.
>
> (5) m₀ at v = 18: 1.3019×10<sup>-10</sup> (hat) → 2.4855×10<sup>-1</sup> (64 coefficients), a factor 1.91×10<sup>9</sup>×.
>
> The deepest certified floor in the arc is 4.7968×10<sup>-1</sup> against rh23's 2.5778×10<sup>-1</sup>.

## Hypotheses and notation

- Windows certified: the triangle hat and the M = 64 optimum of [the family ladder](rh24-family-ladder-convergence.md), at n = 18, 51 and 76 (the three section sizes rh19 certified).
- Route: rh23's direct certified interval arch at the Δ = 0.24 nodes with an interval table for A(r)², the exact recombination for the comb midpoint, and [the 768-bin radius](rh24-radius-limit-and-horizon.md).
- The floor is s − ‖residual‖ − ρ<sub>round</sub> − ρ<sub>D</sub>.

## Proof / evidence

The certificate lane is rh23's, unchanged except for the bin count; the source's regression statement:

> The regressions hold: the hat's certified floor at n = 18 and n = 51 still reproduces rh19's own to within 3%, now through a fourth route — rh19 computed Δ = 0.24 rows directly, rh22 recombined certified δ = 0.03 rows, rh23 used a direct interval arch with a 24-bin radius, and this document uses the same arch with a 768-bin one. Four implementations, the same two numbers.

§6 adds the instrumentation: "every λ<sub>min</sub> is inertia bisection confirmed in exact 60-digit arithmetic and every positive-definiteness claim by an independent dense Cholesky; the Lanczos eigenpair certifies its own residual at 2.2×10<sup>-7</sup>".

## Dependencies and related results

- [The 768-bin radius and the horizon](rh24-radius-limit-and-horizon.md); [the family ladder](rh24-family-ladder-convergence.md); [the power-iteration correction](rh24-power-iteration-correction.md).
- [rh23's certificate equation (4)](../rh23/rh23-certified-floors-v18.md) is the value compared against (2.5778×10<sup>-1</sup>).
- Extended in [rh25's certificate equation (11)](../rh25/rh25-certified-floors-v18.md).

## Notes

- The source states plainly what this does *not* do: "A converging sequence of gains is not a proof that the supremum over all windows of support Δ is finite."
- All figures (1.3019×10<sup>-10</sup>, 2.4855×10<sup>-1</sup>, 1.91×10<sup>9</sup>×, 4.7968×10<sup>-1</sup>) are quoted exactly.
