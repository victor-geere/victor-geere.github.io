# F1 — the trivial bound

**Kind:** Theorem
**Status:** PROVED (Lean: `corr_abs_le`, `corr_zero`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F1

## Statement

> **F1** — the trivial bound: `|S(x,h)| ≤ x` for every `h, x`; `S(x,0) = x`.

The file's status line: THEOREM (Lean: `corr_abs_le`, `corr_zero`). Source given as `rh46` `Rh46/Chowla.lean`.

## Hypotheses and notation

- `S(x,h) := Σ_{n≤x} λ(n) λ(n+h)` is the two-point correlation with shift `h`; `S(x) = S(x,2)` is the target of OPEN 3.4.
- `λ(n) ∈ {±1}` (Definition 1.2), so `|λ(n)λ(n+h)| = 1` and the sum over `n ≤ x` has at most `x` terms.
- `S(x,0) = Σ_{n≤x} λ(n)² = x` since `λ(n)² = 1`.

## Proof / evidence

- Machine-checked in Lean: the source names the declarations `corr_abs_le` and `corr_zero` in `rh46/lean/Rh46/Chowla.lean` (Appendix B records that file as "456 lines, 38 theorems, `./check.sh --all` exit 0, no `sorry`/`axiom`/`native_decide`").
- The source writes the row's statement with the absolute-value bars escaped (`\|S(x,h)\|`); the mathematics is `|S(x,h)| ≤ x`.

## Dependencies and related results

- [`THEOREM (basic)` — complete multiplicativity of `λ`](tpp-dict-03-liouville-completely-multiplicative.md) (`λ(n)² = 1`).
- Companion rows: [F2](tpp-dict-03-f2-lambda-identically-one.md) (`o(x)` is not formal) and [F4](tpp-dict-03-f4-finite-prefix-indeterminacy.md) (finite-prefix indeterminacy).
- Restated in the §7 ledger row "6 (F1–F5)".

## Notes

- The source states the bound for every `h, x`; the equality case `S(x,0) = x` is part of the same row.
