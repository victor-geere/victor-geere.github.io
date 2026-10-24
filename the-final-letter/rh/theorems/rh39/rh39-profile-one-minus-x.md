# The collapse profile is F(x) = 1 − x, unbiased to seven parts in a thousand

**Kind:** Claim
**Status:** VERIFIED (numerical; fitted on the 75 points, rms log residual 0.1559, median ratio 0.9931; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh39.html`](../../html/rh39.html) — §6 "The profile"

## Statement

> **F(x) = 1 − x**, with a median ratio of 0.9931 — unbiased to seven parts in a thousand — and an rms log residual of 0.1559, which is about ±17%. Given that the within-bin spread is a factor of two, that is as well as any single-variable curve can be expected to do, and the first three candidates are not cleanly separated by this data.

> The profile has a name and a measured error bar — F(x) = 1 − x at ±17%, unbiased.

## Hypotheses and notation

- y = λ<sub>min</sub>(n)/E(0), x = n/N<sub>eff</sub>(Δ<sub>w</sub>), N<sub>eff</sub> = ‖μ‖/(2·max weight).
- The fit is on the 75 points carrying the collapse (x &lt; 0.3); candidates are compared by rms log residual and median ratio.
- The profile is a one-variable curve; no mechanism for it is offered in this document.

## Proof / evidence

Numerical fit on the 75 points: rms log residual 0.1559 and median ratio 0.9931 for F(x) = 1 − x, against e<sup>−x</sup> (0.1646, 0.9846) and 1/(1 + x) (0.1720, 0.9680), which the data does not cleanly separate. The within-bin spread is a factor of two.

## Dependencies and related results

- [rh39-random-matrix-prediction-confirmed](rh39-random-matrix-prediction-confirmed.md) — the table of candidates and the refuted random-matrix law.
- [rh39-collapse-second-variable](rh39-collapse-second-variable.md) — the residual of this profile has a named second axis.
- [rh30-effective-count-set-by-window](../rh30/rh30-effective-count-set-by-window.md) — the collapse statement rh30 §10 (a) asked to prove.

## Notes


- The source is careful about precision: the profile is measured at ±17% and unbiased; the first three candidates are not separated by this data.
- rh30's collapse itself is reproduced before the fit: in rh30's own bins the spread of y is 1.044, 1.423, 1.605 and **1.988** across the four bins covering x &lt; 0.3 (75 of the 200 points), 12.796 in [0.3, 1) and **544.97** in [1, 3); the collapse is real, a factor of two wide, and dies at x ≈ 1.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
