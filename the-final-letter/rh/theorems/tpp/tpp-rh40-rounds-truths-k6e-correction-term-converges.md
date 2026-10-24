# K6e — correction term: Σ[log c_k − log s_k] converges absolutely

**Kind:** Claim
**Status:** PROVED (paper argument) + VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6e

## Statement

> **Correction term.** `log c_k − log s_k = −log(1+s_k r_k)`, and `Σ r_k ≤ Σ 1/(q_k−1) < ∞`, so `Σ[log c_k − log s_k]` converges absolutely

## Hypotheses and notation

- `c_k` is the greedy-map coefficient whose log the orbit averages; `s_k = 1 − f_k`; `r_k` the residual; `q_k` the digit.
- Absolute convergence of the displayed series is the assertion.

## Proof / evidence

Register row K6e's state cell reads: "**`PROVED`** + verified"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register rows K6a, K6b, K6c, K6d, K6f, D6.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- The row is the analytic bridge that lets the `s`-statistics control the `c`-averages.
