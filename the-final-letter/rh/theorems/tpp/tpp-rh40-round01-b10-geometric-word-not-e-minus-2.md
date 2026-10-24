# B10 — the word (10,20,40,80), N=500 is not e−2

**Kind:** Claim
**Status:** VERIFIED (numerical, confirmed; true e−2 support `(0, 3, 53)` at N=2000, stable over dps 60/120/200)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.1 "From Agent B", verdict-table row B10

## Statement

> the word `(10,20,40,80)`, N=500 is **not** e−2

## Hypotheses and notation

- The claim concerns the round-1 brief's word `(10,20,40,80)` at `N = 500`, which had been labelled "e−2".
- The true greedy support for e−2 is `(0, 3, 53)` at `N = 2000`.

## Proof / evidence

The verdict-table row's mediator check reads: "confirmed: the true greedy support for e−2 is `(0, 3, 53)` at N=2000, stable over dps 60/120/200".

## Dependencies and related results

- Register row G9 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), harvested as [tpp-rh40-rounds-truths-g9-true-e-minus-2-support.md](tpp-rh40-rounds-truths-g9-true-e-minus-2-support.md), and register row G8.
- §3.4 of the same file ("e−2 support stability over dps ∈ {60, 120, 200} ✅ stable at (0, 3, 53)"); ledger error row 15.

## Notes

- **Restatement.** This row restates register entry G9 of `truths.md` (round 1 of the rh40 dialogue).
- The mislabel came from HANDOFF §3.3 and "was inherited without checking" (ledger row 15).
