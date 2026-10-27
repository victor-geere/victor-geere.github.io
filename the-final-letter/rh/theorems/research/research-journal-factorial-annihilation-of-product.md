# ∏_{n≤N} n^{−1/2} annihilates as (N!)^{−1/2}

**Kind:** Proposition
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 0d, line 81; Round 2 framing, line 207; Round 2 product theorem, line 234; Round 2 status table, line 267; Round 10 table, line 680

## Statement

> **angle addition** = product form: P_N = ∏_{n≤N} n^{−1/2−it}, so |P_N| = (N!)^{−1/2} → 5.7e−33 at N = 50, 1.0e−79 at N = 100, 3.95e−435 at N = 400. It dies instantly and dies *factorially*.

> Annihilating case: a_n = n^{−1/2} − 1 has Σ_{n≤N} a_n = 2√N − N − c → −∞, so the product is (N!)^{−1/2}, log = −½N log N + O(N). **The failure is a whole power of N, not a borderline divergence.**

> | ∏ n^{−1/2} annihilates as (N!)^{−1/2} | **STANDING** | 1.0e−79 at N=100, 3.95e−435 at N=400 |

## Hypotheses and notation

- |P_N| = ∏_{n≤N} n^{−1/2} is the modulus of the product form of the additive family Σ n^{−1/2−it}.
- (N!)^{−1/2} = ∏_{n≤N} n^{−1/2}; log₁₀(400!) = 868.8, so 1/√(400!) = 3.95e−435.
- The product is over all n ≤ N, not over primes; the journal's point is that the factors tend to 0, unlike Euler factors.

## Proof / evidence

The identity ∏_{n≤N} n^{−1/2} = (N!)^{−1/2} is immediate, and the source does not present a separate proof. Numerical certificates: 5.7e−33 at N = 50, 1.0e−79 at N = 100, 3.95e−435 at N = 400 (with log₁₀(400!) = 868.8). The comparison with the product theorem is exact: with a_n = n^{−1/2} − 1, Σ_{n≤N} a_n = 2√N − N − c → −∞, so the criterion of the product theorem fails by a whole power of N.

## Dependencies and related results

- [The product theorem: ∏(1 + a_n) converges to a finite non-zero limit iff Σ a_n converges](research-journal-product-convergence-theorem.md) — the criterion that classifies this as annihilating.
- [The 1/√(¼+t²) growth law for both additive families](research-journal-growth-law-shared-prefactor.md) — the contrasting additive behaviour, ∝ √N.
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — the structural reason: factors tending to 0 vs 1.

## Notes

- The journal's interpretation: "the square root is the culprit: with amplitude n^{−σ}, the product contributes (N!)^{−σ} and dies for every σ > 0. So the product form survives only at σ = 0 — i.e. on the unit circle."
- The source calls the failure "a whole power of N, not a borderline divergence", i.e. it is not repaired by any resummation of this family.
