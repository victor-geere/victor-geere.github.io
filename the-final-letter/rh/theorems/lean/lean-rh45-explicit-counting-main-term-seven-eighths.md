# The counting-function main term `(T/2π) log (T/(2πe)) + 7/8`, rewritten to pin the constant `7/8`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §7 "What Mathlib has, and the counting-function main term", lines 346–371; declaration `Rh45.vonMangoldtMain_eq`

## Statement

> The classical main term of the zero counting function, `(T/2π) log (T/(2π e)) + 7/8`; stated here as an elementary real function, with the constant `7/8` made explicit:
> `vonMangoldtMain T = (T / (2 * Real.pi)) * Real.log (T / (2 * Real.pi * Real.exp 1)) + 7 / 8`.
>
> **The counting-function main term, rewritten.** For `T > 0` the `2πe` in the logarithm splits into `2π` and `e`, and `log e = 1`:
> `(T/2π) log (T/(2πe)) + 7/8 = (T/2π) log (T/2π) - T/2π + 7/8`.
> This is the elementary rewrite that pins the constant `7/8`.

## Hypotheses and notation

- `T : ℝ` with hypothesis `hT : 0 < T`.
- `vonMangoldtMain T = (T/(2π)) · log (T/(2πe)) + 7/8` (definition, line 349); `Real.pi` is `π`, `Real.exp 1` is `e`, `Real.log` the real logarithm.
- `Real.exp 1 = e` is the base of the natural logarithm, so `Real.log (Real.exp 1) = 1`.

## Proof / evidence

Complete Lean proof, no `sorry` (file header, lines 55–56). Declaration `Rh45.vonMangoldtMain_eq` in `Rh45/Explicit.lean` (lines 361–371): the denominator `2πe` is split as `T/(2π)/e` by `field_simp`, then `Real.log_div` and `Real.log_exp` are applied and `ring` closes the identity. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- Defining equation `Rh45.vonMangoldtMain_def` (definitional rewrite, not harvested separately).
- [Zeros of the Riemann zeta function are finite in any compact set](lean-rh45-explicit-zeta-zeros-finite-in-compact.md) — the companion statement from the same section.
- The round's Riemann–von Mangoldt count lives outside the Lean file: [`tpp-rh45-handoff-riemann-von-mangoldt-count.md`](../tpp/tpp-rh45-handoff-riemann-von-mangoldt-count.md) states `N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)` (status `CITED (literature)`).
- Mathlib `Real.log_div`, `Real.log_exp`.

## Notes

- The source describes this as "the elementary rewrite that pins the constant `7/8`"; the file proves the algebra of the main term and does **not** prove the Riemann–von Mangoldt count itself (Mathlib contains no such identity — see the companion file).
