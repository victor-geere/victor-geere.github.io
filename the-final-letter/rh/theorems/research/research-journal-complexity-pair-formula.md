# The complexity pair formula p(L) = L + 1 + Σ_{i<j} max(0, L − a_j + a_i)

**Kind:** Proposition
**Status:** VERIFIED (numerical; exact for small L, over-counts beyond — general law OPEN)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 9 addendum, lines 589–602; "The corrected results about the digit word itself", line 627

## Statement

> I derived the missing law and then found its limit. For a finitely supported binary word with 1s at positions a_0 < a_1 < … < a_m, the distinct length-L factors are determined by the *offsets* of the subset of 1s each window contains, so a pair at distance d contributes **L − d** distinct factors once L ≥ d (the pair can sit at L − d relative offsets), not 1. The resulting formula is
>
>   **p(L) = L + 1 + Σ_{i<j} max(0, L − a_j + a_i).**
>
> Verified exactly against brute force on the true words:

| word | formula p(1..12) | measured p(1..12) |
|---|---|---|
| 1/π (2, 13, 607) | 2,3,4,5,6,7,8,9,10,11,**12,14** | identical |
| and p(11), p(12), p(13) = **12, 14, 16** | | **12, 14, 16** (A predicted 13, 14, 14) |

> **But the formula is not exact for all L.** It over-counts once a window can contain **three or more** 1s, because then different pairs contribute the same factor: for 1/π it first fails at L = 15 (true 19, formula 20) and diverges thereafter (L = 20: true 24, formula 30); for log 2 it fails at L = 6 (true 8, formula 9); for e−2 at L = 5 (true 6, formula 8); for √2−1 at L = 12. The correct general statement is an **inclusion–exclusion over runs of 1s**, not over pairs: p(L) = L + 1 + (contributions of maximal runs whose span fits, with overlaps subtracted). **So the complexity law is exact for small L, has a derived and confirmed leading term, and remains OPEN in general.**

## Hypotheses and notation

- A binary word with 1s at positions a_0 < a_1 < … < a_m (for 1/π: 2, 13, 607; for the other targets the words of the census table).
- p(L) is the number of distinct length-L factors (subwords) of the word; a "window" is a length-L block, and each window is classified by the set of offsets of the 1s it contains.
- A pair at distance d = a_j − a_i contributes max(0, L − d).

## Proof / evidence

The formula was verified exactly against brute force on the true words for L = 1..12 (1/π: 2,3,4,5,6,7,8,9,10,11,12,14), and p(11), p(12), p(13) = 12, 14, 16, matching measurement and refuting Agent A's complexity falsifier prediction 13, 14, 14. The first failure is located for each word (L = 15 for 1/π; L = 6 for log 2; L = 5 for e−2; L = 12 for √2−1).

## Dependencies and related results

- [B's structural characterisation of the factor complexity](research-journal-complexity-structural-characterisation.md) — the correct general characterisation that replaces the pair formula.
- [Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian](research-journal-morse-hedlund.md) — the framework in which "saturating rather than linear" is meaningful.
- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the digit-count law of the same words.

## Notes

- The source's honest status: "exact for small L, has a derived and confirmed leading term, and remains **OPEN** in general." This file is harvested with status VERIFIED (numerical) because the exact-for-small-L part is proved and measured; the general law is flagged OPEN in the statement and here.
- Round 10 Correction 2 additionally refutes Agent A's piecewise law p(L) = 2L − 10 for 11 ≤ L ≤ 594: measured p(15) = 19 (A: 20), p(20) = 24 (A: 30), p(100) = 104 (A: 190), p(300) = 304 (A: 590), p(605) = 609 saturated (A: 1200), p(700) = 609 saturated (A: 1390). The mediator's own adjacency formula is also stated to be wrong.
