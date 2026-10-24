# The growth exponent of |C + iS| is 1/2 exactly; N^{1/4} is refuted

**Kind:** Claim
**Status:** VERIFIED (numerical); the competitor exponent N^{1/4} is REFUTED
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(d) "growth", lines 29–31

## Statement

> t=14.1347251417: |C+iS| at N=100..6400 = 0.7094,1.4150,2.8286,5.6565; /sqrt(N)->0.070706.
>
> exponent = 1/2 exactly; N^{1/4} REFUTED. Integral bound sqrt(N)/sqrt(1/4+t^2)=0.070704.
>
> |C+iS|(N=400)=1.4150 (not 0.849/-28.333); |C+iS|=28.3 unreachable; product 1/sqrt(400!)=1.6e-78539.

## Hypotheses and notation

- C + iS is the complex partial sum at t = 14.1347251417 (the first nontrivial zero ordinate); N runs over 100, 400, 1600, 6400.
- "exponent = 1/2" means |C + iS| grows like N^{1/2}; round 1 reports the ratio |C + iS|/√N → 0.070706. The closed prefactor 1/|1/2 + it| = 1/√(1/4 + t²) = 0.07070352773 is given in round 2's reconciliation (see the linked file).
- The integral bound is √N/√(1/4 + t²) = 0.070704.

## Proof / evidence

The source reports the four moduli, the ratio |C + iS|/√N → 0.070706, and the integral bound value
0.070704 as numerical evidence for exponent exactly 1/2, and records N^{1/4} as REFUTED.
The values 0.849/−28.333 are identified as belonging to the *unweighted* sum at N = 400, not to
|C + iS|, so |C + iS| = 28.3 is "unreachable"; the product 1/√(400!) = 1.6×10⁻⁷⁸⁵³⁹ is quoted as a
companion magnitude.

## Dependencies and related results

- [round2-agentb-sum-identity-prefactor](../round2/round2-agentb-sum-identity-prefactor.md) — the clean identity U_N ≈ ζ(1/2+it)·N^{1/2}·N^{−it}/(1/2+it) explaining the 1/2 exponent.
- [round10-agentb-sum-identity](../round10/round10-agentb-sum-identity.md) — the closing-verdict restatement.

## Notes


- The exponent 1/2 is asserted "exactly" on the basis of the quoted numerics and the matching integral
  bound, not on a written proof in the document.
- The source is correcting an earlier attribution: 0.849, −28.333 is the N = 400 value of the
  unweighted sum, so it does not contradict the 1/2 growth of |C + iS|.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh044/verify/smoothed_zeta.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
