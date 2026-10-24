# K6f — refutation of x-independence: the Sylvester-admissible family converges to log(1/2)

**Kind:** Claim
**Status:** PROVED (paper argument) — reproduced by the mediator both backward (exact relation) and by the forward greedy map from `x = Σ1/q_k`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K6f

## Statement

> **REFUTATION of x-independence.** `q_0 = 4`, `q_{k+1} = 2q_k²` is Sylvester-admissible and gives `s_k → 1/2`, hence `(1/K)Σ_{k<K} log c_k → log(1/2) = −0.693147… ≠ −1`

## Hypotheses and notation

- `q_0 = 4`, `q_{k+1} = 2q_k²`; `s_k = 1 − f_k` the induced variable; `c_k` the greedy coefficient.
- "Sylvester-admissible" means the digit sequence is realisable by a greedy residual; the source reproduces it both backward (from the exact relation) and forward (from `x = Σ1/q_k`).

## Proof / evidence

Register row K6f's state cell reads: "**`PROVED`** — reproduced by the mediator both backward (exact relation) and by the **forward** greedy map from `x = Σ1/q_k`"; its evidence cell reads: "same" (`verify/verify_agentK6.py`).

## Dependencies and related results

- Register row K6 (the refuted independence claim), K6g, K6h, K6i, K6j, I4, I8.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- The finite-`r` means were also measured as not `−1` (register row I8), but this row is the proof-level refutation: an explicit admissible family with a different limit.
