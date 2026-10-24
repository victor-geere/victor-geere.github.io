# Corollary 2 (plateau) — the complexity saturates at a_m + 2

**Kind:** Corollary
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 224–228, declaration `Rh41.complexity_plateau`

## Statement

> **Corollary 2 (plateau).** On `max(span, a_m+1) ≤ L ≤ N - a_m - 1` the complexity is constant, `p(L) = a_m + 2`.

Formally (Lean 4 / Mathlib):

```lean
theorem complexity_plateau (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hLlo : plateauStart S hne ≤ L) (hLhi : L ≤ N - S.max' hne - 1) :
    complexity S N L = S.max' hne + 2
```

where `plateauStart S hne = max (S.max' hne - S.min' hne) (S.max' hne + 1)` — "the left end of the saturation plateau" (line 221).

## Hypotheses and notation

- `S : Finset ℕ`, `S ⊆ range N`, `S.Nonempty`; `a_m = S.max' hne`, `span = a_m - S.min' hne`.
- `plateauStart S hne ≤ L` and `L ≤ N - a_m - 1` — the plateau interval.
- `complexity S N L = p(L)`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.complexity_plateau` in `Rh41/DigitWord.lean` (lines 226–233). It specialises `complexity_main` (the `+1` branch is taken and the `min` selects `a_m + 1`).

## Dependencies and related results

- [Theorem 1 (main) — the main complexity law](lean-rh41-digitword-main-complexity-law.md) — the law specialised here.
- [Corollary 3 — linear decay](lean-rh41-digitword-decay-corollary.md) — the decay that begins at the right end of the plateau.
- [Corollary 4 — the maximum `a_m + 2`](lean-rh41-digitword-max-complexity-corollary-4.md) — uses the nonemptiness of this plateau.

## Notes

- The plateau is nonempty exactly when `plateauStart S hne ≤ N - a_m - 1`; `max_complexity` (Corollary 4) proves it is nonempty under `N ≥ 2 a_m + 2`.
- [The example with an empty plateau](lean-rh41-digitword-plateau-empty-example.md) shows what fails when that hypothesis is dropped.
