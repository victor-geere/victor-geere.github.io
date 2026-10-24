# B2 — p_offset == p_bruteforce for every word of length 12 with 0–4 ones and every L

**Kind:** Claim
**Status:** CHECKED (exhaustive finite: 9 528 exhaustive cases, 0 divergences)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §B "The definition of record, and its equivalence", register row B2

## Statement

> `p_offset == p_bruteforce` (offset-tuple count equals bit-string factor count) for **every** word of length 12 with 0–4 ones and every `L`

## Hypotheses and notation

- `p_offset` counts distinct offset tuples `{a − t : a ∈ ones, t ≤ a ≤ t+L−1}` over window starts `t`; `p_bruteforce` counts distinct length-`L` bit-string factors.
- Words of length 12 with 0–4 ones; every `L`.

## Proof / evidence

Register row B2's evidence cell reads: "`verify_agentB.py` B-d: 9 528 exhaustive cases, 0 divergences".

## Dependencies and related results

- Register row B1 (the definition of record: two windows give the same factor **iff** these tuples agree) — not harvested, the source labels it a definition.
- Register row B3 (the same equivalence deep in the right-edge decay regime).
- Register row C9 (the encoding is lossy in principle for long `L`).

## Notes

- The source's own status word is `VERIFIED`; the evidence is an exhaustive finite enumeration, so the Status line above uses the harvest vocabulary's `CHECKED (exhaustive finite)`.
