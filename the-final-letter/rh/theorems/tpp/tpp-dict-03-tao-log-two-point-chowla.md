# THEOREM 3.8 (log-averaged two-point Chowla; Tao 2015/2016)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.4

## Statement

> **THEOREM 3.8 (log-averaged two-point Chowla; Tao 2015/2016).** Definition 3.7 holds for `k = 2` and every fixed affine pair with `a_1 b_2 − a_2 b_1 ≠ 0`. In particular

```
(1/log x) Σ_{n≤x} λ(n) λ(n+2)/n = o(1) .
```

The file's status line: *Status:* THEOREM. *Source:* [T. Tao, *The logarithmically averaged Chowla and Elliott conjectures for two-point correlations*, arXiv:1509.05422](https://arxiv.org/abs/1509.05422) (Forum of Mathematics, Pi; abstract: *"we establish the logarithmically averaged version … thus breaking the 'parity barrier' for this problem"*). The method is the **entropy decrement argument**, resting on [Matomäki–Radziwiłł, arXiv:1501.04585](https://arxiv.org/abs/1501.04585) on short intervals. *Note the phrase*: Tao's theorem breaks the parity barrier **for the logarithmically averaged problem**, not for the un-averaged one.

## Hypotheses and notation

- Definition 3.7 (logarithmic correlation): for admissible data and a parameter `ω = ω(x) → ∞` with `ω(x) ≤ x`, the **logarithmically averaged** correlation is

```
Σ_{x/ω < n ≤ x} λ(a_1 n + b_1) ⋯ λ(a_k n + b_k) / n  =  o( log ω )      (x → ∞) ;
```

  the case `ω(x) = x` gives the plain log-average over `[1,x]`.
- `k = 2`; the affine pair has `a_1 b_2 − a_2 b_1 ≠ 0` (the non-degeneracy condition).
- `λ` is the Liouville function (Definition 1.2).

## Proof / evidence

- The source gives no proof. It cites Tao, arXiv:1509.05422, and records (Appendix A row Ta1) that the arXiv page was **verified** — title, author, v1 17 Sep 2015, v4 29 Jul 2016, abstract including the "parity barrier" sentence — while "venue from the arXiv comment field. *Volume/article number not confirmed.*"
- The method is the **entropy decrement argument**, resting on Matomäki–Radziwiłł, arXiv:1501.04585 (short intervals).

## Dependencies and related results

- [THEOREM 3.6](tpp-dict-03-matomaki-radziwill-bound.md) (the short-interval input); [THEOREM 3.9](tpp-dict-03-tao-teravainen-log-all-orders.md) (odd orders, plus `k = 2`); [THEOREM 3.10](tpp-dict-03-log-chowla-iff-log-sarnak.md) (equivalence with log-Sarnak).
- Does **not** imply the un-averaged statement: see [`THEOREM 4.4`](tpp-dict-03-log-averaged-no-implication.md) and HEURISTIC 4.5.
- Restated as §4.1 row **T2**; the format is Definition 3.7; restated in the §7 ledger rows "3.7–3.9" and "T2".
- Cited in the source's own index tags as entry `A4`.

## Notes

- The source stresses the scope: this breaks the parity barrier **only** in the logarithmically averaged sense, "not for the un-averaged one"; OPEN 3.4 / OPEN 4.1 remain untouched.
- The venue is recorded with the source's own hedge (volume/article number not confirmed).
