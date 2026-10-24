# Σ μ²(n)n^{−s} = ζ(s)/ζ(2s)

**Kind:** Theorem
**Status:** CITED (literature — classical Euler-product algebra; verified numerically at s = 2, 3, 4)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 1 Agent A answer, line 121; Round 1 status table, line 156; Round 1 Agent B audit, line 167; Round 1 ruling (d), line 135

## Statement

> Σ μ²(n)n^{−s} = ζ(s)/ζ(2s) | **STANDING** (classical) | verified at s = 2,3,4 to 8–10 digits

with the numerical certificate:

> **(d) A's s = 3 constant is slightly off.** Σ_{n≤2·10⁶} μ²(n)n^{−3} = **1.1815649490**, and ζ(3)/ζ(6) = **1.1815649490** — the identity is confirmed to 8 digits, but the value is 1.18156, not the 1.1843 A predicted. Confirmed also at s = 2 (1.51981745 vs 1.51981775) and s = 4 (1.0779281367, exact to 10 digits). Squarefree density measured: 0.60800 (N=10³) → 0.6079385 (N=2·10⁶), against 6/π² = 0.60792710.

## Hypotheses and notation

- μ is the Möbius function; μ²(n) is the squarefree indicator; ζ is the Riemann zeta function.
- Σ μ²(n)n^{−s} = ∏_p (1 + p^{−s}) = ζ(s)/ζ(2s) for Re s > 1.
- The squarefree density 6/π² = 1/ζ(2) = 0.6079271018… is the s → 1⁺ limit instance.

## Proof / evidence

Classical Euler-product algebra, stated as [KNOWN] and as a STANDING (classical) ledger row; the journal's contribution is the independent numerical verification at three points: Σ_{n≤2·10⁶} μ²(n)n^{−3} = 1.1815649490 = ζ(3)/ζ(6) to 8 digits; s = 2: 1.51981745 vs 1.51981775; s = 4: 1.0779281367 exact to 10 digits. Measured squarefree density 0.60800 (N=10³) → 0.6079385 (N=2·10⁶) against 6/π² = 0.60792710.

## Dependencies and related results

- [A(N) = Θ(1) for rational θ/π, density 0](research-journal-rational-digit-count-theta-one.md) — the digit-count context in which κ = 1 − 6/π² is introduced and correctly excluded.
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — the local-factor reading of the same product.
- [The product theorem: ∏(1 + a_n) converges to a finite non-zero limit iff Σ a_n converges](research-journal-product-convergence-theorem.md) — the criterion governing the product.

## Notes

- The source's use of the identity is to refute one of Agent A's numbers: "A's 1.1843 wrong by +2.7e−3". The identity itself is classical and stands.
- Related standing row in the same table: "1 − 6/π² = 0.39207290 correct and correctly excluded from A(N) | **STANDING** | measured squarefree density 0.6079385 at N=2·10⁶".
