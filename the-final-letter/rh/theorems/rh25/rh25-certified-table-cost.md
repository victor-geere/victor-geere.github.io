# (4) The tabulated comb — an exact interpolation-error envelope and the measured cost

**Kind:** Proposition
**Status:** PROVED (paper argument — the envelope is exact because every factor is monotone on its piece) with VERIFIED (numerical) timings
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §2 "(b) The certified comb for a smooth window", equations (4)–(5)

## Statement

> **The table, and what it costs.** The alternative is to tabulate V<sub>c</sub> once and interpolate. Cubic interpolation on a grid aligned to the knot at |x| = δ keeps every panel inside one analytic piece, so the error is h⁴sup|V<sub>c</sub>⁗|/24 with an explicit fourth derivative,
>
> (4) V<sub>c</sub>⁗ = [ c⁴(x−δ)cosh cx + 3c³sinh cx + xc⁴cosh(cz)/2 − (3/2)c³sinh cz ] / sinh²(cδ), z = 2δ − x,
>
> every factor of which is monotone on its piece, so the envelope is exact. The nodes are built in the interval kit and the coefficients carry their own widths, and the panel count is chosen automatically: refine until the interpolation error drops below the double-rounding of the stored coefficients, past which a finer table buys nothing. That lands between 512 and 32,768 panels depending on θ, and leaves a worst-case table error of 1.4×10<sup>-17</sup> across all 10 generators.
>
> The cost, with all three written the way the sieve's inner loop has them — inlined, no function call, one generator, one shift, 600,000 evaluations:
>
> (5) cubic 0.08 s · certified table 0.16 s (2.09×) · closed form (2) 0.13 s (1.77×) · regrouped form (3), as a call, 0.57 s (7.53×).
>
> Not a decade — under 2.1× either way. Which of the two smooth routes is faster is not stable across runs on a shared machine, and that is the useful finding: the table costs nothing to prefer, so it can be preferred for the two reasons that do not move. It touches no library function at all, and it is right.

## Hypotheses and notation

- V<sub>c</sub> is the generator of [equation (1)](rh25-hyperbolic-hat-transform.md); z = 2δ − x; h is the interpolation panel width.
- The error bound is h⁴sup|V<sub>c</sub>⁗|/24, with V<sub>c</sub>⁗ as in (4); the envelope is exact because every factor is monotone on its piece.
- Panel counts land between 512 and 32,768 depending on θ; worst-case table error 1.4×10<sup>-17</sup> across all 10 generators.
- Timings are over 600,000 evaluations, inlined, no function call, one generator, one shift.

## Proof / evidence

The interpolation error bound is stated and its ingredients argued monotone ("every factor of which is monotone on its piece, so the envelope is exact"); the panel count is chosen by the auto-refinement rule; the timings are measured and the source notes they are machine-dependent ("Which of the two smooth routes is faster is not stable across runs on a shared machine").

## Dependencies and related results

- rh24 priced the smooth comb at "six transcendentals where a cubic costs three multiplications" and left it unmeasured; this result replaces that estimate (source: "It also left the estimate untested").
- The table's error enters the certificate through [the binned radius with table error (6)](rh25-binned-radius-table-error.md).
- Preferred route for [the notch-free family search](rh25-notch-free-family-searched.md).

## Notes

- The timings (0.08 s, 0.13 s, 0.16 s, 0.57 s) and factors (2.09×, 1.77×, 7.53×) are quoted exactly; the source stresses the ordering of the two smooth routes is not stable.
- The source's reason for preferring the table is not speed: "It touches no library function at all, and it is right."
