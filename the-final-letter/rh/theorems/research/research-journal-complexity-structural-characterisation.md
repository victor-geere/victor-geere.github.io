# B's structural characterisation of the factor complexity

**Kind:** Proposition
**Status:** PROVED (paper argument; verified against the measured words)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 10 Correction 2, line 709; "The corrected results about the digit word itself", line 627

## Statement

> **So the complexity law is neither A's, nor mine: B's structural characterisation is the correct one** — a non-zero length-L factor is determined by the triple (index of the first 1, its offset, the number of further 1s whose cumulative gap fits), p(L) = #{distinct such triples} + [1 if some gap ≥ L] — and it has **no closed form in L alone**; it is closed in the gap sequence.

The measured consequence for 1/π:

> The measured complexity for 1/π is **p(L) = L + 1 for L ≤ 11; p(L) = 2L − 10 for 12 ≤ L ≤ 593; p(L) = 3L − 603 for 594 ≤ L ≤ 604; and p(L) = 609 for L ≥ 605, saturating** because the word has only three 1s and there are only 609 distinct factors in total. The slope is **1 + #{gaps < L}**, taking the values 1, 2, 3 — not 1 then 2 forever.

## Hypotheses and notation

- The word is the finitely supported greedy digit word of a target (1/π has 1s at positions 2, 13, 607; total distinct factors 609).
- A length-L factor is identified by the triple (index of the first 1, its offset, the number of further 1s whose cumulative gap fits); the extra indicator [1 if some gap ≥ L] counts the all-zero factor available when L exceeds a gap.
- "Closed in the gap sequence" means the law is a function of the gaps g_k, not of L alone.

## Proof / evidence

Stated as Agent B's structural characterisation, adopted by the mediator in Correction 2 ("B's structural characterisation is the correct one"). It is checked against the measured complexity of 1/π: p(L) = L + 1 for L ≤ 11, p(L) = 2L − 10 for 12 ≤ L ≤ 593, p(L) = 3L − 603 for 594 ≤ L ≤ 604, p(L) = 609 for L ≥ 605, with p(15) = 19, p(20) = 24, p(100) = 104, p(300) = 304, p(605) = 609.

## Dependencies and related results

- [The complexity pair formula p(L) = L + 1 + Σ_{i<j} max(0, L − a_j + a_i)](research-journal-complexity-pair-formula.md) — the leading term that this characterisation supersedes in general.
- [Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian](research-journal-morse-hedlund.md) — the framework: saturation instead of linear growth means non-Sturmian.
- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the digit-count law of the same word.

## Notes

- The source records that the saturation table "was first written wrongly, then wrongly 'corrected', and only settled by re-running the enumeration at three values of N", with the lesson: "**every complexity number must be quoted with its truncation length N**, because p(L) falls toward 1 as L approaches N."
- The journal's final refinement: "it saturates on the plateau `span < L ≲ N/2` and decays thereafter"; the measured reality is p(800) = 601 at N = 1400 but 609 at N = 1600 and N = 2000.
