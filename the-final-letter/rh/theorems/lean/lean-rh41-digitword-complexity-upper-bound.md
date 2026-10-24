# The auxiliary general bound p(L) ≤ a_m + 2

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 275–279, declaration `Rh41.complexity_le_max_add_two`

## Statement

> **The general upper bound behind Corollary 4.** For every truncation length `N` and every `L`, at most `a_m + 2` factors occur: there are only `a_m + 1` windows starting at or before `a_m`, and every window starting later is empty.

Formally (Lean 4 / Mathlib):

```lean
theorem complexity_le_max_add_two (S : Finset ℕ) (N L : ℕ) (hne : S.Nonempty) :
    complexity S N L ≤ S.max' hne + 2
```

## Hypotheses and notation

- `S : Finset ℕ`, `S.Nonempty`; `a_m = S.max' hne`.
- `N, L : ℕ` arbitrary — no truncation or length hypothesis at all.
- `complexity S N L = p(L)`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.complexity_le_max_add_two` in `Rh41/DigitWord.lean` (lines 278–327). Window starts are split into those `t ≤ a_m` (at most `a_m + 1` of them) and those `a_m + 1 ≤ t` (whose factor is empty); the image cardinality is bounded by `card_image_le` and `card_union_le`.

## Dependencies and related results

- [Corollary 4 — the maximum of `p` is exactly `a_m + 2`](lean-rh41-digitword-max-complexity-corollary-4.md) — makes the bound exact under `N ≥ 2 a_m + 2`.
- [Theorem 12 (impossibility half), quantitative form](lean-rh41-impossibility-no-linear-growth.md) — uses this bound to refute linear profiles.
- [Theorem 12, linear-profile form](lean-rh41-alphabet-theorem-12-linear-profile-finite-support.md) — the corresponding use inside `Rh41/Alphabet.lean`.

## Notes

- The same statement is restated in `Rh41/Alphabet.lean` as `max_complexity_of_finite_support`'s input; see the alphabet fragment.
