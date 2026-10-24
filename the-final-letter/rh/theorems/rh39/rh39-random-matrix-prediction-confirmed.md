# Marchenko–Pastur fails: the collapse profile is not a random-matrix law

**Kind:** Claim
**Status:** VERIFIED (numerical, registered prediction confirmed: the random-matrix profile fails, scoring 0.6490 against 0.1559; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh39.html`](../../html/rh39.html) — §6 "The profile"

## Statement

> Fitted on the 75 points, against five candidates, with the prediction registered before the measurement as rh37 did.
>
> | F(x) | rms log residual | median ratio |
> |---|---|---|
> | **1 − x** | **0.1559** | 0.9931 |
> | e<sup>−x</sup> | 0.1646 | 0.9846 |
> | 1/(1 + x) | 0.1720 | 0.9680 |
> | 1 − x/2 (§5's shape) | 0.2072 | 0.9505 |
> | §5's bound | 0.2484 | 0.9185 |
> | (1 − √x)² — Marchenko–Pastur | 0.6490 | 1.6716 |
>
> **F(x) = 1 − x**, with a median ratio of 0.9931 — unbiased to seven parts in a thousand — and an rms log residual of 0.1559, which is about ±17%. Given that the within-bin spread is a factor of two, that is as well as any single-variable curve can be expected to do, and the first three candidates are not cleanly separated by this data.

> **The registered prediction was that Marchenko–Pastur would fail, and it fails.** If the ordinates behaved like random phases, M would be a weighted sample covariance matrix and the hard edge (1 − √x)² would be the profile. It scores 0.6490, four times the winner, and it is *low* by a median factor of 1.67 and a worst of 3.76. Low is the informative direction: the true minimum eigenvalue is much larger than random phases would give, which is what rigidity of the zeros predicts and what rh36 saw from the other side when it found the floor to be a suppression factor below chance. The zeros are not a random sample, and the collapse profile is not a random-matrix law.

## Hypotheses and notation

- The fit is on the 75 points carrying the collapse; y = λ<sub>min</sub>(n)/E(0), x = n/N<sub>eff</sub>.
- The six candidates: 1 − x, e<sup>−x</sup>, 1/(1 + x), 1 − x/2, §5's bound, and Marchenko–Pastur's (1 − √x)².
- The prediction was registered before the measurement, as rh37 did.

## Proof / evidence

Numerical fit on the 75 points, rms log residual and median ratio as tabled: 1 − x wins with 0.1559 and 0.9931; Marchenko–Pastur scores 0.6490 and 1.6716, i.e. four times the winner's residual and low by a median factor of 1.67 and a worst of 3.76.

## Dependencies and related results

- [rh39-annihilator-is-a-genuine-bound](rh39-annihilator-is-a-genuine-bound.md) — §5's shape and bound, also scored in the table.
- [rh36-collapse-forced-suppression](../rh36/rh36-collapse-forced-suppression.md) — the suppression factor below chance, the other side of the rigidity reading.
- [rh30-effective-count-set-by-window](../rh30/rh30-effective-count-set-by-window.md) — the collapse whose profile this names.

## Notes


- The registered prediction is *that the random-matrix law fails*, and it is confirmed; the random-matrix law is what is refuted. The direction of the failure (low) is the informative part, and it is read as rigidity of the zeros.
- The profile F(x) = 1 − x is unbiased to seven parts in a thousand with an rms log residual of about ±17%; a proof of it is not offered, and rh30 §10 (a) remains open.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
