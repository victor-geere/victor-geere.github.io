# The mean square over the zeros is the same linear functional either way (agreeing to 1.9×10⁻¹²)

**Kind:** Claim
**Status:** PROVED (paper argument); VERIFIED (numerical, 1.9×10⁻¹² of the mass)
**Area:** rh-html
**Source:** [`rh36.html`](../../html/rh36.html) — §2 "The instrument"

## Statement

> rh35 §4 modulated the moment function by averaging two shifted copies of it, which is correct and expensive: every new frequency needs the whole zero table swept again for a fresh key set. The same object is reached by re-weighting the measure,
>
> w<sub>γ</sub> → w<sub>γ</sub>(1 + a cos(v₀γ)),  nonnegative for |a| ≤ 1 by inspection,
>
> because *E* is the same linear functional of the weight either way: ½(E(k+v₀) + E(k−v₀)) = 2∑<sub>γ</sub> w<sub>γ</sub> cos(kγ) cos(v₀γ). The cosines depend only on the key set, which is fixed by the gear set, so they are computed once and a re-weighting is one pass. The two forms agree to 1.9×10⁻¹² of the mass, which is the roundoff of summing four thousand cosines two different ways.

## Hypotheses and notation

- w<sub>γ</sub> is the weight at ordinate γ; a is the modulation amplitude with |a| ≤ 1; v₀ is the modulation frequency.
- The two shifted copies: ½(E(k+v₀) + E(k−v₀)) versus the re-weighted E(k).
- "Key set": the cosines cos(kγ), fixed by the gear set and computed once.

## Proof / evidence

By the displayed identity, then numerically: the two forms agree to 1.9×10⁻¹² of the mass. Two regressions fix the instrument against rh35: the floor on the first twenty-four gear rates is 0.293898, and putting the whole budget on log 2 drives it to 0.101006.

## Dependencies and related results

- [rh35-quadrature-lemma-refuted-on-g](../rh35/rh35-quadrature-lemma-refuted-on-g.md) — rh35 §4's averaging of shifted copies, replaced by one pass here.
- [rh34-unwrapped-gram-and-dirichlet-polynomial](../rh34/rh34-unwrapped-gram-and-dirichlet-polynomial.md) — E and G in rh34's vocabulary.
- [rh39-annihilator-is-a-genuine-bound](../rh39/rh39-annihilator-is-a-genuine-bound.md) — rh39 later weighs the mass with the same re-weighted E.

## Notes

- The source describes this as the instrument's identity, unconditional arithmetic; it is what makes the sweeps in §§3–6 affordable.
- The re-weighting is nonnegative for |a| ≤ 1 "by inspection", which is the constraint the later searches also impose.
