# The positive and negative totals of the `N = 2` truncation at `t = π / log 2`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §6, lines 398–422

## Statement

> At `t = π / log 2` the positive total of the `N = 2` truncation is `1` (only the summand `n = 1` contributes).

```lean
theorem posRe_two_at_pi_div_log_two : posRe 2 (Real.pi / Real.log 2) = 1
```

> At `t = π / log 2` the negative total of the `N = 2` truncation is `-1` (only the summand `n = 2` contributes).

```lean
theorem negRe_two_at_pi_div_log_two : negRe 2 (Real.pi / Real.log 2) = -1
```

Together they exhibit the non-trivial splitting at the balance point: `posRe = 1` (summand `n = 1`) and `negRe = -1` (summand `n = 2`), summing to `realPartial 2 (π / log 2) = 0`.

## Hypotheses and notation

- `posRe N t` is the total of the summands with `0 < cos (t log (k+1))`; `negRe N t` the total of those with `cos (t log (k+1)) < 0`.
- At `t = π / log 2` the two summands are `cos 0 = 1` (for `n = 1`) and `cos π = -1` (for `n = 2`), so they fall in the two different filters.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declarations `posRe_two_at_pi_div_log_two` (lines 400–409) and `negRe_two_at_pi_div_log_two` (lines 413–422) in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean). Both rewrite the defining filtered sums and evaluate the two cosines with `(π / log 2) * log 2 = π` and `Real.cos_pi`.

## Dependencies and related results

- [The `N = 2` truncation is balanced at `t = π / log 2`](lean-rh43-balance-two-balanced-at-pi-over-log-two.md).
- [Splitting the real part: `realPartial N t = posRe N t + negRe N t`](lean-rh43-balance-real-part-splits-into-positive-negative-totals.md).

## Notes

- The two evaluations are the source's own; they are what shows the `N = 2` balancing at `π / log 2` is a genuine positive-vs-negative cancellation rather than a degenerate zero of one side.
