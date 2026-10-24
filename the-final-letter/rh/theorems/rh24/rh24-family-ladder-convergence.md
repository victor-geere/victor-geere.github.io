# The family ladder M = 8 ⊂ 16 ⊂ 32 ⊂ 64 and its convergence

**Kind:** Proposition
**Status:** PROVED (paper argument; the nesting) with VERIFIED (numerical) gains; convergence is stated as evidence, not as a proof
**Area:** rh-html
**Source:** [`rh24.html`](../../html/rh24.html) — §3 "(a) Where the families converge"

## Statement

> The family is h = Σ<sub>|k| ≤ M−1</sub> a<sub>k</sub> φ<sub>δ</sub>(· − kδ) with δ = Δ/M, giving M free coefficients after symmetry. rh22 ran M = 8, rh23 ran M = 16 and showed the first is exactly a subspace of the second. The same refinement nests every rung: M = 8 ⊂ 16 ⊂ 32 ⊂ 64, each search warm-started at the exact refinement of the last, so the ladder measures the family and not the starting point.
>
> **The answer.** At v = 18 the ladder runs 5.378×10<sup>-3</sup> → 2.741×10<sup>-2</sup> → 2.252×10<sup>-1</sup> → 2.511×10<sup>-1</sup>, and the successive gains are 5.10×, 8.22×, 1.11×. At the other two section sizes the pattern is the same: five to eight for the first doubling, under 1.30 for the last. **The sequence is converging, not growing.** Doubling the coefficient count again would, on this evidence, buy well under a factor of two, and the cost is a δ-row twice as long and a search in 128 dimensions.
>
> What that does *not* establish is a bound. Each family's ceiling bounds only that family; the ceilings themselves grow along the ladder (8.980×10<sup>-3</sup> at M = 8, 8.456×10<sup>-1</sup> at M = 64 at v = 18), so nothing here bounds the supremum over all windows of support Δ. A decaying sequence of gains is evidence of convergence and not a proof of it, and the document says so on the card.

## Hypotheses and notation

- δ = Δ/M; the window h has M free coefficients after symmetry (a<sub>k</sub> = a<sub>−k</sub>).
- "Warm-started" means the M = 2M′ search is seeded at the exact refinement (image) of the M′ optimum — "nested subdivision / multigrid" in the dictionary.
- λ<sub>min</sub> is the achieved floor at v = 18; the ceilings listed (8.980×10<sup>-3</sup> at M = 8, 8.456×10<sup>-1</sup> at M = 64) are family-specific.

## Proof / evidence

- Nesting: shown in [rh23's nested-families result](../rh23/rh23-nested-families.md) and extended rung by rung with the exact refinement of the previous optimum.
- Search: performed with the corrected best-response ([the power-iteration correction](rh24-power-iteration-correction.md)).
- The source's §5 records six certificates through rh23's route unchanged and the deepest certified floor 4.7968×10<sup>-1</sup> against rh23's 2.5778×10<sup>-1</sup>.

## Dependencies and related results

- [rh23's nested families](../rh23/rh23-nested-families.md); [the power-iteration correction](rh24-power-iteration-correction.md).
- The ceilings of [rh22](../rh22/rh22-ceiling-for-every-window.md) and [rh23's comparison](../rh23/rh23-ceiling-comparison-8-vs-16.md).
- The question this leaves — the supremum over all windows of support Δ — is answered negatively in [rh25's no-ceiling result](../rh25/rh25-no-ceiling-all-windows.md).

## Notes

- The source states the convergence *as evidence, not proof*: "A decaying sequence of gains is evidence of convergence and not a proof of it."
- The ladder values (5.378×10<sup>-3</sup>, 2.741×10<sup>-2</sup>, 2.252×10<sup>-1</sup>, 2.511×10<sup>-1</sup>) and gains (5.10×, 8.22×, 1.11×) are quoted exactly.
