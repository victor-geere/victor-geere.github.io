# E8 — the plateau onset has no formula found so far

**Kind:** Claim
**Status:** OPEN (all four tested candidates fail on ≥3 of 5 words; on 375 random eligible supports `a_{m−1}+1` fails in 284)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E8

## Statement

> **The plateau onset has no formula found so far.** Measured onsets 605, 6065, 250, 60, 53. Candidates tested and **refuted**: `a_{m−1}+1`, `N − 2a_m − 2`, `a_m + 2 − #distinct gaps`, `N − a_m`

## Hypotheses and notation

- The onset is the smallest `L` with `p(L) = a_m + 2`; `a_m` = last support position, `N` = truncation length.
- `#distinct gaps` counts the distinct values among the `d_j`.

## Proof / evidence

Register row E8's evidence cell reads: "all four fail on ≥3 of 5 words; on 375 random eligible supports `a_{m−1}+1` fails in 284". The source states this as an open problem with a list of refuted candidates, not as a proof.

## Dependencies and related results

- Register row E8a (Theorem E: the onset is a function of `(gaps, N, a_0)` but has no closed form).
- Register rows J11, J12 (the same candidates recorded as refuted laws), and K2 (the open problem).

## Notes

- Harvested with status `OPEN` honestly: the source labels the row `OPEN` and gives only refutations of candidates, no positive formula.
