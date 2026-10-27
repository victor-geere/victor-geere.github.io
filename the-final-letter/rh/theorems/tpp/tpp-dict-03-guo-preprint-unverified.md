# UNVERIFIED 4.7 (a recent frontier development; preprint, single author, not peer-reviewed)

**Kind:** Claim
**Status:** OPEN (source label: **UNVERIFIED** citation; preprint, not peer-reviewed)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.3

## Statement

> **UNVERIFIED 4.7 (a recent frontier development; preprint, single author, not peer-reviewed).** [J. Guo, *Logarithmic Chowla correlations across all shift scales*, arXiv:2608.23500v4 (Aug/Sep 2026)](https://arxiv.org/abs/2608.23500) proves a *fixed power-logarithmic* bound for the **log-weighted** two-point correlation across the full shift range: there is `c > 0` and, for every sufficiently large `x`, a set `ℰ_x` with `|ℰ_x ∩ [1,H]| ≪_A H (log x)^{−A}` for every fixed `A > 0` and every `1 ≤ H ≤ x`, such that `max_{1≤h≤x, h∉ℰ_x} sup_{1≤y≤x} |Σ_{n≤y} λ(n)λ(n+h)/n| ≪ (log x)^{1−c}`; plus a GRH-conditional bound uniform in `h` with no exceptional shifts.

The file's status line: *Status:* **UNVERIFIED citation** in the sense required by this file: the arXiv abstract page was read (title, author, submission dates, abstract) but the paper is a 2026 preprint that is **not peer-reviewed** and was **not** independently checked by this file. Crucially, **it is a logarithmic statement with an exceptional set of shifts**; it does **not** give `Σ_{n≤x}λ(n)λ(n+2) = o(x)`, and OPEN 4.1 is unaffected. Recorded here only so that the dictionary's "logarithmic" column is not read as frozen at 2019.

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2); the sum is the **log-weighted** (`/n`) two-point correlation.
- `c > 0`; `ℰ_x` is an exceptional set of shifts with `|ℰ_x ∩ [1,H]| ≪_A H (log x)^{−A}` for every fixed `A > 0` and every `1 ≤ H ≤ x`.
- The bound is `max_{1≤h≤x, h∉ℰ_x} sup_{1≤y≤x} |Σ_{n≤y} λ(n)λ(n+h)/n| ≪ (log x)^{1−c}`, plus a GRH-conditional bound uniform in `h` with no exceptional shifts.
- GRH = the generalised Riemann hypothesis.

## Proof / evidence

- The source gives no proof; it records that the arXiv abstract page was read (title, author, v1 24 Aug 2026, v4 1 Sep 2026, abstract verbatim) and that the paper is **not peer-reviewed** and **not independently checked** (Appendix A row Gu1).
- The source marks the citation **UNVERIFIED (preprint, not peer-reviewed)**.

## Dependencies and related results

- [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md) and [THEOREM 3.9](tpp-dict-03-tao-teravainen-log-all-orders.md) are the earlier log-averaged theorems this preprint extends across shift scales.
- [THEOREM 4.4](tpp-dict-03-log-averaged-no-implication.md) explains why it cannot imply the un-averaged target; [OPEN 3.4](tpp-dict-03-two-point-chowla-open.md) remains open.
- Restated in the §7 ledger row "4.7".

## Notes

- **Status mapping:** the source's own label is **UNVERIFIED**, which is not one of the SPEC status terms; the closest term is OPEN, and the qualifier records the source's label exactly. The mathematical claim is a cited preprint result, not a result of this workspace.
- The source's warning is reproduced: this is a **logarithmic** statement **with an exceptional set of shifts**; it does **not** give `Σ_{n≤x}λ(n)λ(n+2) = o(x)`, and OPEN 4.1 is unaffected.
