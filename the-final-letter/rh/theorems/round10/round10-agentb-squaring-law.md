# (A)5 Squaring law: r′ = (1−f)r²/(1+(1−f)r), c = r′/r² → 1−f, hence A(N) = log₂ log N + O(1)

**Kind:** Theorem
**Status:** VERIFIED (numerical; exact identity, 6-digit step check)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 5, lines 14–15

## Statement

> 5. Squaring law: with m=ceil(1/r), f=1/r-m+1, r' = (1-f)r^2/(1+(1-f)r), c=r'/r^2 -> 1-f.
>    Hence A(N) = log_2 log N + O(1) with a target-dependent O(1).

## Hypotheses and notation

- m = ⌈1/r⌉, f = 1/r − m + 1 ∈ [0, 1), r′ = r − 1/m; c := r′/r².
- A(N) = #{n ≤ N : δ_n = 1}; the O(1) term is stated to be target-dependent.

## Proof / evidence

The source states the squaring law and the resulting growth law A(N) = log₂ log N + O(1) with a
target-dependent O(1). The 6-digit numerical verification and the index lists are recorded in
round 7 §(1) (see the linked files).

## Dependencies and related results

- [round7-agentb-squaring-law-residual](../round7/round7-agentb-squaring-law-residual.md) — the round-7 statement with the verification and the measured c values.
- [round7-agentb-an-log-log-n-growth](../round7/round7-agentb-an-log-log-n-growth.md) — the round-7 derivation and verified index lists.
- [round10-agentb-an-log-log-with-correction](round10-agentb-an-log-log-with-correction.md) — the sharpened form with the explicit Σ log c_k term.
- [handoff-greedy-squaring-law](../handoff/handoff-greedy-squaring-law.md) — the harvest of the same law from HANDOFF.md §2.

## Notes


- This is a closing-verdict restatement of round 7 §(1); it adds the qualification that the O(1) is
  target-dependent.
- No new numerical certificate is given in this item; the figures live in the round-7 files.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `verify/round7_squaring_verify.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
