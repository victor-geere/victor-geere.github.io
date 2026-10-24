# The localisation lemma (rh31 §8 (a))

**Kind:** Lemma
**Status:** CONJECTURED (stated as the open target; measured constant 1/1.81)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §7 "Where the conjunction stands", lines 1593–1602, and §8 "What this document leaves", subsection "(a) the localisation lemma", lines 1629–1632

## Statement

> The conjunction-shaped statement this leaves is sharper than the one rh30 left. Then: "prove the collapse." Now: prove that for a positive atomic measure the minimising nonnegative polynomial localises — that λ<sub>min</sub> ≥ c·min<sub>θ</sub>∫K<sub>n</sub> dμ for an absolute constant c, in the regime n below the resolved-atom count. The measured c is 1/1.81 on everything tried.

and §8(a):

> Prove λ<sub>min</sub> ≥ c·C<sub>n</sub>(μ) for n ≤ N<sub>eff</sub>-ish resolutions, atomic μ, absolute c. The measured c is 1/1.81 ≈ 0.55; the natural tools are the ones rh30 §10 named (Beurling–Selberg, one-sided approximants) now aimed at a localisation rather than a global floor. Fail honestly: find the measure that drives c to zero, which would itself be a structure statement about where certificates die.

## Hypotheses and notation

- μ is a positive atomic measure; C<sub>n</sub>(μ) = min<sub>θ</sub>∫K<sub>n</sub>(θ−t)dμ(t) is §5's emptiest-arc density.
- c is to be an absolute constant; the regime is n below the resolved-atom count (equivalently n ≲ N<sub>eff</sub>).
- The measured value is c = 1/1.81 ≈ 0.55 across everything tried.

## Proof / evidence

No proof; the source states it as the target and records the measurement of c on the grid of [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md). Both branches are named: proving the localisation would convert every emptiest-arc computation into a certified floor; the failure branch would be the measure that drives c to zero.

## Dependencies and related results

- [rh31-fejer-ceiling-dominates-lambda-min](rh31-fejer-ceiling-dominates-lambda-min.md) — the proved inequality C<sub>n</sub> ≥ λ<sub>min</sub> this would tighten in the other direction.
- [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md) — the measurement that supplies c = 1/1.81.
- [rh32-absolute-constant-refuted](../rh32/rh32-absolute-constant-refuted.md) — rh32 §7 executes the failure branch: the lemma with absolute c is false.
- rh30 §10 (b) (Beurling–Selberg majorants) — the tools the source proposes.

## Notes

- This is harvested as a labelled result (the source calls it "the localisation lemma") but its status is CONJECTURED: the source states it as what must be proved, and honours the negative branch in advance.
- The source states the boundary is part of the content: "it is false past the bulk, so its boundary is part of its content."
