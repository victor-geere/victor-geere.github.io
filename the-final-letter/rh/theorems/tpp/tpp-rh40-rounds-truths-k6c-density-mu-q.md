# K6c — the density μ_q(s) = q(q−1)/(q−s)² → 1 (Lebesgue), not Gauss–Kuzmin

**Kind:** Claim
**Status:** VERIFIED (normalisation exact; `L¹` distance computed)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6c

## Statement

> **The density.** Given the digit `q`, `s` has density `μ_q(s) = q(q−1)/(q−s)² → 1` (Lebesgue), **not** Gauss–Kuzmin (`L¹` distance 0.172 at `q = 10⁶`)

## Hypotheses and notation

- `q` is the greedy digit, `s = 1 − f` the induced variable of register row K6b.
- Gauss–Kuzmin is the comparison law for continued-fraction digits; the `L¹` distance quoted is between the two densities at `q = 10⁶`.

## Proof / evidence

Register row K6c's state cell reads: "**`VERIFIED`** (normalisation exact; `L¹` distance computed)"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register rows K6a, K6b, K6d, K6e, K6i (whose mean input is this density).
- [L¹ convergence of the orbit average to −1 for uniform `x`](tpp-rh40-k-remaining-conjecture-l1-convergence-uniform-x.md).

## Notes

- The limit `μ_q → 1` is the source's route to the `E[log s_k | q_k]` computation of row K6d.
