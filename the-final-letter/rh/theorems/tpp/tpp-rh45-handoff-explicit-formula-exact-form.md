# The explicit formula (exact form)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh45/HANDOFF.md) — §1 "The instrument"

## Statement

> and, in its exact form, the **explicit formula**
>
> ```
> sum_ρ  F(1/2 + iγ)  =  F(1/2 + i/2) + F(1/2 − i/2)  −  Σ_{n≥2} (Λ(n)/√n) [g(log n) + g(−log n)] ,
> ```
>
> where `g` is the inverse Fourier/Laplace transform of `F` (so that the prime side is
> weighted by `Λ`), the sum is over the nontrivial zeros, and the pole terms come from
> `s = 1` (and `s = 0` under `s ↔ 1−s`).

## Hypotheses and notation

- `F` is the test function; `g` is its inverse Fourier/Laplace transform, so the prime side is weighted by `Λ`.
- `sum_ρ` runs over the nontrivial zeros `ρ = 1/2 + iγ`; the prime sum runs over `n ≥ 2`.
- Pole terms: `F(1/2 + i/2) + F(1/2 − i/2)`, coming from `s = 1` and, under `s ↔ 1−s`, `s = 0`.

## Proof / evidence

- The source states this as the round's instrument without proof or citation; it is a classical identity quoted as a rung of the round's argument, hence CITED (literature).
- No derivation is given in HANDOFF.md.

## Dependencies and related results

- [The per-zero count (Riemann–von Mangoldt)](tpp-rh45-handoff-riemann-von-mangoldt-count.md) — the companion statement in the same section.
- [The smoothed zero count](tpp-rh45-handoff-smoothed-zero-count.md).
- [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md) — the round's ledger gives the corrected Weil form, which **adds the archimedean term** `(1/2π) ∫_ℝ φ(t) Ψ(t) dt` with `Ψ(t) = −log π + Re ψ(1/4 + it/2)`, and records that omitting it was one of the first draft's two errors.

## Notes

- As printed in HANDOFF.md this identity has only the pole terms and the prime sum on the right; it **omits the archimedean term**. The round's own ledger ([`truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) §1) and [`README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) state the correct form with the archimedean integral, and record that the missing archimedean integral had size `−1.196346718078` on the `σ = 1` Gaussian. The verbatim statement above is preserved as the source gives it; the correction is reported, not applied.
- The ledger's corrected form also writes the pole pair as `Φ(1) + Φ(0) = 2φ(i/2)` for even `g`.
- The source uses the word "exact" for this identity as opposed to the smoothed count that follows it.
