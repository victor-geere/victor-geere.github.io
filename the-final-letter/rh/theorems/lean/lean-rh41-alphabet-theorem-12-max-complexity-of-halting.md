# Theorem 12 (impossibility, halting-process form) — the complexity maximum of a halting process is a_m + 2

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 687–694, declaration `Rh41.max_complexity_of_halting`

## Statement

> **Theorem 12 (impossibility), halting-process form.** A process that halts at `N₀` has finite support `digitSupport α x N₀`; for `N ≥ 2 a_m + 2` its complexity maximum is the fixed number `a_m + 2`.

Formally (Lean 4 / Mathlib):

```lean
theorem max_complexity_of_halting (α : ℕ → ℚ) (x : ℚ) {N₀ N : ℕ} (hN : N₀ ≤ N)
    (hne : (digitSupport α x N₀).Nonempty)
    (hN' : 2 * (digitSupport α x N₀).max' hne + 2 ≤ N) :
    (Icc 1 N).sup (fun L => complexity (digitSupport α x N₀) N L) =
      (digitSupport α x N₀).max' hne + 2
```

## Hypotheses and notation

- `α : ℕ → ℚ`, `x : ℚ` — alphabet and target; the process's support after halting at `N₀` is `digitSupport α x N₀ = (range N₀).filter (fun n => α n ≤ residual α x n)` (line 106).
- `hN : N₀ ≤ N` — the truncation `N` extends past the halting time.
- `hne` — the support is nonempty; `hN' : 2 * a_m + 2 ≤ N` with `a_m = (digitSupport α x N₀).max' hne`.
- The conclusion is the maximum of `L ↦ complexity (digitSupport α x N₀) N L` over `1 ≤ L ≤ N`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.max_complexity_of_halting` in `Rh41/Alphabet.lean` (lines 690–698). It applies `max_complexity` from `Rh41.DigitWord` (restated in this file as `max_complexity_of_finite_support`, line 642) to the finite support `digitSupport α x N₀`, using `mem_digitSupport` to place `digitSupport α x N₀ ⊆ range N` from `hN : N₀ ≤ N`.

## Dependencies and related results

- [Corollary 4 — the maximum of p is a_m + 2](lean-rh41-digitword-max-complexity-corollary-4.md) — the finite-support theorem applied here.
- [Halting is final — no later index is taken](lean-rh41-alphabet-halting-is-final.md) — why the support after halting is `digitSupport α x N₀`.
- [Theorem 12, linear-profile form](lean-rh41-alphabet-theorem-12-linear-profile-halting-process.md) — the consequence for linear profiles.

## Notes

- This is the halting-process face of the same `TRUTHS.md` item as the finite-support form; both appear in the file header's list of Theorem 12 material.
