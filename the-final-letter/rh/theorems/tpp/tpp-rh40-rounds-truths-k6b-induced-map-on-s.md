# K6b — the induced map on s: s_{k+1} = 1 − {q²/s}, not the Gauss map

**Kind:** Claim
**Status:** VERIFIED (exact on rationals; not the Gauss map, max deviation 0.91)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6b

## Statement

> **The induced map** on `s = 1−f`: `s_{k+1} = 1 − {q²/s}`

## Hypotheses and notation

- `s = 1 − f` with `f = {1/r_k}` the fractional part of the squaring law (register row D6); `q` is the greedy digit.
- The comparison map is the Gauss map `s ↦ 1−{1/s}`.

## Proof / evidence

Register row K6b's state cell reads: "**`VERIFIED`** exactly on rationals; and it is **not** the Gauss map `s ↦ 1−{1/s}` (max deviation 0.91)"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register rows K6a (the `u`-map), K6c (the density of `s`), K6d, K6e, K6f, D6.

## Notes

- The ledger records (rows 30 and 34 of `ledger.md`) that the mediator first declared this identity false on 5 of 8 mismatches; the identity is correct and the test had read `s_next` from the wrong `r'`.
