# The optimal-window frontier D*(a) = 1/(b₀ᵀM⁻¹b₀)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh12.html`](../../html/rh12.html) — §2 "Dig one — the frontier: the optimal window, solved", equation (1)

## Statement

> W(t&#8320;) = 2∑<sub>γ</sub>[h(γ−t&#8320;) + h(γ+t&#8320;)] = **f**<sup>T</sup> M(t&#8320;) **f**, &nbsp;&nbsp; h(0) = (**b**&#8320;·**f**)² = 1,
>
> with M built from the 1517 zeros plus the density tail beyond the table … Minimising a positive quadratic form under one linear constraint is a single linear solve: D*(a) = 1/(**b**₀ᵀM⁻¹**b**₀). One matrix, one inversion, the *exact* optimum over the entire infinite-dimensional family at that budget — the matched filter for the quietest point of the spectrum, tuned here to the dip at t₀* = 17.1.

The measured frontier: D*(a) falls from 0.90 (two gears) through 2.6×10<sup>−4</sup> (8 gears), 5.0×10<sup>−6</sup> (12), to 1.6×10<sup>−7</sup> (41), flattening past ~27 gears.

## Hypotheses and notation

- Profile **f**: a vector on nodes (piecewise-linear, even, vanishing at ±a); h = |f̂|².
- Fixed gear budget: support of g inside [−2a, 2a], so only gears with log n ≤ 2a are consulted.
- M(t₀) is the zeros-side matrix built from the 1517 zeros plus the density tail beyond T = 2000 (residual leak measured &lt; 10<sup>−3</sup> of the answer); **b**₀ is the constraint vector with **b**₀·**f** = f̂(0).
- D*(a) is the deepest dip a bandlimited window of support a can drive the Weil-positivity reading to.

## Proof / evidence

The source gives the argument (the scanned functional is exactly quadratic in the window, so minimising it under one linear constraint is a single linear solve) and reports the computed frontier, its agreement with the direct zeros-side evaluation, and the explicit-formula certification of the winning window to 2×10<sup>−4</sup>. The closing audit of the page states: "the optimal-window solver's residuals (< 10⁻⁸), positivity of every D*, monotone frontier, beyond-table leakage < 10⁻³ of D*, EF certification of the winner to 2×10⁻⁴, and its D* equal to the direct zeros-side reading".

## Dependencies and related results

- [Weil positivity: W(h) ≥ 0 for every h = |f̂|²](../rh10/rh10-weil-positivity-criterion.md) — the criterion being optimised (rh4 §15's Axiom 8).
- [The Lehmer-pair collision bound λ* = −0.00119](../rh11/rh11-lehmer-pair-collision-bound.md) — the companion hunt of the same document.
- rh13 §3 builds this window space into a full 25×25 Gram matrix; rh14 §3 and rh15 §4 continue the frontier inside the merged kernel.

## Notes

- The reduction to one linear solve is an argument of the source; the frontier numbers are floating-point computations on a truncated zero table with a stated leakage bound.
- The source reads the value as a price schedule: "past ~27 gears the frontier flattens toward ~1.6×10⁻⁷, and the limiting floor is set by the zero table's own precision." rh15 §4 later qualifies the D* frontier as arithmetic but unconverged (quote it only with the mesh it was computed at).
