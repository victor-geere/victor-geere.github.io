# C7 — LS(L) = 0 for all L: the standard left-special count is identically zero

**Kind:** Claim
**Status:** VERIFIED (numerical; `verify_agentB.py` B-a, independent bit-string `bLS`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C7

## Statement

> `LS(L) = 0` for all `L`: **the standard left-special count is identically zero** on these words, so a left-special correction to C2 is structurally the wrong object

## Hypotheses and notation

- `LS(L)` is the standard left-special factor count of length `L` for the finitely supported word `w`.
- "C2" is register row C2, `p(L+1) − p(L) = RS(L)` on `L ≤ N − a_m − 2`.

## Proof / evidence

Register row C7's evidence cell reads: "`verify_agentB.py` B-a, independent bit-string `bLS`".

## Dependencies and related results

- Register rows C2 and C4 (the identity being corrected).
- Register row J8 (the refuted `RS(L) − LS(L+1)` repair).
- Register row D4 (`Z(L)` is a terminal-uniqueness indicator instead).

## Notes

- Consequence recorded in the source: the naive left-special correction "is not merely the wrong count, it is structurally the wrong object".
