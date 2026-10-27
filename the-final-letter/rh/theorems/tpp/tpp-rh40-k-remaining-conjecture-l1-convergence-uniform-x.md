# L¹ convergence of the orbit average to −1 for uniform `x`

**Kind:** Theorem
**Status:** PROVED (source's label; no proof text given — reduction stated)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §4.5 "What remains true"

## Statement

> * **PROVED:** for `x` uniform on `(0,1)`, `E[(1/K)Σ log c_k] = −1 + O(1/K)` —
>   convergence in `L¹`, hence in probability.

## Hypotheses and notation

- `x` is uniform on `(0,1)` — the probabilistic model for the starting point of the greedy residual orbit.
- `c_k` is the squaring constant of the law `r_{k+1} = c_k r_k²`; `log c_k = log s_k − log(1 + s_k r_k)` with `s_k = q_k − u_k`, `u_k = 1/r_k`, `q_k = ⌈u_k⌉` (the source's §4.1–4.3 coordinate system).
- `E[·]` is expectation over the uniform law on `(0,1)`; the claim is about the average `(1/K)Σ_{k<K} log c_k`.
- `L¹` convergence here means convergence of the expectation of the absolute deviation; "hence in probability" is the standard implication.

## Proof / evidence

The source lists this under "What remains true" in §4.5 with the label **PROVED** and the statement quoted above; it gives no proof text for it in this file. Its §4.3 supplies part of the surrounding reduction: "the correction term is absolutely convergent — `log c_k = log s_k − log(1 + s_k r_k)` with `0 ≤ log(1+s_k r_k) ≤ r_k` and `Σ r_k ≤ Σ 1/(q_k−1) < ∞` by the Sylvester bound. Verified to 100 digits. So the whole problem reduces to `Σ log s_k`."

## Dependencies and related results

- [The residual-orbit limit depends on x](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md) — §4.4's refutation of the universal-limit claim; this probabilistic statement is what survives.
- [Conjecture: the limit −1 for Lebesgue-a.e. x](tpp-rh40-k-remaining-conjecture-lebesgue-a-e-limit.md) — the almost-sure strengthening, listed as `[CONJECTURE]` immediately after this item.
- [Conjecture: x with no limit at all](tpp-rh40-k-remaining-conjecture-family-without-limit.md) — the other `[CONJECTURE]` in §4.5.

## Notes

- This is the first bullet under §4.5 "What remains true", explicitly prefixed by the source with `**PROVED:**`; it is harvested on that label. The source does not print a proof of the `L¹` convergence in `K_remaining.md`, so this file does not attribute one.
- §4.2's verified supporting facts are context, not part of this statement: the digit-conditional density `μ_q(s) = q(q−1)/(q−s)² = 1 + (2s−1)/q + O(1/q²) → 1` (integrates to 1 to 25 digits; `L¹` distance `0.172` from `1/((1+s) log 2)` at `q = 10⁶`), and `E[log s_k | q_k] = −1 + 1/(2q_k) + O(1/q_k²)` checked to 12 digits for `q ≤ 10⁶`.
- The source's §4.5 also records that the stronger claim that the achievable limits are *exactly* `(−∞, 0]` via `q_{k+1} = ⌊q_k²/s*⌋` is `PARTIAL` (not reproduced for `s* = 0.9`, `s* = 0.99`); it is not harvested as a theorem here.
