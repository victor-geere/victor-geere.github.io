# The instrument — and the correct form of the formula

**Kind:** Theorem
**Status:** VERIFIED (numerical, ≥ 20 digits on four kernels)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) — "The instrument — and the correct form of the formula"

## Statement

> Riemann–von Mangoldt.  With `g` an even test function, its Fourier transform
> `φ(t) = ∫_ℝ g(u)e^{itu}du`, and `Φ(s) = φ((s−1/2)/i)`, the identity is
>
> ```
> Σ_ρ Φ(ρ)  =  Φ(1) + Φ(0)                              [poles of ζ at s = 1, 0]
>            − Σ_{n≥2} (Λ(n)/√n)[g(log n) + g(−log n)]  [primes]
>            + (1/2π) ∫_ℝ φ(t) Ψ(t) dt                  [ARCHIMEDEAN]
> Ψ(t) = −log π + Re ψ(1/4 + it/2) ,        Φ(1) + Φ(0) = 2φ(i/2) for even g .
> ```

With the archimedean term restored, the identity holds to **≥ 20 digits** on four
kernels (Gaussian: residual `1.6·10⁻⁴⁴`; modulated Gaussian with `O(1)` LHS:
`9.6·10⁻⁴⁶`; narrow Gaussian: `−1.1·10⁻⁶³`; Cauchy companion `a=1`: ~2 digits, limited
by its `log G/G` zero-side tail).

## Hypotheses and notation

- `g` is an **even** test function; `φ(t) = ∫_ℝ g(u)e^{itu}du`; `Φ(s) = φ((s−1/2)/i)`.
- `Σ_ρ` runs over the nontrivial zeros; `Λ` is the von Mangoldt function; `ψ` is the digamma function; the prime sum runs over `n ≥ 2`.
- Pole terms `Φ(1) + Φ(0)` equal `2φ(i/2)` for even `g`.
- Archimedean term `(1/2π) ∫_ℝ φ(t) Ψ(t) dt` with `Ψ(t) = −log π + Re ψ(1/4 + it/2)`.

## Proof / evidence

- **VERIFIED** on four kernels to ≥ 20 digits (Gaussian residual `1.6·10⁻⁴⁴`; modulated Gaussian with `O(1)` LHS `9.6·10⁻⁴⁶`; narrow Gaussian `−1.1·10⁻⁶³`; Cauchy companion `a=1` ~2 digits, limited by its `log G/G` zero-side tail).
- The source states no Lean proof for the identity itself; the round's ledger adds that the algebraic layer is proved in Lean `Rh45/Explicit.lean` — see [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md).
- The source's own first draft was wrong here; see [What my first draft got wrong](tpp-rh45-readme-draft-errors-refuted.md).

## Dependencies and related results

- [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md) — the ledger's statement of the same corrected form with the four-kernel table.
- [The counting formula (the clean unconditional core)](tpp-rh45-readme-counting-formula.md).
- [Three structural advantages over the partial-sum route](tpp-rh45-readme-three-structural-advantages.md).

## Notes

- The README frames this as "the correct form of the formula": "With the archimedean term restored, the identity holds to ≥ 20 digits on four kernels".
- The Cauchy kernel at `a = 1/2` is the boundary case — "both its pole term and its prime sum diverge — which is exactly why my first Cauchy-based test could never have worked." Only the `a = 1` companion is usable, and only to ~2 digits.
- No new explicit formula is claimed: the README's "What the round does *not* claim" section disclaims any new explicit formula, improvement of Riemann–Siegel, zero-free region or RH progress.
