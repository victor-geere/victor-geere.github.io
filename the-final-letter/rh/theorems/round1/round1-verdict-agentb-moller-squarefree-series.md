# (b) Moller: the squarefree-series value and the residue correction

**Kind:** Claim
**Status:** VERIFIED (numerical, to the digits quoted) / correction of an earlier claim
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(b) "Moller", lines 16–19

## Statement

> sum_{n<=2e6} mu^2(n) n^-3 = 1.1815649490 ; zeta(3)/zeta(6) = 1.18156494901.
> A's 1.1843 is WRONG by +2.7e-3.
>
> A's divergence form has wrong residue: is (6/pi^2)/(s-1), not (1-6/pi^2)s/(s-1).

## Hypotheses and notation

- μ is the Möbius function, μ²(n) the squarefree indicator; the sum is over n ≤ 2×10⁶.
- ζ(3)/ζ(6) = 1.18156494901 is the exact value the partial sum approaches (since Σ μ²(n)n^{−s} = ζ(s)/ζ(2s)).
- "A" is the other agent in the adjudication; "A's divergence form" is the claimed behaviour of the same Dirichlet series near s = 1.

## Proof / evidence

The source reports the partial sum and the closed value ζ(3)/ζ(6) numerically and states that the
proposal 1.1843 is wrong by +2.7×10⁻³. The residue statement is asserted, not derived in the
document; the standard value of Σ μ²(n)n^{−s} at s = 1 is 6/π².

## Dependencies and related results

- [round1-verdict-agentb-squarefree-density-and-count](round1-verdict-agentb-squarefree-density-and-count.md) — the companion squarefree density and count.

## Notes


- The source states the three quantities without proof; the numerical partial sum is quoted to the
  digits shown (1.1815649490) and the closed form to one digit more (1.18156494901).
- The residue correction is the source's refutation of a competing "divergence form"; the corrected
  residue is (6/π²)/(s−1).
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `audit3.py`, `verify/round1_corrected.py`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
