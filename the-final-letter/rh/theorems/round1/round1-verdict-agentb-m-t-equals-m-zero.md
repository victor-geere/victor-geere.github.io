# The matrix M(t) equals M(0) exactly for all t, with no spectral dips

**Kind:** Proposition
**Status:** PROVED (paper argument, diagonal congruence; the round-1 route via diagonality was retracted in round 2, the conclusion is re-derived there)
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(c) "STRUCTURAL KILL", lines 23–26

## Statement

> |w_n|^2=(n+2)^{-1} is REAL and t-FREE (phase cancels in w^2).
>
> => M(t) = M(0) EXACTLY for all t; min|eig| = 0.9478672986 (n=10 case 2/211) for ALL t.
>
> No dips at 14.1347, 21.022, 25.0109, 30.4249 — structural, not numerical.

## Hypotheses and notation

- M(t) = D K D is the quadratic-form matrix of the construction; w_n are the weights whose squared moduli are (n+2)^{−1}.
- t is the real parameter (the height on the critical line) probed at the first four ordinates 14.1347, 21.022, 25.0109, 30.4249.
- min|eig| = 0.9478672986 is reported for "n=10 case 2/211".

## Proof / evidence

The source argues structurally: the only t-dependence in M sits in the phases of w_n, and the
squared moduli |w_n|² = (n+2)^{−1} are real and t-free, so M(t) = M(0) for all t and no spectral
event in t is possible. The numerical value min|eig| = 0.9478672986 is reported as constant in t;
the absence of dips at the four ordinates is asserted to be structural rather than numerical.

Round 1 obtained this through the (later refuted) claim that K is diagonal; round 2 keeps the
conclusion and replaces the argument by the diagonal-similarity statement (see the linked round-2 file).

## Dependencies and related results

- [round1-verdict-agentb-k-diagonal-refuted](round1-verdict-agentb-k-diagonal-refuted.md) — the retracted diagonal step, whose consequence (diagonal M) this file reports.
- [round2-agentb-m-t-equals-m-zero](../round2/round2-agentb-m-t-equals-m-zero.md) — the corrected derivation via M = D K D with D = diag((n+2)⁻¹).
- [round10-agentb-m-t-equals-m-zero](../round10/round10-agentb-m-t-equals-m-zero.md) — the closing-verdict restatement.

## Notes

- The status records that the *conclusion* is asserted as proved by a congruence/similarity
  argument, while the round-1 justification for it (K diagonal) is REFUTED; round 2 supplies the
  surviving argument.
- The four ordinates 14.1347, 21.022, 25.0109, 30.4249 are the imaginary parts of the first four
  nontrivial zeros of ζ; the source's point is that no eigenvalue drop occurs at them.
- The number 0.9478672986 is quoted exactly as given.
