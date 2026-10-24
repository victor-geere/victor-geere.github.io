# Theorem 9 (correct half) — bounded partial sums force every index to be taken

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 204–218 (`Rh41.taken_all_of_bounded_partial_sums`); lines 242–248 (`Rh41.never_halts_of_partial_sums_lt`); lines 255–261 (`Rh41.partial_sums_lt_of_step`); lines 281–287 (`Rh41.partial_sums_iff`); lines 294–303 (`Rh41.taken_all_of_bounded_partial_sums_mono`); lines 305–310 (`Rh41.residual_ge_sub_sum`)

## Statement

> **Theorem 9 (correct half), core form.** For a positive alphabet whose strict partial sums satisfy `(∑_{k<n} α k) + α n ≤ x` for every `n`:
>
> * every index is taken;
> * `residual α x n = x - ∑_{k<n} α k` for every `n`;
> * the residual is `> 0` at every step, so the process never halts.

Formally (Lean 4 / Mathlib):

```lean
theorem taken_all_of_bounded_partial_sums (α : ℕ → ℚ) (x : ℚ)
    (hpos : ∀ n, 0 < α n)
    (hsum : ∀ n, (∑ k ∈ range n, α k) + α n ≤ x) :
    (∀ n, taken α x n) ∧
      (∀ n, residual α x n = x - ∑ k ∈ range n, α k) ∧
      (∀ n, 0 < residual α x n)
```

> **Theorem 9 (correct half), sub-sum form.** If every *finite sub-sum* of the alphabet is `< x` (and `α > 0`), then every index is taken and the residual is `> 0` forever: the process never halts finitely.

```lean
theorem never_halts_of_partial_sums_lt (α : ℕ → ℚ) (x : ℚ)
    (hpos : ∀ n, 0 < α n)
    (hlt : ∀ s : Finset ℕ, (∑ k ∈ s, α k) < x) :
    (∀ n, taken α x n) ∧ (∀ n, 0 < residual α x n)
```

> The two formulations of Theorem 9 are equivalent (for a positive non-increasing alphabet): bounding every strict partial sum by `x` is the same as making every finite sub-sum `< x`.

```lean
theorem partial_sums_iff (α : ℕ → ℚ) (x : ℚ)
    (hmono : ∀ n, α (n + 1) ≤ α n) (hpos : ∀ n, 0 < α n) :
    (∀ s : Finset ℕ, (∑ k ∈ s, α k) < x) ↔
      (∀ n, (∑ k ∈ range n, α k) + α n ≤ x)
```

The file also proves:

- `partial_sums_lt_of_step` — the `⟸`-to-strict conversion (lines 258–279): with `α` non-increasing and positive, `(∑_{k<n} α k) + α n ≤ x` for all `n` implies every finite sub-sum is `< x`. (The proof only uses positivity.)
- `taken_all_of_bounded_partial_sums_mono` — the same three-part conclusion "exactly as printed in `TRUTHS.md`", with the non-increasing hypothesis included (it is not needed for this direction).
- `residual_ge_sub_sum` — lower-bound form: `x - ∑ k ∈ s, α k ≤ residual α x n` whenever `range n ⊆ s`.

## Hypotheses and notation

- `α : ℕ → ℚ` — the alphabet (the greedy process at step `n` compares the residual `r` with `α n`; the digit is `1` iff `r ≥ α n`, then `α n` is subtracted).
- `x : ℚ` — the target; `hpos : ∀ n, 0 < α n`; `hsum` bounds every strict partial sum.
- `residual α x n` and `taken α x n` are defined in `Rh41/Alphabet.lean` (lines 88, 93); the harmonic digit word is the case `α n = 1/(n+2)`.
- `hmono` (only in the equivalence and the `_mono` restatement) is monotonicity of the alphabet.

## Proof / evidence

Complete Lean proofs, no `sorry`/`admit`, no new axioms, no `native_decide` — declarations in `Rh41/Alphabet.lean` as cited above.

For `taken_all_of_bounded_partial_sums`: induction on `n` shows `residual α x n = x - ∑_{k<n} α k` and `α n ≤ residual α x n`; positivity of the residual is `x - ∑_{k<n} α k ≥ α n > 0` from `hsum n`.

## Dependencies and related results

- [Theorem 9, easy direction — halting needs a large partial sum](lean-rh41-alphabet-theorem-9-halting-needs-large-partial-sum.md) — the other, true direction of the printed criterion.
- [Theorem 11 (exponential alphabet)](lean-rh41-alphabet-theorem-11-exponential-alphabet.md) and [Theorem 10 row 3](lean-rh41-alphabet-theorem-10-row-3-abstract.md) — the counterexamples showing the printed `iff` is false.

## Notes

- The file header states plainly: "**`TRUTHS.md` Theorem 9 is printed with an `iff` that is false.** It reads 'the process halts finitely **iff** `Σ_n α_n ≥ x`'. The `⇐` direction is refuted by the source itself … The correct content, proved here, is the pair 'halting at `N` ⟹ some finite partial sum `∑_{k<N} α k` is `≥ x`' and 'all finite partial sums are `< x` ⟹ the process never halts'."
- The non-increasing hypothesis printed in Theorem 9 "is *not needed* for the two directions proved here (only positivity is); it is nevertheless kept in `taken_all_of_bounded_partial_sums_mono` and `partial_sums_lt_of_step` so that the statements match the source".
- The six declarations above are all facets of the single `TRUTHS.md` item Theorem 9 (correct half) and are folded into this one file.
