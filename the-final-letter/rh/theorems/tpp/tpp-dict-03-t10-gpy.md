# T10 — Goldston–Pintz–Yıldırım: small gaps relative to the average

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.1, row T10 of the "What is proved" table

## Statement

> **T10** — `liminf (p_{n+1}−p_n)/log p_n = 0`; `H_1 ≤ 16` under Elliott–Halberstam.

The row's status and citation: THEOREM | [Goldston–Pintz–Yıldırım, arXiv:math/0508185](https://arxiv.org/abs/math/0508185), *Primes in Tuples I* | **verified** (arXiv abs: title, authors, 10 Aug 2005, abstract); *journal volume/pages not independently confirmed*.

## Hypotheses and notation

- `p_n` is the `n`-th prime; `log` is the natural logarithm.
- `liminf (p_{n+1}−p_n)/log p_n = 0` says the gap is infinitely often small relative to the average gap `log p_n` (not a bounded gap).
- `H_1 = liminf_n (p_{n+1} − p_n)`; "under Elliott–Halberstam" is the conditional clause.
- Appendix A row GPY gives the journal reference as Ann. of Math. **170** (2009) 819–862, "Annals volume/pages not independently confirmed".

## Proof / evidence

- No proof is given; the row cites Goldston–Pintz–Yıldırım, arXiv:math/0508185, marked **verified (arXiv)** in Appendix A.

## Dependencies and related results

- Listed first in the §5.3 landscape table (year 2005: GPY), whose "how it is limited by parity" column reads: "produces *a* bounded gap, not two specified primes in a fixed tuple".
- Companion frontier rows: [T9 (Maynard)](tpp-dict-03-t9-maynard.md), [T11 (Zhang)](tpp-dict-03-t11-zhang.md), [T8 (Polymath8b)](tpp-dict-03-t8-polymath8b-bounded-gaps.md).
- The parity ceiling that limits this technology is [THEOREM 2.1](tpp-dict-03-selberg-parity-principle.md) / [THEOREM 5.2](tpp-dict-03-no-bounded-depth-sieve-lower-bound.md).

## Notes

- The unconditional clause is relative-to-average (`/log p_n`), not a bounded gap; the bounded gap `H_1 ≤ 16` is **conditional** on Elliott–Halberstam in this row. The source distinguishes them in the §5.3 table by writing "`H_1 ≤ 16` under EH".
