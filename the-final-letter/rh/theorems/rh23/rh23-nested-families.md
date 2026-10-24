# The M = 8 and M = 16 families are nested, exactly

**Kind:** Proposition
**Status:** PROVED (paper argument; VERIFIED (numerical) — refinement reproduces λ<sub>min</sub> to 5.9×10<sup>-12</sup>)
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §3 "(i) The larger family", paragraph "The families are nested, exactly"

## Statement

> A window of the M = 8 family is piecewise linear on the δ = 0.03 grid; sampling it on the δ = 0.015 grid and interpolating linearly returns the same function, because linear interpolation of a piecewise-linear function on a refined grid is exact. Refining rh22's optimum this way reproduces its λ<sub>min</sub> to 5.9×10<sup>-12</sup> at every section size — the residue is the inertia bisection's own floor. So the two searches run over nested sets and the comparison is a real one.

The source also corrects the count:

> rh22 searched h = Σ<sub>k</sub>a<sub>k</sub>φ<sub>δ</sub>(·−kδ) with δ = Δ/8 and |k| ≤ 7 — eight free coefficients after symmetry — and asked what δ = 0.015 would give. It said seventeen. It is sixteen: with Δ = Mδ the support stays exactly [−Δ, Δ] only for |k| ≤ M−1, so M = 16 gives thirty-one coefficients and sixteen free ones.

## Hypotheses and notation

- The M-family is h = Σ<sub>|k| ≤ M−1</sub> a<sub>k</sub> φ<sub>δ</sub>(· − kδ) with δ = Δ/M, giving M free coefficients after symmetry.
- The M = 8 family (rh22) is piecewise linear on the δ = 0.03 grid; the M = 16 family (rh23) on the δ = 0.015 grid.
- The residue 5.9×10<sup>-12</sup> is attributed to "the inertia bisection's own floor".

## Proof / evidence

The argument is the exactness of linear interpolation of a piecewise-linear function on a refined grid, plus the numerical check at every section size to 5.9×10<sup>-12</sup>. The source's dictionary glosses "nested families" as "the M = 8 windows are exactly the M = 16 windows with a<sub>k</sub> linear between even k" / "refinement of a spline space".

## Dependencies and related results

- rh22's search over the M = 8 family ([the search and its certified floor](../rh22/rh22-certified-floors-m0.md)).
- rh22's open item (i), corrected here.
- Extended in rh24 to the ladder M = 8 ⊂ 16 ⊂ 32 ⊂ 64 ([power iteration correction and the local optima](../rh24/rh24-power-iteration-correction.md), [ladder and convergence](../rh24/rh24-family-ladder-convergence.md)).

## Notes

- This is a *correction* of rh22's count (sixteen, not seventeen free coefficients) and of the reason a comparison is legitimate (nestedness, not a coincidence).
- The source states the exactness as a property of piecewise-linear functions on refined grids; the numerical residue is separately reported.
