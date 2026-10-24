# THEOREM 3.9 (log-averaged Chowla for odd orders and for k = 2 — Tao–Teräväinen, Tao)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.4

## Statement

> **THEOREM 3.9 (log-averaged Chowla for odd orders and for `k = 2` — Tao–Teräväinen, Tao).** Definition 3.7 holds for every fixed **odd** `k` and every fixed admissible affine data (Tao–Teräväinen), and for `k = 2` (Tao, arXiv:1509.05422). For even `k ≥ 4` it is **open**.

The file's status line: *Status:* THEOREM. *Sources:* [Tao–Teräväinen, arXiv:1708.02610, Duke Math. J. **168** (2019) 1977–2027](https://arxiv.org/abs/1708.02610) (structural theorem for log-averaged correlations plus the **odd**-order cases of log-Chowla; also see [arXiv:1710.02112, J. Théor. Nombres Bordeaux **30** (2018) 997–1015](https://arxiv.org/abs/1710.02112) for the odd-order paper) and [Tao–Teräväinen, arXiv:1809.02518, Alg. Number Th. **13** (2019) 2103–2150](https://arxiv.org/abs/1809.02518) (unweighted Chowla at almost all scales, for `k` odd or `k = 2`; it proves no log-averaged statement).

## Hypotheses and notation

- Definition 3.7 (logarithmic correlation) is as in [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md): for a parameter `ω = ω(x) → ∞`, `ω(x) ≤ x`, the logarithmically averaged correlation `Σ_{x/ω < n ≤ x} λ(a_1 n + b_1) ⋯ λ(a_k n + b_k)/n = o(log ω)`; `ω(x) = x` gives the plain log-average over `[1,x]`.
- `k` is **fixed** (not growing with `x`); the affine data `a_i n + b_i` are fixed and admissible.
- `λ` is the Liouville function (Definition 1.2).

## Proof / evidence

- The source gives no proof; it cites Tao–Teräväinen arXiv:1708.02610 (plus the odd-order paper arXiv:1710.02112) and arXiv:1809.02518, all three marked **verified** in Appendix A (arXiv API: titles, authors, journal refs, abstracts).
- The odd-`k` cases are Tao–Teräväinen's (`arXiv:1710.02112` Theorem 1.1, and `arXiv:1708.02610` Theorem 1.1(i) for an odd number of shifts); the `k = 2` case is Tao's (`arXiv:1509.05422`). The almost-all-scales paper `arXiv:1809.02518` proves the *unweighted* statement at almost all scales for `k` odd or `k = 2`, and says of the log-averaged one that even `k ≥ 4` is unknown.

## Dependencies and related results

- [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md) (the two-point case); [THEOREM 3.10](tpp-dict-03-log-chowla-iff-log-sarnak.md) (equivalences) and [THEOREM 3.13](tpp-dict-03-structure-theorem-correlations.md) (the structure theorem for log correlations).
- Restated as §4.1 row **T6**; cited in the source's index tags as entry `A4`; restated in the §7 ledger row "3.7–3.9".
- Does **not** imply the un-averaged statement: [`THEOREM 4.4`](tpp-dict-03-log-averaged-no-implication.md).

## Notes

- "All orders" means every fixed `k`; the source does not claim uniformity in `k`.
- As with 3.8, the source's whole point in listing these is that the log-averaged theorem is a theorem while the un-averaged target (OPEN 3.4) is open.

- **Primary-source correction (2025-10-06, session 003 citation audit).** This document — and the dictionary row it was harvested from — presented "log-averaged Chowla for **all orders**" as a theorem and credited the general case to `arXiv:1809.02518`. **No such result exists.** The papers say: `arXiv:1710.02112` Theorem 1.1 — "Let `k ≥ 1` be an **odd** natural number … `(1/log x) Σ_{n≤x} λ(a₁n+b₁)…λ(a_k n+b_k)/n = o(1)`"; `arXiv:1708.02610` Theorem 1.1(i) — the logarithmically averaged conjecture for an **odd** number of shifts, with the affine form (eq. 8) stated "if `k` is even", i.e. again an odd number of factors; `arXiv:1809.02518`, the paper credited here, proves the **unweighted** conjecture at almost all scales and states the log-averaged position itself — "the logarithmically averaged Chowla conjecture has been established for `k = 2` in [29] and for all odd values of `k` in [32]". The `k = 2` log-averaged case is Tao's `arXiv:1509.05422`, which this document did not cite. The scope is now stated as odd `k` plus `k = 2`, with even `k ≥ 4` open. This is the same class of error as the MRT erratum — a real paper, cited for a statement it does not make — and it was found the same way, by reading the source.
