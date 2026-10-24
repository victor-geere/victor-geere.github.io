# C5 — Z(L) ∈ {0,1} always

**Kind:** Claim
**Status:** VERIFIED (numerical; same run as C4, 0 violations)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C5

## Statement

> `Z(L) ∈ {0,1}` always

## Hypotheses and notation

- `Z(L) = |F(L)| − #{prefixes of F(L+1)}` (register row C3), for the finitely supported word `w`.

## Proof / evidence

Register row C5's evidence cell reads: "same run, 0 violations" (the run of row C4).

## Dependencies and related results

- Register rows C3, C4, C6.
- Register row D4 (the terminal-window lemma), which explains why at most one factor is lost per step.

## Notes

- The source states this without a written proof; the evidence is the numerical run recorded against row C4.
