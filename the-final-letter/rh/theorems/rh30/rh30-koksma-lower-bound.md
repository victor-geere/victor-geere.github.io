# Route one: Koksma, through the discrepancy

**Kind:** Proposition
**Status:** PROVED (paper argument, using Bernstein's inequality in L<sup>1</sup> and Koksma's inequality; both classical)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §5, subsection "Route one: Koksma, through the discrepancy", lines 1116–1137

## Statement

> For a trig polynomial q = |p|<sup>2</sup> of degree n−1 with unit coefficients, Bernstein's inequality in L<sup>1</sup> gives ‖q′‖<sub>1</sub> ≤ 2π(n−1), and Koksma's inequality against the weighted star discrepancy D*<sub>w</sub> of the atoms gives
>
> λ<sub>min</sub>(T<sub>n</sub>) ≥ E<sub>h</sub>(0) · (1 − 2π(n−1) D*<sub>w</sub>).
>
> This is the arc's first lower bound on λ<sub>min</sub> that is not a Cholesky, and at n = 2 it is within 7% of the truth at the three narrow supports — it is not a weak bound, it is a bound with the wrong shape. It dies at depth v = 1.32, where the certificates reach 18.
>
> And it dies for the reason §2 named: a single atom of relative weight p forces a jump of p in the distribution function, so D*<sub>w</sub> ≥ 1/(2N<sub>eff</sub>) always, and the reach of this route is at most 1 + N<sub>eff</sub>/π whatever the ordinates do. The measured D*<sub>w</sub> is between 1.20 and 7.93 times that floor, so the bound is not losing to the arithmetic of the zeros. It is losing to the window.

## Hypotheses and notation

- q = |p|<sup>2</sup> is a trigonometric polynomial of degree n−1 with unit coefficients.
- D*<sub>w</sub> is the weighted star discrepancy of the atoms; N<sub>eff</sub> is §2's effective count.
- T<sub>n</sub> is the Toeplitz section; E<sub>h</sub>(0) is the diagonal (the total mass).

## Proof / evidence

Paper argument: Bernstein's L<sup>1</sup> inequality plus Koksma's inequality. The reach limit D*<sub>w</sub> ≥ 1/(2N<sub>eff</sub>) is the source's own observation ("a single atom of relative weight p forces a jump of p in the distribution function"). The numerical checks are the 7% agreement at n = 2 at the three narrow supports, the death at depth v = 1.32, and the measured D*<sub>w</sub> lying between 1.20 and 7.93 times the floor.

## Dependencies and related results

- [rh30-effective-count-set-by-window](rh30-effective-count-set-by-window.md) — N<sub>eff</sub>, which caps this route's reach.
- [rh30-marcinkiewicz-zygmund-lower-bound](rh30-marcinkiewicz-zygmund-lower-bound.md) — route two, which reaches further.
- rh30 §5 "The verdict": both routes lose linearly in n; the missing inequality is one that uses q ≥ 0. That is an open direction, not harvested here.

## Notes

- The source is explicit that the bound is not merely weak but wrongly shaped: "The mismatch is in the shape, not in any constant, and no sharpening of the constants would close four decades of it."
