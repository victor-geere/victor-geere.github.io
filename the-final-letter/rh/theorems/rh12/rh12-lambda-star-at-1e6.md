# λ* = −2.27×10⁻⁵ at altitude 10⁶

**Kind:** Claim
**Status:** VERIFIED (numerical; validated dynamics; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh12.html`](../../html/rh12.html) — §3 "Dig two — altitude: GUE arrives, and the pairs are harvested"

## Statement

> The headline: **λ* = −2.27×10⁻⁵**, fifty-two times past rh11's −0.00119, three decades past rh10's −0.989. And with it, the hunt's complete economics, now measured rather than argued: the bound is quadratic in the rarest gap; the rarest gap among N samples shrinks like N<sup>(−1/3)</sup>; so λ* improves like N<sup>(−2/3)</sup>, and *each further decade costs 10^1.5 ≈ 32× more zeros*.

The three tightest harvested pairs collide at λ* = −2.3×10<sup>−5</sup>, −3.2×10<sup>−5</sup>, −4.8×10<sup>−5</sup>, each on the g²/8 law to 0.1%.

## Hypotheses and notation

- The band is 60,000 consecutive zeros near t = 10⁶, harvested by the Riemann–Siegel formula (main sum 398 terms, one correction term suffices to 3×10<sup>−6</sup>), scanned at step 0.05 with a change-point audit rescanning at step 0.006; the census agrees with the counting formula within ±2.5 (the S(T) fluctuation it cannot see).
- Collisions are computed under the backward-heat zero dynamics of rh11 §3, with the frozen background spliced (1500 discrete neighbours a side plus the density integral beyond, including the 1.7 million unseen zeros below the band); the splice moves the validation collision by 0.02%.
- λ* is a collision value, i.e. a measured lower bound for the de Bruijn–Newman constant from this data.

## Proof / evidence

The source describes the computation and its validation: the Riemann–Siegel implementation checked against Euler–Maclaurin at four points (≤ 2.5×10<sup>−3</sup>), an eight-zero splice against the rh11 table, and the collision recipe validated against rh10/rh11's direct value (−0.98871 vs −0.98899). It also states the honest audit row: "no theorem; no rigorous bound (our λ* readings are validated dynamics, 7 decades above the cited rigorous ladder)".

## Dependencies and related results

- [The collision-time law τ* = g₀²/8](../rh11/rh11-collision-time-gap-law.md) — the law each altitude collision obeys to 0.1%.
- [The Lehmer-pair collision bound: λ* = −0.00119](../rh11/rh11-lehmer-pair-collision-bound.md) — the lower-altitude predecessor.
- [GUE statistics at 10⁶](rh12-gue-statistics-at-1e6.md) — the same band's spacing statistics.
- rh15 §4 shows the related D* frontier is unconverged at every reachable mesh.

## Notes


- The λ* values are measurements of a validated dynamical model, not rigorous bounds; the source says so, and quotes the literature ladder as cited rather than reproduced.
- The source's sober reading: "the wall at 0 (Rodgers–Tao) remains what rh11 said it was: reached by theorem, touchable from below at documented and unbounded cost, crossable only by proving RH."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
