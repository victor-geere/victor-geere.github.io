# K6g — the achieved limits are exactly (−∞, 0] (partial)

**Kind:** Claim
**Status:** VERIFIED (numerical, partial: `s* = 1/2` and `s* = 0.1` reproduced; `s* = 0.9, 0.99` did **not** reproduce under `q_{k+1} = ⌊q_k²/s*⌋`; the weaker conclusion is proved by K6f)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6g

## Statement

> The achieved limits are exactly `(−∞, 0]` (so `Σ log c_k` is bounded for some `x` and unbounded for others)

## Hypotheses and notation

- "Achieved limits" are the possible values of `(1/K)Σ_{k<K} log c_k`; `s*` is a prescribed limit of `s_k`.
- The prescription tested is `q_{k+1} = ⌊q_k²/s*⌋`.

## Proof / evidence

Register row K6g's state cell reads: "**`PARTIAL`** — `s* = 1/2` and `s* = 0.1` reproduced; `s* = 0.9, 0.99` did **not** reproduce under `q_{k+1} = ⌊q_k²/s*⌋`. The *weaker* conclusion (limits are not unique) is proved by K6f"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register rows K6f (the proved weaker conclusion), K6h, K6i, K6j.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- Harvested with the source's own split status: the ambitious "exactly `(−∞, 0]`" statement is only partial, and only the non-uniqueness of limits is proved (by K6f).
