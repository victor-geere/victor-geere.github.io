# The margin identity (10)–(11) — Turán positivity ⟺ the Cauchy–Schwarz defect is smaller than the factorial gain

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/POSITIVITY.md`](../../xi-horn/POSITIVITY.md) — §3 "The margin identity", equations (10)–(11)

## Statement

> Dividing (9) into the ratio splits it exactly:
>
> ```
>   c(n+1)²        γ(n+1)²        (2n+3)(2n+4)
>  ─────────  =  ───────────  ×  ──────────────                              (10)
>  c(n)c(n+2)    γ(n)γ(n+2)      (2n+1)(2n+2)
> ```
>
> The first factor is ≤ 1 always, by (8). The second is > 1 always, and ≈ 1 + 2/n. So:
>
> > **Turán positivity holds at n ⟺ the horn's Cauchy–Schwarz defect is smaller than the factorial gain:**
> >
> > ```
> > Δ²log γ(n)  <  log[ (2n+3)(2n+4) / ((2n+1)(2n+2)) ]   ≈  2/n           (11)
> > ```
>
> A contest between two explicit quantities, both computable from Φ alone. Define the **margin ratio** as the left side over the right; positivity is `< 1`.

The source tabulates the two sides and their ratio:

> ```
>    n    C–S defect Δ²log γ     factorial gain     margin ratio
>    0        1.026436807         1.791759469        0.5729
>    1        0.4499716953        0.9162907319       0.4911
>    2        0.2835920375        0.6241543091       0.4544
>    4        0.1583657953        0.3829922523       0.4135
>    8        0.0804389016        0.2165861508       0.3714
>   10        0.0637222861        0.1779831552       0.3580
>   15        0.0411732598        0.1231449788       0.3343
>   20        0.0299578831        0.0941480646       0.3182
>   25        0.0233284112        0.0762066088       0.3061
>   30        0.0189831488        0.0640095605       0.2966
>   32        0.0176418349        0.0601583127       0.2933
> ```
>
> Both sides decay like const/n; the defect's constant is ≈ 0.57 against the gain's 2, and the ratio drifts *down* — the inequality gets safer with depth over the range computed.

## Hypotheses and notation

- c(n) = γ(n)/(2n)! are the Taylor coefficients of ξ about ½ (equation (9)); γ(n) are the even moments (equation (7)).
- The Cauchy–Schwarz defect is Δ²log γ(n) = log γ(n+2) − 2 log γ(n+1) + log γ(n) > 0, forced by (8).
- The factorial gain is log[(2n+3)(2n+4)/((2n+1)(2n+2))] ≈ 2/n > 0.
- The margin ratio is defect/gain; Turán positivity holds iff the ratio is < 1.
- The table is at 60 decimal digits for n = 0 … 32.

## Proof / evidence

The source derives (10) by substituting c(n) = γ(n)/(2n)! into the ratio c(n+1)²/(c(n)c(n+2)) and separating the moment ratio from the factorial factor ((2n+3)(2n+4))/((2n+1)(2n+2)). The first factor is ≤ 1 by (8); the second exceeds 1 and is ≈ 1 + 2/n. Taking logarithms splits the Turán inequality into the contest (11). The source also tabulates both sides and the ratio for selected n = 0 … 32, observing that both decay like const/n with constants ≈ 0.57 and 2 and that the ratio drifts downward.

## Dependencies and related results

- The forced log-convexity (8): [xihorn-positivity-moment-sequence-forced-log-convex.md](xihorn-positivity-moment-sequence-forced-log-convex.md).
- The Turán inequality (9): [xihorn-positivity-turan-inequality-for-xi.md](xihorn-positivity-turan-inequality-for-xi.md).
- The holomorphic continuation of this margin: [xihorn-continuation-holomorphic-margin.md](xihorn-continuation-holomorphic-margin.md) and [xihorn-continuation-asymptotic-law-limit-four.md](xihorn-continuation-asymptotic-law-limit-four.md).

## Notes

- The source's §3 caveat: "Do not over-read that. It is 33 values of one d = 2 condition, it is not a proof, and it is not the same quantity as the certified floors of rh19–rh27a. rh28/rh29's 'worse than a power law' is about a different object; nothing here softens it."
- The downward drift of the ratio is "an observation over 33 points, not a trend with a proof, and not transferable to rh28/rh29's floors" (§6).
