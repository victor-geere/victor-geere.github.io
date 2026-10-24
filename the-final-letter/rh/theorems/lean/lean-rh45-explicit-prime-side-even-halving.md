# Evenness of the weight halves the prime side

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §6 "The prime side and its splitting", lines 308–323; declarations `Rh45.primeSide_even`, `Rh45.primeSide_even_eq_two_mul_sum`

## Statement

> **Evenness halves the prime side.** If `g (-u) = g u` for all `u`, the `-log` half equals the `+log` half, so `primeSide g nmax = 2 * primeSideLog g nmax`.
>
> The same statement with the two halves displayed as a single sum: for even `g`, `primeSide g nmax = 2 * ∑_{n≤nmax} (Λ n / √n) g (log n)`.

## Hypotheses and notation

- `g : ℝ → ℝ` with hypothesis `hg : ∀ u, g (-u) = g u` (`g` even); `nmax : ℕ`.
- `primeSide g nmax = ∑_{n=2}^{nmax} (Λ n / √n) (g (log n) + g (−log n))` (definition, line 274).
- `primeSideLog g nmax = ∑_{n=2}^{nmax} (Λ n / √n) g (log n)` (definition, line 278).
- `Λ` is Mathlib's von Mangoldt function `ArithmeticFunction.vonMangoldt`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations in `Rh45/Explicit.lean`: `Rh45.primeSide_even` (lines 310–316) — the `−log` half is shown equal to the `+log` half by `Finset.sum_congr` with `hg`, then the split of [`primeSide_split`](lean-rh45-explicit-prime-side-splits-into-log-halves.md) and `ring` finish — and `Rh45.primeSide_even_eq_two_mul_sum` (lines 320–323), which is literally `primeSide_even g hg nmax` with the sum displayed. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- [The prime side of the explicit formula splits into its +log and −log halves](lean-rh45-explicit-prime-side-splits-into-log-halves.md) — `primeSide_split`.
- [Non-negativity of the prime side](lean-rh45-explicit-prime-side-nonneg.md).
- [Evenness of the Cauchy and Gaussian kernels](lean-rh45-explicit-kernel-evenness.md) — the same evenness shape on the zero side's kernels.

## Notes

- `primeSide_even_eq_two_mul_sum` has exactly the content of `primeSide_even` (its proof is that declaration applied), so it is recorded inside this file rather than harvested as a separate theorem file — the "already captured by another harvested statement" case.
