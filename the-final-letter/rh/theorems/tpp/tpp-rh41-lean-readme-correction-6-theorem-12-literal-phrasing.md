# Correction 6 — the literal phrasing of Theorem 12

**Kind:** Claim
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — "Corrections found while formalising", item 6

## Statement

> **The literal phrasing of Theorem 12.** "For every `c > 0` there is `L` with `p(L) < c·L`" is false for a *fixed* truncation `N` once `c·N ≤ a_m+2`. `Impossibility.no_linear_growth` states the correct version: for every `c > 0` there are `N` and `L` with `1 ≤ L ≤ N` and `p(L) < c·L` (the truncation is part of the data and may grow with `L`), and `no_affine_profile` / `no_sturmian_profile` give the resulting impossibilities.

## Hypotheses and notation

- `p(L)` is the factor complexity of the word on a support `0 ≤ a_0 < … < a_m` truncated at length `N`; `c > 0` is the slope.
- The literal reading fixes the truncation `N` and quantifies only over `L`; the correction quantifies over `N` and `L` together (`1 ≤ L ≤ N`).
- The obstruction for fixed `N`: once `c·N ≤ a_m+2`, the value `p(L) < c·L` cannot occur for `1 ≤ L ≤ N`.

## Proof / evidence

The README states the corrected quantification and names the formalised declarations: `Impossibility.no_linear_growth`, `Impossibility.no_affine_profile`, `Impossibility.no_sturmian_profile` (in `Rh41/Impossibility.lean`, no `native_decide`).

## Dependencies and related results

- [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md) — the theorem whose literal phrasing is corrected.
- [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md) — the bound `max_L p(L) = a_m + 2` behind the fixed-`N` obstruction.

## Notes

- The corrected statement is a **quantifier correction**, not a weakening of the impossibility: the truncation `N` is part of the data and may grow with `L`.
