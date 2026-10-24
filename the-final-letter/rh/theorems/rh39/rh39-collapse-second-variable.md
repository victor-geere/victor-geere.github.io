# The collapse has a second variable: the mesh-to-window ratio carries 60.0% of the residual

**Kind:** Claim
**Status:** VERIFIED (numerical, on the 75 points carrying the collapse; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh39.html`](../../html/rh39.html) — §7 "The second variable"

## Statement

> rh30 treats the within-bin spread as the width of the collapse. It is not noise. At x = 0.2947 the five meshes give 0.536, 0.576, 0.720, 0.785, 0.576 — structure, not scatter.

> Divide out the profile and average the residual within each octave of the mesh-to-window ratio. It **peaks at 1.042 where the mesh matches the window** and falls away on both sides, to 0.734 three octaves below and 0.881 four octaves above.

> That single variable carries **60.0%** of the residual variance. It is genuinely the *ratio* and not either scale: the mesh alone carries 35.9% and the window alone 18.3%. Dividing it out takes the rms log residual from 0.1559 to **0.0986** and narrows every quantile bin, the widest from 1.988 to 1.567.

> The reading is natural. The window sets the measure's bandwidth and the mesh sets the sampling rate at which the Gram matrix reads it; matching them is the least redundant sampling, and mismatching either way wastes degrees of freedom. rh30's family varied both, saw the residual, and booked it as the collapse's width. Most of it is a second axis.

## Hypotheses and notation

- y = λ<sub>min</sub>(n)/E(0) against x = n/N<sub>eff</sub>(Δ<sub>w</sub>), N<sub>eff</sub> = ‖μ‖/(2·max weight).
- The residual is taken after dividing out the profile F(x) = 1 − x, averaged within octaves of log₂(mesh/window).
- The 75 points are those carrying the collapse (x &lt; 0.3); the profile's rms log residual is 0.1559 before the division.

## Proof / evidence

Numerical on the 75 points: residual peaks at 1.042 where mesh = window, 0.734 three octaves below, 0.881 four octaves above; the ratio carries 60.0% of the residual variance (mesh alone 35.9%, window alone 18.3%); dividing it out takes the rms log residual from 0.1559 to 0.0986 and narrows the widest quantile bin from 1.988 to 1.567.

## Dependencies and related results

- [rh39-profile-one-minus-x](rh39-profile-one-minus-x.md) — the profile whose residual this is.
- [rh39-n-eff-is-barely-the-variable](rh39-n-eff-is-barely-the-variable.md) — the first variable, whose work inside the regime is limited.
- [rh30-effective-count-set-by-window](../rh30/rh30-effective-count-set-by-window.md) — N<sub>eff</sub> and the family varied here.

## Notes


- The source's summary is that rh30 booked a second axis as noise: "any collapse claimed without it is claiming credit for a residual that has a name."
- The section is conditional on RH through rh29's zero table (4,308 ordinates, γ ≤ 4800) and rh27b/c's optimised windows.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
