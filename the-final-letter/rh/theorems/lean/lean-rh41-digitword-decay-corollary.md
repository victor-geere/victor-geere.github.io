# Corollary 3 (decay) — the complexity decays linearly to N - L + 1

**Kind:** Corollary
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 235–239 (declaration `Rh41.complexity_decay`); lines 252–254 (`Rh41.complexity_eq_one_of_le`); lines 261–263 (`Rh41.complexity_eq_two_of_pred`)

## Statement

> **Corollary 3 (decay).** For `L ≥ max(span, a_m+1, N - a_m - 1)` the complexity decays linearly, `p(L) = N - L + 1`.

Formally (Lean 4 / Mathlib):

```lean
theorem complexity_decay (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hLN : L ≤ N) (hLlo : max (plateauStart S hne) (N - S.max' hne - 1) ≤ L) :
    complexity S N L = N - L + 1
```

Two right-hand endpoints of the decay are recorded as separate theorems in the same file:

> The right-hand end of Corollary 3: `p(N) = 1`.

```lean
theorem complexity_eq_one_of_le (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hN : S.max' hne + 1 ≤ N) : complexity S N N = 1
```

> The right-hand end of Corollary 3: `p(N-1) = 2`.

```lean
theorem complexity_eq_two_of_pred (S : Finset ℕ) (N : ℕ) (hS : S ⊆ range N) (hne : S.Nonempty)
    (hN : S.max' hne + 1 ≤ N - 1) : complexity S N (N - 1) = 2
```

## Hypotheses and notation

- `S : Finset ℕ`, `S ⊆ range N`, `S.Nonempty`; `a_m = S.max' hne`; `plateauStart S hne = max (a_m - S.min' hne) (a_m + 1)`.
- `L ≤ N` and `max (plateauStart S hne) (N - a_m - 1) ≤ L`.
- For the endpoints: `a_m + 1 ≤ N` (resp. `a_m + 1 ≤ N - 1`).

## Proof / evidence

Complete Lean proofs, no `sorry`/`admit`, no new axioms — declarations `Rh41.complexity_decay` (lines 237–250), `Rh41.complexity_eq_one_of_le` (lines 253–259) and `Rh41.complexity_eq_two_of_pred` (lines 262–273), all in `Rh41/DigitWord.lean`. Both are specialisations of `complexity_main` (`complexity_decay` splits on `L ≤ N - a_m - 1`; the endpoint theorems substitute `L = N` and `L = N - 1`).

## Dependencies and related results

- [Theorem 1 (main) — the main complexity law](lean-rh41-digitword-main-complexity-law.md) — the law specialised here.
- [Corollary 2 (plateau)](lean-rh41-digitword-plateau-corollary.md) — the constancy that precedes the decay.
- [Theorem 12, linear-profile form](lean-rh41-alphabet-theorem-12-linear-profile-finite-support.md) — uses `p(N) = 1` and `p(N-1) = 2` to rule out a homogeneous linear profile.

## Notes

- The two endpoint theorems are the "right-hand end of Corollary 3" and are immediate substitutions into the decay law; they are folded into this file rather than harvested separately.
- The following index row for this file therefore covers `complexity_decay`, `complexity_eq_one_of_le` and `complexity_eq_two_of_pred`.
