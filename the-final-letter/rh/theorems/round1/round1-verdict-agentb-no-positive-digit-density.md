# A(N) ≤ √(2N), hence A(N)/N → 0: no positive digit density anywhere

**Kind:** Proposition
**Status:** PROVED (paper argument, from the invariant d_N < 1/(N+2))
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(e) "irrational density", lines 34–37

## Statement

> Exact Alg E on 60-digit rationals: A(N) stabilises at 2-4 terms for N up to 2e5;
> stopping when d < 1/(n+3). A(N) <= sqrt(2N) by the invariant d_N < 1/(N+2).
>
> => A(N)/N -> 0 for rationals AND irrationals; NO positive digit density anywhere.
> A's falsifier (A(1e6)/1e6 -> positive) therefore does NOT kill him.

## Hypotheses and notation

- A(N) = #{n ≤ N : δ_n = 1} is the census of selected indices of the greedy digit word.
- d_N is the residual after N steps; the invariant invoked is d_N < 1/(N+2).
- Alg E is the unsigned Egyptian/Sylvester rule of §(a).

## Proof / evidence

The source derives A(N) ≤ √(2N) from the invariant d_N < 1/(N+2), and reports the exact Alg E run
on 60-digit rationals (A(N) stabilises at 2–4 terms for N up to 2×10⁵, stopping when d < 1/(n+3)).
From A(N) ≤ √(2N) it concludes A(N)/N → 0 for rationals and irrationals, so no positive digit
density exists anywhere at any target; the proposed falsifier A(10⁶)/10⁶ → positive therefore fails.

## Dependencies and related results

- [round1-verdict-agentb-alg-e-rational-termination](round1-verdict-agentb-alg-e-rational-termination.md) — Alg E and the finite-support instances.
- [round7-agentb-an-log-log-n-growth](../round7/round7-agentb-an-log-log-n-growth.md) — the sharper A(N) = log₂ log N + O(1) law asserted in round 7.

## Notes

- The source asserts the bound "by the invariant d_N < 1/(N+2)" and gives no separate proof; the
  inequality A(N) ≤ √(2N) is quoted as stated.
- The conclusion is the source's negative answer to a proposed falsifier, not a claim about the deeper
  arithmetic of the construction.
