# Row 1 refuted — the unrestricted main formula p(L) = min(a_m+1, N-L+1) + [L ≤ N-a_m-1]

**Kind:** Theorem
**Status:** REFUTED (Lean counterexample, no sorry; `decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 564–569, declaration `Rh41.refuted_main_formula_all_L`

## Statement

> Refuted: the unrestricted main formula (row 1). For support `{0,1}`, `N = 2`, `L = 1` the true value is `1` while the formula reads `2`.

Formally (Lean 4 / Mathlib):

```lean
theorem refuted_main_formula_all_L :
    complexity ({0, 1} : Finset ℕ) 2 1 = 1 ∧
      min (({0, 1} : Finset ℕ).max' (by decide) + 1) (2 - 1 + 1)
        + (if 1 ≤ 2 - ({0, 1} : Finset ℕ).max' (by decide) - 1 then 1 else 0) = 2
```

## Hypotheses and notation

- The candidate is the right-hand side of Theorem 1 (`min(a_m + 1, N - L + 1) + [L ≤ N - a_m - 1]`) applied **without** the hypothesis `L ≥ a_m + 1`; this is row 1 of `TRUTHS.md` §5.
- Witness: `S = {0,1}`, `N = 2`, `L = 1`, where `a_m = 1` and the formula reads `min 2 2 + 1 = 2`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.refuted_main_formula_all_L` in `Rh41/DigitWord.lean` (lines 566–570), both conjuncts closed by `decide`.

## Dependencies and related results

- [Theorem 1 (main) — the main complexity law](lean-rh41-digitword-main-complexity-law.md) — the formula that is correct only under `L ≥ a_m + 1` (or `L ≥ max(span, a_m+1)`).
- [Row 6 refuted — the span formula](lean-rh41-digitword-span-formula-refuted.md) — the same formula family with `min(L + span, N - L + 1)`.

## Notes

- The refuted row is the *unrestricted* formula; Theorem 1 itself is not affected, being conditional on `L ≥ a_m + 1`.
