# (iv) LOG ZETA: log ζ(s) = Σ_{p,k} p^{−ks}/k, −ζ′/ζ(s) = Σ Λ(n)n^{−s}

**Kind:** Proposition
**Status:** CITED (literature, classical Dirichlet series; the explicit-formula reading is the source's own)
**Area:** workspace
**Source:** [`round2_agentB.md`](../../research/various/round2_agentB.md) — §(iv) "LOG ZETA", lines 45–50

## Statement

> log ζ(s) = Σ_{p,k} p^{-ks}/k (amplitude 1/k); −ζ'/ζ(s) = Σ Λ(n)n^{-s} (amplitude log p, no 1/k).
> The explicit formula's prime side uses Λ: −Σ Λ(n)n^{-1/2}g(log n). So it matches −ζ'/ζ, not
> log ζ. The 1/k is destroyed by differentiation: d/ds(p^{-ks}/k) = −(log p)p^{-ks}. This matters:
> a greedy/additive mechanism would need to produce amplitude log p at frequency k log p, i.e.
> resolve the pair (p,k) — exactly the prime-power resolution the digit string has no mechanism for.

## Hypotheses and notation

- p runs over primes, k ≥ 1 over prime powers; Λ is the von Mangoldt function (Λ(n) = log p for n = p^k, else 0).
- g is the test function of the explicit formula; the prime side is written −Σ Λ(n)n^{−1/2}g(log n).
- "amplitude" refers to the coefficient in the Dirichlet series; "frequency" to log n.

## Proof / evidence

The source states the two classical series expansions and the differentiation identity
d/ds(p^{−ks}/k) = −(log p)p^{−ks}, and uses them to conclude that the explicit formula's prime side
matches −ζ′/ζ rather than log ζ, and that reproducing it additively would require resolving the pair
(p, k). No proof of the classical expansions is given in the document.

## Dependencies and related results

- [round2-agentb-riemann-von-mangoldt-count](round2-agentb-riemann-von-mangoldt-count.md) — the count formula from the same section.
- [round5-agentb-two-obstructions-one-cause](../round5/round5-agentb-two-obstructions-one-cause.md) — the later structural reading of the same obstruction.

## Notes

- Status CITED (literature) for the classical expansions; the closing consequence about the digit
  string having "no mechanism" for prime-power resolution is the source's own structural argument.
- No numerical precision is involved in this file.
