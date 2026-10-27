# The ceiling stays comparable: 1.80–3.17× in the sixteen-coefficient family against 2.33–2.69× in rh22's

**Kind:** Proposition
**Status:** PROVED (paper argument; the ceiling itself; VERIFIED (numerical) values for the optima)
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §3 "(i) The larger family", paragraph following Figure 2

## Statement

> The search gains 2.2× at v = 4.08, 7.7× at v = 12 and 7.4× at v = 18. What the number means is fixed by the ceiling of rh22 §4 — for any test vector c, max<sub>h</sub>min<sub>c</sub> ≤ min<sub>c</sub>max<sub>h</sub>, so the minimum over the cutting planes the search itself generates is a proven upper bound on m₀ for every window in the family. In the sixteen-coefficient family that ceiling sits 1.80–3.17× above the optimum, against 2.33–2.69× in rh22's. **Comparable** — and that is the answer to item (i). rh22's search was near its own family's best, exactly as its ceiling claimed; what limited it was the family, and doubling the family buys another 2.2–7.7×. Nothing here says where the supremum over *all* windows of support Δ sits: each ceiling bounds only its own family, and the sequence of families is not bounded by any of them.

## Hypotheses and notation

- m₀ is the quantity the certificates spend; the ceiling is [rh22's equation (3)](../rh22/rh22-ceiling-for-every-window.md), m₀(h) ≤ min<sub>c ∈ 𝒞</sub>λ<sub>top</sub>(M<sub>c</sub>, G)·C<sub>h</sub>(0) for every h in the family.
- The sixteen-coefficient family is the M = 16 family of [the nested-families result](rh23-nested-families.md).
- The comparison ratios are the ceiling's distance above the attained optimum: 1.80–3.17× (M = 16) against 2.33–2.69× (M = 8, rh22).

## Proof / evidence

The ceiling is a theorem (rh22 §4); the attained optima and the ratios are computed by the search. §6 records the regression: "56 named checks in 248 seconds … rh22's λ<sub>min</sub> values are reproduced bit for bit before anything is built on them."

## Dependencies and related results

- [rh22's ceiling (3)](../rh22/rh22-ceiling-for-every-window.md).
- The M = 16 search results and the gain factors 2.2× / 7.7× / 7.4× are quoted by this statement.
- The question of the supremum over all windows is *retired* in [rh25's no-ceiling result](../rh25/rh25-no-ceiling-all-windows.md); rh24 reports the ceilings growing along the ladder ([ladder and convergence](../rh24/rh24-family-ladder-convergence.md)).

## Notes

- The source draws the narrow conclusion it supports: "rh22's search was near its own family's best … what limited it was the family". It explicitly refuses the stronger reading about all windows.
- The figures 2.2×, 7.7×, 7.4×, 1.80–3.17×, 2.33–2.69× are quoted exactly.
