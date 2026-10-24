# Theorem 12 (impossibility, halting-process form) — a halting process has no linear complexity profile

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 700–706, declaration `Rh41.no_linear_complexity_of_halting`

## Statement

> **Theorem 12 (impossibility), halting-process form.** A halting process cannot realise the linear profile `p(L) = c·L`, `c > 0`, on its (finite) support.

Formally (Lean 4 / Mathlib):

```lean
theorem no_linear_complexity_of_halting (α : ℕ → ℚ) (x : ℚ) {N₀ N : ℕ} (hN : N₀ ≤ N)
    (hne : (digitSupport α x N₀).Nonempty)
    (hN' : 2 * (digitSupport α x N₀).max' hne + 2 ≤ N) (c : ℚ) (hc : 0 < c)
    (hprof : ∀ L, 1 ≤ L → L ≤ N →
      (complexity (digitSupport α x N₀) N L : ℚ) = c * (L : ℚ)) : False
```

## Hypotheses and notation

- `α : ℕ → ℚ`, `x : ℚ`; `N₀` is the halting time and `digitSupport α x N₀` the (finite) support of the first `N₀` digits.
- `hN : N₀ ≤ N`; `hne` — the support is nonempty; `hN' : 2 * a_m + 2 ≤ N` with `a_m = (digitSupport α x N₀).max' hne`.
- `c : ℚ` with `0 < c`; `hprof` — the profile is assumed for all `L` with `1 ≤ L ≤ N`.
- Conclusion `False`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.no_linear_complexity_of_halting` in `Rh41/Alphabet.lean` (lines 702–710). It reduces to `no_linear_complexity_of_finite_support` applied to `S = digitSupport α x N₀`, with `S ⊆ range N` obtained from `hN` via `mem_digitSupport`.

## Dependencies and related results

- [Theorem 12, finite-support linear form](lean-rh41-alphabet-theorem-12-linear-profile-finite-support.md) — the theorem applied here.
- [Theorem 12, maximum-complexity halting form](lean-rh41-alphabet-theorem-12-max-complexity-of-halting.md) — the companion halting-process statement.
- [Halting is final — no later index is taken](lean-rh41-alphabet-halting-is-final.md).
- [Theorem 12 (impossibility half), quantitative form](lean-rh41-impossibility-no-linear-growth.md) — the corresponding result in `Rh41/Impossibility.lean`.

## Notes

- "Terminating process" in the file header's summary of Theorem 12 is formalised by the halting hypothesis `residual α x N₀ = 0` via the nonempty finite support `digitSupport α x N₀`.
