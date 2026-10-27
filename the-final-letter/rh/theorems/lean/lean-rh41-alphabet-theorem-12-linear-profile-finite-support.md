# Theorem 12 (impossibility, finite-support form) — no homogeneous linear profile p(L) = c·L

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 647–653, declaration `Rh41.no_linear_complexity_of_finite_support`

## Statement

> **Theorem 12 (impossibility), finite-support form.** A finite support cannot realise a homogeneous linear complexity profile `p(L) = c·L`, `c > 0`: at `L = N` the complexity is `1` and at `L = N - 1` it is `2`, which forces `c = -1`.

Formally (Lean 4 / Mathlib):

```lean
theorem no_linear_complexity_of_finite_support (S : Finset ℕ) (hne : S.Nonempty)
    (N : ℕ) (hS : S ⊆ range N) (hN : 2 * S.max' hne + 2 ≤ N) (c : ℚ) (hc : 0 < c)
    (hprof : ∀ L, 1 ≤ L → L ≤ N → (complexity S N L : ℚ) = c * (L : ℚ)) : False
```

## Hypotheses and notation

- `S : Finset ℕ`, `S.Nonempty`, `S ⊆ range N`; `c : ℚ` with `0 < c`.
- `2 * S.max' hne + 2 ≤ N` — the hypothesis under which Corollary 4 makes the maximum `a_m + 2` and the plateau nonempty.
- `hprof` — the profile is assumed for all `L` with `1 ≤ L ≤ N`.
- The conclusion is `False`, i.e. the profile is impossible.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.no_linear_complexity_of_finite_support` in `Rh41/Alphabet.lean` (lines 651–674). It uses `complexity_eq_one_of_le` (`p(N) = 1`) and `complexity_eq_two_of_pred` (`p(N-1) = 2`) from `Rh41.DigitWord`, obtaining `c·N = 1` and `c·(N-1) = 2`, whence `c = -1`, contradicting `c > 0`.

## Dependencies and related results

- [Corollary 3 (decay) — endpoints p(N) = 1 and p(N-1) = 2](lean-rh41-digitword-decay-corollary.md) — the two facts used.
- [Corollary 4 — the maximum of p is a_m + 2](lean-rh41-digitword-max-complexity-corollary-4.md) — the source's `max_complexity_of_finite_support` restatement (line 642) that this theorem accompanies.
- [Theorem 12, halting-process form](lean-rh41-alphabet-theorem-12-linear-profile-halting-process.md) — the same conclusion for the finite support of a halting process.
- [Theorem 12 (impossibility half), quantitative form](lean-rh41-impossibility-no-linear-growth.md) — the version in `Rh41/Impossibility.lean`, with the `∃ N L` phrasing.

## Notes

- The file header's caveat about Theorem 12's literal phrasing applies here: "**Theorem 12's literal `c·L` phrasing needs care.** 'For every `c > 0` there is `L` with `complexity S N L < c·L`' is false once `c·N ≤ a_m + 2`, since every complexity is `≥ 1` and `c·L ≤ c·N`. The structural statement proved here is stronger and is the mathematically meaningful one: at `L = N` the complexity is `1` and at `L = N - 1` it is `2`, so *no* homogeneous linear profile `p(L) = c·L` (`c > 0`) can hold for all `L ∈ [1,N]`."
