# M(t) = D K D with D = diag((n+2)⁻¹): a diagonal congruence cannot create a spectral event in t

**Kind:** Proposition
**Status:** PROVED (paper argument, diagonal-similarity argument)
**Area:** workspace
**Source:** [`round2_agentB.md`](../../research/various/round2_agentB.md) — "ACKNOWLEDGED ERROR", lines 5–9

## Statement

> The P_n are greedy digit functions δ_n(θ), NOT Legendre polynomials. The mediator's quadrature K
> (max off-diag 0.8631) is correct. My conclusion happens to survive for the reason the
> mediator gives: M(t)=DKD with D=diag((n+2)^{-1}) — |w_n|² REAL and t-free — so M(t)=M(0)
> exactly. Moral: an ansatz whose ONLY t-dependence is a diagonal congruence cannot have a
> spectral event in t. Retracted claim was structurally impossible, not merely unsupported.

## Hypotheses and notation

- M(t) = D K D is the quadratic-form matrix of the construction; D = diag((n+2)⁻¹); K is the mediator's quadrature matrix whose maximum off-diagonal entry is 0.8631.
- w_n are the weights; |w_n|² is real and t-free ("the phase cancels in w²").
- The "t-dependence" of the ansatz is the real parameter t (the height on the critical line).

## Proof / evidence

The source accepts the mediator's quadrature K in place of the retracted orthogonality relation, and
re-derives the conclusion: since the only t-dependence of the ansatz enters through D and |w_n|² is
real and t-free, M(t) = M(0) exactly. From that it states the general moral that an ansatz whose only
t-dependence is a diagonal congruence cannot have a spectral event in t.

## Dependencies and related results

- [round1-verdict-agentb-k-diagonal-refuted](../round1/round1-verdict-agentb-k-diagonal-refuted.md) — the retracted orthogonality claim this file replaces.
- [round1-verdict-agentb-m-t-equals-m-zero](../round1/round1-verdict-agentb-m-t-equals-m-zero.md) — the round-1 statement of the surviving conclusion.
- [round10-agentb-m-t-equals-m-zero](../round10/round10-agentb-m-t-equals-m-zero.md) — the closing-verdict restatement.

## Notes

- This file supersedes the round-1 justification: the diagonal step (K diagonal) is false, while the
  similarity statement M(t) = D K D with D = diag((n+2)⁻¹) is the source's corrected derivation.
- The "Moral" sentence is the source's own general statement, quoted here as part of the result.
