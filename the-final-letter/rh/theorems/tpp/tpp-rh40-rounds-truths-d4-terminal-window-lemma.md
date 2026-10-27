# D4 — terminal-window lemma

**Kind:** Claim
**Status:** VERIFIED (numerical; `verify_agentB.py` B-a)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D4

## Statement

> **Terminal-window lemma.** `Z(L) = 1` **iff** the terminal window `t = N − L` realises a factor occurring at no other window start

## Hypotheses and notation

- `Z(L) = |F(L)| − #{prefixes of F(L+1)}` (register row C3); `N` = truncation length.
- The terminal window is the last window start, `t = N − L`.

## Proof / evidence

Register row D4's evidence cell reads: "`verify_agentB.py` B-a".

## Dependencies and related results

- Register row C3, C5, C6 (`Z`'s definition, its range, its exact interval).
- Register row C4 (the identity that uses `Z`).
- Register row E5 (the decay law on the same interval).

## Notes

- The source's ledger records that "B's `Z(L)` is exactly the indicator of the terminal window's factor being unique" (mediator claim M5h in `round01.md`).
