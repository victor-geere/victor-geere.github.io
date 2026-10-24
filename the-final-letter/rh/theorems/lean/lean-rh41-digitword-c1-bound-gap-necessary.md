# Necessity of the min-gap bound in Theorem 5 (dropping it fails)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 624–628, declaration `Rh41.c1_bound_gap_necessary`

## Statement

> Dropping `L ≤ min gap` fails: `1/π`, `L = 13` (min gap `11`) gives `p = 16 ≠ 14`.

Formally (Lean 4 / Mathlib):

```lean
theorem c1_bound_gap_necessary :
    complexity ({2, 13, 607} : Finset ℕ) 1400 13 = 16 ∧ 13 + 1 = 14
```

## Hypotheses and notation

- Witness: the `1/π` support `S = {2, 13, 607}`, `N = 1400`, `L = 13`. The minimum gap of `S` is `13 - 2 = 11`, so `L ≤ min gap` fails (`13 > 11`).
- True value `p(13) = 16`; Theorem 5's conclusion would give `L + 1 = 14`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.c1_bound_gap_necessary` in `Rh41/DigitWord.lean` (lines 626–629): first conjunct by `native_decide`, arithmetic by `norm_num`.

## Dependencies and related results

- [Theorem 5 (C1 regime)](lean-rh41-digitword-c1-regime-theorem-5.md) — the theorem whose bound is shown necessary.
- [Necessity of the bound `L ≤ a_0`](lean-rh41-digitword-c1-bound-a0-necessary.md), [necessity of `L ≤ N - a_0 - 1`](lean-rh41-digitword-c1-bound-hedge-necessary.md).
- [Row 6 refuted — the span formula](lean-rh41-digitword-span-formula-refuted.md) — another witness at `L = 13` exceeding the gap.

## Notes

- The section header: "`TRUTHS.md` Theorem 5 claims that each of the three bounds in `L ≤ min(min gap, a_0, N - a_0 - 1)` is necessary. These three theorems record concrete counterexamples to the weakened forms."
