# A4 — the lower bound A(N) ≥ log₂ log N − log₂ log(1/x) − 1

**Kind:** Claim
**Status:** PROVED (paper argument; Theorem F: `r_{k+1} ≤ r_k²`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §A "The object", register row A4

## Statement

> `A(N) = #{n ≤ N : δ_n = 1}`: the **lower** bound `A(N) ≥ log₂ log N − log₂ log(1/x) − 1`

## Hypotheses and notation

- `A(N) = #{n ≤ N : δ_n = 1}`, the number of indices up to `N` taken by the greedy process.
- `x` is the target; `r_k` the residual. The proof input is Theorem F, `r_{k+1} ≤ r_k²`.

## Proof / evidence

Register row A4's evidence cell reads: "see K5 in `K_remaining.md`". The mechanism is the squaring bound `r_{k+1} ≤ r_k²` (Theorem F), which makes the indices grow super-exponentially, giving the `Ω(log log N)` lower bound.

## Dependencies and related results

- [Theorem F — the lower bound on `A(N)`](tpp-rh40-k-remaining-theorem-f-an-lower-bound.md) — the written proof.
- Register row A4b (the matching upper bound, `OPEN`) and row A4c (`⌊log₂ log₂ n_k⌋ = k + O(1)` empirically tight).
- [Theorem G — the upper bound is open](tpp-rh40-k-remaining-theorem-g-upper-bound-open.md).

## Notes

- The source records this as **`PROVED`** (Theorem F), in contrast with the matching upper bound A4b, which it leaves `OPEN`.
