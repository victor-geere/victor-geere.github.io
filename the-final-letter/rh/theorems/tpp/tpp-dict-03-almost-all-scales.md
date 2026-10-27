# THEOREM 3.12 (Chowla for almost all scales / exceptional shifts — Tao–Teräväinen)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.5

## Statement

> **THEOREM 3.12 (Chowla for almost all scales / exceptional shifts — Tao–Teräväinen).** The `k`-point un-averaged Chowla statement `E_{n≤X} λ(n+h_1)⋯λ(n+h_k) = o(1)` holds for **`k` odd or `k = 2`**, for all scales `X` outside a set of **zero logarithmic density**; and (separately) the logarithmic correlations of bounded multiplicative functions vanish at **almost all scales** `X`, with an explicit structure theorem: they vanish unless `g_1⋯g_k` weakly pretends to be a twisted Dirichlet character `n ↦ χ(n)n^{it}`.

The file's status line: *Status:* THEOREM. *Source:* [Tao–Teräväinen, arXiv:1809.02518, Alg. Number Th. **13** (2019) 2103–2150](https://arxiv.org/abs/1809.02518) (abstract verified verbatim, including the sentence *"we establish the `k`-point Chowla conjecture `E_{n≤X} λ(n+h_1)⋯λ(n+h_k) = o(1)` for `k` odd or equal to `2` for all scales `X` outside of a set of zero logarithmic density"*).

The file's reading: *Reading.* This is an **almost-all-scales** statement, not an almost-all-shifts one, and it does not give the statement at a **prescribed** scale `X`. It therefore does not give `S(x) = o(x)` for the given `x`.

## Hypotheses and notation

- `E_{n≤X}` denotes the average over `n ≤ X`; `λ` is the Liouville function (Definition 1.2).
- `k` is fixed; the exceptional scales form a set of **zero logarithmic density**.
- `g_1, …, g_k` are bounded multiplicative functions; `χ(n)n^{it}` is a twisted Dirichlet character.
- "weakly pretends to be" is the source's pretentiousness vocabulary.

## Proof / evidence

- The source gives no proof; it cites Tao–Teräväinen, arXiv:1809.02518, whose abstract is quoted verbatim (Appendix A row TT3 marks the citation **verified**).
- The same paper supplies the almost-all-scales structure theorem mentioned in [THEOREM 3.13](tpp-dict-03-structure-theorem-correlations.md).

## Dependencies and related results

- Restated as §4.1 row **T7**; contrasted with the almost-all-**shifts** statement [THEOREM 3.11](tpp-dict-03-mrtt-almost-all-shifts.md).
- [`THEOREM 4.6`](tpp-dict-03-almost-all-insufficient.md) states that neither almost-all statement yields `S(x) = o(x)` at the prescribed scale; OPEN 3.4 remains open.
- Also relevant to HEURISTIC 2.4, which cites §4.1 rows T7–T8 for the structure theory.
- Restated in the §7 ledger row "3.12".

## Notes

- The source stresses the quantifier structure: **almost all scales**, not a prescribed one; the exceptional set of scales is not excluded at a prescribed scale.
- The "structure theorem" clause is shared with THEOREM 3.13; the source states it here as part of this theorem.

- **Primary-source correction (2025-10-06, session 003 citation audit).** The abstract quoted here omits the paper's requirement that the shifts `h_1, …, h_k` be **distinct**: Corollary 1.14 is false for a repeated shift, and the abstract's wording does not carry the hypothesis. The document's statement should be read with distinctness added.
