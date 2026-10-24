# And the residue is a shared truncation

**Kind:** Claim
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §2, subsection "And the residue is a shared truncation", lines 509–529

## Statement

> The prime side stops its archimedean integral at r = 4800, which rh27a certified; the omitted piece is (1/π)∫<sub>4800</sub><sup>∞</sup>ĥ<sup>2</sup>ψ̃cos. That is the same quantity as ∑<sub>γ>4800</sub>ĥ(γ)<sup>2</sup>cos, because the smooth zero density *is* ψ̃/2π. Cut the zero table in the same place and the two truncations cancel. All five curves in figure 1 bottom out at 4800, and past it the residue stops falling and settles on the arch tail — a factor of 1.12 over the last doubling of T.

The source's numbers for the two sides: they agree to 1.38×10<sup>−7</sup> absolute at Δ′ = 0.48 on a row whose diagonal is 0.707, and to 3.37×10<sup>−5</sup> at the worst of the five supports.

## Hypotheses and notation

- ψ̃ is the smooth zero-density weight; rh27a certified the cut of the archimedean integral at r = 4800.
- γ > 4800 are the zero ordinates above the cut; the zero table is rh29's, cut at 4800.
- The five supports are the arc's five searched windows; the residue is the difference between the prime-side and zero-side rows.

## Proof / evidence

The equality of the discarded archimedean tail with the zero sum is the paper argument (smooth zero density = ψ̃/2π); the cancellation is then measured: all five curves bottom out at 4800, with the figures quoted above. The source frames it as "which turns a piece of rh17's bookkeeping into a measurement".

## Dependencies and related results

- [rh29-explicit-formula-right-to-left](rh29-explicit-formula-right-to-left.md) — the identity whose two sides are being compared.
- rh27a (the certified cut at 4800), rh17 (the interval kit and L1).

## Notes

- The source states that restoring the discarded tail is what makes the arc's certificates conservative: it "raises λ<sub>min</sub> at all five supports and lowers it at none — by 0.0098% at the widest and 1.88% at the narrowest."
- The identical statement appears again in the source's §9 dictionary under "the matched cut".
