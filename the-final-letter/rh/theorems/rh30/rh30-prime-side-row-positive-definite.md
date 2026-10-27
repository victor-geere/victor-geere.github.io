# The prime-side row is positive-definite for every window

**Kind:** Proposition
**Status:** PROVED (paper argument, by Bochner; VERIFIED numerically on 24 random windows)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §9 "Where the conjunction stands", lines 1657–1671

## Statement

> Detrended, closure is the balance of the marked points, and the weights are ĥ(γ)<sup>2</sup> — squares. rh29's identity says the row the arc computes from the primes *is* the row the zeros give. A row of the form 2∑<sub>γ</sub>ĥ(γ)<sup>2</sup>cos(γv) is a non-negative combination of cosines, so it is positive-definite by Bochner, for *every* window whatever. Which means the prime-side row inherits that, and positivity is not a thin property to be certified point by point.

The source's numerical check:

> Checked at 24 coefficient vectors drawn uniformly from the sphere, the prime-side row and the zero-side row still agree to 5.2×10<sup>−6</sup> of the diagonal — and all 24 of those random windows are positive-definite on the prime side, as all 8 tested are on the zero side. Not one indefinite form in the sample.

## Hypotheses and notation

- The row is 2∑<sub>γ</sub>ĥ(γ)<sup>2</sup>cos(γv), a non-negative combination of cosines because the weights ĥ(γ)<sup>2</sup> are squares.
- "for every window whatever" quantifies over the arc's family of windows, not over all admissible test functions.
- Bochner's theorem supplies positive-definiteness from the non-negative cosine combination.
- The 24 coefficient vectors are drawn uniformly from the sphere of the family's 16 free coefficients (symmetrised to 31).

## Proof / evidence

Paper argument (Bochner). The numerical evidence is the 24-draw check: prime-side and zero-side rows agree to 5.2×10<sup>−6</sup> of the diagonal, all 24 prime-side forms are positive-definite, all 8 tested zero-side forms are.

## Dependencies and related results

- [rh29-symbol-is-an-atomic-measure](../rh29/rh29-symbol-is-an-atomic-measure.md) and [rh29-explicit-formula-right-to-left](../rh29/rh29-explicit-formula-right-to-left.md) — the identity that makes the prime-side row equal the zero-side row.
- [rh30-detrended-helix-closure](rh30-detrended-helix-closure.md) — the detrended picture this is read from.
- [rh30-weil-criterion-direction](rh30-weil-criterion-direction.md) — the logical consequence the source draws from it.

## Notes

- The source states this as a correction of how the programme's certificates should be read, not as new arithmetic: "It is not a small correction, so here is the measurement rather than the argument."
- The claim is scoped to the arc's window family; the source does not claim it for arbitrary admissible windows.
