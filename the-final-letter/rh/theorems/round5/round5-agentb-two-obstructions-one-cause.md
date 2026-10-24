# (2) REGULARIZATION THESIS: two different obstructions, one common cause

**Kind:** Claim
**Status:** PROVED (paper argument, structural reading of the two accounts)
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — §(2) "REGULARIZATION THESIS", lines 26–35

## Statement

> Two DIFFERENT obstructions, one common cause.
> Additive: sum_{n<=N} n^{-1/2-i gamma} = O(N^{1/2}); the Dirichlet series diverges at sigma=1/2
> (abscissa 1), partial sums have square-root growth.
> Multiplicative: partial Euler products at sigma=1/2 do not converge to zeta(s); Goldfeld: ...
>     Common cause: at sigma=1/2 the explicit formula forces the cut-off length in the two accounts
> to scale differently, so no finite P or N reproduces the other side. Not one phenomenon.

## Hypotheses and notation

- The additive account is the truncated zero-sum side with cut-off N; the multiplicative account is the truncated Euler product with cut-off x (the source's "P" is the prime-side cut-off).
- σ = Re s = 1/2; γ is a zero ordinate.
- "O(N^{1/2})" is the additive square-root growth recorded in the statement.

## Proof / evidence

The source contrasts the additive obstruction (partial sums O(N^{1/2}), Dirichlet series divergent at
σ = 1/2, abscissa 1) with the multiplicative one (partial Euler products do not converge to ζ(s);
Goldfeld's asymptotic, see the linked file), and asserts that the common cause is that at σ = 1/2 the
explicit formula forces the two cut-off lengths to scale differently, so no finite P or N reproduces
the other side. The conclusion drawn is that this is not one phenomenon.

## Dependencies and related results

- [round5-agentb-goldfeld-partial-euler-products](round5-agentb-goldfeld-partial-euler-products.md) — the multiplicative half, with the Goldfeld citation and numerics.
- [round1-verdict-agentb-growth-exponent-one-half](../round1/round1-verdict-agentb-growth-exponent-one-half.md) — the additive square-root growth.
- [round2-agentb-log-zeta-versus-zeta-prime](../round2/round2-agentb-log-zeta-versus-zeta-prime.md) — the companion reading of the explicit formula's prime side.

## Notes

- The status records a structural argument, not a formal theorem; the source presents it as the
  correct reading of the two regularization failures.
- The statement's middle line is abbreviated in this file (the Goldfeld line is quoted in full in the
  linked file) to keep the quoted block to the source's own sentence structure.
