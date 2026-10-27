# (A)3 Sum identity: U_N = Σ_{n≤N} n^{−it} ~ (N^{1−it}−1)/(1−it), |U_N| ~ N^{1/2}/|1/2+it|

**Kind:** Claim
**Status:** VERIFIED (numerical; U_400 checked exactly to the quoted digits)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 3, lines 9–10

## Statement

> 3. Sum identity: U_N = sum_{n<=N} n^{-it} ~ (N^{1-it}-1)/(1-it); |U_N| ~ N^{1/2}/|1/2+it|.
>    Verified exactly: U_400 = 0.8491822187 - 28.33298692i.

## Hypotheses and notation

- U_N = Σ_{n≤N} n^{−it}; the asymptotic is at t = 14.1347251417 (the first nontrivial zero ordinate).
- The modulus form |U_N| ~ N^{1/2}/|1/2 + it| uses 1/|1/2 + it| = 1/√(1/4 + t²).

## Proof / evidence

The source states the asymptotic and reports the exact check U_400 = 0.8491822187 − 28.33298692i.
No proof is given in the document.

## Dependencies and related results

- [round2-agentb-sum-identity-prefactor](../round2/round2-agentb-sum-identity-prefactor.md) — the round-2 reconciliation, with the U_N and A_N tables and the ratio 0.070653/0.070706.
- [round1-verdict-agentb-growth-exponent-one-half](../round1/round1-verdict-agentb-growth-exponent-one-half.md) — the round-1 growth-exponent claim for the same sums.

## Notes


- Status VERIFIED (numerical): the asymptotic is stated with "~", and the supporting check is the
  quoted complex value at N = 400.
- This is a closing-verdict restatement of round 2's "Clean identity".
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `verify/bootstrap_verification.py`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
