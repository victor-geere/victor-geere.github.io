# (iii) λ<sub>min</sub> → 0 is required by RH

**Kind:** Proposition
**Status:** PROVED (paper argument, under RH; via Szegő's infimum theorem, cited)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §3 "The measure, and three things that follow", item (iii), lines 1471–1479

## Statement

> (iii) λ<sub>min</sub> → 0 is required by RH. μ is purely atomic: countably many points, no absolutely continuous part at all. So the geometric mean exp(∫ln w) of its a.c. density is zero, and by Szegő's infimum theorem the n-step prediction error — which dominates λ<sub>min</sub>(T<sub>n</sub>) — falls to zero.

## Hypotheses and notation

- μ is the atomic measure of item (i).
- λ<sub>min</sub>(T<sub>n</sub>) is the smallest eigenvalue of the n-th Toeplitz section of the arc's row.
- "the geometric mean exp(∫ln w) of its a.c. density is zero" — the source's shorthand for the Szegő infimum of a purely atomic symbol.
- Szegő's infimum is quoted in the source's dictionary as: inf<sub>n</sub> λ<sub>min</sub>(T<sub>n</sub>) ≤ the geometric mean of the symbol's a.c. part.

## Proof / evidence

The source's argument: μ has no absolutely continuous part, so the geometric mean of the a.c. density is zero, and Szegő's infimum theorem gives that the n-step prediction error (which dominates λ<sub>min</sub>(T<sub>n</sub>)) falls to zero. Szegő's theorem itself is cited, not reproved. The source also corrects rh28's reading: "rh28 read its own depth curve as bad news... It was not. A decay to zero is what RH predicts; a floor that held uniformly in the depth would have been the alarming observation."

## Dependencies and related results

- [rh29-symbol-is-an-atomic-measure](rh29-symbol-is-an-atomic-measure.md) — supplies the purely atomic μ.
- [rh29-depth-curve-past-one-decade](rh29-depth-curve-past-one-decade.md) — the measured depth curve whose decay this explains.
- rh28 (the Fejér ceiling and the depth curve), rh27c (the log-Sobolev ceiling).

## Notes

- The source flags the remainder as open in its own words: "What is open is the rate, and only the rate." That rate is not harvested here.
- Conditional on RH, like every statement about μ in rh29 after §2.
