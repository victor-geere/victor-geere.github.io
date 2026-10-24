# (1) SQUARING LAW: r′ = (1−f)r²/(1+(1−f)r) exactly, c := r′/r² → 1−f

**Kind:** Theorem
**Status:** VERIFIED (numerical, 6 digits at every step; the source states the identity as exact)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(1) "SQUARING LAW — EXACT, c IDENTIFIED", lines 3–9

## Statement

> With m=ceil(1/r), n=m-2 (the mediator's convention), f=1/r-m+1 in [0,1), the residual
> update r'=r-1/m satisfies EXACTLY
>     r' = (1-f) r^2 / (1 + (1-f) r),      c := r'/r^2 = (1-f)/(1+(1-f)r)  ->  1-f  (r->0).
> Verified to 6 digits against direct computation for 1/pi and log2 at every step.
> Hence r_{k+1} = c_k r_k^2 with c_k in (1-r_k, 1] = 1-f_k, NOT a constant (not 1, not 1/2):
> measured c = 0.674,0.352,0.438,0.707 (1/pi) and 0.402,0.710,0.235,0.255 (log2), all predicted.

## Hypotheses and notation

- The greedy step selects m = ⌈1/r⌉ and replaces r by r′ = r − 1/m; n = m − 2 is the mediator's index convention; f = 1/r − m + 1 ∈ [0, 1) is the fractional part (1/r − ⌊1/r⌋).
- c := r′/r² is the ratio (the "squaring constant"); c_k is its value at step k, and r_k the residual.
- Targets checked: 1/π and log 2.

## Proof / evidence

The source states the identity as an exact algebraic rearrangement of r′ = r − 1/⌈1/r⌉ and reports
verification to 6 digits against direct computation for 1/π and log 2 at every step. The range
c_k ∈ (1 − r_k, 1] = 1 − f_k and the fact that c is not constant are stated as consequences, with
the measured values 0.674, 0.352, 0.438, 0.707 (1/π) and 0.402, 0.710, 0.235, 0.255 (log 2), "all predicted".

## Dependencies and related results

- [handoff-greedy-squaring-law](../handoff/handoff-greedy-squaring-law.md) — the same law harvested from HANDOFF.md §2 (with the equivalent form n_{k+1} = ⌈1/r_k⌉ − 2).
- [round7-agentb-an-log-log-n-growth](round7-agentb-an-log-log-n-growth.md) — the growth law derived from it.
- [round10-agentb-squaring-law](../round10/round10-agentb-squaring-law.md) — the closing-verdict restatement.

## Notes


- The source writes "EXACTLY" for the identity and "Verified to 6 digits" for the check; the status
  records both without upgrading the numerical check to a proof.
- The measured constants are quoted with three decimals exactly as in the source.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `verify/round7_squaring_verify.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
