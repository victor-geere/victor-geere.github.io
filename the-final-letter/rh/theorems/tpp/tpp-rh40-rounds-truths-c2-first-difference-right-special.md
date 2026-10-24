# C2 — p(L+1) − p(L) = RS(L) holds for every L ≤ N − a_m − 2

**Kind:** Claim
**Status:** VERIFIED (numerical; `verify_agentB.py` B-a, `probes.py` probe 4)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C2

## Statement

> `p(L+1) − p(L) = RS(L)` holds for every `L ≤ N − a_m − 2`

## Hypotheses and notation

- `RS(L)` is the number of right-special factors of length `L` of the word `w`.
- `N` is the truncation length, `a_m` the last support position; the range stops two below the decay onset.

## Proof / evidence

Register row C2's evidence cell reads: "`verify_agentB.py` B-a; `probes.py` probe 4".

## Dependencies and related results

- Register row C4 (the corrected identity `p(L+1) − p(L) = RS(L) − Z(L)` for **every** `L`), which extends this one past the decay onset.
- Register row C7 (`LS(L) = 0` for all `L`), which kills the naive left-special correction.
- Register row G3 (the measured `RS(L)` runs for 1/π).

## Notes

- The restriction to `L ≤ N − a_m − 2` is exactly where `Z(L) = 0`; the corrected identity C4 removes it.
