# 1/2 + 1/3 + 1/6 = 1 is the unique 3-term distinct-unit-fraction decomposition of 1

**Kind:** Theorem
**Status:** PROVED (paper argument, unconditional; verified exhaustively for denominators below 200 000)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 9 §1, line 581; "The corrected results about the digit word itself", line 630; Round 10 table, line 684

## Statement

> **1/2 + 1/3 + 1/6 = 1 is the UNIQUE 3-term distinct-unit-fraction decomposition of 1**, verified exhaustively with exact rationals for denominators below 200 000; the proof is two lines (a = 2 since 1/a ≥ 1/3, then 1/b + 1/c = 1/2 with b > 2 forces b = 3, c = 6). There are **6 four-term solutions** (2,4,5,20), (2,4,6,12), …, so uniqueness is special to three terms. **Consequence: the perfect-number-6 observation carries no arithmetic content** — it is the uniqueness of a Diophantine identity, not a fact about primes.

The Round 10 certification gives B's proof:

> (2,3,6) unique 3-term distinct-unit-fraction decomposition of 1 — B's unconditional proof (a ≤ 3; a = 3 impossible; a = 2 forces b < 4) — **no bound on c needed**, my 200000 enumeration was unnecessary.

## Hypotheses and notation

- Distinct unit fractions 1/a + 1/b + 1/c = 1 with a < b < c positive integers, distinct.
- "Term" counts summands; {(2,3,6)} is the unique unordered triple.
- Four-term solutions exist (6 of them), e.g. (2,4,5,20), (2,4,6,12), so uniqueness is special to three terms.

## Proof / evidence

Two independent supports. (i) Exhaustive exact-rational enumeration for all distinct triples with denominators below 200 000, finding only (2,3,6). (ii) B's unconditional two-line proof: a ≤ 3 since 1/a ≥ 1/3 of the total; a = 3 is impossible (then 1/b + 1/c = 2/3 with b > 3 forces b < 3·(2/3)/2 = ... the source's own summary: "a = 3 impossible; a = 2 forces b < 4"), so a = 2, and then 1/b + 1/c = 1/2 with b > 2 forces b = 3, c = 6. The journal records that the 200 000 enumeration was unnecessary given the proof.

## Dependencies and related results

- [Termination of the greedy Egyptian expansion for rational θ/π](research-journal-rational-termination.md) — the θ = π support {0,1,4}, i.e. denominators {2,3,6}.
- [The greedy map is Engel/Sylvester, not Gauss](research-journal-sylvester-not-gauss.md) — the Sylvester/Engel framework of Egyptian expansions.

## Notes

- The journal attaches a deflation: "**A's perfect-number observation is true but his reason is wrong.** … the non-trivial divisors of *every* perfect number sum to 1 … What is special about 6 is only that its divisors are small … the observation carries no multiplicative content." It also notes that Sylvester's own sequence 2, 3, 7, 43, 1807, … is *not* the greedy Egyptian path for θ/π = 1, which chooses 2, 3, 6.
- The Round 10 table lists this among the certified STANDING results.
