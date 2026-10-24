# The prime side of the explicit formula splits into its `+log` and `−log` halves

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §6 "The prime side and its splitting", lines 300–306; declaration `Rh45.primeSide_split`

## Statement

> **Splitting of the prime side.** The two logs separate term by term:
> `primeSide g nmax = primeSideLog g nmax + primeSideNegLog g nmax`. Finite algebra (distributivity and `Finset.sum_add_distrib`), no analysis.

## Hypotheses and notation

- `g : ℝ → ℝ` — the prime-side weight; `nmax : ℕ` — the truncation point of the prime sum.
- `primeSide g nmax = ∑_{n=2}^{nmax} (Λ n / √n) (g (log n) + g (−log n))` (definition, line 274), with `Λ` Mathlib's von Mangoldt function `ArithmeticFunction.vonMangoldt` (already `ℝ`-valued).
- `primeSideLog g nmax = ∑_{n=2}^{nmax} (Λ n / √n) g (log n)` (line 278) — the `+log` half.
- `primeSideNegLog g nmax = ∑_{n=2}^{nmax} (Λ n / √n) g (−log n)` (line 282) — the `−log` half.
- The sums run over `Finset.Icc 2 nmax`.

## Proof / evidence

Complete Lean proof, no `sorry` (file header, lines 55–56). Declaration `Rh45.primeSide_split` in `Rh45/Explicit.lean` (lines 303–306): rewriting with the three defining equations, `← Finset.sum_add_distrib`, then `Finset.sum_congr` with `ring` on each summand. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- Defining equations `Rh45.primeSide_def`, `Rh45.primeSideLog_def`, `Rh45.primeSideNegLog_def` (definitional rewrites, not harvested separately).
- [Evenness of the weight halves the prime side](lean-rh45-explicit-prime-side-even-halving.md) — the further collapse when `g` is even.
- [Non-negativity of the prime side](lean-rh45-explicit-prime-side-nonneg.md).

## Notes

- The source presents the split as "finite algebra (distributivity and `Finset.sum_add_distrib`), no analysis"; the harvest preserves that reading.
