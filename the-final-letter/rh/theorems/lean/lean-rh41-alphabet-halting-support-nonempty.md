# A halting process with positive target has nonempty support

**Kind:** Lemma
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 617–620, declaration `Rh41.digitSupport_nonempty_of_halting`

## Statement

> A halting process with positive target has nonempty support: if no digit were ever taken, the residual would still be `x > 0`.

Formally (Lean 4 / Mathlib):

```lean
lemma digitSupport_nonempty_of_halting (α : ℕ → ℚ) (x : ℚ) {N₀ : ℕ} (hx : 0 < x)
    (h : residual α x N₀ = 0) : (digitSupport α x N₀).Nonempty
```

## Hypotheses and notation

- `α : ℕ → ℚ`, `x : ℚ` with `0 < x` — positive target.
- `N₀ : ℕ` with `residual α x N₀ = 0` — halting at step `N₀`.
- `digitSupport α x N₀ = (range N₀).filter (fun n => α n ≤ residual α x n)` — the support of the first `N₀` digits.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.digitSupport_nonempty_of_halting` in `Rh41/Alphabet.lean` (lines 619–636). If the support were empty, every digit would be `0`, so the telescoping identity would give `residual α x N₀ = x ≠ 0`.

## Dependencies and related results

- [Halting is final — no later index is taken](lean-rh41-alphabet-halting-is-final.md) — the companion halting fact.
- [Theorem 12, maximum-complexity halting form](lean-rh41-alphabet-theorem-12-max-complexity-of-halting.md) — the theorem whose hypothesis `hne` this lemma supplies.

## Notes

- The lemma is used to discharge the nonemptiness hypothesis in the Theorem 12 halting-process statements; it is itself stated as a labelled result in the source.
