# Exponential accuracy needs the functional equation

**Kind:** Theorem
**Status:** CITED (literature, classical theta identity — Riemann 1859; independently verified to `5.7·10^{−69}`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/README.md`](../../research/twin-prime-parity/rounds/rh044/README.md) — "The settled facts", fact 3, lines 69–79

## Statement

The classical theta identity

```
π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s) + A(1−s)] ,   A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx
```

is verified independently to `5.7·10^{−69}` (`s = 2`), `1.8·10^{−68}` (`s = 4`), `1.0·10^{−64}` (`s = 1/2+it₁`), with a rigorous tail bound decaying like `e^{−πX}` (`B(X) = 1.0·10^{−45}` at `X = 32`). A one-sided smoothed sum omits a tail of size `√N·|M_φ(s)|`, so only this route reaches `o(N^{−A})` for every `A`.

## Hypotheses and notation

- `θ(x) = Σ_{n∈ℤ} e^{−πn²x}` is the Jacobi theta function; `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx`; `Γ` is the gamma function.
- `t₁ = 14.134725141734693` is the first zero; `X` is the quadrature truncation of the theta integral.
- The `O(√t)` term count and the tail bound `e^{−πX}` are as in the source.

## Proof / evidence

The README states the identity as fact 3 of "The settled facts (verified by the round and by its independent auditor)", quoting the independent verification accuracies and the tail bound `B(X) = 1.0·10^{−45}` at `X = 32`. The ledger's version gives the fuller tail-bound list `B(X) = 7.9·10^{−7}, 1.6·10^{−12}, 1.2·10^{−23}, 1.0·10^{−45}, 1.9·10^{−48}` at `X = 4, 8, 16, 32, 34`. No proof is given in the source; it is classical.

## Dependencies and related results

- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the source's ledger version of this result (T3); this file is its README restatement.
- [R4 — the theta identity `ζ(s) = 1/(s−1) + 1/s + …`](tpp-rh044-truths-r4-theta-identity-correction.md) — the misquoted variant, refuted.
- [README fact 2](tpp-rh044-readme-fact-2-smoothing-law.md) — the one-sided route this identity replaces.

## Notes

- Restatement of round **rh044** §3 (the ledger's T3); per the harvest SPEC a classical result carries **Status CITED (literature)**, and the source states it without proof.
- The README quotes only the `X = 32` entry of the ledger's tail-bound list, consistently with it.
