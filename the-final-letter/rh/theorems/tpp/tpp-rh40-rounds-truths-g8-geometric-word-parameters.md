# G8 — the word (10, 20, 40, 80), N = 500, max p = 82

**Kind:** Claim
**Status:** VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.2 "The other dialogue words", register row G8

## Statement

> `(10, 20, 40, 80)` | `N = 500` | `a_m = 80` | max `p = 82` | plateau `L`-range `[60, 419]` | decay from `419`

## Hypotheses and notation

- The support is `(10, 20, 40, 80)`, the truncation `N = 500`, so `a_m = 80` and `a_m + 2 = 82`.
- "Decay from" is the first `L` of the decay range `[N − a_m − 1, N − 1]` = `[419, 499]`.

## Proof / evidence

The source prints under the §G.2 table: "All rows `VERIFIED` by `probes.py` probe 1 and `verify_agentB.py` B-b/B-e."

## Dependencies and related results

- Register rows E1, E5, E6, E7, F2, G6, G7, G9, and C6/C4 (whose evidence uses this word).
- Register row J12 (the refuted onset candidate `a_m + 2 − #distinct gaps` fails here: 60 vs 79).

## Notes

- This word is **not** e−2 (see register row G9 and [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) row B10); the source records the mislabel as a mediator error.
