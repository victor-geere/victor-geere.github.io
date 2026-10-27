# The quadrature lemma refuted: the profile floor does not order the loss

**Kind:** Proposition
**Status:** REFUTED (the gap/profile hypothesis of rh32 §8 (a); refuted by construction)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §4 "The refutation", lines 508–599 and §7's summary at lines 592–599

## Statement

The refuted hypothesis (rh32 §8(a), quoted in rh33 §1): for mirrored atomic measures whose emptiness profile stays above depth q at all widths beyond K kernel units, prove the atom sum dominates a smoothed density on degree-n forms with loss a function of (q, K) alone.

The refutation:

> Now look at what the emptiness profile sees. Write q<sub>1</sub> for the profile floor beyond one kernel width: the least share of its fair mass that any arc wider than 2π/n holds. This is exactly the quantity rh32 §8 (a) proposed to price the loss with. For the modulated crystal at ε = 0.9, q<sub>1</sub> = 0.803 — because one period of the modulation fits inside one kernel width, so every arc the profile looks at averages it away.
>
> Now the control — and it is exactly the construction rh32 §8 (b) asked for by name. Take the same crystal and thin the atoms in a *half*-kernel-width arc to half density. Its floor comes out at q<sub>1</sub> = 0.803 as well, matching the modulated measure's to 5.9×10<sup>−4</sup> — three digits. At that identical floor the two losses differ by a factor 1.49: the thinned arc keeps ρ = 0.817, the modulation 0.550.
>
> That pair alone answers (b): no function of the profile floor, monotone or not, can be the loss. And the *ordering* reverses too. The strongest pair in the constructed set is a modulated measure whose emptiest arc beyond one kernel width holds 78% of its fair mass losing more than a thinned one whose emptiest arc holds 60% — ρ = 0.500 against 0.704, a factor 1.41 the wrong way. That kills (a): no *monotone* f can satisfy ρ ≥ f(q<sub>1</sub>). Across the whole constructed set — thirty-two measures: weights modulated at three frequencies and six depths, one arc thinned at five widths and four densities, two jittered lattices — 37 of the 446 ordered pairs whose floors differ by at least 0.05 have the fuller measure losing more, and within the band 0.35 ≤ q<sub>1</sub> ≤ 0.85 the losses spread over a factor 1.75.

The source's diagnosis, from §4's close:

> the profile is a statement about how empty the measure looks at kernel scale, and ρ is a statement about what a degree-n polynomial can do with it. A polynomial of degree n resolves frequency n − 1; an arc of width 2π/n does not. Any statistic built from arc masses is blind in exactly the band where the matrix is most sensitive.

## Hypotheses and notation

- q<sub>1</sub> is the profile floor beyond one kernel width: the least share of its fair mass that any arc wider than 2π/n holds.
- The modulated crystal is [rh33-modulated-crystal-loss-exact](rh33-modulated-crystal-loss-exact.md); the control thins a half-kernel-width arc of the same crystal to half density.
- ρ is the loss constant; 32 constructed measures give 446 ordered pairs.

## Proof / evidence

Refutation by construction: at the identical floor q<sub>1</sub> = 0.803 (matching to 5.9×10<sup>−4</sup>) the two losses differ by 1.49; ordering reverses in the strongest pair (78% fuller losing more than 60%, ρ = 0.500 against 0.704); 37 of 446 ordered pairs have the fuller measure losing more. The source notes this is exactly the outcome rh32 §8(b) called the cheaper one.

## Dependencies and related results

- [rh32-two-parameter-conjecture](../rh32/rh32-two-parameter-conjecture.md) — the conjecture whose quadrature step this kills.
- [rh33-modulated-crystal-loss-exact](rh33-modulated-crystal-loss-exact.md) — the exact computation of the counterexample.
- [rh33-moments-are-a-prime-sum](rh33-moments-are-a-prime-sum.md) — §6 supplies the replacement (the moments, i.e. the certified row).
- [rh32-safe-zone](../rh32/rh32-safe-zone.md) — rh32 §8(b) posed the construction.

## Notes

- The source states the gap "as stated does not exist, in two different senses. Its hypothesis class is wrong (§4) ... And its conclusion was never needed (§6)."
- Status REFUTED applies to the profile/gap hypothesis; the source's §6 result is the positive replacement.
