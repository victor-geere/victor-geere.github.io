# G9 — true e−2 is (0, 3, 53) at N = 2000; (10, 20, 40, 80) is not e−2

**Kind:** Claim
**Status:** VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e; support stable at dps 60/120/200)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.2 "The other dialogue words", register row G9

## Statement

> **true e−2 is `(0, 3, 53)` at `N = 2000`** (stable at dps 60/120/200); `(10, 20, 40, 80)` is **not** e−2 | `N = 2000` | `a_m = 53` | max `p = 55` | plateau `L`-range `[53, 1946]` | decay from `1946`

## Hypotheses and notation

- The support is `(0, 3, 53)`, the truncation `N = 2000`, so `a_m = 53` and `a_m + 2 = 55`.
- "Decay from" is the first `L` of the decay range `[N − a_m − 1, N − 1]` = `[1946, 1999]`.

## Proof / evidence

The source prints under the §G.2 table: "All rows `VERIFIED` by `probes.py` probe 1 and `verify_agentB.py` B-b/B-e." Support stability over `dps ∈ {60, 120, 200}` is recorded in [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) §3.4.

## Dependencies and related results

- Register rows E1, E5, E6, E7, F2, G6, G7, G8.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) row B10 (the mislabel and the correction) and rows A3, J1, J2, J5.

## Notes

- The exclusion clause is part of the source's statement: the word `(10, 20, 40, 80)` used in the round-1 brief as "e−2" is **not** e−2. The ledger records the mislabel as a mediator error that "came from HANDOFF §3.3 and was inherited without checking".
