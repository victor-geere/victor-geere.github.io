# Zeros of the Riemann zeta function are finite in any compact set

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry; restatement of a Mathlib theorem)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §7 "What Mathlib has, and the counting-function main term", lines 337–344; declaration `Rh45.riemannZetaZeros_finite_in_compact`

## Statement

> Mathlib's Riemann–von Mangoldt substitute: the zeros of `ζ` are a discrete set, so a compact region contains only finitely many of them. This file states no Riemann–von Mangoldt identity, because Mathlib contains none; this is the directly available finiteness statement (`IsCompact.inter_riemannZetaZeros_finite`, restated): for every compact `S ⊆ ℂ`, `(S ∩ riemannZetaZeros).Finite`.

## Hypotheses and notation

- `S : Set ℂ` with hypothesis `hS : IsCompact S`.
- `riemannZetaZeros ⊆ ℂ` — Mathlib's set of zeros of the Riemann zeta function.
- `(S ∩ riemannZetaZeros).Finite` is Mathlib's finiteness predicate for a set.

## Proof / evidence

Complete Lean proof, no `sorry` (file header, lines 55–56). Declaration `Rh45.riemannZetaZeros_finite_in_compact` in `Rh45/Explicit.lean` (lines 342–344), a one-line application of Mathlib's `IsCompact.inter_riemannZetaZeros_finite`; the source describes it as "the directly available finiteness statement (`IsCompact.inter_riemannZetaZeros_finite`, restated)". The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- Mathlib `IsCompact.inter_riemannZetaZeros_finite`.
- [The counting-function main term rewritten](lean-rh45-explicit-counting-main-term-seven-eighths.md) — the classical main term, which the source states and proves independently of any analysis because Mathlib has no Riemann–von Mangoldt identity.
- The workspace's Riemann–von Mangoldt count itself is stated elsewhere in the round: [`tpp-rh45-handoff-riemann-von-mangoldt-count.md`](../tpp/tpp-rh45-handoff-riemann-von-mangoldt-count.md) (status `CITED (literature)`).

## Notes

- The status is `PROVED (Lean)` because the declaration is a complete Lean proof, but the source is explicit that it is a **restatement** of a Mathlib theorem, not new mathematics, and that it is only a substitute for Riemann–von Mangoldt ("this file states no Riemann–von Mangoldt identity, because Mathlib contains none"). It must not be read as a proof of the Riemann–von Mangoldt count.
