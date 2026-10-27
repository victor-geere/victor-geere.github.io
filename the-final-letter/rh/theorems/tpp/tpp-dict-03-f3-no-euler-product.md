# F3 — no Euler product

**Kind:** Theorem
**Status:** PROVED (Lean; NUMERICAL discrepancy `2.0144` vs tail `1.84·10⁻⁵`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F3

## Statement

> **F3** — no Euler product: `n ↦ λ(n)λ(n+2)` is **not multiplicative**, so the associated Dirichlet series has no Euler product and the `ζ`/Perron route does not apply; Lean carries a concrete non-multiplicativity witness.

The file's status line: THEOREM (Lean) + NUMERICAL (discrepancy `2.0144` vs tail `1.84·10⁻⁵`). Source given as `rh46` §1.5; `rh47` §2 (B3).

## Hypotheses and notation

- `f(n) := λ(n)λ(n+2)`; `λ` is the Liouville function (Definition 1.2).
- "Multiplicative" means `f(mn) = f(m)f(n)` for coprime `m, n`; a multiplicative `f` with `f(1) = 1` would admit an Euler product for `Σ f(n)n^{−s}`.
- `D(2) = Σ_{n≤10⁶} f(n)/n²` is the numerical value compared with the naive multiplicative model.

## Proof / evidence

- Lean: the source says "Lean carries a concrete non-multiplicativity witness"; Appendix B lists the rh46 Lean file with `./check.sh --all` exit 0.
- Numerical (source, §5.4 bridge B3): `f` is **not multiplicative** (`f(1) = −1 ≠ 1`; `f(2)f(11) = −1 ≠ f(22) = 1`; 11 942 failing coprime pairs below 200), so there is **no Euler product**: `D(2) = Σ_{n≤10⁶} f(n)/n² = −1.12681304` (tail `≤ 1.0·10⁻⁶`) against the naive multiplicative model `0.88757352`, discrepancy `2.01438655 > 1.84·10⁻⁵`.

## Dependencies and related results

- **Restatement:** the source states the same content again as bridge **B3** / row **F8** ("no Euler product (same content as F3, stated as a bridge) | §5.4 (B3) | REFUTED"); no separate file is written for F8, since the source itself calls it the same content. Bridge B3's status is REFUTED (the claim that the `ζ`-machinery applies to `f`).
- [`THEOREM (basic)` — complete multiplicativity of `λ`](tpp-dict-03-liouville-completely-multiplicative.md) (why `λ` itself does have an Euler product, and `f` does not).
- [F7](tpp-dict-03-f7-index-parity-invisible.md) (the companion `ζ`-budget bridge failure); [Twist-invariance identity](tpp-dict-03-twist-invariance.md).
- Restated in the §7 ledger row "6 (F1–F5)".

## Notes

- The exact figures are quoted as the source gives them: `D(2) = −1.12681304`, model `0.88757352`, discrepancy `2.01438655`, tail `≤ 1.0·10⁻⁶`, threshold `1.84·10⁻⁵`, and 11 942 failing coprime pairs below 200.
- The numerical discrepancy is evidence of non-multiplicativity, not a proof of it; the Lean witness is the proof component.
