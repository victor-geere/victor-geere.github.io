# The explicit formula, read from right to left

**Kind:** Theorem
**Status:** CITED (literature — the explicit formula; stated under RH)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §2 "The explicit formula, read from right to left", boxed identity at lines 345–349

## Statement

> E<sub>h</sub>(v) = ∑<sub>ρ</sub> ĥ(γ<sub>ρ</sub>)<sup>2</sup> cos(γ<sub>ρ</sub> v)  =  2 ∑<sub>γ > 0</sub> ĥ(γ)<sup>2</sup> cos(γ v)   under RH.

## Hypotheses and notation

- The test function is H<sub>v</sub>(r) = ĥ(r)<sup>2</sup> cos(rv); ĥ is the window's transform.
- The arc builds E<sub>h</sub>(v) = pole + arch − comb and reads the explicit formula from the left-hand side; this statement reads the same identity the other way.
- The pole term is H<sub>v</sub>(i/2) + H<sub>v</sub>(−i/2); the archimedean term is (1/π)∫<sub>0</sub><sup>∞</sup> ĥ<sup>2</sup>ψ̃cos; the prime term is the comb.
- ρ runs over the non-trivial zeros, γ over the ordinates of the zeros above the real axis.
- "under RH" means every ordinate is real, which is what lets the right-hand side be written as 2 ∑<sub>γ > 0</sub>.

## Proof / evidence

The source states this without proof and explicitly disclaims novelty: "Nothing here is new mathematics — it is the explicit formula — but the arc had never evaluated the right-hand side, and doing so gives a second, independent route to every number in twenty-seven documents." It records that the sum converges absolutely, the envelope of ĥ(r)<sup>2</sup> falling like r<sup>−4</sup> (only the envelope, as §3(0) corrects) with zero density ln(r/2π)/2π. §2 is described as a two-sided check: the same row computed from 4.9 million prime powers and from 22,491 zero ordinates.

## Dependencies and related results

- The zero table (rh29 §2): 22,491 ordinates to T = 20,000, built by Riemann–Siegel with three correction terms, validated against rh11's 1,517 audited ordinates.
- [rh29-symbol-is-an-atomic-measure](rh29-symbol-is-an-atomic-measure.md), [rh29-row-cannot-leave-its-diagonal](rh29-row-cannot-leave-its-diagonal.md), [rh29-lambda-min-tends-to-zero](rh29-lambda-min-tends-to-zero.md) — §3's three items are consequences of this identity read as a moment sequence.
- rh18 (lattice ⇔ windows ⇔ Bochner ⇔ RH), rh27a (the cut at 4800), rh28 — the arc's prior documents the identity connects.

## Notes

- Status is CITED (literature), not PROVED: the source itself says this is the explicit formula and that "nothing here is new mathematics". It is harvested because the document sets it out in its statement box as the rung the whole of §§3–7 stands on.
- §2 hedges the conditional direction: "Everything after it uses the zero side, and the zero side *is* RH — it assumes every ordinate is real."
