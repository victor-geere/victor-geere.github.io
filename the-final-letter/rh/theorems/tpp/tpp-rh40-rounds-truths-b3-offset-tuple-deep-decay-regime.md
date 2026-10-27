# B3 — the offset-tuple equivalence holds deep in the right-edge decay regime

**Kind:** Claim
**Status:** CHECKED (exhaustive finite: 608 cases, 0 divergences)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §B "The definition of record, and its equivalence", register row B3

## Statement

> The same equivalence holds deep in the right-edge decay regime, where a lossy sparse encoding might have diverged: all `L ∈ [792, 1399]` at `N = 1400`

## Hypotheses and notation

- The equivalence of register row B2 (`p_offset == p_bruteforce`).
- The decay regime of 1/π at `N = 1400`: `L ∈ [792, 1399]`.

## Proof / evidence

Register row B3's evidence cell reads: "`verify_agentB.py` B-d: 608 cases, 0 divergences".

## Dependencies and related results

- Register row B2 (the same equivalence at small length).
- Register row C9, which cites B3 as the reason the lossy encoding "never actually diverges from the bit-string count on any case tested".
- Register row E5 (the decay law on exactly `L ∈ [N − a_m − 1, N − 1]`), the regime in question.

## Notes

- Status word `CHECKED (exhaustive finite)` follows the evidence; the source's own word is `VERIFIED`.
