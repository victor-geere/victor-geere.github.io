# Alg E (unsigned Egyptian/Sylvester) terminates on the tested rationals with finite support

**Kind:** Claim
**Status:** VERIFIED (exact rational arithmetic; specific instances)
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — "CONVENTION REPAIR", lines 4–6, and §(a) "verified", lines 11–13

## Statement

> Alg E (unsigned Egyptian/Sylvester, take iff d_n >= 1/(n+2)): reproduces A's {0,1,4}
> at theta=pi, terminating with d=0 at step 4.
>
> 1/2+1/3+1/6 = 1 exactly, indices {0,1,4}: CONFIRMED under Alg E.
>
> Alg E supports: 1->{0,1,4}; 1/2->{0}; 1/3->{1}; 1/4->{2}; 2/5->{1,13}.
> All terminate; finite support; A(N)=Theta(1). A's claim 4 CORRECT.

## Hypotheses and notation

- Alg E is the unsigned Egyptian/Sylvester greedy rule: at step n take (set δ_n = 1) iff d_n ≥ 1/(n+2), with term +1/(n+2); this is contrasted with Alg S (signed, threshold d_n > 0, term ±1/(n+2)).
- "supports" lists the indices n with δ_n = 1; A(N) = #{n ≤ N : δ_n = 1} is the term count.

## Proof / evidence

The source reports these as verified under Alg E and gives the exact identity 1/2 + 1/3 + 1/6 = 1
with indices {0, 1, 4}, terminating with d = 0 at step 4. The document gives no proof of termination
in general; it records the instances listed. The source also records the negative convention fact that
Alg S "(signed, threshold d_n>0, term +-=1/(n+2)): does NOT terminate for rationals" and that its own
earlier use of Alg S "was wrong".

## Dependencies and related results

- [round1-verdict-agentb-sylvester-rational-termination](round1-verdict-agentb-sylvester-rational-termination.md) — the classical termination theorem for the Sylvester greedy algorithm that this instance list illustrates.
- [round1-verdict-agentb-residual-bound-sine](round1-verdict-agentb-residual-bound-sine.md) — the residual bound for the same s_N.

## Notes

- The source's standing is that Alg E is the algorithm A was using, and that the earlier Alg S "does NOT terminate for rationals".
- The claim that "All terminate" is asserted for the five listed rationals only; general rational
  termination is a literature result (see the linked file), not proved in this document.
- The support {0,1,4} at θ = π is restated in round 10 §(A) item 1.
