# No two-sided squaring law — the ratio (r - 1/(n+2))/r² has no positive lower bound

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 531–537, declaration `Rh41.Harmonic.no_positive_lower_bound`

## Statement

> **No two-sided squaring law** (TRUTHS.md §5, refuted row 8). For every `ε > 0` there is a residual `0 < r < 1` and a step index `n` at which the step is active and `(r - 1/(n+2))/r² < ε`. Witness `r = 1/2 + 1/m` at `n = 0`.

Formally (Lean 4 / Mathlib):

```lean
theorem no_positive_lower_bound (ε : ℚ) (hε : 0 < ε) :
    ∃ r : ℚ, 0 < r ∧ r < 1 ∧ ∃ n : ℕ,
      (1 : ℚ) / (n + 2) ≤ r ∧ r < 1 / ((n : ℚ) + 1) ∧
        (r - 1 / (n + 2)) / r^2 < ε
```

## Hypotheses and notation

- `ε : ℚ` with `0 < ε`.
- The witnesses are `r = 1/2 + 1/m` for `m` large (chosen with `m > max (4/ε) 3`) and `n = 0`.
- The step is active in the strict range `1/(n+2) ≤ r < 1/((n:ℚ)+1)`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.Harmonic.no_positive_lower_bound` in `Rh41/GreedyResidual.lean` (lines 534–577). It takes `m > max (4/ε) 3` (Archimedean), sets `r = 1/2 + 1/m`, verifies `0 < r < 1` and activity at `n = 0`, and bounds `(r - 1/2)/r² = (1/m)/r²` by `ε` using `r² ≥ 1/4`.

## Dependencies and related results

- [The squaring law r_{k+1} ≤ r_k²](lean-rh41-greedyresidual-squaring-law.md) — the upper half that does hold; this theorem shows the ratio cannot also be bounded below.
- [The exact squaring identity](lean-rh41-greedyresidual-squaring-identity.md) — the exact form of the same quantity.

## Notes

- The source labels this "refuted row 8" of `TRUTHS.md` §5: what is refuted is the two-sided (lower-bound) squaring law; the theorem above is the positive statement that refutes it, and is proved in full.
- `native_decide` is not used anywhere in `Rh41/GreedyResidual.lean`; the only automation over concrete numbers is `norm_num` on the explicitly listed rationals `residual 0 1 0 … residual 0 1 5`.
