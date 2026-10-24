# K6d — E[log s_k | q_k] = −1 + 1/(2q_k) + O(1/q_k²)

**Kind:** Claim
**Status:** VERIFIED (numerical, to 12+ digits for `q ≤ 10⁶`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6d

## Statement

> `E[log s_k | q_k] = −1 + 1/(2q_k) + O(1/q_k²)`

## Hypotheses and notation

- `s_k = 1 − f_k` is the induced variable of register row K6b; `q_k` is the greedy digit.
- The expectation is under the conditional density `μ_q` of register row K6c.

## Proof / evidence

Register row K6d's state cell reads: "**`VERIFIED`** to 12+ digits for `q ≤ 10⁶`"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register rows K6c (the density input), K6e (the correction term that turns this into a statement about `log c_k`), K6f, K6i, K6j.

## Notes

- The `O(1/q_k²)` term is not proved; the row is a numerical verification of the displayed expansion.
