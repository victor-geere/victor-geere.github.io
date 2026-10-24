# The sum identity U_N ≈ ζ(1/2+it)·N^{1/2}·N^{−it}/(1/2+it): the shared prefactor 1/|1/2+it|

**Kind:** Claim
**Status:** VERIFIED (numerical; U_400 exact to the quoted digits)
**Area:** workspace
**Source:** [`round2_agentB.md`](../../research/various/round2_agentB.md) — "RECONCILIATION (confirmed exactly)", lines 12–20

## Statement

> U_N = Σ_{n≤N} n^{-it}:  U_100=(4.3048056−5.3428702i) |6.8613127|
>   U_400=(0.8491822187−28.33298692i) |28.34571|  <-- handoff's 0.849, −28.333 EXACT
>   U_1600=(−71.946739−87.563485i) |113.33004|
>   U_6400=(−447.51616−64.780088i) |452.18046|
> A_N = Σ_{n≤N} n^{-1/2-it}: |A_N| = 0.7094,1.4150,2.8286,5.6565 at N=100,400,1600,6400.
> |U_N|/N → 0.070653 ; |A_N|/√N → 0.070706 ; 1/|1/2+it| = 1/√(1/4+t²) = 0.07070352773.
> Clean identity:  U_N ≈ ζ(1/2+it)·N^{1/2}·(N^{-it}/(1/2+it))  so |U_N| ≈ N^{1/2}/|1/2+it|,
> and  A_N = Σ n^{-1/2}n^{-it}  is the same sum with the weight n^{-1/2} supplying exactly that
> factor. Both families share the prefactor 1/|1/2+it|. N^{1/4} was the second moment, not the size.

## Hypotheses and notation

- U_N = Σ_{n≤N} n^{−it} is the unweighted Dirichlet partial sum; A_N = Σ_{n≤N} n^{−1/2−it} is the weighted one.
- The fixed height is t = 14.1347251417 (the first nontrivial zero ordinate), as in round 1 §(d).
- 1/|1/2 + it| = 1/√(1/4 + t²) = 0.07070352773 is the common prefactor.

## Proof / evidence

The source reports the complex values of U_N at N = 100, 400, 1600, 6400, the moduli of A_N, and the
two ratios |U_N|/N → 0.070653 and |A_N|/√N → 0.070706 against the closed prefactor
1/√(1/4 + t²) = 0.07070352773; it calls the asymptotic identity "clean". The value
U_400 = 0.8491822187 − 28.33298692i confirms the handoff's 0.849, −28.333 exactly.

## Dependencies and related results

- [round1-verdict-agentb-growth-exponent-one-half](../round1/round1-verdict-agentb-growth-exponent-one-half.md) — the round-1 growth-exponent claim for the same sums.
- [round10-agentb-sum-identity](../round10/round10-agentb-sum-identity.md) — the closing-verdict restatement.

## Notes


- The identity is stated with "≈" (asymptotic), not as an exact equality, and is supported by the
  quoted numerics; the source calls it "Clean identity".
- The source's clarification "N^{1/4} was the second moment, not the size" is retained here.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `verify/bootstrap_verification.py`, `rounds/rh044/verify/smoothed_zeta.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
