# The block-complexity mechanism is sparsity, not Sturmian: p(L) ≤ (#distinct gap patterns) + 1

**Kind:** Proposition
**Status:** PROVED (paper argument, structural; supported by the census)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(3) "BLOCK COMPLEXITY — ANOMALY REAL, MECHANISM IS SPARSITY NOT STURMIAN", lines 32–38

## Statement

> So the log2 anomaly IS real (I reproduce p(5)=7). But the mechanism is NOT Sturmian structure:
> these words are eventually identically zero with 3-4 ones at positions e.g. 0,4,36,6069.
> The gap structure (36-4=32, 6069-36=6033) admits extra blocks, and once L exceeds the
> largest gap the count saturates (sampled p(L) grows sublinearly, not as L+1). Real Sturmian
> words are never eventually zero; this word is, so p(L) <= (number of distinct gap patterns)+1,
> bounded by the sparse support. (c) YES: eventual constancy of the tail forces p(L) to saturate,
> which is sufficient to explain all the above without any Sturmian framework.

## Hypotheses and notation

- p(L) is the block complexity of the greedy digit word (see the linked census file).
- The word is eventually identically zero with 3–4 ones, at positions such as 0, 4, 36, 6069 for the target under discussion (log 2's list begins 0,4,36,6069,144715219).
- "gap structure": gaps 36 − 4 = 32 and 6069 − 36 = 6033; a "gap pattern" is the multiset/sequence of gaps among the support.

## Proof / evidence

The source argues from the eventual sparsity of the support: once L exceeds the largest gap the
count saturates, so p(L) grows sublinearly ("sampled p(L) grows sublinearly, not as L+1"); it
bounds p(L) ≤ (number of distinct gap patterns) + 1, bounded by the sparse support, and states that
this suffices to explain the observed anomalies without any Sturmian framework, noting that real
Sturmian words are never eventually zero whereas this word is.

## Dependencies and related results

- [round7-agentb-block-complexity-census](round7-agentb-block-complexity-census.md) — the corrected p(L) sequences this explains.
- [round7-agentb-sturmian-word-count](round7-agentb-sturmian-word-count.md) — the Sturmian count law that is ruled out as the mechanism.
- [round10-agentb-complexity-law-factor-classes](../round10/round10-agentb-complexity-law-factor-classes.md) — the later exact characterisation by (i, x, k).

## Notes

- The bound p(L) ≤ (#distinct gap patterns) + 1 is stated, not derived line by line, in the source.
- The source's answer "(c) YES" refers to the question whether eventual constancy of the tail forces
  p(L) to saturate; that framing is retained in the statement.
