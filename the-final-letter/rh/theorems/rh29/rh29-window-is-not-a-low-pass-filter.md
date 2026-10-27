# (0) The window is not a low-pass filter

**Kind:** Claim
**Status:** PROVED (paper argument; numerical values VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §3 "The measure, and three things that follow", item (0), lines 1440–1451

## Statement

> (0) The window is not a low-pass filter. A digression, but it corrects something three documents have assumed. ĥ(r)<sup>2</sup> = Û<sub>c</sub>(r)<sup>2</sup>A(r)<sup>2</sup>, and only the envelope Û<sub>c</sub><sup>2</sup> falls like r<sup>−4</sup>; A is the coefficient polynomial and is periodic in r with period 2π/δ = 837.8. rh25's search drove A almost to zero at small r — the pole term 2ĥ(i/2)<sup>2</sup> is 5.8×10<sup>−4</sup> against a diagonal of 0.300 — so the atom at γ<sub>1</sub> is 10.8 times *lighter* than the heaviest of the first 300, at γ = 364.74, and carries 0.10% of the total mass.

## Hypotheses and notation

- ĥ(r) = Û<sub>c</sub>(r)·A(r) is the window's transform, split into envelope and coefficient polynomial.
- δ is the gear spacing; the period of A is 2π/δ = 837.8.
- γ<sub>1</sub> = 14.1347 is the first zero ordinate; "the heaviest of the first 300" is at γ = 364.74.
- The diagonal is the total mass E<sub>h</sub>(0) of the measure.

## Proof / evidence

The factorisation ĥ<sup>2</sup> = Û<sub>c</sub><sup>2</sup>A<sup>2</sup> and the periodicity of A are stated as the reason; the size figures (5.8×10<sup>−4</sup> against 0.300, 10.8 times lighter, 0.10% of the total mass) are measurements. The source's consequence is negative and explicit: "Any argument in this arc that treated γ<sub>1</sub> = 14.1347 as where the mass sits — §6 was about to be one — is arguing about 0.10% of the measure."

## Dependencies and related results

- rh25's search (which drove A near zero at small r).
- [rh29-symbol-is-an-atomic-measure](rh29-symbol-is-an-atomic-measure.md) — the measure whose atom weights this is about.
- [rh29-offline-quadruple-exclusion-test](rh29-offline-quadruple-exclusion-test.md) — uses (0) to note that γ<sub>1</sub> is not the best place to point the test.

## Notes

- The source itself calls this item "a digression", but it is a labelled item of §3 and it states a correction three documents had assumed; it is harvested because of that label.
- The envelope claim is qualified in the source: only the envelope falls like r<sup>−4</sup>, not the window.
