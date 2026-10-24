# Residual bound: |sin θ − s_N| ≤ π/(N+1)

**Kind:** Claim
**Status:** PROVED (paper argument, tail bound; verified numerically, not sharp for most θ)
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(a) "verified", lines 9–10

## Statement

> Residual bound: |sin th - s_N| <= pi/(N+1) — holds (tail bound), but NOT sharp for
> most th; at th=pi, N=60 max over 160-pt grid, mean reported in transcript.

## Hypotheses and notation

- "th" is the source's ASCII notation for θ; π is written `pi`. The bound is asserted on θ ∈ [0, π].
- s_N = Σ_{n≤N} δ_n π/(n+2) is the greedy harmonic-sine partial sum built from the digit word δ_n.
- The source's check is at θ = π, N = 60, maximum and mean taken over a 160-point grid (the mean value itself is "reported in transcript", not in this file).

## Proof / evidence

The source states the bound "holds (tail bound)" and marks it under "## (a) verified", i.e. it is
established by the standard tail estimate of the greedy construction; the source gives no written
proof in this document. The sharpness caveat is the source's own: the bound is "NOT sharp for most th".

## Dependencies and related results

- [round1-verdict-agentb-alg-e-rational-termination](round1-verdict-agentb-alg-e-rational-termination.md) — the same s_N under Alg E, with support {0,1,4} at θ = π.
- [round1-verdict-agentb-growth-exponent-one-half](round1-verdict-agentb-growth-exponent-one-half.md) — the companion numerical bound in the growth section.

## Notes

- The source states the bound without proof in the document, and explicitly qualifies it as non-sharp.
- Restated in round 5 §(4) ("builds s_N = sum delta_n pi/(n+2) with |sin theta - s_N| <= pi/(N+1)")
  and again in round 10 §(A) item 1; the round 10 version restricts the domain to [0, π].
