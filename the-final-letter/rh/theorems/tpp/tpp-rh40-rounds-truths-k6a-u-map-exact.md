# K6a — the u-map: u_{k+1} = q²/s − q exactly

**Kind:** Claim
**Status:** PROVED (paper argument, algebra; VERIFIED numerically on 8 rational seeds × 25 steps, 0 mismatches)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6a

## Statement

> **The `u`-map.** With `u = 1/r_k`, `q = ⌈u⌉`, `s = q − u`: `u_{k+1} = q²/s − q` exactly

## Hypotheses and notation

- `r_k` is the residual after `k` greedy steps; `u = 1/r_k`; `q = ⌈u⌉` is the digit; `s = q − u` is the complementary gap.
- The identity is asserted exactly, for rational seeds at least.

## Proof / evidence

Register row K6a's state cell reads: "**`PROVED`** (algebra) + verified on 8 rational seeds × 25 steps, 0 mismatches"; its evidence cell reads: "`verify/verify_agentK6.py`".

## Dependencies and related results

- Register rows K6b (the induced `s`-map), K6c, K6d, K6e, K6f, K6g, K6, D6.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- The ledger records (rows 29 and 33 of `ledger.md`) that a verification script compared against `u' = uq/(q−u)` while advancing with the wrong coefficient `1/(q−2)`; the correct coefficient is `1/q`, and the four mismatches were the script's error, not the map's.
