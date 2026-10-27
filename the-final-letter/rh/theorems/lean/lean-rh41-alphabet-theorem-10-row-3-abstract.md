# Theorem 10 row 3 (abstract form) — positive, tending to 0, no finite sub-sum equal to x ⟹ never halts

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 493–504, declaration `Rh41.never_halts_of_tendsto_zero`; with the engine lemma at lines 441–451, `Rh41.exists_taken_ge`

## Statement

> **Theorem 10 row 3, abstract form.** If the alphabet is positive, tends to `0`, and *no finite sub-sum of the alphabet equals the target* `x`, then the residual is `> 0` at every step and infinitely many indices are taken: the process never halts.
>
> This is row 3 of `TRUTHS.md` Theorem 10 with its missing hypothesis ("no finite sub-sum equals `x`") supplied. That hypothesis is what rules out the residual reaching `0`: `residual α x n = 0` would exhibit a finite sub-sum equal to `x`.

Formally (Lean 4 / Mathlib):

```lean
theorem never_halts_of_tendsto_zero (α : ℕ → ℚ) (x : ℚ) (hx : 0 < x)
    (hα : ∀ n, 0 < α n) (htend : TendsToZero α)
    (hsub : ∀ s : Finset ℕ, (∑ k ∈ s, α k) ≠ x) :
    (∀ n, 0 < residual α x n) ∧ Set.Infinite {n : ℕ | taken α x n}
```

The engine of the proof is stated separately:

> **One-step lemma (the engine of Theorem 10 row 3).** If the residual at step `k` is `> 0` and `α n → 0`, then some `n ≥ k` is taken and the residual strictly decreases at that step.

```lean
lemma exists_taken_ge (α : ℕ → ℚ) (x : ℚ) (hα : ∀ n, 0 < α n)
    (htend : TendsToZero α) {k : ℕ} (hr : 0 < residual α x k) :
    ∃ n, k ≤ n ∧ taken α x n ∧ residual α x (n + 1) < residual α x k
```

## Hypotheses and notation

- `α : ℕ → ℚ` positive and `TendsToZero α`, i.e. `∀ ε : ℚ, 0 < ε → ∃ N, ∀ n ≥ N, α n < ε` (defined at line 110).
- `x : ℚ` with `0 < x`.
- `hsub : ∀ s : Finset ℕ, (∑ k ∈ s, α k) ≠ x` — **the hypothesis the file adds to the printed row 3**.
- `{n : ℕ | taken α x n}` — the set of taken indices (the support).

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declarations `Rh41.exists_taken_ge` (lines 449–491) and `Rh41.never_halts_of_tendsto_zero` (lines 501–528) in `Rh41/Alphabet.lean`.

- `exists_taken_ge`: let `r = residual α x k > 0` and take the first `n ≥ k` with `α n ≤ r` (which exists by `htend r`). Every earlier index is not taken, so the residual is still `r` at time `n`; then `n` is taken and the residual drops by `α n > 0`.
- `never_halts_of_tendsto_zero`: if `residual α x n = 0`, the telescoping identity expresses `x` as a finite sub-sum, contradicting `hsub`; so the residual is `> 0` forever, and `exists_taken_ge` iterated with `Set.infinite_iff_exists_gt` gives infinitely many taken indices.

## Dependencies and related results

- [Theorem 9, easy direction](lean-rh41-alphabet-theorem-9-halting-needs-large-partial-sum.md) — the contrapositive face of the same dichotomy.
- [Theorem 10 row 3, power alphabet](lean-rh41-alphabet-theorem-10-row-3-power-alphabet.md) — the concrete instance `α n = (n+2)^{-p}`, `x = 1`.
- [Theorem 11 (exponential alphabet)](lean-rh41-alphabet-theorem-11-exponential-alphabet.md) — the other non-halting family.

## Notes

- The header's correction: "**`TRUTHS.md` Theorem 10 row 3 is stated for real `p > 0`.** The formal `powerAlpha` statement covers natural `p ≥ 1`; the only analytic input the argument uses is `(n+2)^{-p} → 0`, isolated as `powerAlpha_tendsto_zero`, and the abstract `never_halts_of_tendsto_zero` applies to every alphabet with that property."
- The added hypothesis is not cosmetic: without it the residual can reach `0` in finitely many steps even when `Σ α_n ≥ x`.
