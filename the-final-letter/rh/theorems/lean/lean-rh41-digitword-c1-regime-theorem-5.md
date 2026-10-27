# Theorem 5 (C1 regime) — p(L) = L + 1 below the gap, a_0 and N - a_0 - 1

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 345–351, declaration `Rh41.complexity_c1`

## Statement

> **Theorem 5 (C1 regime).** If `L` is at most the minimal gap, at most `a_0` and at most `N - a_0 - 1`, then `p(L) = L + 1`.

Formally (Lean 4 / Mathlib):

```lean
theorem complexity_c1 (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hL1 : 1 ≤ L) (hLN : L ≤ N)
    (hgap : ∀ a ∈ S, ∀ b ∈ S, a < b → L ≤ b - a)
    (hmin : L ≤ S.min' hne) (hedge : L ≤ N - S.min' hne - 1) :
    complexity S N L = L + 1
```

## Hypotheses and notation

- `S : Finset ℕ`, `S ⊆ range N`, `S.Nonempty`; `a_0 = S.min' hne`.
- `1 ≤ L ≤ N`.
- `hgap` — every distance between two support points is at least `L` ("`L` is at most the minimal gap").
- `L ≤ a_0` (`hmin`) and `L ≤ N - a_0 - 1` (`hedge`).

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.complexity_c1` in `Rh41/DigitWord.lean` (lines 347–454).

1. Under the gap hypothesis a window of length `L` contains at most one support point.
2. Hence every factor is either `∅` or a singleton `{j}` with `j < L`.
3. The two inclusions are proved (`∅` occurs at `t = 0`; every `{j}`, `j < L`, occurs at `t = a_0 - j`), giving the factor set `insert ∅ ((range L).image (fun j => {j}))`, whose cardinality is `L + 1`.

## Dependencies and related results

- [Necessity of `L ≤ a_0`](lean-rh41-digitword-c1-bound-a0-necessary.md), [necessity of `L ≤ min gap`](lean-rh41-digitword-c1-bound-gap-necessary.md), [necessity of `L ≤ N - a_0 - 1`](lean-rh41-digitword-c1-bound-hedge-necessary.md) — the three counterexamples showing each bound is needed.
- [Corollary 2 (plateau)](lean-rh41-digitword-plateau-corollary.md) — the complementary large-`L` regime.

## Notes

- The section header reads: "`TRUTHS.md` Theorem 5 claims that each of the three bounds in `L ≤ min(min gap, a_0, N - a_0 - 1)` is necessary. These three theorems record concrete counterexamples to the weakened forms."
