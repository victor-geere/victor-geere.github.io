# Refuted: K(n,m) = ∫₀^π P_n P_m = 2/(2n+1) δ_nm, so K is diagonal

**Kind:** Claim
**Status:** REFUTED (retracted by the same author in round 2)
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(c) "STRUCTURAL KILL", lines 22–23

## Statement

> K(n,m)=int_0^pi P_n P_m = 2/(2n+1) delta_nm  => K DIAGONAL.
>
> M = D K D with D=diag((n+2)^{-(s+1/2)}); M is diagonal with M_nn=(2/(2n+1))(n+2)^{-1}.

## Hypotheses and notation

- P_n are the source's digit functions; D = diag((n+2)^{−(s+1/2)}) is the diagonal weight; K is the quadratic-form matrix.
- δ_nm is the Kronecker delta; s is the complex variable of the zeta side.

## Proof / evidence

The source asserts the orthogonality relation as the "STRUCTURAL KILL" of the eigenvalue-drop claim.
It is refuted by the same author in round 2:

> I wrote "∫₀^π P_n(cosθ)P_m(cosθ)dθ = 2/(2n+1)δ_nm, so K is diagonal." The P_n are greedy
> digit functions δ_n(θ), NOT Legendre polynomials. The mediator's quadrature K
> (max off-diag 0.8631) is correct.

## Dependencies and related results

- [round1-verdict-agentb-m-t-equals-m-zero](round1-verdict-agentb-m-t-equals-m-zero.md) — the conclusion the source drew from this step, which survives in round 2 by the similarity argument.
- [round2-agentb-m-t-equals-m-zero](../round2/round2-agentb-m-t-equals-m-zero.md) — the corrected re-derivation.

## Notes

- Status REFUTED: the orthogonality identity and the resulting diagonality of M are withdrawn in
  round 2. The numerical witness against it is the mediator's quadrature with max off-diagonal 0.8631.
- The source's own round-2 moral: "my conclusion happens to survive … Retracted claim was structurally
  impossible, not merely unsupported" — but the diagonal step itself is false and must not be reused.
