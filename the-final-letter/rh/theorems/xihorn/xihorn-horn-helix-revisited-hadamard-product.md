# The horn's gears are its closures — Ξ(t) = Ξ(0)·Π_k (1 − t²/γ_k²)

**Kind:** Theorem
**Status:** CITED (literature; Hadamard's factorization applied to the order-1 entire Ξ, rebuilt numerically from 150 factors to 2.2×10⁻⁶)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §1.4 "The horn's gears are its closures", equation (4); §7 dictionary, term "the horn's gears are its closures"

## Statement

> The multiplicative statement behind (1): with the zeros on the line,
>
> ```
> Ξ(t) = Ξ(0) · Π_k ( 1 − t²/γ_k² )                                          (4)
> ```
>
> — the horn as a *stack of factors, one per closure*, each vanishing at its own γ_k. This is the exact analogue of the helix's gear decomposition, with the zeros in the role of the integers. Rebuilt numerically from 150 factors, tail again paid through λ₁ (Σ_{k>150} 1/γ_k² ≈ λ₁ − Σ₁₅₀, correction < 3e−6 relative):
>
> ```
>   t     Π₁₅₀           × tail factor    = product      true Ξ(t)/Ξ(0)   rel. err
>   5     0.58935449     0.94050878       0.55429307     0.55429185       2.2e−6
>   17   −0.0022217324   0.49212405      −0.001093368   −0.0010930514     2.9e−4
> ```

## Hypotheses and notation

- Ξ is the horn's entire function (Ξ(t) with ξ(½+it) the source's convention in horn-helix.md; here Ξ(t)/Ξ(0) is the normalised product).
- The stated premises are "with the zeros on the line" — the pairing ρ = ½ ± iγ, as in the closure ledger of §1.2.
- γ_k are the non-trivial zero ordinates; λ₁ = 1 + γ_E/2 − ½ln 4π = 0.0230957089661 pays the tail in Σ 1/γ_k².

## Proof / evidence

The source applies Hadamard's factorization to the order-1 entire Ξ ("The horn is entire of order 1, so Hadamard applies"); it does not re-derive the product. The numerical rebuild from 150 factors plus the λ₁ tail factor reproduces Ξ(5)/Ξ(0) = 0.55429185 as 0.55429307 (rel. err 2.2e−6) and Ξ(17)/Ξ(0) = −0.0010930514 as −0.001093368 (rel. err 2.9e−4). §6 lists the same rows.

## Dependencies and related results

- [The closure ledger](xihorn-horn-helix-revisited-closure-ledger.md) (1) is the logarithmic derivative of this product.
- Hadamard's factorization of Ξ; λ₁ from rh10 §5 → [ξ′/ξ(1) = λ₁](xihorn-horn-helix-revisited-lambda-one-at-one.md).
- §1.4's reading: the exact analogue of the helix's gear decomposition, "with the zeros in the role of the integers".

## Notes

- The source states (4) "with the zeros on the line"; the numeric rebuild and the tail estimate inherit that premise, and the source notes only that the first 150 zeros are verified on the line.
- The λ₁ tail correction is stated as "< 3e−6 relative".
