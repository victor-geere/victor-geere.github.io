# The selection rule: precision 1.000 and recall 1.000, with no zero consulted

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh16.html`](../../html/rh16.html) — §2 "The recursion prints the zeros"

## Statement

> Locating is not detecting. The spectrum has 149 local maxima in that band and only 30 are ordinates; the rest are ripples of the estimate. A rule is needed, and it must not consult the answer. Two zero-blind signals work, and neither works alone: a true line is a pole of the filter, so it sits still when the estimator is disturbed, whereas a ripple is an artefact of one particular fit. So disturb it two independent ways — change the filter order (five orders, majority vote), and change the mesh entirely (the Δ = 0.015 recursion is a different kernel row, a different recursion and a different band). Nothing but a real line survives both. The rule keeps 30 lines, of which 30 are ordinates: precision 1.000, recall 1.000. And the count is independently predicted: Riemann–von Mangoldt gives N(103.7) = θ(T)/π + 1 = 30.65, which also consults no zero.

## Hypotheses and notation

- Band: r &lt; 103.7 at mesh Δ = 0.03 (399 nodes); 149 local maxima, of which 30 are true ordinates.
- The two disturbances: filter order (five orders, majority vote) and mesh (the Δ = 0.015 recursion).
- Precision and recall are computed against the 30 known ordinates for scoring only; the rule itself consults none.

## Proof / evidence

The source reports the rule, its two zero-blind signals, and the score: 30 lines kept, 30 of them ordinates, precision 1.000, recall 1.000, against the independent Riemann–von Mangoldt count 30.65. It also reports that two plausible alternatives fail: "Ranking peaks by height gets 24 of 30 — the tallest peaks are not the truest ones. Ranking by sharpness fails too: 20% of ripples are as narrow as the sharpest genuine line and 80% of genuine lines are broader than the narrowest ripple, so no single cut separates them."

## Dependencies and related results

- [The recursion prints the zeros](rh16-inverse-map-zeros-from-primes.md) — the spectrum whose lines are being selected.
- [The notch law cannot tell which process it is looking at](rh16-notch-law-process-blind.md) and [the Schur margin separates the processes](rh16-schur-margin-separates-processes.md) — the document's other §4 diagnostics.
- rh15's Riemann–von Mangoldt count (θ(T)/π + 1) is the independent predictor used here.

## Notes


- The rule uses no zero, but the precision/recall scoring does; the source states the count is independently predicted by Riemann–von Mangoldt.
- "What works is not a property of a peak at all, but its persistence under two independent disturbances of the estimator."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
