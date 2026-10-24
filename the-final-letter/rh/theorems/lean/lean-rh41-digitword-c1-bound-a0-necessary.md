# Necessity of the bound L ≤ a_0 in Theorem 5 (dropping it fails)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 620–623, declaration `Rh41.c1_bound_a0_necessary` (619 is its docstring)

## Statement

> Dropping `L ≤ a_0` fails: support `{1}`, `N = 3`, `L = 2` gives `p = 2 ≠ 3`.

Formally (Lean 4 / Mathlib):

```lean
theorem c1_bound_a0_necessary :
    complexity ({1} : Finset ℕ) 3 2 = 2 ∧ 2 + 1 = 3
```

That is: the conclusion `p(L) = L + 1` of Theorem 5 fails (`2 ≠ 3`) at this instance even though the other two bounds hold.

## Hypotheses and notation

- `S = {1}`, so `a_0 = a_m = 1`; `N = 3`, `L = 2`. The bound `L ≤ a_0` fails (`2 > 1`), and the true value is `p(2) = 2`, whereas Theorem 5's conclusion `p(L) = L + 1` would read `3`. (The min-gap bound is vacuous for a one-point support.)

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.c1_bound_a0_necessary` in `Rh41/DigitWord.lean` (lines 620–622): first conjunct by `decide`, the arithmetic by `norm_num`.

## Dependencies and related results

- [Theorem 5 (C1 regime)](lean-rh41-digitword-c1-regime-theorem-5.md) — the theorem whose bound is shown necessary.
- [Necessity of the min-gap bound](lean-rh41-digitword-c1-bound-gap-necessary.md), [necessity of the `N - a_0 - 1` bound](lean-rh41-digitword-c1-bound-hedge-necessary.md).

## Notes

- The section header: "`TRUTHS.md` Theorem 5 claims that each of the three bounds in `L ≤ min(min gap, a_0, N - a_0 - 1)` is necessary. These three theorems record concrete counterexamples to the weakened forms."
