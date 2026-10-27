# The real obstruction is globality, not admissibility: no truncation of either sum equals the other

**Kind:** Claim
**Status:** PROOF-SKETCH (structural remark; no derivation is supplied — the source's own word for it is "essentially a truism about trace formulas"; the source calls it "essentially a truism about trace formulas")
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — §(1) "ADMISSIBILITY", lines 21–24

## Statement

> The real obstruction is NOT admissibility but GLOBALITY: both sides are infinite, and no
> truncation of either sum equals the other. That is a property of the identity, essentially a
> truism about trace formulas (spectrum vs geometry), and it is the correct explanation of the
> mediator's failed truncations -- not an admissibility failure.

## Hypotheses and notation

- "Both sides" are the two sides of the explicit-formula identity: the zero side Σ_ρ ĝ(γ_ρ) and the prime side Σ_n Λ(n)n^{−1/2}g(log n).
- "Truncation" is any finite cut-off of either sum; "globality" is the fact that each side is an infinite sum whose finite truncations do not match.

## Proof / evidence

The source argues structurally: since both sides are infinite sums, no truncation of one equals the
other, and this — rather than any failure of admissibility — is the explanation of the failed
truncation experiments. It presents this as a property of the identity, "essentially a truism about
trace formulas (spectrum vs geometry)".

## Dependencies and related results

- [round5-agentb-gaussian-is-admissible](round5-agentb-gaussian-is-admissible.md) — the companion admissibility result.

## Notes

- The source's own framing ("essentially a truism") is quoted; the status records that the source
  asserts this structurally rather than proving a formal theorem.
- No numerical certificate is attached to this claim in the source.

- **Correction (2025-10-06, session 003 residual-defect repair).** This carried `PROVED (paper argument, structural)`. The source supplies no argument for the globality claim — it names it as one: `round5_agentB.md:23` calls it "essentially a truism about trace formulas (spectrum vs geometry)". The file's own numerical work (`verify/final_adjudication.py:51-59`) shows the *asymmetry* that makes the claim plausible — the prime side needs `~e^X/X` terms where the zero side needs `~(X/2π)log(X/2π)` at the same scale — which is evidence for, not a proof of, "no truncation matches". Grade changed to `PROOF-SKETCH`.
