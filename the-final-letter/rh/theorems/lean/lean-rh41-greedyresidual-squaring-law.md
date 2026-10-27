# The squaring law r_{k+1} ≤ r_k² at every active step

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 504–509, declaration `Rh41.Harmonic.squaring_law`

## Statement

> **The squaring law** (TRUTHS.md §3, checked): at every active step, `r_{k+1} ≤ r_k²`. With `n_k ≤ (1/x)^{2^{k-1}} + 1` this gives `A(N) = Ω_x(log log N)`.

Formally (Lean 4 / Mathlib):

```lean
theorem squaring_law (n : ℕ) (r : ℚ) (hr : 0 < r)
    (hact : (1 : ℚ) / (n + 2) ≤ r) (hlt : r < 1 / ((n : ℚ) + 1)) :
    r - 1 / (n + 2) ≤ r^2
```

## Hypotheses and notation

- `n : ℕ` — the step index; the harmonic constant at this step is `1/(n+2)`.
- `r : ℚ` with `0 < r` — the residual before an active step.
- `hact : 1/(n+2) ≤ r` — the step is active, so the new residual is `r - 1/(n+2)`.
- `hlt : r < 1/((n:ℚ)+1)` — the strict invariant at the step.
- `A(N)` is the number of ones among the first `N` digits of the greedy digit word.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.Harmonic.squaring_law` in `Rh41/GreedyResidual.lean` (lines 507–527). It substitutes the exact identity `squaring_identity`, shows `0 < f ≤ 1` for the factor `f = squaringFactor n r`, and closes the resulting inequality with `nlinarith` using `0 ≤ (1-f)·r³`.

## Dependencies and related results

- [The exact squaring identity](lean-rh41-greedyresidual-squaring-identity.md) — the identity substituted in the proof.
- [No positive lower bound for r'/r²](lean-rh41-greedyresidual-no-positive-lower-bound.md) — the matching negative result: the ratio has no positive lower bound, so the squaring law has no two-sided analogue.
- [Rational termination (Theorem 8, first half)](lean-rh41-greedyresidual-rational-termination.md) — the other main result about this orbit.

## Notes

- The file header lists this as the item "§3 **'Checked'** `r_{k+1} ≤ r_k²` at every active step" — i.e. it was a numerically checked law and is here a theorem for all `n` and all rational residuals in the active range; the conclusion `A(N) = Ω_x(log log N)` is stated in the source as the consequence, not proved here.
