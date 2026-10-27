# The large sieve is an upper bound (Montgomery, Topics in Multiplicative Number Theory, Ch. 27)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(2) "LARGE-SIEVE CLAIM — INVALID", lines 15–17

## Statement

> The large sieve is an UPPER bound: sum_{r<=R} |sum_{n<=N} a_n e(n t_r)|^2 <= (N+delta^{-1}) sum|a_n|^2
> for delta-well-spaced points (Montgomery, Topics in Multiplicative Number Theory, Ch. 27).

## Hypotheses and notation

- a_n are arbitrary coefficients; e(x) = e^{2πix}; the points t_r are δ-well-spaced, r ≤ R.
- δ is the spacing parameter; the factor is (N + δ^{−1}); Σ|a_n|² is the coefficient energy.

## Proof / evidence

The source states the inequality as the standard large sieve and cites Montgomery, *Topics in
Multiplicative Number Theory*, Ch. 27; no proof is given in the document. The inequality is set out
as a rung of the §(2) argument, namely to fix the direction of the large sieve.

## Dependencies and related results

- [round7-agentb-no-large-sieve-lower-bound](round7-agentb-no-large-sieve-lower-bound.md) — the companion refutation of the recalled lower-bound form.

## Notes

- Status CITED (literature): the workspace quotes the standard result to correct the direction of an
  earlier appeal to it.
- The source's own emphasis, preserved in the statement, is "UPPER bound".
