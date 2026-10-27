# The squaring law r_{k+1} ≤ r_k² and the lower bound A(N) = Ω_x(log log N)

**Kind:** Claim
**Status:** **CORRECTED 2026-10-11** — the squaring law is PROVED (Lean); the consequence is the **upper** bound `A(N) = O_x(log log N)`, not `Ω_x(log log N)`. (Register OP-13, now SETTLED.)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §3 "The support: greedy orbits"

## Statement

> **Checked.** `r_{k+1} ≤ r_k²` at every active step (max observed ratio 0.993905). Consequently `n_k ≤ (1/x)^{2^{k−1}} + 1` for `k ≥ 2`, and
>
> ```
> A(N) := #{k : n_k ≤ N} = Ω_x(log log N).
> ```

## Hypotheses and notation

- `x ∈ (0,1)` is the greedy target; `r_k` is the residual of the greedy rule of the source's Object paragraph and `n_k` the index of the corresponding active step, so that `A(N) = #{k : n_k ≤ N}` counts the taken indices up to `N`. The source does not restate these definitions in §3.
- `r_{k+1} ≤ r_k²` is asserted at every **active** step; the observed ratio is at most `0.993905`.
- `Ω_x` is the lower-bound Landau symbol, with the implied constant allowed to depend on `x`.

## Proof / evidence

The source's evidence is the exhaustive numerical check, with the maximum observed ratio `0.993905`; the case `k = 1` is excluded by the stated range `k ≥ 2` for the `n_k` bound.

The squaring inequality is machine-checked: `Harmonic.squaring_identity` (the exact identity for the ratio) and `Harmonic.squaring_law` in `Rh41/GreedyResidual.lean`. The passage to `A(N) = Ω_x(log log N)` uses real logarithms and is listed by the round's Lean README under "Not formalised".

## Dependencies and related results

- [The ratio r_{k+1}/r_k² has no positive lower bound](tpp-rh41-truths-claim-no-positive-lower-bound-ratio.md) — the sharp half; shows only the one-sided law survives, so the matching `O(log log N)` bound is open.
- [Refuted — `A(N) = log₂ log N + O(1)` with an explicit constant](tpp-rh41-truths-refuted-explicit-loglog-constant.md) — the §5 row that records the same obstruction.
- [Theorem 7 (maps)](tpp-rh41-truths-theorem-7-induced-maps.md) — the orbit identities on the same dynamics.

## Correction (2026-10-11)

The displayed implication is **reversed**. From `r_{k+1} ≤ r_k²` one gets `r_k ≤ x^{2^k}`; combined with the active-step condition `r_k ≥ 1/(n_k+2)` this gives `n_k + 2 ≥ x^{−2^k}`, hence `n_k ≥ x^{−2^k} − 2` and

```
A(N) = #{k : n_k ≤ N} ≤ log₂( log(N+2) / log(1/x) ) = O_x(log log N).
```

So the squaring law yields the **upper** bound. The `Ω_x(log log N)` (lower) bound is the side that fails: `r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k)` has no positive lower bound, so the residual may drop faster than squaring. See `research/twin-prime-parity/open/07-open-problems.md` §0.1 item 5, `rh41/TRUTHS.md` §3 (both corrected), and `open/op13_almost_everywhere.py` for the finite evidence.

## Notes

- The matching **lower** bound `A(N) = Ω(log log N)` is the side that is open/false; the **upper** bound `O(log log N)` is proved by the argument above (paper; `squaring_law` and `residual_invariant` are Lean).
- The ratio value `0.993905` is quoted exactly as printed.
