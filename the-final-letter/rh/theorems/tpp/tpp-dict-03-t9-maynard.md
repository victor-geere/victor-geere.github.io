# T9 — Maynard: bounded gaps in every order and the `k`-tuples proportion

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.1, row T9 of the "What is proved" table

## Statement

> **T9** — `liminf_n (p_{n+m}−p_n) < ∞` for every `m`; `H_1 ≤ 600`; `≤ 12` under Elliott–Halberstam; prime `k`-tuples conjecture for a positive proportion of admissible `k`-tuples.

The row's status and citation: THEOREM | [J. Maynard, arXiv:1311.4600](https://arxiv.org/abs/1311.4600), Ann. of Math. (2015) | **verified** (arXiv abs: title, author, v1 19 Nov 2013, abstract); *journal volume/pages not independently confirmed*.

## Hypotheses and notation

- `p_n` is the `n`-th prime; `H_1 = liminf_n (p_{n+1} − p_n)`.
- `m ≥ 1` is any fixed order: `liminf_n (p_{n+m} − p_n) < ∞` means `m+1` primes in a bounded interval infinitely often.
- "Elliott–Halberstam" is the Elliott–Halberstam conjecture (the source writes `H_1 ≤ 12` under EH).
- "Prime `k`-tuples conjecture for a positive proportion of admissible `k`-tuples": Maynard's theorem that a positive proportion of admissible `k`-tuples satisfy the prime `k`-tuples conjecture.

## Proof / evidence

- No proof is given; the row cites Maynard, arXiv:1311.4600, marked **verified (arXiv)** in Appendix A (row May: title, author, dates, abstract `H_1 ≤ 600`, `≤ 12` under EH, `H_m < ∞`; "Annals volume/pages not independently confirmed").
- Appendix A gives the journal reference as Ann. of Math. **181** (2015) 383–413, "not independently confirmed".

## Dependencies and related results

- Companion frontier rows: [T8 (Polymath8b)](tpp-dict-03-t8-polymath8b-bounded-gaps.md), [T10 (GPY)](tpp-dict-03-t10-gpy.md), [T11 (Zhang)](tpp-dict-03-t11-zhang.md).
- Listed in the §5.3 landscape table (year 2014: "detects 'at least one prime among many forms', never a specified pair").
- The parity ceiling that limits this technology is [THEOREM 2.1](tpp-dict-03-selberg-parity-principle.md) / [THEOREM 5.2](tpp-dict-03-no-bounded-depth-sieve-lower-bound.md).

## Notes

- The source lists `H_1 ≤ 600` for this row; the separate later value `H_1 ≤ 246` is row [T8](tpp-dict-03-t8-polymath8b-bounded-gaps.md).
- The `liminf_n (p_{n+m}−p_n) < ∞` statement is for **every** `m`, not for twin primes specifically.
