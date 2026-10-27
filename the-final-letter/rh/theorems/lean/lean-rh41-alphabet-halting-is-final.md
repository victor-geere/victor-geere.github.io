# Halting is final — after the residual reaches 0, no later index is taken

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 595–598, declaration `Rh41.not_taken_of_residual_eq_zero`

## Statement

> After halting at `N₀`, no later index is taken (the residual stays `0` and `α > 0`).

Formally (Lean 4 / Mathlib):

```lean
theorem not_taken_of_residual_eq_zero (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 < α n)
    {N₀ : ℕ} (h : residual α x N₀ = 0) : ∀ n ≥ N₀, ¬ taken α x n
```

## Hypotheses and notation

- `α : ℕ → ℚ` with `∀ n, 0 < α n` — a positive alphabet.
- `x : ℚ`, `N₀ : ℕ` with `residual α x N₀ = 0` — the process has halted at step `N₀`.
- `taken α x n` — the digit at step `n` is `1`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.not_taken_of_residual_eq_zero` in `Rh41/Alphabet.lean` (lines 597–615). By induction on the steps after `N₀`, the residual stays `0`; a taken index `n ≥ N₀` would require `α n ≤ 0`, contradicting positivity.

## Dependencies and related results

- [A halting process has nonempty support](lean-rh41-alphabet-halting-support-nonempty.md) — the companion fact about the support at halting time.
- [Theorem 12, maximum-complexity halting form](lean-rh41-alphabet-theorem-12-max-complexity-of-halting.md) — uses the finiteness of `digitSupport α x N₀`.

## Notes

- This is why the support of a terminating process may be taken to be the finite set `digitSupport α x N₀`: no index after `N₀` is ever taken.
