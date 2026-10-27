# T8 — Polymath8b: bounded gaps and the parity ceiling

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.1, row T8 of the "What is proved" table

## Statement

> **T8** — `H_1 = liminf(p_{n+1}−p_n) ≤ 246`; `≤ 6` under the generalised Elliott–Halberstam conjecture; "at least two of three" is optimal for purely sieve-theoretic considerations.

The row's status and citation: THEOREM | [D. H. J. Polymath, arXiv:1407.4897](https://arxiv.org/abs/1407.4897), Res. Math. Sci. **1**:12 (2014) | **verified** (arXiv API: title, journal ref, full abstract).

## Hypotheses and notation

- `p_n` is the `n`-th prime; `H_1 = liminf_n (p_{n+1} − p_n)` is the least limit-inferior gap.
- GEH = the generalised Elliott–Halberstam conjecture (the source writes "generalised Elliott–Halberstam conjecture" in 2.1 and "Elliott–Halberstam" in the other rows).
- "At least two of three" refers to the admissible triple statement in [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) part (d).

## Proof / evidence

- No proof is given; the row cites Polymath8b, arXiv:1407.4897, with the abstract verified in full (Appendix A row P8b: "including `H_1 ≤ 246`, `≤ 6` under GEH, and the parity-optimality sentence").
- The parity-optimality clause is the published instance recorded in [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) part (d).

## Dependencies and related results

- [THEOREM 2.1](tpp-dict-03-selberg-parity-principle.md) (parts (a)–(d)); [THEOREM 5.2](tpp-dict-03-no-bounded-depth-sieve-lower-bound.md) (which cites T8 as the sharpest published form of the exclusion).
- Companion frontier rows: [T9 (Maynard)](tpp-dict-03-t9-maynard.md), [T10 (GPY)](tpp-dict-03-t10-gpy.md), [T11 (Zhang)](tpp-dict-03-t11-zhang.md).
- Also listed in the §5.3 landscape table (year 2014); the §7 ledger row carrying the optimality clause is "2.1".

## Notes

- "At least two of three" is a **ceiling** result for purely sieve-theoretic reasoning, not a lower bound for twin primes; the source's §5.3 table records it as "and the ceiling".
- The row restates the optimality clause already carried by THEOREM 2.1(d); the file records it as a ledger row rather than a new theorem.

- **Primary-source correction (2025-10-06, session 003 citation audit).** The abstract sentence quoted here is **v1** wording: v2–v4 reword it to "the `H_1 ≤ 6` bound is the best possible". The mathematics is unchanged; the quotation is version-specific and the archive does not name a version. The paper's own optimality argument is unnumbered and is described by the authors as "somewhat informal and heuristic".
