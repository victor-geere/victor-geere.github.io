# The frequency/amplitude dictionary of the explicit formula

**Kind:** Theorem
**Status:** PROVED (paper argument; classical explicit-formula structure, verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 2 ruling, lines 244–255; Round 2 status table, line 271; Synthesis §3, line 416; "The ten things that stand" §6, line 619; Round 10 table, line 687

## Statement

> **The prime-power frequency dictionary, verified by the mediator** (which B asserts and A concedes, and which is the real structural finding of the round). Each prime power n = p^k contributes a term at **frequency log n = k log p** with **amplitude Λ(n)/√n**:

| n | p | k | frequency k log p | amplitude Λ(n)/√n | period 2π/freq |
|---|---|---|---|---|---|
| 2 | 2 | 1 | 0.693147 | 0.490129 | 9.0647 |
| 4 | 2 | 2 | 1.386294 | 0.346574 | 4.5324 |
| 8 | 2 | 3 | 2.079442 | 0.245065 | 3.0216 |
| 3 | 3 | 1 | 1.098612 | 0.634284 | 5.7192 |
| 9 | 3 | 2 | 2.197225 | 0.366204 | 2.8596 |
| 5 | 5 | 1 | 1.609438 | 0.719763 | 3.9040 |

> So the additive coordinate of the explicit formula is indexed by **prime powers, each at its own frequency k log p** — not by n, and not even by primes.

and in the final synthesis:

> The frequency/amplitude dictionary of the explicit formula is exact and convention-free: prime powers p^k at frequency **k log p** with amplitude **Λ(n)/√n** = (log p)p^{−k/2}. The additive side is indexed by prime *powers*, and the amplitude is an unbounded two-parameter family (0.490129, 0.634284, 0.346574, 0.719763, 0.245065, 0.366204 for n = 2, 3, 4, 5, 8, 9) — not a digit string and not bounded by one.

## Hypotheses and notation

- Λ(n) is the von Mangoldt function (Λ(p^k) = log p, else 0); √n = n^{1/2}.
- Frequency is log n = k log p for n = p^k; period is 2π/frequency.
- −ζ'/ζ = Σ Λ(n)n^{−s} is the underlying identity; the prime side of the explicit formula is −Σ Λ(n)n^{−1/2}g(log n).

## Proof / evidence

The dictionary is read off the classical identity −ζ'/ζ = Σ_n Λ(n)n^{−s}, which the source sets out as the additive coordinate of the explicit formula; the mediator verified the table by computing Λ(n)/√n and k log p for the listed prime powers. The source stresses the dictionary "stands independently" of any archimedean normalisation and of the failed numerical explicit-formula closure: it "needs no archimedean convention at all."

## Dependencies and related results

- [The product theorem: ∏(1 + a_n) converges to a finite non-zero limit iff Σ a_n converges](research-journal-product-convergence-theorem.md) — the multiplicative side.
- [Differentiation converts the frequency k log p into the amplitude log p](research-journal-derivative-mechanism.md) — how the dictionary arises from log ζ by d/ds.
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — why no greedy local factor produces these amplitudes.

## Notes

- The status is PROVED (paper argument): the content is the classical explicit-formula/Euler-product structure, which the journal labels "STANDING, NEW" and verifies numerically. It is not a bare mention — the source sets the table out as its own rung ("the real structural finding of the round").
- The journal's reading of the amplitude set: "Λ(n)/√n = (log p)p^{−k/2} is a two-parameter family … **25 distinct amplitudes for primes below 100**, and no bound, since log p is unbounded. A binary digit carries one bit." Agent A labels the derived statement "an **observation, not a theorem** — approximation to any precision is always possible, exact greedy representation is not"; the dictionary itself is not what he is downgrading.
