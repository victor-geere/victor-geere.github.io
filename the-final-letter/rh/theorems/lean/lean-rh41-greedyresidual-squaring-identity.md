# The exact squaring identity

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 483–489, declaration `Rh41.Harmonic.squaring_identity`

## Statement

> **The exact squaring identity** (TRUTHS.md §3). At an active step with `1/(n+2) ≤ r < 1/(n+1)` and `f = 1/r - (n+1)`, `r - 1/(n+2) = (1-f)·r²/(1 + (1-f)·r)`.

Formally (Lean 4 / Mathlib):

```lean
theorem squaring_identity (n : ℕ) (r : ℚ) (hr : 0 < r)
    (hact : (1 : ℚ) / (n + 2) ≤ r) (hlt : r < 1 / ((n : ℚ) + 1)) :
    r - 1 / (n + 2) =
      (1 - squaringFactor n r) * r^2 / (1 + (1 - squaringFactor n r) * r)
```

where `squaringFactor n r = 1 / r - ((n : ℚ) + 1)` — "`f = 1/r - (n+1)`, the fractional-part bookkeeping of TRUTHS.md §3, so that `1 - f = (n+2) - 1/r`" (line 481).

## Hypotheses and notation

- `n : ℕ` — the step index of the harmonic alphabet `1/(n+2)`.
- `r : ℚ` with `0 < r` — the residual before the step.
- `hact : 1/(n+2) ≤ r` — the step is active (digit `1`).
- `hlt : r < 1/((n:ℚ)+1)` — the strict upper invariant.
- `squaringFactor n r = 1/r - (n+1) = f`, so `1 - f = (n+2) - 1/r`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.Harmonic.squaring_identity` in `Rh41/GreedyResidual.lean` (lines 486–502). The proof rewrites to a common denominator (`eq_div_iff`), shows the denominator `1 + (1-f)·r = (n+2)·r > 0`, and closes with `field_simp; ring`.

## Dependencies and related results

- [The squaring law r_{k+1} ≤ r_k²](lean-rh41-greedyresidual-squaring-law.md) — the inequality derived from this identity.
- [No positive lower bound for r'/r²](lean-rh41-greedyresidual-no-positive-lower-bound.md) — the refuted two-sided companion.

## Notes

- The identity is exact in `ℚ`; the file header stresses "Everything is in `ℚ`/`ℕ`/`ℤ`; no analysis, no `ℝ`".
- The identity is stated for the harmonic alphabet only (the sub-namespace `Rh41.Harmonic`), not for the general alphabet of `Rh41/Alphabet.lean`.
