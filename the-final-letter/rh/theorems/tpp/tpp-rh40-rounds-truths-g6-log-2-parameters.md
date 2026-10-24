# G6 — log 2: word (0, 4, 36, 6069), N = 13000, max p = 6071

**Kind:** Claim
**Status:** VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.2 "The other dialogue words", register row G6

## Statement

> log 2, `(0, 4, 36, 6069)` | `N = 13000` | `a_m = 6069` | max `p = 6071` | plateau `L`-range `[6065, 6930]` | decay from `6930`

## Hypotheses and notation

- The support is `(0, 4, 36, 6069)`, the truncation `N = 13000`, so `a_m = 6069` and `a_m + 2 = 6071`.
- "Decay from" is the first `L` of the decay range `[N − a_m − 1, N − 1]` = `[6930, 12999]`.

## Proof / evidence

The source prints under the §G.2 table: "All rows `VERIFIED` by `probes.py` probe 1 and `verify_agentB.py` B-b/B-e."

## Dependencies and related results

- Register rows E1, E5, E6, E7, F2, F5, G7, G8, G9.
- Register rows J1 and J2, whose true first failures are at `L = 4` for log 2.

## Notes

- The measured plateau `[6065, 6930]` extends below the proved plateau onset `max(span, a_m+1) = 6070` by 5; the source keeps the onset open (K2).
