# (1) Complexity law: every non-zero length-L factor is determined by (i, x, k); p(L) = #{distinct (i,x,k)} + [1 if some gap ≥ L]

**Kind:** Theorem
**Status:** PROVED (paper argument, exact characterisation; verified numerically)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(1) "COMPLEXITY LAW — SETTLED STRUCTURALLY", lines 34–37

## Statement

> Exact: every non-zero length-L factor is determined by (i,x,k) = (index of the first 1 in the
> factor, its offset, number of further 1s whose cumulative gap <= L-x). p(L) = #{distinct
> (i,x,k)} + [1 if some gap >= L]. Verified: 1/pi p(1..13) = 2..12,14,16 (matches the mediator's
> 12,14,16); log2 = 2,3,4,5,7,8,...,15; sqrt2-1 = ...,13,15,16; e-2 = 2,3,4,6,7,...

## Hypotheses and notation

- p(L) is the block complexity (number of distinct length-L factors) of the greedy digit word.
- (i, x, k): i is the index of the first 1 in the factor, x its offset, k the number of further 1s whose cumulative gap is ≤ L − x.
- The formula adds 1 when some gap of the support is ≥ L; the verified row for 1/π is p(1..13) = 2, …, 12, 14, 16.

## Proof / evidence

The source states the characterisation as "Exact" — every non-zero length-L factor is determined by
the triple (i, x, k) — and gives the counting formula. It reports numerical verification: for 1/π,
p(1..13) = 2..12, 14, 16, matching the mediator's 12, 14, 16; for log 2 the sequence 2, 3, 4, 5, 7, 8, …, 15;
for √2−1 the tail …, 13, 15, 16; for e−2 the beginning 2, 3, 4, 6, 7, … . No proof is written out in the document.

## Dependencies and related results

- [round7-agentb-block-complexity-census](../round7/round7-agentb-block-complexity-census.md) — the round-7 corrected census of the same complexity.
- [round7-agentb-p-l-saturates-by-gaps](../round7/round7-agentb-p-l-saturates-by-gaps.md) — the earlier sparsity bound p(L) ≤ (#distinct gap patterns) + 1.
- [round10-agentb-pair-count-law-refuted](round10-agentb-pair-count-law-refuted.md) — the refutation of the pairwise-distance formula.

## Notes

- The source's leading word is "Exact"; the status records it as a paper-argument characterisation
  with the numerical verification listed.
- The sequences are quoted with the source's ellipses (…), which are part of the statement as given.
