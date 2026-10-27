# The termination regime of the p-family: divergence for p ≤ 1, termination for 1 < p ≤ p*, unreachable for p > p*

**Kind:** Theorem
**Status:** PROVED (paper argument from total mass; indices verified numerically, mpmath dps = 60)
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — §(3) "TERMINATION/SAMPLING DILEMMA", lines 37–48

## Statement

> Numbers CONFIRMED (exact, mpmath dps=60, target 1):
>   p=1.05 -> [0,1,3,47,3697], residual 4.281e-8
>   p=1.2  -> [0,1,2,5,42,1134], residual 7.429e-8
>   p=1.5  -> 12 terms, last index 77716, residual 2.625e-13
>   p=1    -> [0,1,4], residual 1.9e-62  (terminates cleanly)
>   p=1.7  -> 107 terms, last 4321 ;  p>=p* -> never terminates (mass < 1)
> Sharp threshold p* = 1.728647239 (zeta(p*)=2). For p<=1 the series diverges (always
> terminates); for 1<p<=p* it converges to >=1 and terminates with index blowing up like
> 1/(zeta(p)-1) as p->p*+ ; for p>p* the target is unreachable -- NOT a termination failure but
> an insufficient-total-mass failure. So the dilemma is a theorem of the FAMILY (mass vs target),
> not of greedy systems in general.

## Hypotheses and notation

- The p-family takes terms (n+2)^{−p} (n ≥ 0) against target 1; p* is defined by ζ(p*) = 2 (see the threshold file).
- The bracketed lists are the selected indices; "last index" is the final selected n; "residual" is the remaining distance to the target.
- p ≥ p* means the total available mass Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1 is < 1.

## Proof / evidence

The source reports the listed exact runs at mpmath dps = 60 and derives the regime from the mass
comparison: for p ≤ 1 the series diverges so termination always occurs; for 1 < p ≤ p* the mass is
≥ 1 and termination occurs with index blowing up like 1/(ζ(p) − 1) as p → p*⁺; for p > p* the target
is unreachable, which the source insists is an insufficiency-of-total-mass failure rather than a
termination failure.

## Dependencies and related results

- [round5-agentb-reachability-threshold-zeta-two](round5-agentb-reachability-threshold-zeta-two.md) — the threshold p* = 1.728647239 and the mass equivalence.
- [round5-agentb-local-factor-telescopes](round5-agentb-local-factor-telescopes.md) — the companion exact product.

## Notes

- The residual values are quoted exactly as written (4.281e-8, 7.429e-8, 2.625e-13, 1.9e-62).
- The source's summary sentence calls the result "a theorem of the FAMILY (mass vs target), not of
  greedy systems in general"; the status does not extend the claim beyond the p-family.
