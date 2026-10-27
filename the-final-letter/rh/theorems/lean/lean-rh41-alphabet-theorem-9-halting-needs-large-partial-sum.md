# Theorem 9, easy direction — halting needs a large partial sum

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 325–330, declaration `Rh41.le_sum_of_residual_eq_zero`

## Statement

> **Theorem 9, easy direction.** If the residual vanishes at step `N`, then the first `N` alphabet terms already sum to at least `x`. (Nonnegativity of the alphabet is needed: a negative alphabet can reach `0` with a smaller sum.)

Formally (Lean 4 / Mathlib):

```lean
theorem le_sum_of_residual_eq_zero (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 ≤ α n)
    (N : ℕ) (h : residual α x N = 0) :
    x ≤ ∑ k ∈ range N, α k
```

## Hypotheses and notation

- `α : ℕ → ℚ` with `∀ n, 0 ≤ α n` — a nonnegative alphabet (nonnegativity is essential).
- `x : ℚ`, `N : ℕ`, and `residual α x N = 0` — the process has halted by step `N`.
- `∑ k ∈ range N, α k` — the first `N` alphabet terms.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.le_sum_of_residual_eq_zero` in `Rh41/Alphabet.lean` (lines 328–339). The telescoping identity `residual_eq_sub_sum` gives `x = ∑_{k<N} digit α x k`, and each digit is at most `α k`.

## Dependencies and related results

- [Theorem 9 (correct half)](lean-rh41-alphabet-theorem-9-correct-half.md) — the companion direction.
- [Theorem 11 (exponential alphabet)](lean-rh41-alphabet-theorem-11-exponential-alphabet.md) and [Theorem 10 row 3](lean-rh41-alphabet-theorem-10-row-3-abstract.md) — show that the converse ("`Σ α_n ≥ x` implies halting") is false, so the printed `iff` of Theorem 9 is not valid.

## Notes

- This is the direction of the printed `iff` that survives; the file header stresses that the converse is refuted by the source's own Theorem 10 row 3 (`Σ α_n = ∞`, never halts) and Theorem 11 (`Σ α_n = 1 = x`, never halts finitely).
- "The first `N` alphabet terms" counts the alphabet, not the digits actually taken; the inequality is `≥ x` because the digits sum to `x`.
