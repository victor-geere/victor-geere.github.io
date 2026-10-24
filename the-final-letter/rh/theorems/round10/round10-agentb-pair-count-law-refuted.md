# Refuted: p(L) = L + 1 + #pairs, and no formula in {L, #pairs, #distances} can work

**Kind:** Claim
**Status:** REFUTED (numerical: 1/π L = 11 predicts 13 vs 12; L = 13 predicts 15 vs 16; √2−1 L = 12 predicts 14 vs 15)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(1) "COMPLEXITY LAW — SETTLED STRUCTURALLY", lines 38–43

## Statement

> A's L+1+#pairs fails: 1/pi L=11 gives 13 vs 12, L=13 gives 15 vs 16; sqrt2-1 L=12 gives 14 vs 15.
> The failure is structural: one long gap (594, 605 for 1/pi) is shared by several pairs, so pair
> counts overcount, and near L equal to a gap length the (i,x,k) classes split differently.
> Conclusion: p(L) IS determined by the gap sequence, but NOT by pairwise distances alone; no
> formula in {L, #pairs, #distances} can work. The law is closed in the gap sequence and open only
> if one insists on a closed form in L.

## Hypotheses and notation

- The refuted formula is p(L) = L + 1 + #pairs (pairs of 1s at distance ≤ L); #distances is the variant counting distinct distances.
- The witnesses: 1/π at L = 11 (predicts 13, truth 12) and L = 13 (predicts 15, truth 16); √2−1 at L = 12 (predicts 14, truth 15).
- The long gaps of the 1/π support are quoted as 594 and 605.

## Proof / evidence

The source refutes the pair-count formula by the listed counterexamples and explains the failure
structurally: one long gap (594, 605 for 1/π) is shared by several pairs, so pair counts overcount,
and near L equal to a gap length the (i, x, k) classes split differently. It concludes that p(L) is
determined by the gap sequence but not by pairwise distances alone, so no formula in
{L, #pairs, #distances} can work; the law is closed in the gap sequence and "open only if one insists
on a closed form in L".

## Dependencies and related results

- [round10-agentb-complexity-law-factor-classes](round10-agentb-complexity-law-factor-classes.md) — the exact (i, x, k) characterisation that is the ground truth for the counterexamples.
- [handoff-pair-count-law-refuted](../handoff/handoff-pair-count-law-refuted.md) — the same formula refuted from HANDOFF.md §5.

## Notes

- Status REFUTED records the source's verdict ("A's L+1+#pairs fails") and the exact enumeration
  witnesses.
- The closing clause "open only if one insists on a closed form in L" is a scope remark by the source,
  not an open problem in the technical sense; the characterisation itself is claimed closed.
