# Radius to its limit, and the certified horizon moves to n = 82 (v = 19.44)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical, evidence absent) — 768-bin radius, certified floors: the source's "59 named checks" are not in this repository)
**Area:** rh-html
**Source:** [`rh24.html`](../../html/rh24.html) — §2 "(b) The radius, to its limit — and the horizon", equations (1)–(2)

## Statement

> rh23's bound was
>
> (1) ρ<sup>bin</sup><sub>p</sub> = δu · Σ<sub>bins</sub> sup<sub>bin</sub>|C<sub>h</sub>′| · M<sub>Δ</sub>(p, bin) + ε · Σ<sub>bins</sub> sup<sub>bin</sub>Q<sub>h</sub> · M<sub>Δ</sub>(p, bin),
>
> with 24 bins across [0, 2Δ], M<sub>Δ</sub>(p, bin) the gear mass the sieve put in that bin at node p, and Q<sub>h</sub> the local ℓ¹ norm that multiplies the per-term rounding. Refining the bins can only shrink it — a supremum over a smaller set is smaller — and in the limit it becomes the exact mass-weighted integral of |C<sub>h</sub>′| against the prime-power measure.
>
> Not much. Going from 24 bins to 768 adds 1.069× for the hat and 1.480× for the searched window, and the curve is visibly flat by 384. Against rh22's recombined bound the totals are 10.57× and 2.85×, so rh23 already had 94% of what the method can give for the hat and 68% for the searched window.
>
> (2) the deepest section the triangle hat can certify moves from rh19's n = 76 (v = 18.00) to n = 82 (v = 19.44).

## Hypotheses and notation

- [rh23's binned radius](../rh23/rh23-binned-radius.md) with the bin count refined from 24 to 768; ε is the per-term rounding constant of the binned bound.
- M<sub>Δ</sub>(p, bin) is the gear mass in a bin at node p; Q<sub>h</sub> is the local ℓ¹ norm.
- "Margin" is the ratio λ<sub>min</sub>/radius; the certified horizon is the deepest n at which the margin stays above 1.

## Proof / evidence

- Refinement monotonicity: "a supremum over a smaller set is smaller"; the limit is the exact mass-weighted integral ∫|C<sub>h</sub>′| dμ.
- Numerical: 1.069× (hat) and 1.480× (searched) from 24 → 768 bins; totals 10.57× and 2.85× against rh22's recombined bound.
- The horizon ladder is recomputed over rh19's longer sieve at 768 bins: "the triangle hat's margin is 6.48× at n = 76, 2.08× at n = 80, and drops below 1 at n = 83."
- For searched windows, "Their margins never fall below 1.5×10<sup>7</sup> at any n the sieve reaches, and their floors barely decay … from v = 18.00 to v = 19.92 the M = 8 optimum loses a factor 1.11 and the M = 16 optimum 1.78, against the hat's 3.25."

## Dependencies and related results

- [rh23's binned radius](../rh23/rh23-binned-radius.md); rh19's deepest certified section (n = 76, v = 18.00) and its own comb reaching v = 19.92.
- rh21's conclusion that the sieve, not the arithmetic, is the wall at v ≈ 27–30 — which this result makes "literally true" for a searched window.
- The same refinement idea extended with a table-error term in [rh25's binned radius with table error (6)](../rh25/rh25-binned-radius-table-error.md).

## Notes

- The source calls this "the first time the arc's certified horizon has moved since rh19" and is careful about the scope: the gain is "Modest in v".
- The bin-refinement gains and the horizon figures are quoted exactly.

- **Correction (2025-10-06, session 003 residual-defect repair).** The numerical half of the Status rested on `rh24.html`'s "59 named checks in 1182 seconds" (`rh24.html:2148`). **No such artefact is in this repository**: a tree-wide search for a script or log computing the 768-bin radius or the certified floors finds nothing, and the figures (the horizon at `v = 19.44`, the floors) exist only as prose in the source page. The qualifier `evidence absent` now says so. The paper-argument half of the label is unaffected.
