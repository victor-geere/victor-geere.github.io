# Necessity of the bound L ≤ N - a_0 - 1 in Theorem 5 (dropping it fails)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 630–633, declaration `Rh41.c1_bound_hedge_necessary`

## Statement

> Dropping `L ≤ N - a_0 - 1` fails: support `{5}`, `N = 8`, `L = 4` gives `p = 4 ≠ 5` (the gap hypothesis is vacuous and `L = 4 ≤ a_0 = 5`).

Formally (Lean 4 / Mathlib):

```lean
theorem c1_bound_hedge_necessary :
    complexity ({5} : Finset ℕ) 8 4 = 4 ∧ 4 + 1 = 5
```

## Hypotheses and notation

- Witness: `S = {5}` (one point, so `a_0 = a_m = 5` and the min-gap hypothesis is vacuous), `N = 8`, `L = 4`.
- `L = 4 ≤ a_0 = 5` holds, but `L ≤ N - a_0 - 1 = 2` fails.
- True value `p(4) = 4`; Theorem 5's conclusion would give `L + 1 = 5`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.c1_bound_hedge_necessary` in `Rh41/DigitWord.lean` (lines 632–634): first conjunct by `decide`, arithmetic by `norm_num`.

## Dependencies and related results

- [Theorem 5 (C1 regime)](lean-rh41-digitword-c1-regime-theorem-5.md) — the theorem whose bound is shown necessary.
- [Necessity of the bound `L ≤ a_0`](lean-rh41-digitword-c1-bound-a0-necessary.md), [necessity of the min-gap bound](lean-rh41-digitword-c1-bound-gap-necessary.md).

## Notes

- The section header: "`TRUTHS.md` Theorem 5 claims that each of the three bounds in `L ≤ min(min gap, a_0, N - a_0 - 1)` is necessary. These three theorems record concrete counterexamples to the weakened forms."
