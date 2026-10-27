# GUE statistics at altitude 10⁶

**Kind:** Claim
**Status:** VERIFIED (numerical; pre-registered forecast; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh12.html`](../../html/rh12.html) — §3 "Dig two — altitude: GUE arrives, and the pairs are harvested"

## Statement

> The hunt was *pre-registered*: GUE repulsion (P(s&lt;x) ≈ (π²/9)x³ near 0) predicts the tightest of N = 60,000 gaps at a median 0.0219 of the local mean spacing. Observed: 0.0257 — inside the forecast's own spread, the third-tightest at 0.037.

and, for the spacing distribution of the same band:

> The nearest-neighbour spacing distribution of the band (bars) against the GUE curve (orange): Kolmogorov–Smirnov distance 0.012, against 0.046 for the 1516 low-height gaps (dashed) — rh8's honestly-flagged "not yet GUE" is now, measurably, 3.7× closer to yes; pair correlation (not shown) lands on 1−(sin πx/πx)² to 0.014.

## Hypotheses and notation

- N = 60,000 consecutive zeros near t = 10⁶; gaps normalised by the local mean spacing.
- GUE repulsion near zero: P(s&lt;x) ≈ (π²/9)x³; the forecast is a median over the tightest of N gaps.
- The low-height comparison set is the 1516 gaps to T = 2000 of rh11.

## Proof / evidence

The source reports the pre-registered forecast and its outcome (median 0.0219 predicted, 0.0257 observed, third-tightest 0.037) and the distribution distances (KS 0.012 against 0.046 at low height; pair correlation on 1−(sin πx/πx)² to 0.014). The audit adds the assertions: "the pre-registered GUE forecast with the observed minimum inside its acceptance band; KS distances and pair-correlation deviation asserted (0.012 < 0.02; low-height 0.046 > 1.8×; R₂ dev 0.014 < 0.03)".

## Dependencies and related results

- [λ* = −2.27×10⁻⁵ at altitude 10⁶](rh12-lambda-star-at-1e6.md) — the collisions harvested from the same band.
- [The optimal-window frontier](rh12-optimal-window-frontier.md) — the other dig of the same document.
- rh16 §4 later calibrates the arc's readings against Poisson, GUE-like and rigid surrogate processes.

## Notes


- The forecast was fixed before the data were examined; the source calls the outcome "inside the forecast's own spread", not a confirmation of GUE.
- The KS distances are finite-sample statistics of one band, not a theorem about ζ.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
