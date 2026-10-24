# THEOREM (basic) — complete multiplicativity of `λ`

**Kind:** Theorem
**Status:** PROVED (Lean for the multiplicativity facts; Dirichlet-series identity cited from `01` §2)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §1.1, the "THEOREM (basic)" following Definition 1.2

## Statement

> **THEOREM (basic).** `λ` is **completely** multiplicative (`λ(mn) = λ(m)λ(n)` for all `m, n ≥ 1`, with no coprimality restriction), `λ(n) ∈ {±1}`, `λ(n)² = 1`, `λ(1) = 1`. Its Dirichlet series is

```
Σ_{n≥1} λ(n) n^{−s} = ζ(2s)/ζ(s)     (σ > 1) ,
```

> equivalently `λ = 1_□ * μ`: `Σ_{d|n} λ(d) = 1` if `n` is a square and `0` otherwise.

The file's own attribution: [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §2, Lemmas 2.1–2.3; `rh46/lean/Rh46/Chowla.lean` (`liouville_mul`, `liouville_sq`, `liouville_abs_le_one`).

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` for `n ≥ 1` (Definition 1.2), where `Ω(n)` is the number of prime factors of `n` **with multiplicity** (Definition 1.1).
- `1_□` is the indicator of the squares; `μ` is the Möbius function; `*` denotes Dirichlet convolution; `ε` is the unit of that convolution.
- `σ > 1` is the abscissa of absolute convergence of the Dirichlet series.
- Convention adopted by the rounds: `λ(0) = 1`, which destroys complete multiplicativity at `0` (recorded in Lean as `liouville_mul_zero_false`). All statements use `n ≥ 1`.

## Proof / evidence

- The file cites the Lean declarations `liouville_mul`, `liouville_sq`, `liouville_abs_le_one` (`rh46/lean/Rh46/Chowla.lean`) and dictionary file `01` §2 Lemmas 2.1–2.3.
- No proof is written out in this file.

## Dependencies and related results

- Definition 1.1 (`Ω`, `ω`); Definition 1.2 (Liouville `λ`).
- Used by THEOREM 2.2, UNVERIFIED 2.3, THEOREM 3.3 and THEOREM 5.5.
- Restated in this file's own §7 ledger under row "1.1 (basic)".

## Notes

- The source's `Source:` line splits the statement: the multiplicativity/square/bound clauses are the ones carrying Lean declaration names; the Dirichlet-series and convolution identities are quoted from the earlier dictionary entry `01` §2. This harvest does not claim a Lean proof of `Σ λ(n)n^{−s} = ζ(2s)/ζ(s)`.
- The **Convention warning** of the source is reproduced above: `λ(0) = 1` is a convention, not `(−1)^{Ω(0)}`, and it destroys complete multiplicativity at `0`.
