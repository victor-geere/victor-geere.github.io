# Corollary 4 — the maximum of p over 1 ≤ L ≤ N is exactly a_m + 2

**Kind:** Corollary
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 329–333, declaration `Rh41.max_complexity`

## Statement

> **Corollary 4.** If `N ≥ 2a_m + 2` the plateau is nonempty and the maximum of `p` over `1 ≤ L ≤ N` is exactly `a_m + 2`.

Formally (Lean 4 / Mathlib):

```lean
theorem max_complexity (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hN : 2 * S.max' hne + 2 ≤ N) :
    (Icc 1 N).sup (fun L => complexity S N L) = S.max' hne + 2
```

## Hypotheses and notation

- `S : Finset ℕ`, `S ⊆ range N`, `S.Nonempty`; `a_m = S.max' hne`.
- `2 * a_m + 2 ≤ N` — the hypothesis making the plateau `[plateauStart S hne, N - a_m - 1]` nonempty.
- `(Icc 1 N).sup (fun L => complexity S N L)` — the maximum of `L ↦ p(L)` over `1 ≤ L ≤ N`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.max_complexity` in `Rh41/DigitWord.lean` (lines 331–343).

- `≤`: `complexity_le_max_add_two` bounds each value by `a_m + 2`.
- `≥`: `plateauStart S hne ∈ Icc 1 N` under `2 a_m + 2 ≤ N`, and `complexity_plateau` gives the value `a_m + 2` there.

## Dependencies and related results

- [The auxiliary general bound p(L) ≤ a_m + 2](lean-rh41-digitword-complexity-upper-bound.md).
- [Corollary 2 (plateau)](lean-rh41-digitword-plateau-corollary.md) — supplies the attaining length.
- [The empty-plateau example](lean-rh41-digitword-plateau-empty-example.md) — shows the maximum is *not* `a_m + 2` in general when `N < 2 a_m + 2`.
- `Rh41/Alphabet.lean` restates this as `max_complexity_of_finite_support` (see the alphabet fragment).

## Notes

- The hypothesis `N ≥ 2 a_m + 2` is essential: see the example below with `S = {0,…,199}`, `N = 259`, where the maximum over `1 ≤ L ≤ 259` is `60`, not `201`.
