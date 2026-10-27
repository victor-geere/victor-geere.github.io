# I6 — HANDOFF §6.5's residual-orbit protocol is unachievable

**Kind:** Claim
**Status:** VERIFIED (from register row I5 plus arithmetic)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §I "Verified constants", register row I6

## Statement

> **HANDOFF §6.5's protocol is unachievable.** It asks for "~40–50 steps" per target. By I5 that needs `2^38`–`2^48` **decimal digits** (≈10¹²); at 3200 dps only 13 steps survive. `A(N) = log₂ log N` is consistent with this squaring growth

## Hypotheses and notation

- The protocol is HANDOFF §6.5's "iterate ~40–50 steps per target, then test whether the running averages converge".
- dps = decimal digits of working precision; `A(N) = #{n ≤ N : δ_n = 1}`.

## Proof / evidence

Register row I6's evidence cell reads: "I5 + arithmetic".

## Dependencies and related results

- Register rows I5, I7, I8, A4, D6.
- The ledger records the same finding (row 19 of `ledger.md`) as a HANDOFF defect.

## Notes

- The claim refutes a *protocol*, not a mathematical statement; the source calls it `VERIFIED` and uses it to close the direct-iteration route.
