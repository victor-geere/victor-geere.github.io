# The law that survives: the emptiest-arc Fejér density

**Kind:** Claim
**Status:** VERIFIED (numerical; median 1.04, never exceeds 1.81; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §5 "The law that survives", lines 1428–1456

## Statement

> Across every bulk grid point — all sixteen families, the outliers that broke §3's collapse, and the adversarial window of §4 — the ratio C<sub>n</sub>/λ<sub>min</sub> has median 1.04 and never exceeds 1.81. The worst fit is the envelope window, the one whose heavy atoms are the first hundred *consecutive* zeros, at 1.81; every other family stays below 1.39. The D*-window of §4 obeys the law at 1.35: its tiny λ<sub>min</sub> is not an anomaly, it is the law reading a genuinely empty arc that the anchored discrepancy cannot see. Past n ≈ N<sub>eff</sub> the ceiling detaches — reaching 1.2×10<sup>3</sup> on this grid — which is rh30's regime where the atoms are resolved and no smooth test vector is optimal.

The source's equivalent measured statement:

> The measured statement — λ<sub>min</sub> ≥ C<sub>n</sub>(μ)/1.81 across everything tried — *is* a positivity statement: it says the minimising |p|<sup>2</sup> concentrates its mass in the emptiest arc and can do only a bounded factor better than the Fejér bump that does the same.

## Hypotheses and notation

- C<sub>n</sub>(μ) = min<sub>θ</sub>∫K<sub>n</sub>(θ−t)dμ(t) is §5's emptiest-arc density; λ<sub>min</sub> the smallest eigenvalue of T<sub>n</sub>.
- The bulk grid is rh31's 336 points over sixteen families, three meshes, seven depths; the outliers are those that broke §3's collapse; the adversarial window is §4's D*-minimiser.
- The law is claimed only in the bulk: past n ≈ N<sub>eff</sub> the ceiling detaches.

## Proof / evidence

Numerical. The source also records the unifying reading: "rh30's collapse was the shadow of the emptiest-arc law on a family whose emptiest arc happens to be a function of n/N<sub>eff</sub> — that is what sitting on the discrepancy floor does."

## Dependencies and related results

- [rh31-fejer-ceiling-dominates-lambda-min](rh31-fejer-ceiling-dominates-lambda-min.md) — the proved inequality this measures the tightness of.
- [rh31-collapse-fails-off-searched-family](rh31-collapse-fails-off-searched-family.md) and [rh31-anchored-discrepancy-refuted](rh31-anchored-discrepancy-refuted.md) — the two refutations the same quantity survives.
- [rh31-localisation-conjecture](rh31-localisation-conjecture.md) — the conjecture built on this measurement.

## Notes


- The constant is measured, not proved: "A proof would convert every emptiest-arc computation — which is elementary, no eigenvalue needed — into a certified floor, for every window at once." That proof is §8(a)'s open target.
- The source flags the boundary as part of the content: "it is false past the bulk, so its boundary is part of its content."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
