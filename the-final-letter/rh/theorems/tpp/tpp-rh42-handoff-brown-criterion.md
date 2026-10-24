# Brown's criterion (as used for the positive half-series)

**Kind:** Theorem
**Status:** CITED (literature; Brown's criterion, used as a rung of the §5.5 argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §5.5 "The budget is *not* sufficient: the reachable set and its gaps"

## Statement

> A non-increasing positive sequence whose first term is at most the sum of the rest is
> **complete** — its subset sums fill `[0, total]` (Brown's criterion; the greedy achieves
> every value).

## Hypotheses and notation

- A non-increasing positive sequence `a_1 ≥ a_2 ≥ …` (the application in the source is the positive half-series `a_k = (2k)^{−p}`).
- "complete": every value in `[0, total]` is a subset sum, `total` being the sum of the sequence.
- The criterion used in §5.5 is the *first* condition of that kind: `2^{−p} ≤ P(p) − 2^{−p}`, i.e. the first term at most the sum of the rest.

## Proof / evidence

The source states the criterion without proof (it is cited as "Brown's criterion") and uses it inside the §5.5 argument. The same document's refutation row R3 of `truths.md` (Lean `single_condition_not_sufficient`) shows the *single* condition is not sufficient in general for a finite sequence — see the Notes of the companion harvested refutation.

## Dependencies and related results

- Applied to the positive half of the signed alphabet to obtain T10 (positive half complete iff `p ≤ p*`).
- The source's §7 R1 lists "(b) Brown's completeness criterion and the greedy's optimality on complete sequences" as a planned written-out ingredient.

## Notes

- **CITED (literature)**: the source names the criterion and attributes it, but gives no proof of it here.
- This entry is harvested because §5.5 sets the criterion out as a labelled rung of its own argument, not as a bare mention.
- The name "Brown's criterion" is the source's; no bibliographic reference is given in this document.
