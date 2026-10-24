# u_k = 2^k(u_0 + O(1)), hence A(N) = log₂ log N + O(1)

**Kind:** Theorem
**Status:** PROVED (paper argument from the squaring law; indices verified numerically)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(1) "SQUARING LAW — EXACT, c IDENTIFIED", lines 10–13

## Statement

> u=log r: u_{k+1} = 2u_k + log c_k, c_k bounded in a compact subinterval of (0,1], so
>    u_k = 2^k(u_0+O(1)) and A(N) = log_2 log(1/r_0) + O(1) = log_2 log N + O(1).  CORRECT.
> Verified indices: 1/pi 2,13,607,845027,1010073215737; log2 0,4,36,6069,144715219;
> sqrt2-1 1,11,251,218199,61323543800; e-2 0,3,53,9997,3620211521 — all match mediator.

## Hypotheses and notation

- r_k is the residual after k selections, u_k = log r_k, and c_k = r_{k+1}/r_k² is the squaring constant of the linked law.
- A(N) = #{n ≤ N : δ_n = 1} is the term count of the greedy digit word; r_0 = θ/π is the target ratio.
- The lists are the selected indices, e.g. for 1/π: 2, 13, 607, 845027, 1010073215737.

## Proof / evidence

From u_{k+1} = 2u_k + log c_k with c_k confined to a compact subinterval of (0, 1], the source
derives u_k = 2^k(u_0 + O(1)), hence A(N) = log₂ log(1/r_0) + O(1) = log₂ log N + O(1). The four
index lists (1/π, log 2, √2−1, e−2) are reported as verified and as matching the mediator's values.

## Dependencies and related results

- [round7-agentb-squaring-law-residual](round7-agentb-squaring-law-residual.md) — the squaring law r_{k+1} = c_k r_k² from which this is derived.
- [round1-verdict-agentb-no-positive-digit-density](../round1/round1-verdict-agentb-no-positive-digit-density.md) — the weaker bound A(N) ≤ √(2N).
- [round10-agentb-an-log-log-with-correction](../round10/round10-agentb-an-log-log-with-correction.md) — the sharpened form with the explicit Σ log c_k term.
- [handoff-greedy-squaring-law](../handoff/handoff-greedy-squaring-law.md) — the same growth law harvested from HANDOFF.md.

## Notes

- The derivation is conditional on c_k staying in a compact subinterval of (0, 1]; the source states
  that condition and does not prove it.
- The index lists are quoted exactly as written, including 1010073215737, 61323543800 and 3620211521.
