# Theorem 11 (dichotomy false) — the exponential alphabet takes every index while its residual tends to 0

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 376–380 (`Rh41.expAlpha_residual`); lines 392–396 (`Rh41.expAlpha_taken`); lines 398–400 (`Rh41.expAlpha_support_univ`); lines 402–422 (`Rh41.expAlpha_residual_tendsto_zero`); lines 424–430 (`Rh41.expAlpha_bounded_gaps_and_termination`); lines 432–437 (`Rh41.expAlpha_residual_pos`)

## Statement

> **Theorem 11 (dichotomy false).** The exponential alphabet selects every index *and* its residual converges to `0`: bounded gaps and convergence to `0` occur together, so "bounded gaps OR termination, never both" is false.

The file states the parts as follows (`α n = (1/2)^(n+1)`, `x = 1`, i.e. `expAlpha`):

> **Theorem 11, residual.** After `n` steps the residual is exactly `(1/2)^n`.
> **Theorem 11, no zero digits.** Every index is taken.
> The support of the exponential alphabet is all of `ℕ`: all gaps are `1`.
> **Theorem 11, convergence.** The residual of the exponential alphabet tends to `0` (in `ε`-`N` form).

Formally (Lean 4 / Mathlib):

```lean
theorem expAlpha_residual (n : ℕ) : residual expAlpha 1 n = (1 / 2 : ℚ) ^ n

theorem expAlpha_taken (n : ℕ) : taken expAlpha 1 n

theorem expAlpha_support_univ : {n : ℕ | taken expAlpha 1 n} = Set.univ

theorem expAlpha_residual_tendsto_zero :
    ∀ ε : ℚ, 0 < ε → ∃ N : ℕ, ∀ n ≥ N, residual expAlpha 1 n < ε

theorem expAlpha_bounded_gaps_and_termination :
    (∀ n, taken expAlpha 1 n) ∧
      (∀ ε : ℚ, 0 < ε → ∃ N : ℕ, ∀ n ≥ N, residual expAlpha 1 n < ε)

theorem expAlpha_residual_pos (n : ℕ) : 0 < residual expAlpha 1 n
```

## Hypotheses and notation

- `expAlpha : ℕ → ℚ := fun n => (1 / 2 : ℚ) ^ (n + 1)` — "the exponential alphabet `α n = (1/2)^(n+1)` of `TRUTHS.md` Theorem 11" (line 348).
- Target `x = 1`.
- `taken α x n` — the digit at step `n` is `1`; `residual α x n` — the residual after `n` steps.
- "Bounded gaps" means every index is taken (support all of `ℕ`, gaps all `1`); `expAlpha_residual_pos` records that the process never *reaches* `0` at a finite step.

## Proof / evidence

Complete Lean proofs, no `sorry`/`admit`, no new axioms, no `native_decide` — declarations in `Rh41/Alphabet.lean` as cited above.

- `expAlpha_residual`: induction, using `expAlpha_le` (the alphabet is decreasing) and the algebra `(1/2)^n - (1/2)^(n+1) = (1/2)^(n+1)`.
- `expAlpha_taken`: `expAlpha n ≤ residual expAlpha 1 n` rewritten by `expAlpha_residual` and `expAlpha_le`.
- `expAlpha_residual_tendsto_zero`: `ε`-`N` argument via `exists_nat_gt`.
- `expAlpha_bounded_gaps_and_termination`: conjunction of `expAlpha_taken` and `expAlpha_residual_tendsto_zero`.

## Dependencies and related results

- [Theorem 9 (correct half)](lean-rh41-alphabet-theorem-9-correct-half.md) — the criterion whose `iff` this alphabet refutes.
- [Theorem 10 row 3, abstract form](lean-rh41-alphabet-theorem-10-row-3-abstract.md) — the other family (`Σ α_n = ∞`, never halts).

## Notes

- The file header's correction: "**`TRUTHS.md` Theorem 11 says the exponential alphabet 'terminates exactly'.** Formally the residual is `(1/2)^n > 0` at every finite step, so the process does not reach `0` finitely; what is true (and proved) is that the residual tends to `0` while every index is taken."
- The `expAlpha_partial_sum` lemma (`∑_{k<N} expAlpha k = 1 - (1/2)^N`, line 366) is auxiliary to this item and is not harvested separately.
- The six declarations above are facets of the single `TRUTHS.md` item Theorem 11 and are folded into this one file.
