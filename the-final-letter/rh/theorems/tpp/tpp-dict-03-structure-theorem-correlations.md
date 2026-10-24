# THEOREM 3.13 (the structure theorem for correlations; the modern "why")

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.5

## Statement

> **THEOREM 3.13 (the structure theorem for correlations; the modern "why").** For `1`-bounded multiplicative `g_0, …, g_k`, the correlation sequence `a ↦ lim (1/log ω_m) Σ_{x_m/ω_m ≤ n ≤ x_m} g_0(n+ah_0)⋯g_k(n+ah_k)/n` is a uniform limit of periodic sequences; if `g_0⋯g_k` does **not** weakly pretend to be a Dirichlet character, it vanishes identically and the periodic approximants are `χ`-isotypic otherwise.

The file's status line: *Status:* THEOREM. *Source:* [Tao–Teräväinen, arXiv:1708.02610](https://arxiv.org/abs/1708.02610) (abstract verified verbatim); almost-all-scales version in [arXiv:1809.02518](https://arxiv.org/abs/1809.02518).

The file's "why it matters": *Why this matters for `λ`.* `λ` weakly pretends to be nothing (its Dirichlet series `ζ(2s)/ζ(s)` has no `L`-function pole structure of the pretentious type at `s = 1`), which is the structural reason the *log-averaged* correlations vanish. The same structure theorem is what is **not** available for the un-averaged sum.

## Hypotheses and notation

- `g_0, …, g_k` are `1`-bounded multiplicative functions on the positive integers.
- `h_0, …, h_k` are fixed shifts; `a` is the correlation variable; `x_m`, `ω_m` are the scales and averaging parameters of the limit, with `ω_m → ∞`.
- "weakly pretends to be a Dirichlet character" is the source's pretentiousness term; `χ`-isotypic means the periodic approximants are built from a Dirichlet character `χ`.
- `ζ` is the Riemann zeta function; `λ = 1_□ * μ` gives `Σ_{n≥1} λ(n)n^{−s} = ζ(2s)/ζ(s)`.

## Proof / evidence

- The source gives no proof; it cites Tao–Teräväinen, arXiv:1708.02610 (abstract verified verbatim; Appendix A row TT1), with the almost-all-scales version in arXiv:1809.02518 (row TT3).

## Dependencies and related results

- [THEOREM 3.9](tpp-dict-03-tao-teravainen-log-all-orders.md) (the log-averaged Chowla theorem resting on this structure); [THEOREM 3.12](tpp-dict-03-almost-all-scales.md) (the almost-all-scales version); [THEOREM 3.10](tpp-dict-03-log-chowla-iff-log-sarnak.md) (equivalences).
- Used in HEURISTIC 2.4 as the "structure theorems (§4.1 rows T7–T8)".
- Restated in the §7 ledger row "3.13".

## Notes

- The displayed limit definition is reproduced verbatim, including the structure of the averaging (`(1/log ω_m)` and the range `x_m/ω_m ≤ n ≤ x_m`).
- The source presents this as the structural explanation for why the **log-averaged** correlations vanish, and explicitly says the structure theorem is **not** available for the un-averaged sum.

- **Primary-source correction (2025-10-06, session 003 citation audit).** The paper builds its correlation sequence `f(a)` from a **generalised limit functional** `lim~`; ordinary limits are not known to exist there. This document writes a plain `lim` and calls the display verbatim, and it drops the paper's hypothesis `1 ≤ ω_m ≤ x_m`.
