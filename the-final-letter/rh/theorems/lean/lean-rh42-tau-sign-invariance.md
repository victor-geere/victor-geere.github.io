# Theorem 14, sign invariance: a positive residual stays `≥ 0` and a negative residual stays `≤ 0`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `tauStep_nonneg` (lines 117–124), `tauStep_pos_of_lt` (lines 130–138), `tauStep_nonpos` (lines 142–150), `tauStep_neg` (lines 157–164)

## Statement

> **Sign invariance (non-strict).** For a positive residual, a step leaves the residual nonnegative:
> `0 < r → 0 ≤ tauStep p n r`.
>
> **Sign invariance (strict, with a strictness hypothesis).** If the term is strictly smaller than a positive residual, a step preserves strict positivity:
> `0 < r → tauTerm p n < r → 0 < tauStep p n r`.
> (Without this hypothesis strict positivity can fail: at `r = 1/2`, `n = 0`, `p = 1` the term is taken with equality and the residual becomes `0`.)
>
> **Sign invariance (mirror, non-strict).** For a negative residual, a step leaves the residual nonpositive:
> `r < 0 → tauStep p n r ≤ 0`.
>
> Lean statements:
>
> `tauStep_nonneg (p n : ℕ) {r : ℚ} (hr : 0 < r) : 0 ≤ tauStep p n r`
>
> `tauStep_pos_of_lt (p n : ℕ) {r : ℚ} (hr : 0 < r) (h : tauTerm p n < r) : 0 < tauStep p n r`
>
> `tauStep_nonpos (p n : ℕ) {r : ℚ} (hr : r < 0) : tauStep p n r ≤ 0`
>
> `tauStep_neg (p n : ℕ) {r : ℚ} (hr : r < 0) : tauStep p n r ≤ 0`

## Hypotheses and notation

- One greedy step at index `n` from residual `r` (`tauStep p n r`, definition not harvested here): the term `tauTerm p n` is taken exactly when it has the sign of `r` and its absolute value is at most `|r|`, in which case it is subtracted from the residual; otherwise the residual is unchanged. `tauTake p n r` is the named take condition.
- Hypotheses: `p, n : ℕ`; the residual `r : ℚ` is strictly positive (`hr : 0 < r`) for the first two statements and strictly negative (`hr : r < 0`) for the last two; `tauStep_pos_of_lt` additionally assumes `tauTerm p n < r`.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` by the four `theorem`s named above; each splits on the take condition `tauTake p n r` and uses `tauStep_eq_sub_of_cond` / `tauStep_eq_self_of_not`. No `sorry`/`admit`/`axiom`/`native_decide` occurs in the file.

- `tauStep_nonneg`: if the term is taken, `r - α ≥ 0` from `α ≤ r` (positive branch) or from `α < 0 < r` (negative branch); otherwise the residual is `r > 0`.
- `tauStep_pos_of_lt`: if the term is taken, `r - α > 0` from `α < r`; otherwise the residual is `r > 0`.
- `tauStep_nonpos` / `tauStep_neg`: if the term is taken, `r - α ≤ 0` from `r ≤ α` (negative branch) or `r < 0 < α` (positive branch); otherwise the residual is `r < 0`.

## Dependencies and related results

- The alphabet sign [`lean-rh42-tau-alphabet-sign.md`](lean-rh42-tau-alphabet-sign.md) supplies the sign information about `tauTerm`.
- The lift to the whole run is [`lean-rh42-tau-residual-sign.md`](lean-rh42-tau-residual-sign.md); the parity consequence is [`lean-rh42-tau-parity-lock.md`](lean-rh42-tau-parity-lock.md).
- The rh42 Lean README lists this row as "Theorem 14, sign invariance" ↔ `tauStep_nonneg`, `tauStep_pos_of_lt`, `tauStep_nonpos`, `tauStep_neg`.

## Notes

- `tauStep_nonpos` and `tauStep_neg` have literally the same type: the source states the negative-target invariance twice. The docstring of `tauStep_neg` explains that the strict form cannot hold in general — a take at a negative residual gives `r - α ≤ 0`, and `r - α < 0` unless `α = r` exactly, which can happen (e.g. `r = α = -1/2`). Both declarations are folded into this file.
- The docstring of `tauStep_nonneg` states the non-strict form; the strictness hypothesis `α < r` in `tauStep_pos_of_lt` is necessary, as the source notes by the explicit counterexample above.
