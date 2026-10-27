# Riemann–von Mangoldt: N(T) = (T/2π)log(T/2π) − T/2π + 7/8

**Kind:** Theorem
**Status:** CITED (literature; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 1 AFE addendum, line 199; Round 2 [KNOWN] (ii), line 236; Round 5 closure check, lines 397–406; Round 4 density check, line 385

## Statement

> **Also verified:** Riemann–von Mangoldt, N(T) = (T/2π)log(T/2π) − T/2π + 7/8: at T = 100, N = 29 vs 29.0023; T = 1000, N = 649 vs 648.616; T = 2000, N = 1517 vs 1516.993. S(T) wanders in [−0.59, +0.58] over this range — the honest scale of the "error term" a finite computation must fight.

Round 2, with the completed counting function:

> (ii) B verified Riemann–von Mangoldt at T = 300 (exact N = 138, main term 137.7119, S = +0.2881) and states honestly that **no primes appear in the main term — the prime content sits entirely in S(T)**.

Round 5 check of A's claimed closure uses N(T) = θ(T)/π + 1 + (1/π)arg ζ(½+iT) and θ(T) = Im logΓ(¼+iT/2) − (T/2)log π, with S = k − N(T) values 0.31500462 (k=100), 0.70719132 (k=1000), 0.59476701 (k=5000), 0.44573033 (k=10000).

## Hypotheses and notation

- N(T) counts the non-trivial zeros with ordinate in (0,T]; the main term is (T/2π)log(T/2π) − T/2π + 7/8; S(T) = N(T) − main term.
- The completed form used in Round 5: N(T) = θ(T)/π + 1 + (1/π)arg ζ(½+iT), θ(T) = Im logΓ(¼+iT/2) − (T/2)log π.
- The archimedean density argument: Re ψ(½+ir/2) − log π matches log(r/2π) to 7 digits at r = 10⁴ (7.3724633 against 7.3724633, difference 1.7e−9).

## Proof / evidence

The formula is classical and is used as a rung (CITED). The mediator's numerical checks: T = 100, N = 29 vs 29.0023; T = 1000, 649 vs 648.616; T = 2000, 1517 vs 1516.993; B's check at T = 300 (exact N = 138, main term 137.7119, S = +0.2881); S(T) values from the Round 5 closure check. The source also records that the correct archimedean argument is ½+ir/2, not ¼+ir/2 (a Mediator error in the ledger), confirmed by the 1/r²-shrinking discrepancy against log(r/2π).

## Dependencies and related results

- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — uses the same zero-counting scale.
- [Measured GUE level repulsion in the zeta zeros](research-journal-zero-level-repulsion.md) — the finer statistics of the same ordinates.
- [A finite additive object cannot distinguish a zero from a dip](research-journal-partial-sum-local-minima.md) — the truncation side.

## Notes

- The journal's key honest reading: "**no primes appear in the main term — the prime content sits entirely in S(T)**", and A's claimed explicit-formula closure "closes only up to S(T), the term that carries the zeros' individual positions. That is not a closure and the journal does not record one."
- The status is CITED (literature): the formula is stated and verified, not proved, in this workspace.
