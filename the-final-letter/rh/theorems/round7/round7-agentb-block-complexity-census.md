# Corrected block-complexity census p(L) for 1/π, √2−1, log 2, e−2

**Kind:** Claim
**Status:** VERIFIED (numerical, corrected computation)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(3) "BLOCK COMPLEXITY — ANOMALY REAL, MECHANISM IS SPARSITY NOT STURMIAN", lines 27–31

## Statement

> Corrected computation (my first run was buggy: it sampled blocks only at 1-positions):
>   1/pi    p(L),L=1..12 = 2,3,4,5,6,7,8,9,10,11,12,14   (L+1 until L=11, breaks at 12)
>   sqrt2-1              = 2,3,4,5,6,7,8,9,10,11,13,15
>   log2                 = 2,3,4,5,7,8,9,10,11,12,13,14  (breaks at L=5)  <- mediator's value
>   e-2                  = 2,3,4,6,7,8,9,10,11,12,13,14  (breaks at L=4)

## Hypotheses and notation

- p(L) is the block complexity of the greedy digit word (the number of distinct length-L blocks), in the mediator's convention.
- The words are those of the targets 1/π, √2−1, log 2 and e−2; the lists give p(L) for L = 1, …, 12.
- "breaks at L" marks the first L at which p(L) exceeds L + 1 (for log 2, L = 5; for e−2, L = 4).

## Proof / evidence

The source reports a corrected computation, noting that its first run was buggy because "it sampled
blocks only at 1-positions". It confirms the log 2 anomaly by reproducing p(5) = 7 and identifies the
value as the mediator's. The four sequences are quoted exactly.

## Dependencies and related results

- [round7-agentb-p-l-saturates-by-gaps](round7-agentb-p-l-saturates-by-gaps.md) — the explanation of the sequences by sparsity of the support.
- [round10-agentb-complexity-law-factor-classes](../round10/round10-agentb-complexity-law-factor-classes.md) — the later exact factor characterisation of p(L).

## Notes


- The source flags its own earlier run as buggy; the values here are the corrected ones.
- The comment "(L+1 until L=11, breaks at 12)" applies to the 1/π row.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `verify/round7_squaring_verify.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
