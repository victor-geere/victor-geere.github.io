# F2 — the "`λ ≡ 1`" triviality: `o(x)` is not formal

**Kind:** Theorem
**Status:** PROVED (Lean: `corrAsymptotic_zero_false`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F2

## Statement

> **F2** — the "`λ ≡ 1`" triviality — **`o(x)` is not formal**: the completely multiplicative, bounded function `λ ≡ 1` has correlation exactly `x`; so `o(x)` is **not** a consequence of complete multiplicativity plus boundedness — it is a genuine arithmetic statement about `λ`.

The file's status line: THEOREM (Lean: `corrAsymptotic_zero_false`). Source given as `rh46` §1.1.

## Hypotheses and notation

- `λ ≡ 1` is the completely multiplicative, `1`-bounded function identically equal to `1`; its two-point correlation is `Σ_{n≤x} 1 = x`.
- `o(x)` is the conclusion sought in OPEN 3.4 (`S(x) = o(x)`).
- "Formal" here means: deducible from complete multiplicativity plus boundedness alone.

## Proof / evidence

- Machine-checked in Lean: the source names the declaration `corrAsymptotic_zero_false` (Appendix B lists it among the declarations of `rh46/lean/Rh46/Chowla.lean`; the file is recorded as 456 lines, 38 theorems, `./check.sh --all` exit 0, no `sorry`/`axiom`/`native_decide`).
- The argument recorded by the source: `λ ≡ 1` satisfies complete multiplicativity and boundedness but has correlation exactly `x`, hence those two properties cannot imply `o(x)`.

## Dependencies and related results

- [F1](tpp-dict-03-f1-trivial-bound.md) (the trivial bound); [F3](tpp-dict-03-f3-no-euler-product.md) (no Euler product); [F4](tpp-dict-03-f4-finite-prefix-indeterminacy.md) (a finite check cannot prove `o(x)`).
- [`THEOREM (basic)` — complete multiplicativity of `λ`](tpp-dict-03-liouville-completely-multiplicative.md) (the property being shown insufficient).
- Restated in the §7 ledger row "6 (F1–F5)".

## Notes

- This row is the source's warning that `o(x)` is a genuine arithmetic statement about `λ` and not a formal consequence of its algebraic properties; it must not be read as evidence against `o(x)`.
