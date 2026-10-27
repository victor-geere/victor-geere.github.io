# Theorem 10 row 3 (power alphabet) — (n+2)^{-p}, x = 1, never halts

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry; natural `p ≥ 1`, the source's printed version being for real `p > 0`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 566–575, declaration `Rh41.powerAlpha_never_halts`; lines 377–384 (`Rh41.powerAlpha_infinitely_many_taken`); lines 539–541 (`Rh41.powerAlpha_tendsto_zero`)

## Statement

> **Theorem 10 row 3** (`α n = (n+2)^{-p}`, `p > 0`, `x = 1`) with the missing hypothesis made explicit. If no finite sub-sum of the alphabet equals `1`, then the residual is positive at every step and the taken set is infinite: the process never halts.

Formally (Lean 4 / Mathlib):

```lean
theorem powerAlpha_never_halts (p : ℕ) (hp : 0 < p)
    (hsub : ∀ s : Finset ℕ, (∑ k ∈ s, powerAlpha p k) ≠ 1) :
    (∀ n, 0 < residual (powerAlpha p) 1 n) ∧
      Set.Infinite {n : ℕ | taken (powerAlpha p) 1 n}
```

with, in the same file,

```lean
def powerAlpha (p : ℕ) : ℕ → ℚ := fun n => ((n + 2 : ℚ) ^ p)⁻¹

theorem powerAlpha_infinitely_many_taken (p : ℕ) (hp : 0 < p)
    (hsub : ∀ s : Finset ℕ, (∑ k ∈ s, powerAlpha p k) ≠ 1) :
    ∀ k : ℕ, ∃ n ≥ k, taken (powerAlpha p) 1 n

lemma powerAlpha_tendsto_zero (p : ℕ) (hp : 0 < p) : TendsToZero (powerAlpha p)
```

> **`(n+2)^{-p} → 0` for `p > 0`** (natural `p ≥ 1`): the only analytic fact about the power family that Theorem 10 row 3 needs.

## Hypotheses and notation

- `p : ℕ` with `0 < p`; `powerAlpha p n = ((n + 2 : ℚ)^p)⁻¹`, i.e. `(n+2)^{-p}` with a natural exponent.
- Target `x = 1`.
- `hsub : ∀ s : Finset ℕ, (∑ k ∈ s, powerAlpha p k) ≠ 1` — no finite sub-sum equals the target (the explicit missing hypothesis).
- `powerAlpha_infinitely_many_taken` is the same second conjunct in the "for every bound" form.

## Proof / evidence

Complete Lean proofs, no `sorry`/`admit`, no new axioms, no `native_decide` — declarations in `Rh41/Alphabet.lean` as cited above.

- `powerAlpha_tendsto_zero`: given `ε > 0`, choose `m > ε⁻¹` and `N = m + 2`; for `n ≥ N`, `(n+2)^{-p} ≤ (n+2)^{-1} < ε`.
- `powerAlpha_never_halts`: applies `never_halts_of_tendsto_zero` with `x = 1`, `powerAlpha_pos` and `powerAlpha_tendsto_zero`.
- `powerAlpha_infinitely_many_taken`: unfolds `Set.Infinite` via `Set.infinite_iff_exists_gt`.

## Dependencies and related results

- [Theorem 10 row 3, abstract form](lean-rh41-alphabet-theorem-10-row-3-abstract.md) — the theorem applied (`never_halts_of_tendsto_zero`).
- [Theorem 9 (correct half)](lean-rh41-alphabet-theorem-9-correct-half.md) — the criterion the `Σ α_n = ∞` family refutes.

## Notes

- The file header's scope remark: "**`TRUTHS.md` Theorem 10 row 3 is stated for real `p > 0`.** The formal `powerAlpha` statement covers natural `p ≥ 1`; the only analytic input the argument uses is `(n+2)^{-p} → 0`, isolated as `powerAlpha_tendsto_zero`, and the abstract `never_halts_of_tendsto_zero` applies to every alphabet with that property." The statement above is therefore the natural-exponent version actually formalised.
- `hsub` is the hypothesis the source adds to the printed row 3; it is not vacuous. For `p = 1`, `x = 1` the finite sub-sum at `{0,1,4}` equals `1` (`1/2 + 1/3 + 1/6 = 1`), which is exactly the terminating case recorded in [`GreedyResidual.lean`](lean-rh41-greedyresidual-support-of-one.md).
