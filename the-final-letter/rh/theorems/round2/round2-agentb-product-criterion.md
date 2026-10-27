# (i) PRODUCT THEOREM: ∏(1+a_n) converges to a finite non-zero limit iff Σ a_n converges

**Kind:** Theorem
**Status:** CITED (literature, classical infinite-product criterion)
**Area:** workspace
**Source:** [`round2_agentB.md`](../../research/various/round2_agentB.md) — §(i) "PRODUCT THEOREM", lines 22–27

## Statement

> ∏(1+a_n) converges to a finite non-zero limit iff Σ a_n converges (and no factor 0);
> with a_n ≥ −1 eventually, iff Σ a_n < ∞. Euler: a_p = (1−p^{-s})^{-1}−1 = Σ_{k≥1}p^{-ks} ~ p^{-s},
> Σ_p p^{-s} < ∞ for σ>1 ⇒ finite non-zero. Annihilating case: a_n = n^{-1/2}−1, Σ_{n≤N} a_n =
> 2√N − N − c → −∞ ⇒ product = 0, and indeed ∏ n^{-1/2} = (N!)^{-1/2}, log = −½N log N + O(N).
> Not summability but its failure by an entire power of N.

## Hypotheses and notation

- a_n are the product factors, with the source's convention a_n ≥ −1 eventually for the second form.
- σ = Re s; p runs over primes; a_p = (1 − p^{−s})^{−1} − 1 is the Euler local factor minus 1.
- c is a finite constant in the partial-sum asymptotic Σ_{n≤N} a_n = 2√N − N − c.

## Proof / evidence

The classical convergence criterion is stated and applied: the Euler local factors give
a_p ~ p^{−s} with Σ_p p^{−s} < ∞ for σ > 1, so the Euler product is finite and non-zero; the
annihilating example a_n = n^{−1/2} − 1 has divergent partial sums, and correspondingly
∏_{n≤N} n^{−1/2} = (N!)^{−1/2} with log = −½N log N + O(N). The source gives no proof of the
criterion itself; it attributes neither author nor reference in this document.

## Dependencies and related results

- [round10-agentb-product-criterion](../round10/round10-agentb-product-criterion.md) — the closing-verdict restatement of the same criterion.

## Notes

- Status CITED (literature): the criterion is a standard theorem, harvested here because the source
  sets it out as a labelled section and uses it as a rung of its own argument.
- The source's point, retained in the last sentence quoted, is that the failure in the example is "not
  summability but its failure by an entire power of N".
