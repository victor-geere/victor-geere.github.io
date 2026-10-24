# Goldfeld's partial-Euler-product asymptotic and its implication of RH

**Kind:** Theorem
**Status:** CITED (literature; K. Conrad, "Partial Euler products on the critical line")
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — §(2) "REGULARIZATION THESIS", lines 30–33

## Statement

> Multiplicative: partial Euler products at sigma=1/2 do not converge to zeta(s); Goldfeld:
> prod_{p<=x}(1-a_p p^{-s}+...)^{...} ~ C/log x, and the asymptotic implies RH for the L-function
> (K. Conrad, "Partial Euler products on the critical line"). Verified numerically: |prod-zeta| =
> 0.0611, 0.0228, 0.0131 at x=1e3,1e4,1e5 while |zeta(1/2+i gamma_1)| = 2.75e-11 (ratio 1e9).

## Hypotheses and notation

- The partial Euler product is ∏_{p≤x}(1 − a_p p^{−s} + …)^{…} at σ = 1/2 (the source elides the higher local factors with "…").
- C is a non-zero constant; the asymptotic is in x → ∞.
- γ_1 is the imaginary part of the first nontrivial zero of ζ; the reference is K. Conrad, "Partial Euler products on the critical line".

## Proof / evidence

The source cites Goldfeld's asymptotic and its consequence (the asymptotic implies RH for the
L-function) with the Conrad reference. It adds a numerical check: |prod − zeta| = 0.0611, 0.0228,
0.0131 at x = 10³, 10⁴, 10⁵, against |ζ(1/2 + iγ_1)| = 2.75×10⁻¹¹ (ratio 10⁹). No proof is given
in the document.

## Dependencies and related results

- [round5-agentb-two-obstructions-one-cause](round5-agentb-two-obstructions-one-cause.md) — the section's thesis, of which this is the multiplicative half.
- [round2-agentb-product-criterion](../round2/round2-agentb-product-criterion.md) — the convergence criterion for infinite products used in the surrounding argument.

## Notes

- Status CITED (literature): the workspace quotes Goldfeld's result and the Conrad reference; the
  numerical values are the workspace's own check.
- The source's notation for the local factors is abbreviated ("+...)^{...}"); it is reproduced as
  written rather than completed.
