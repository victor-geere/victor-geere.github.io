# A3 — for irrational x the process never terminates and n_{k+1} = ⌈1/r_k⌉ − 2

**Kind:** Claim
**Status:** CITED (INHERITED — HANDOFF §2, verified there to index 128 541 453; not recomputed this session)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §A "The object", register row A3

## Statement

> For `x` irrational the process never terminates and `n_{k+1} = ⌈1/r_k⌉ − 2`

## Hypotheses and notation

- `x` irrational; `r_k` is the residual after `k` greedy steps, `n_k` the index selected at step `k`.
- The register's preamble admits an entry as `VERIFIED` only if the mediator recomputed it independently; A3 was not recomputed in this session.

## Proof / evidence

Register row A3's evidence cell reads: "HANDOFF §2, verified there to index 128 541 453; not recomputed this session". The source states this without proof of its own.

## Dependencies and related results

- Register row A5 (rational termination) is the complementary case.
- Register row D6 (the squaring law), which is the quantitative form of the residual recursion used here.

## Notes

- The source's own status word is `INHERITED`, defined in its preamble as "asserted in HANDOFF.md; **not** rechecked in this session", and its admission rule explicitly refuses to call such a claim `VERIFIED`. The Status line above preserves that word.
