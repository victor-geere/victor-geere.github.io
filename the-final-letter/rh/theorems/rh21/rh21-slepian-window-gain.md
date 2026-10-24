# A Slepian window gains 62×

**Kind:** Claim
**Status:** VERIFIED (numerical, at equal support and equal energy; typical weight 4.22×10⁻⁴ against the triangle hat's 6.76×10⁻⁶; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh21.html`](../../html/rh21.html) — §5 "The window, and the room under the barrier"

## Statement

> A Slepian window of the same support and the same energy, the classical solution to concentrating a transform in a band, achieves 4.22×10⁻⁴: a gain of 62×, closing the gap to 61×. It stays admissible without modification — unit energy keeps C(0) finite, so C = h⋆ȟ is bounded, the comb remains a finite sum, and rh18's identity at arbitrary nodes applies unchanged.

with, from the abstract:

> a Slepian window at the same support and the same energy gains 62×.

## Hypotheses and notation

- Equal support and equal energy comparison, over the first 40 zeros (up to γ = 122.9), at unit energy.
- The barrier of [the window barrier](rh21-window-barrier.md) is 2.56×10⁻²; the triangle hat's typical weight is 6.76×10⁻⁶ ("3,780× under it"); the Slepian's typical weight is 4.22×10⁻⁴, closing the gap to 61×.
- "Typical weight" is the geometric mean of |ĥ(γ<sub>j</sub>)|² over the low zeros (the source's methodological finding: the minimum is a lottery, so window comparisons must use the typical weight).
- The Slepian window is cited as the classical extremal for band concentration: D. Slepian and H. O. Pollak (1961), H. J. Landau and H. O. Pollak (1961).

## Proof / evidence

The source measures the typical weight of the two windows at equal support and energy, and reports the refinement table (M, typical, minimum): 121 → 4.74×10⁻⁴, 4.27×10⁻⁶; 201 → 4.86×10⁻⁴, 3.12×10⁻⁶; 301 → 4.22×10⁻⁴, 3.05×10⁻⁸ — "swing: typical ×1.15, minimum ×140". The document's 32 named checks in 57 s include "the Slepian's gain and the instability of the minimum".

## Dependencies and related results

- [The window barrier](rh21-window-barrier.md) is the ceiling this gain is measured against.
- [rh18 T3](../rh18/rh18-t3-escape-ball.md) and rh19's α turn a window gain into escape radius and certified floor: "every gain there multiplies straight through".
- rh20's [Ceiling](../rh20/rh20-universal-ceiling.md) is what raised the question of varying the hat.

## Notes


- The source's own limits: "What is actually claimed. That a better window exists, that it is worth 62× on the quantity that feeds the certified floor, and that 61× more remains between the best window tried and an elementary barrier. Not that a Slepian is the right choice: it was picked because it is the classical extremal for exactly this concentration problem, and no search over windows was run."
- The source notes it stays admissible without modification, so the 62× does not cost the comb structure.
- Hypothesis: RH for the zeros-side kernel of §2; the barrier itself is unconditional.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
