# The greedy local factor telescopes to 1/(N+2) exactly, not 2/(N+2)

**Kind:** Proposition
**Status:** PROVED (paper argument, exact telescoping product)
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — "TWO CORRECTIONS", item 1, lines 3–6

## Statement

> The greedy local factor telescopes to 1/(N+2), NOT 2/(N+2). Exact: prod_{n=0}^{1000}(1-1/(n+2))
> = 1/1002 = 0.000998003992; prod_{n=0}^{N} = 1/(N+2) exactly (N=3 -> 1/5). The mediator's
> measured 0.000999 at N=1000 is the 1/(N+2) value; the closed form quoted was wrong by factor 2.

## Hypotheses and notation

- The local factor at index n is (1 − 1/(n+2)); the product runs n = 0, …, N (so N + 1 factors).
- The numerical instance is N = 1000: ∏ = 1/1002 = 0.000998003992, and the small case N = 3 gives 1/5.

## Proof / evidence

The source states the telescoping identity ∏_{n=0}^{N}(1 − 1/(n+2)) = 1/(N+2) exactly and quotes the
two instances. It is a correction of a quoted closed form that was too large by a factor 2; the
measured 0.000999 at N = 1000 is identified with the 1/(N+2) value.

## Dependencies and related results

- [round5-agentb-reachability-threshold-zeta-two](round5-agentb-reachability-threshold-zeta-two.md) — the companion correction of the termination threshold.

## Notes

- The source states the identity as "Exact"; the 1002 denominator is quoted exactly and the decimal
  0.000998003992 is the source's own rendering of 1/1002.
- The claim explicitly refutes the value 2/(N+2) that had been quoted in the discussion.
