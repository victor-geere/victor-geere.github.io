# T5 — Matomäki–Radziwiłł: the non-trivial bound and `μ` in short intervals

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.1, row T5 of the "What is proved" table

## Statement

> **T5** — `Σ_{n≤x}λ(n)λ(n+1) ≪ (1−δ)x` for some `δ > 0`; `μ` cancels in almost all short intervals `[x, x+ψ(x)]`, `ψ → ∞`.

The row's status and citation: THEOREM | [Matomäki–Radziwiłł, arXiv:1501.04585](https://arxiv.org/abs/1501.04585) | **verified** (arXiv API: title, authors, abstract).

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2); `μ` is the Möbius function (Definition 1.3).
- `δ > 0`; `≪` is Vinogradov notation.
- "`μ` cancels in almost all short intervals `[x, x+ψ(x)]`" means the Möbius sum over the interval is `o` of its length for almost every `x`, with `ψ(x) → ∞` arbitrarily slowly.

## Proof / evidence

- No proof is given; the row cites Matomäki–Radziwiłł, arXiv:1501.04585, marked **verified** in the row's last column (arXiv API: title, authors, abstract). Appendix A row MR1 adds: K. Matomäki, M. Radziwiłł, *Multiplicative functions in short intervals*, arXiv:1501.04585; Ann. of Math. **183** (2016) 1015–1056, "**verified (arXiv)** … *Annals volume/pages not independently confirmed*".

## Dependencies and related results

- The first clause **restates** [`THEOREM 3.6`](tpp-dict-03-matomaki-radziwill-bound.md) of §3.3 (same bound, same shift `h = 1`, same paper); the row is recorded here because the ledger adds the second clause about `μ` in short intervals.
- The paper is the short-interval input to [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md) (the entropy decrement method).
- Restatement: the §7 ledger carries the first clause as row "3.6" (`Σ_{n≤x}λ(n)λ(n+1) ≪ (1−δ)x`).

## Notes

- Harvested as a ledger row because the source's §4.1 table is an explicitly labelled THEOREM-status ledger and this row carries content beyond THEOREM 3.6 (the `μ` short-interval clause). The overlap with 3.6 is recorded, not duplicated in substance.
- The source records a **partially confirmed** journal reference (Annals volume/pages not independently confirmed) while the arXiv metadata is marked verified.
