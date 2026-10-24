# THEOREM 3.11 (Chowla for almost all shifts — Matomäki–Radziwiłł–Tao "MRTT")

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.5

## Statement

> **THEOREM 3.11 (Chowla for almost all shifts — Matomäki–Radziwiłł–Tao "MRTT").** For fixed `k` and `H = H(x) ≤ x` with `H(x) → ∞`,

```
Σ_{h_1,…,h_k ≤ H} | Σ_{n≤x} λ(n+h_1) ⋯ λ(n+h_k) | = o(H^k x) .
```

> In particular the two-point correlation `Σ_{n≤x} λ(n)λ(n+h)` is `o(x)` for **almost every** shift `h ≤ H(x)`, for any `H(x) → ∞`. The same paper gives `∫_0^X |Σ_{x≤n≤x+H} λ(n) e(αn)| dx = o(HX)` uniformly in `α`.

The file's status line: *Status:* THEOREM. *Source:* [K. Matomäki, M. Radziwiłł, T. Tao, *An averaged form of Chowla's conjecture*, arXiv:1503.05121, Algebra Number Theory **9** (2015) 2167–2196](https://arxiv.org/abs/1503.05121) (abstract verified verbatim). *This is the "MRTT almost-all-shifts result".* It says **nothing** about the single shift `h = 2`: an average over `H` shifts can vanish while every individual shift contributes a non-vanishing amount, and the statement is *about the average*.

## Hypotheses and notation

- `k` is fixed; `H = H(x) ≤ x` with `H(x) → ∞`.
- The outer sum is over `h_1, …, h_k ≤ H`; `e(αn) = e^{2πiαn}`.
- `λ` is the Liouville function (Definition 1.2); `o(·)` is as `x → ∞` (respectively `X → ∞` for the integral).
- "Almost every shift" means outside a subset of `{h ≤ H(x)}` of density `o(1)`.

## Proof / evidence

- The source gives no proof; it cites Matomäki–Radziwiłł–Tao, arXiv:1503.05121, and records (Appendix A row MRT1) that the citation is **verified** (arXiv API: title, authors, dates, abstract verbatim, journal ref).

## Dependencies and related results

- Restated as §4.1 row **T4**; contrasted with the almost-all-**scales** statement [THEOREM 3.12](tpp-dict-03-almost-all-scales.md).
- [`THEOREM 4.6`](tpp-dict-03-almost-all-insufficient.md) states that this averaged statement does not yield `S(x) = o(x)` at the single shift `h = 2`; OPEN 3.4 remains open.
- Restated in the §7 ledger row "3.11".

## Notes

- The source explicitly warns that this is an average over shifts and "says **nothing** about the single shift `h = 2`"; that scope warning is preserved.
- The second displayed statement (the uniform `L¹` bound for exponential sums over short intervals) is part of the same cited paper and is reproduced as the source gives it.

- **Primary-source correction (2025-10-06, session 003 citation audit).** The paper's two displays here carry explicit error terms — roughly `log log H / log H` for the averaged Chowla theorem and `log^{−1/3000} X` for the modulated short-interval bound (the paper advertises quantitative decay in its abstract; Theorem 1.3's modulation bound is `log^{−1/700} X`) — and this document quotes both statements with `o(·)` only. Nothing stated here is wrong; the quantitative content is simply absent. Recorded rather than rewritten, because the qualitative form is what the archive's argument uses. The scope warning that follows (the result is about the *average* over shifts and says nothing about a single shift) is correct and load-bearing.
