# The termination threshold is p* = 1.728647239 (ζ(p*) = 2), not 3/2

**Kind:** Proposition
**Status:** PROVED (paper argument from the total mass; p* located numerically as the root of ζ(p) = 2)
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — "TWO CORRECTIONS", item 2, lines 7–10

## Statement

> The termination threshold is p* = 1.728647239... (where zeta(p)=2), NOT 3/2.
> Sum of available mass = sum_{n>=0}(n+2)^{-p} = zeta(p)-1. Termination <=> zeta(p)-1 >= 1
> <=> zeta(p) >= 2 <=> p <= p*. At p=1.5, zeta(1.5)-1 = 1.6124 > 1 (so fine); at p=2,
> zeta(2)-1 = 0.6449 < 1 (unreachable). p=3/2 is not a threshold.

## Hypotheses and notation

- The p-family has terms (n+2)^{−p}, n ≥ 0; the target is 1; total available mass is Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1.
- p* is defined by ζ(p*) = 2; the source quotes p* = 1.728647239… .
- "Termination" means the greedy expansion reaches the target exactly.

## Proof / evidence

The source reduces termination to a mass comparison: termination ⟺ ζ(p) − 1 ≥ 1 ⟺ ζ(p) ≥ 2 ⟺ p ≤ p*,
and quotes the two checks ζ(1.5) − 1 = 1.6124 > 1 and ζ(2) − 1 = 0.6449 < 1. The numerical value
p* = 1.728647239… is the root of ζ(p) = 2 to the digits given.

## Dependencies and related results

- [round5-agentb-termination-regime-law](round5-agentb-termination-regime-law.md) — the full regime statement for p ≤ 1, 1 < p ≤ p* and p > p*.
- [round5-agentb-local-factor-telescopes](round5-agentb-local-factor-telescopes.md) — the companion correction.

## Notes

- The correction is directed at the value 3/2 quoted earlier ("p=3/2 is not a threshold").
- The equivalence is argued from total mass; the value p* itself is a numerical root, quoted to nine
  significant digits as 1.728647239… (the source writes the ellipsis).
