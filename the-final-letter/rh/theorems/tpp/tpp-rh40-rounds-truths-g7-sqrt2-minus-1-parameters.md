# G7 — √2−1: word (1, 11, 251), N = 2000, max p = 253

**Kind:** Claim
**Status:** VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.2 "The other dialogue words", register row G7

## Statement

> √2−1, `(1, 11, 251)` | `N = 2000` | `a_m = 251` | max `p = 253` | plateau `L`-range `[250, 1748]` | decay from `1748`

## Hypotheses and notation

- The support is `(1, 11, 251)`, the truncation `N = 2000`, so `a_m = 251` and `a_m + 2 = 253`.
- "Decay from" is the first `L` of the decay range `[N − a_m − 1, N − 1]` = `[1748, 1999]`.

## Proof / evidence

The source prints under the §G.2 table: "All rows `VERIFIED` by `probes.py` probe 1 and `verify_agentB.py` B-b/B-e."

## Dependencies and related results

- Register rows E1, E5, E6, E7, F2, G6, G8, G9.

## Notes

- The measured plateau `[250, 1748]` starts below the proved plateau onset `max(span, a_m+1) = 251`; the onset remains open (K2).
