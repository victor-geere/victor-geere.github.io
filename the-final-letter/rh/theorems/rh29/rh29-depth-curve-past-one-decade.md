# The depth curve, past one decade

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §4 "(b) The depth curve, past one decade", lines 1483–1529 and boxed table at lines 1623–1629

## Statement

> Δ′ = 0.48   v = 1.44 to 288   λ<sub>min</sub> = 4.98×10<sup>−1</sup> → 2.21×10<sup>−5</sup>   secant 1.89
> Δ′ = 0.24   v = 1.2 to 144   λ<sub>min</sub> = 3.72×10<sup>−1</sup> → 3.79×10<sup>−5</sup>   secant 1.92
> Δ′ = 0.12   v = 1.44 to 72   λ<sub>min</sub> = 2.81×10<sup>−1</sup> → 4.87×10<sup>−4</sup>   secant 1.62
> Δ′ = 0.06   v = 1.08 to 36   λ<sub>min</sub> = 1.70×10<sup>−1</sup> → 4.92×10<sup>−3</sup>   secant 1.01
> Δ′ = 0.03   v = 1.14 to 18   λ<sub>min</sub> = 8.74×10<sup>−2</sup> → 2.89×10<sup>−2</sup>   secant 0.40

The source's reading of it: "Over v ∈ [18, 72] the mean slope at Δ′ = 0.12 is 3.73, against the 0.41 endpoint secant rh28 published for [1, 18]. rh28 called that extrapolation optimistic; it was optimistic by a factor of 9 in the exponent. The end-to-end secants over the extended ranges are 1.89, 1.92, 1.62, 1.01, 0.40 at v<sub>max</sub> = 288, 144, 72, 36, 18 — still under the last local slope at every support, so the secant is still not the slope and quoting one for the other is still wrong."

## Hypotheses and notation

- λ<sub>min</sub> is the smallest eigenvalue of the Toeplitz section, computed from the zero side (hence under RH).
- v is the depth, n the section length; the curves stop at n = 601 because the truncation of the measure starts to dominate (the last doubling of T moves λ<sub>min</sub> by 0.38% at n = 601 and by 6.7% at n = 1201).
- "secant" is the end-to-end exponent over the stated range.

## Proof / evidence

Numerical: from a table of zeros a row of length n costs O(#zeros) per node at any depth, so the curve costs seconds per support rather than a sieve. Over rh28's range the curve reproduces what rh28 saw — at Δ′ = 0.12 the local slopes climb 0.04, 0.41, 0.55, 0.48, 0.51, 0.68, 0.72 — but past v = 18 the four successive slopes are 2.61, 7.14, 1.22, 3.92, a factor of 5.8 between adjacent steps.

## Dependencies and related results

- [rh29-lambda-min-tends-to-zero](rh29-lambda-min-tends-to-zero.md) — §3(iii) says the decay to zero is required by RH; this is its measured rate.
- rh28 (the depth curve this extends), rh27c (the log-Sobolev ceiling).

## Notes


- The source says plainly that the steepening does not settle into anything and that "λ<sub>min</sub> of a Toeplitz section is not a smooth function of the section length and there is no reason it should be"; it also notes "None of this threatens positivity."
- The five secant values quoted above are the end-to-end secants, not local slopes.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
