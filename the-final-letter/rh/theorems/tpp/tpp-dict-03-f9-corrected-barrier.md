# F9 — the corrected barrier

**Kind:** Claim
**Status:** OPEN (source label: HEURISTIC / **OPEN**; the source states the impossibility claim is **not** a theorem)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F9; §5.4 row F9

## Statement

> **F9** — the corrected barrier: **no sign-blind alphabet with no arithmetic input** can supply a positive-density multiplicative coupling to `Ω`; and `S(x) = o(x)` is OPEN.
>
> Status: HEURISTIC / **OPEN**.

The §5.4 row gives the corrected form and the reasons it is not a theorem:

> **F9**: the corrected barrier: **no sign-blind alphabet with no arithmetic input** can supply a positive-density multiplicative coupling to `Ω` | HEURISTIC / **OPEN** | `rh47/truths.md` §3; the audit forced two corrections: the phrase "additive character in `log n`" is too wide (`n^{−it}` *is* multiplicative on `(ℝ₊,×)`, and the budgets are constants in `p`), and the audit's `C3a` exhibits a greedy object with an **arithmetic** alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) whose signal lives in the alphabet and is **circular**. The impossibility claim is therefore **not** a theorem.

## Hypotheses and notation

- `Ω` is the number of prime factors with multiplicity (Definition 1.1); `λ(n) = (−1)^{Ω(n)}` (Definition 1.2).
- A **sign-blind alphabet** is the programme's vocabulary for an alphabet (in the greedy-harmonic-sine sense of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md)) with no arithmetic input; `n^{−it}` is multiplicative on `(ℝ₊, ×)`.
- `C3a` is the audit's construction exhibiting the circular arithmetic alphabet `α_p = (−1)^{Ω(p+2)}/(p+2)` with `z = +10.1`.
- `S(x) := Σ_{n≤x} λ(n) λ(n+2)` (OPEN 3.4).

## Proof / evidence

- There is **no proof**: the source states the impossibility claim is "**not** a theorem".
- The source records the two corrections forced by the audit: (i) the phrase "additive character in `log n`" is too wide (`n^{−it}` *is* multiplicative on `(ℝ₊,×)`, and the budgets are constants in `p`); (ii) the audit's `C3a` exhibits a greedy object with an **arithmetic** alphabet whose signal lives in the alphabet and is **circular**.
- Sources: `rh47/truths.md` §3; `rh47/verify/independent_check.py` (31/31 checks, the audit of the barrier claim, per Appendix C). Register entries OP-3, OP-18.

## Dependencies and related results

- [F6](tpp-dict-03-f6-no-signal-greedy-support.md) and [F7](tpp-dict-03-f7-index-parity-invisible.md) (the bridge refutations the corrected barrier summarises); [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md) / OPEN 4.1 (the second clause).
- Definition 1.11 (parity-blind weight / rule).
- Restated in the §5.4 bridge table, the §6 F-table, and the §7 ledger row "6 (F9)".

## Notes

- **Status mapping:** the source's own label is "HEURISTIC / **OPEN**"; harvested as **OPEN** with the source's label preserved, because the source explicitly downgrades the impossibility claim from a theorem to a heuristic after the audit.
- The source's own words: "The impossibility claim is therefore **not** a theorem." That hedge must not be dropped.
