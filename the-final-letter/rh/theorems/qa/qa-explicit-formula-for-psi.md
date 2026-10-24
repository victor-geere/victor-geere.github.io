# The explicit formula for ψ(x)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q4, lines 110–114; listed as "Rigorous, classical" in the Part I "Notes on rigor", line 278

## Statement

> The explicit formula
>
> ```
> ψ(x) = x − Σ_ρ x^ρ/ρ − log 2π − ½ log(1 − x⁻²)
> ```
>
> is a genuine error-correcting scheme. The "message" is the primes (via ψ, the weighted prime power count); the "decoded value" is the smooth leading term x; and the sum over zeros is the **correction stream**. Each zero contributes a term of magnitude ≈ x^{Re ρ}/|ρ|.

## Hypotheses and notation

- ψ(x) is the Chebyshev function, the weighted prime power count, Σ<sub>n≤x</sub> Λ(n).
- The sum Σ_ρ runs over the nontrivial zeros ρ = β + iγ of ζ(s); x > 1 in the usual formulation.
- The term ½ log(1 − x⁻²) is the contribution of the trivial zeros.

## Proof / evidence

The source states the formula and cites it as classical; it supplies no proof. In the Part I "Notes on rigor" the explicit formula is listed among the items that are "Rigorous, classical". The source's own additions around it — "the message is the primes", "the decoded value is the smooth leading term x", "the sum over zeros is the correction stream" — are explicitly labelled as its own synthesis / framing.

## Dependencies and related results

- [qa-von-koch-equivalence](qa-von-koch-equivalence.md) — the prime-counting form of what RH buys under this formula.
- [qa-ingham-omega-result](qa-ingham-omega-result.md) — the classical statement about the term a single off-line zero contributes.
- The same answer notes the classical fact that "a single zero of real part β > 1/2 forces ψ(x) − x to oscillate at amplitude x^β".

## Notes

- The source is explicit that the error-correcting-code reading is analogy and not theorem: "(Analogy, not a theorem — but the underlying explicit formula is rigorous…)".
- This is a citation of a standard result, harvested only because qa.md sets it out as a rung of its own argument and lists it as rigorous in its own notes. The status CITED (literature) records that the workspace did not prove it and cites no specific reference beyond "classical".
