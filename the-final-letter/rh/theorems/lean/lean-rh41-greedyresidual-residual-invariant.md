# Theorem 1 (invariant) — the residual stays in [0, 1/(n+1))

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 411–414, declaration `Rh41.Harmonic.residual_invariant`

## Statement

> **Theorem 1 (invariant).** For `0 < x < 1` the residual never goes negative and stays below `1/(n+1)` at step `n`.

Formally (Lean 4 / Mathlib):

```lean
theorem residual_invariant (x : ℚ) (hx0 : 0 < x) (hx1 : x < 1) :
    ∀ n, 0 ≤ residual 0 x n ∧ residual 0 x n < 1 / ((n : ℚ) + 1)
```

## Hypotheses and notation

- `x : ℚ` with `0 < x < 1` — the target of the greedy process.
- `residual 0 x n` — the residual after `n` steps with alphabet `1/(n+2)`, starting at index `0`.
- The two one-step lemmas behind the induction are `step_nonneg` (line 389) and `step_lt` (line 396), stated as `0 ≤ (if c ≤ r then r - c else r)` and `(if 1/(n+2) ≤ r then r - 1/(n+2) else r) < 1/(n+2)`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.Harmonic.residual_invariant` in `Rh41/GreedyResidual.lean` (lines 413–423). Induction on `n`: the lower bound is `step_nonneg`, and the upper bound uses `step_lt` with the inductive hypothesis `r < 1/(n+1)`.

## Dependencies and related results

- [Theorem 8 (first half) — rational termination](lean-rh41-greedyresidual-rational-termination.md) — the termination theorem whose invariant (`r < 1/(i+1)`) this result supplies.
- [The squaring law](lean-rh41-greedyresidual-squaring-law.md) — uses the strict upper bound `r < 1/(n+1)`.

## Notes

- The file header lists this as "The invariant behind §3 — `residual_invariant`"; the numbering "Theorem 1" is the source's own label for this item.
- The source's constants: `step_nonneg` is stated for a generic `c`, `step_lt` for `c = 1/(n+2)`; both are auxiliary and not harvested separately.
