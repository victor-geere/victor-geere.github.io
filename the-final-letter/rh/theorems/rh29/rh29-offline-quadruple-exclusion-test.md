# The single-quadruple exclusion test

**Kind:** Claim
**Status:** PROVED (paper argument, conditional on a single off-line quadruple; VERIFIED at 151 nodes)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §7 "What an off-line zero would do", lines 1813–1856 and boxed table at lines 1837–1839

## Statement

> ĥ is entire, so the identity in §2 continues off the real axis. A zero at ½ ± σ ± iγ contributes to E<sub>h</sub>(v) the quantity 4 Re[ĥ(γ+iσ)<sup>2</sup> cos((γ+iσ)v)], whose size grows like e<sup>σv</sup>. ... a quadruple at γ<sub>1</sub> with σ = 0.5 is 3,917 times larger at v = 18 than at v = 0.
>
> So the bound of §3(ii) is a test with teeth in principle. A single off-line quadruple at γ<sub>1</sub> would have pushed |E<sub>h</sub>| past E<sub>h</sub>(0) somewhere in v ≤ 18 if its σ exceeded 0.3854. It did not; the test passed at all 151 nodes. And by §3(0) γ<sub>1</sub> is not the best place to point it: sweeping the first sixty ordinates, the sharpest test is at γ = 107.17, which catches a quadruple at σ = 0.3258.
>
> It is also a very weak test, and the weakness is structural. What has to beat the diagonal is e<sup>σv</sup>, so the excluded σ falls only like 1/V:
>
> V = 18: σ > 0.3854  •  V = 36: σ > 0.1928  •  V = 72: σ > 0.0966  •  V = 144: σ > 0.0486  •  V = 288: σ > 0.0242  •  V = 576: σ > 0.0121

## Hypotheses and notation

- A quadruple is the four zeros ½ ± σ ± iγ (off the critical line if σ ≠ 0); V is the depth reached.
- The test uses the §3(ii) bound |E<sub>h</sub>(v)| ≤ E<sub>h</sub>(0).
- 16% better (γ = 107.17 vs γ<sub>1</sub>): the source adds "and 16% off a useless region is a useless region."

## Proof / evidence

The growth e<sup>σv</sup> is the paper argument (ĥ entire, identity continued off the real axis); the exclusion thresholds are computed from the §3(ii) bound and checked against the 151 measured nodes. The source also notes the sharper route's own limit: "reaching σ = 0.01 by this route would need a certified row to depth 576, which is thirty-two times rh19's horizon and costs e<sup>576</sup> in primes."

## Dependencies and related results

- [rh29-row-cannot-leave-its-diagonal](rh29-row-cannot-leave-its-diagonal.md) — the bound this test uses.
- [rh29-window-is-not-a-low-pass-filter](rh29-window-is-not-a-low-pass-filter.md) — item (0), used to relocate the test to γ = 107.17.
- rh27a (the 4 Re[ĝ(γ+iσ)<sup>2</sup>] route), rh19 (the v = 18 horizon).

## Notes

- The source flags the hypothesis explicitly and treats the multi-quadruple case as open: "the bound above assumes there is *one* quadruple. Several at different γ can cancel one another at every node measured, and ruling that out needs a zero-density input the arc does not have." That obstruction is listed under "What is left (c) the conspiracy bound" and is not harvested as a result.
- The source's own verdict on the test is that it is weak and that σ = 0.385 at γ ≈ 14 "is a region ruled out far more cheaply by counting zeros".
