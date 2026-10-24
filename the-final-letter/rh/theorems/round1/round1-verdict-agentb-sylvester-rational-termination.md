# Sylvester greedy = Fibonacci–Sylvester termination for rationals (Curtiss 1922; Erdős–Graham 1980)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`round1_verdict_agentB.md`](../../research/various/round1_verdict_agentB.md) — §(e) "irrational density", literature line, lines 38–39

## Statement

> Literature: Sylvester greedy = Fibonacci-Sylvester termination for rationals;
> term count bounds via Curtiss 1922 / Erdos-Graham 1980 ch. on Egyptian fractions.

## Hypotheses and notation

- "Sylvester greedy" is the greedy unit-fraction (Egyptian) expansion: repeatedly subtract the largest
  unit fraction 1/⌈1/r⌉ available; the source identifies it with the Fibonacci–Sylvester algorithm.
- The cited term-count bounds are those of Curtiss (1922) and of the Erdős–Graham chapter on Egyptian fractions (1980).

## Proof / evidence

The source states the termination theorem and its attribution as literature, with no proof in the
document. It is used as a rung of the §(e) density argument: rational targets terminate, so the
eventual behaviour of A(N) is decided by the irrational case.

## Dependencies and related results

- [round1-verdict-agentb-alg-e-rational-termination](round1-verdict-agentb-alg-e-rational-termination.md) — the concrete rational instances verified in round 1.
- [round10-agentb-sylvester-not-gauss](../round10/round10-agentb-sylvester-not-gauss.md) — the companion correction that this map is the Engel/Sylvester map, not the Gauss map.

## Notes

- Status CITED (literature): the workspace did not prove this; the source cites Curtiss 1922 and
  Erdős–Graham 1980 for the term-count bounds.
- The citation is a single "Literature:" line; no page or theorem number is given in the source.
