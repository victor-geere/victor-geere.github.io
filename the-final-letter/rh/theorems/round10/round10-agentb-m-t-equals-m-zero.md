# (A)4 M(t) = D K D is a diagonal similarity with |w_n|² real and t-free, so M(t) = M(0) exactly

**Kind:** Proposition
**Status:** PROVED (paper argument, similarity argument)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 4, lines 11–13

## Statement

> 4. M(t) = D K D is a diagonal similarity with |w_n|^2 real and t-free, so M(t)=M(0) exactly;
>    no spectral event in t is possible. (My earlier "K diagonal" step was wrong; the conclusion
>    survives by the similarity argument.)

## Hypotheses and notation

- M(t) = D K D with diagonal D and quadrature matrix K; w_n are the weights; |w_n|² is real and independent of t.
- t is the real parameter (height on the critical line); "spectral event" means an eigenvalue drop of M(t).

## Proof / evidence

The source states the similarity argument: the only t-dependence enters through the diagonal
congruence, |w_n|² is real and t-free, hence M(t) = M(0) exactly and no spectral event in t is
possible. It explicitly records that its earlier "K diagonal" step was wrong and that the conclusion
survives by the similarity argument.

## Dependencies and related results

- [round2-agentb-m-t-equals-m-zero](../round2/round2-agentb-m-t-equals-m-zero.md) — the corrected round-2 derivation, with the quadrature's max off-diagonal 0.8631.
- [round1-verdict-agentb-m-t-equals-m-zero](../round1/round1-verdict-agentb-m-t-equals-m-zero.md) — the round-1 statement of the conclusion, then resting on the refuted diagonal step.
- [round1-verdict-agentb-k-diagonal-refuted](../round1/round1-verdict-agentb-k-diagonal-refuted.md) — the refuted step referred to in the parenthetical.

## Notes

- This is a closing-verdict restatement of round 2's corrected argument; the parenthetical retraction
  of the "K diagonal" step is quoted in the statement, as the source writes it.
- Status does not extend to any claim beyond M(t) = M(0) and the absence of spectral events in t.
