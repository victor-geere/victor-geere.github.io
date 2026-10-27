# Theorem 12 (impossibility half) — no affine complexity profile

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean) — lines 57–60, declaration `Rh41.no_affine_profile`

## Statement

> **Theorem 12 (impossibility half).** No finite support has an affine complexity profile `p(L) = a·L + b` with `a > 0`.

Formally (Lean 4 / Mathlib):

```lean
theorem no_affine_profile (S : Finset ℕ) (a b : ℚ) (ha : 0 < a) :
    ¬ (∀ N L : ℕ, 1 ≤ L → L ≤ N → (complexity S N L : ℚ) = a * L + b)
```

## Hypotheses and notation

- `S : Finset ℕ` — an arbitrary finite support, possibly empty.
- `a b : ℚ` with `0 < a` — the affine profile's slope and intercept.
- The profile is required to hold for all `N` and all `L` with `1 ≤ L ≤ N`.
- `complexity S N L = p(L)` as in `Rh41.DigitWord`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.no_affine_profile` in `Rh41/Impossibility.lean` (lines 59–93). Assuming the profile holds, both the empty and the nonempty case are contradicted:

- `S = ∅`: `complexity S N L ≤ 1`, while `a·L + b > 1` for large `L`.
- `S ≠ ∅`: `complexity S N L ≤ a_m + 2` (`complexity_le_max_add_two`), while `a·L + b > a_m + 2` for large `L`.

## Dependencies and related results

- [`Rh41.DigitWord.complexity_le_max_add_two`](lean-rh41-digitword-complexity-upper-bound.md) — the uniform bound `p(L) ≤ a_m + 2`.
- [No linear profile (quantitative form)](lean-rh41-impossibility-no-linear-growth.md) — the `b = 0` case, proved separately in the same file.
- [The Sturmian profile `p(L) = L + 1` is not realised](lean-rh41-impossibility-no-sturmian-profile.md) — derived from this theorem with `a = 1`, `b = 1`.

## Notes

- This is the strongest of the three impossibility statements in `Rh41/Impossibility.lean`; the other two are corollaries (the Sturmian one is literally proved by applying this theorem with `a = 1`, `b = 1`).
- The file's header calls this "the mathematical core of Theorem 12 of `TRUTHS.md`: exact termination and linear complexity growth are incompatible", proved "with no reference to the alphabet or to the process".
