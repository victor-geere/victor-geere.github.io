# Every residual of the Tau greedy keeps the sign of its target

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `tauResidual_nonneg` (lines 239–245) and `tauResidual_nonpos` (lines 249–255)

## Statement

> Every residual of the algorithm on a nonnegative target is nonnegative, and every residual on a nonpositive target is nonpositive:
>
> `0 ≤ x → ∀ n, 0 ≤ tauResidual p x n`
>
> `x ≤ 0 → ∀ n, tauResidual p x n ≤ 0`
>
> Lean statements:
>
> `tauResidual_nonneg (p : ℕ) {x : ℚ} (hx : 0 ≤ x) : ∀ n, 0 ≤ tauResidual p x n`
>
> `tauResidual_nonpos (p : ℕ) {x : ℚ} (hx : x ≤ 0) : ∀ n, tauResidual p x n ≤ 0`

## Hypotheses and notation

- `tauResidual p x : ℕ → ℚ` is the residual obtained from the target `x` after performing the greedy steps at the indices `0, 1, …, n-1`: `tauResidual p x 0 = x` and `tauResidual p x (n+1) = tauStep p n (tauResidual p x n)` (definition, not harvested separately).
- Hypotheses: `p : ℕ`; the target satisfies `0 ≤ x` (`tauResidual_nonneg`) or `x ≤ 0` (`tauResidual_nonpos`).
- The taken set of the algorithm is `tauTaken p x n`, defined by `tauStep p n (tauResidual p x n) ≠ tauResidual p x n`; its finite support is `support p x N`.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` by the two `theorem`s named above, by induction on `n`. Where the current residual is `0` the step leaves it `0` (`tauStep_zero`, the "no term is ever taken" fact); where it is nonzero the one-step sign invariance ([`lean-rh42-tau-sign-invariance.md`](lean-rh42-tau-sign-invariance.md), `tauStep_nonneg` / `tauStep_neg`) applies. No `sorry`/`admit`/`axiom`/`native_decide` occurs in the file.

## Dependencies and related results

- Uses the one-step sign invariance [`lean-rh42-tau-sign-invariance.md`](lean-rh42-tau-sign-invariance.md) and `tauStep_zero` (a `_zero` plumbing lemma, not harvested separately).
- Feeds the parity lock on the support: [`lean-rh42-tau-parity-lock.md`](lean-rh42-tau-parity-lock.md) and [`lean-rh42-tau-even-gaps.md`](lean-rh42-tau-even-gaps.md).
- The rh42 Lean README describes this row as "the residual sequence and the support" ↔ `tauResidual`, `tauResidual_succ`, `tauTaken`, `support`, `mem_support`, `tauResidual_nonneg`, `tauResidual_nonpos`.

## Notes

- Only the two `theorem`s of that README row are harvested here; the definitions `tauResidual`, `tauResidual_succ` (`rfl`), `tauTaken`, `support` and the membership unfolding `mem_support` are definitional bookkeeping.
