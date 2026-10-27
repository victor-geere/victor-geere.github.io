# Theorem 1 (main) — the main complexity law

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 113–122 (declaration `Rh41.complexity_main`); lines 210–217 (declaration `Rh41.complexity_main_TRUTHS`)

## Statement

> **Theorem 1 (main).** For `L ≥ a_m + 1` (and `1 ≤ L ≤ N`):
>
> `p(L) = min(a_m + 1, N - L + 1) + [L ≤ N - a_m - 1]`.
>
> The `+1` is the single all-zero factor, which occurs exactly when a window of length `L` fits strictly to the right of `a_m`.

Formally (Lean 4 / Mathlib):

```lean
theorem complexity_main (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hL1 : 1 ≤ L) (hLN : L ≤ N) (hL : S.max' hne + 1 ≤ L) :
    complexity S N L = min (S.max' hne + 1) (N - L + 1)
      + (if L ≤ N - S.max' hne - 1 then 1 else 0)
```

The same conclusion is restated as `Rh41.complexity_main_TRUTHS` with the hypotheses exactly as printed in `TRUTHS.md`, i.e. `max (S.max' hne - S.min' hne) (S.max' hne + 1) ≤ L` in place of `S.max' hne + 1 ≤ L` (lines 212–217).

## Hypotheses and notation

- `S : Finset ℕ` with `S ⊆ range N` — support of the word inside the truncation `N`.
- `S.Nonempty`; `a_m = S.max' hne` is the largest support point; `span = a_m - S.min' hne` (as used in the `TRUTHS.md` version).
- `1 ≤ L`, `L ≤ N` — window length within the truncation.
- `hL : a_m + 1 ≤ L` — the truncated `TRUTHS.md` hypothesis `L ≥ max(span, a_m+1)`. The file's section header states: "The proof below only uses `L ≥ a_m + 1` (the span hypothesis is not needed); the statement is therefore given in the sharper form."
- `complexity S N L = p(L)`, the number of distinct length-`L` factors.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms. Declarations `Rh41.complexity_main` (lines 119–208) and `Rh41.complexity_main_TRUTHS` (lines 212–217), both in `Rh41/DigitWord.lean`.

Windows are split into those containing `a_m` (`Wm`) and those missing it (`Wz`). `Wm` is injectively mapped to distinct nonempty factors and has cardinality `min (a_m + 1) (N - L + 1)`; every window in `Wz` gives the empty factor, and `Wz` is nonempty exactly when `L ≤ N - a_m - 1`.

## Dependencies and related results

- [`Rh41.DigitWord.complexity_le_max_add_two`](lean-rh41-digitword-complexity-upper-bound.md) — the general upper bound behind the corollaries.
- [Corollary 2 — the saturation plateau](lean-rh41-digitword-plateau-corollary.md), [Corollary 3 — linear decay](lean-rh41-digitword-decay-corollary.md), [Corollary 4 — the maximum `a_m + 2`](lean-rh41-digitword-max-complexity-corollary-4.md) — the corollaries drawn from this law.
- [Theorem 5 (C1 regime)](lean-rh41-digitword-c1-regime-theorem-5.md) — the complementary small-`L` regime.
- `Rh41.complexity_main_TRUTHS` (same file) — the `TRUTHS.md`-hypothesis restatement folded into this file.

## Notes

- `Rh41/Alphabet.lean` records the same correction: "Theorem 1 is stated with a redundant hypothesis — `L ≥ a_m + 1` suffices; `L ≥ span` is not needed."
- `complexity_main_TRUTHS` is a strict weakening of `complexity_main` (same conclusion, stronger hypothesis) and is therefore folded into this file rather than harvested separately.
