# C4 — the corrected finite-word identity p(L+1) − p(L) = RS(L) − Z(L)

**Kind:** Claim
**Status:** VERIFIED (numerical; 0 failures across all L on `(10,20,40,80)` N=500 (499/499) and 400+ sampled L on each of four other words)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C4

## Statement

> **Corrected finite-word identity:** `p(L+1) − p(L) = RS(L) − Z(L)` for **every** `L`

## Hypotheses and notation

- `RS(L)` the right-special factor count of length `L`; `Z(L) = |F(L)| − #{prefixes of F(L+1)}` (register row C3).
- `p(L)` the factor count; `N` the truncation length; the identity is asserted for every `L`, with no decay-regime restriction.

## Proof / evidence

Register row C4's evidence cell reads: "`verify_agentB.py` B-a: all L on `(10,20,40,80)` N=500 (499/499) and 400+ sampled L on each of 1/π N=1400, log 2 N=13000, √2−1 N=2000, true e−2 N=2000. **0 failures**".

## Dependencies and related results

- Register row C2 (the unrestricted-`L` statement fails without the `Z` term), C3 (the definition of `Z`), C5 and C6 (the structure of `Z`).
- Register row C7 (`LS ≡ 0`), which refutes the naive `RS(L) − LS(L+1)` repair.
- Register rows J8 and D4.

## Notes

- The source credits the repair to Agent B (round 1) and records it in the ledger's attributed-results table as "`STANDING`", mediator-reproduced.
- The formula fails for the naive `RS(L) − LS(L+1)` on every `L` with `Z(L) = 1`; see row J8.
