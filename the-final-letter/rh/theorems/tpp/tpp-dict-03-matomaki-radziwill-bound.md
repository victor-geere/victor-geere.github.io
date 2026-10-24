# THEOREM 3.6 (a non-trivial unconditional bound; the best elementary shape known to the programme)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.3

## Statement

> **THEOREM 3.6 (a non-trivial unconditional bound; the best elementary shape known to the programme).** There is an absolute `δ > 0` with

```
Σ_{n≤x} λ(n) λ(n+1) ≪ (1 − δ) x .
```

The file's status line: *Status:* THEOREM. *Source:* [Matomäki–Radziwiłł, *Multiplicative functions in short intervals*, arXiv:1501.04585](https://arxiv.org/abs/1501.04585), abstract, third consequence: *"we show that the mean-value of `λ(n)λ(n+1)` … is non-trivially bounded in absolute value by `1 − δ` for some `δ > 0`. This settles an old folklore conjecture and constitutes progress towards Chowla's conjecture."* (Quantitative improvements over 3.6 exist in the literature; this file cites only the form it verified.) Note that 3.6 is *far* from `o(x)`: it gives no decay.

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2).
- `δ > 0` is absolute; `(1 − δ)` bounds the mean value of `λ(n)λ(n+1)` in absolute value.
- `≪` is Vinogradov notation.
- Note the shift: this theorem is about `h = 1`, not the target shift `h = 2`.

## Proof / evidence

- The source gives no proof; the statement is quoted from the abstract of Matomäki–Radziwiłł, arXiv:1501.04585 (Appendix A row MR1 marks the arXiv citation **verified**; "Annals volume/pages not independently confirmed").
- The source notes that quantitative improvements over 3.6 exist in the literature and that it "cites only the form it verified".

## Dependencies and related results

- §4.1 row **T5** restates this bound together with the additional short-interval statement for `μ`: see [row T5](tpp-dict-03-t5-matomaki-radziwill.md).
- The method (short intervals) underlies [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md).
- Contrasted with [`OPEN 4.3`](tpp-dict-03-open-intermediate-decay.md): no `O(x/(log x)^A)` bound is known.
- Restated in the §7 ledger row "3.6".

## Notes

- The source emphasises that this bound gives **no decay**: it is far from the `o(x)` of OPEN 3.4.
- The bound is stated for the shift `h = 1`; the source does not extend it to `h = 2`.
