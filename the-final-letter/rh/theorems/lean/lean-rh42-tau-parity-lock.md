# Theorem 14, parity lock: a positive residual changes only at even indices, a negative one only at odd indices

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `tauStep_eq_self_of_odd` (lines 169–174), `take_parity` (lines 178–182), `tauStep_eq_self_of_even` (lines 185–190), `take_parity_neg` (lines 194–198)

## Statement

> At an odd (negative) index a positive residual never takes the term, and at an even (positive) index a negative residual never takes the term:
>
> `Odd n → 0 < r → tauStep p n r = r`
>
> `Even n → r < 0 → tauStep p n r = r`
>
> **Parity lock.** For a positive residual, a step that changes the residual (i.e. that takes the term) happens at an even index; for a negative residual it happens at an odd index:
>
> `0 < r → (tauStep p n r ≠ r → Even n)`
>
> `r < 0 → (tauStep p n r ≠ r → Odd n)`
>
> Lean statements:
>
> `tauStep_eq_self_of_odd (p : ℕ) {n : ℕ} (hn : Odd n) {r : ℚ} (hr : 0 < r) : tauStep p n r = r`
>
> `take_parity (p : ℕ) {r : ℚ} (hr : 0 < r) : ∀ {n : ℕ}, tauStep p n r ≠ r → Even n`
>
> `tauStep_eq_self_of_even (p : ℕ) {n : ℕ} (hn : Even n) {r : ℚ} (hr : r < 0) : tauStep p n r = r`
>
> `take_parity_neg (p : ℕ) {r : ℚ} (hr : r < 0) : ∀ {n : ℕ}, tauStep p n r ≠ r → Odd n`

## Hypotheses and notation

- The rule (`tauStep`, `tauTake`) takes `tauTerm p n` exactly when it has the sign of the current residual `r` and `|tauTerm p n| ≤ |r|`; the alphabet is signed `τ`<sub>`n`</sub>` = (−1)`<sup>`n`</sup>`/(n+2)`<sup>`p`</sup>`, even indices positive and odd indices negative.
- Hypotheses: `p : ℕ`; the residual `r : ℚ` satisfies `0 < r` for the positive-target statements and `r < 0` for the mirrored ones; `tauStep_eq_self_of_odd` assumes `Odd n`, `tauStep_eq_self_of_even` assumes `Even n`.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` by the four `theorem`s named above.

- `tauStep_eq_self_of_odd`: a take at an odd index requires `0 < tauTerm p n` in the positive branch and `r < 0` in the negative branch, both impossible (`tauTerm_neg_of_odd`, `hr`).
- `take_parity` is immediate from `tauStep_eq_self_of_odd` by `Nat.not_even_iff_odd`.
- `tauStep_eq_self_of_even` and `take_parity_neg` are the mirror statements, using `tauTerm_pos_of_even`.

No `sorry`/`admit`/`axiom`/`native_decide` occurs in the file.

## Dependencies and related results

- Uses the alphabet sign [`lean-rh42-tau-alphabet-sign.md`](lean-rh42-tau-alphabet-sign.md).
- The support-level form and the gap theorem are [`lean-rh42-tau-even-gaps.md`](lean-rh42-tau-even-gaps.md).
- The rh42 Lean README lists this row as "Theorem 14, parity lock" ↔ `tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg`.

## Notes

- `tauStep_eq_self_of_odd` is the form of `take_parity` with the contrapositive stated directly (they are equivalent modulo `Nat.not_even_iff_odd`), and likewise `tauStep_eq_self_of_even` for `take_parity_neg`; the source states and proves all four, and they are folded into this one file.
- The statement is about a single step from a fixed residual; the quantifier over the whole run enters only through the residual sequence.
