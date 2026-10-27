# (A)1 Greedy harmonic sine: s_N = Σ_{n≤N} δ_n π/(n+2), |sin θ − s_N| ≤ π/(N+1) on [0, π]

**Kind:** Theorem
**Status:** PROVED (paper argument, tail bound; termination by exact rational arithmetic)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 1, lines 4–6

## Statement

> 1. Greedy harmonic sine: s_N=sum_{n<=N}delta_n pi/(n+2), |sin th - s_N| <= pi/(N+1) on [0,pi].
>    Terminates for rational theta/pi (exact rational arithmetic); support for theta=pi is {0,1,4}.

## Hypotheses and notation

- δ_n is the greedy digit (0 or 1); s_N is the partial sum with terms δ_n π/(n+2).
- θ ∈ [0, π]; the target is sin θ. "support" is the set of indices n with δ_n = 1.
- Termination is asserted for rational θ/π under exact rational arithmetic.

## Proof / evidence

The source lists this as a standing item with evidence: the tail bound |sin θ − s_N| ≤ π/(N+1) on
[0, π], termination for rational θ/π by exact rational arithmetic, and the support {0, 1, 4} at
θ = π. The document gives no proof of the bound or of general rational termination here.

## Dependencies and related results

- [round1-verdict-agentb-residual-bound-sine](../round1/round1-verdict-agentb-residual-bound-sine.md) — the round-1 statement of the same bound (there for θ ∈ [0, π], verified at θ = π).
- [round1-verdict-agentb-alg-e-rational-termination](../round1/round1-verdict-agentb-alg-e-rational-termination.md) — the round-1 instance list, including support {0,1,4}.
- [round5-agentb-local-factor-telescopes](../round5/round5-agentb-local-factor-telescopes.md) — the companion exact product in the same construction.

## Notes

- This is a closing-verdict restatement of results first stated in round 1 §(a) and round 5 §(4);
  it is harvested here as a numbered standing item of the ledger-like final report.
- The source does not attach a numerical value to the bound's sharpness in this item.
