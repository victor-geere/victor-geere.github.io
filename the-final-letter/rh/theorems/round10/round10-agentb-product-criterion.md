# (A)2 Product criterion: ∏(1+a_n) converges to a finite non-zero limit iff Σ a_n converges

**Kind:** Theorem
**Status:** CITED (literature, classical infinite-product criterion)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 2, lines 7–8

## Statement

> 2. Product criterion: prod(1+a_n) converges to finite non-zero iff sum a_n converges;
>    Euler local factor (1-p^-s)^-1-1 ~ p^-s is summable for sigma>1; prod n^-1/2 = (N!)^-1/2.

## Hypotheses and notation

- a_n are the product factors; σ = Re s; p runs over primes.
- The Euler local factor minus 1 is (1 − p^{−s})^{−1} − 1 ~ p^{−s}; Σ_p p^{−s} converges for σ > 1.
- The last clause is the exact identity ∏_{n≤N} n^{−1/2} = (N!)^{-1/2}.

## Proof / evidence

The source restates the classical criterion and its two applications (Euler product finite and
non-zero for σ > 1; the exact annihilating example ∏ n^{−1/2} = (N!)^{-1/2}). No proof is given in
the document.

## Dependencies and related results

- [round2-agentb-product-criterion](../round2/round2-agentb-product-criterion.md) — the round-2 statement of the same criterion, with the asymptotic 2√N − N − c and log = −½N log N + O(N).

## Notes

- Status CITED (literature): the criterion is classical; harvested because the source states it as a
  numbered standing result of its closing verdict.
- The source's item is a restatement of round 2 §(i); the round-2 file carries the fuller statement.
