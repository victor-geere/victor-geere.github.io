# The closure ledger — ξ′/ξ(s) = Σ_γ 2(s−½)/((s−½)² + γ²)

**Kind:** Theorem
**Status:** PROVED (paper argument; from Hadamard's factorization of the order-1 entire ξ, verified by the source from 150 zeros to 4.2×10⁻⁸ on the `s = 2` row and 4.5×10⁻⁷ on the `s = 3+2i` row (the source is prose only; no committed evaluator))
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §1.2 "The closure ledger", equation (1); §7 dictionary, term "the two ledgers"

## Statement

> The horn is entire of order 1, so Hadamard applies: ξ is determined by its zeros. Its logarithmic derivative, with the zeros paired ρ = ½ ± iγ (the first 150 verified on the line; the tail in the same form), collapses to an **absolutely convergent** sum:
>
> ```
> ξ′/ξ(s) = Σ_γ  2(s−½) / ( (s−½)² + γ² )                                    (1)
> ```
>
> Verified against the direct derivative:
>
> ```
>   s        direct ξ′/ξ                    ledger: 150 zeros + tail        |diff|
>   2        0.06906623153                  0.06906627302                   4.2e−8
>   3+2i     0.1164994564 + 0.0902089923i   0.116499249 + 0.0902093933i     4.5e−7
> ```
>
> The tail past γ₁₅₀ = 318.85 is not estimated — it is **paid exactly by λ₁**: Σ_γ 1/(¼+γ²) = λ₁ = 1 + γ_E/2 − ½ln 4π = 0.0230957089661 (rh10 §5's constant), of which the first 150 zeros supply 0.02064233715, leaving 0.00245337 for the tail.

## Hypotheses and notation

- ξ is the completed zeta function, entire of order 1; γ runs over the non-trivial zero ordinates, paired as ρ = ½ ± iγ.
- The pairing ρ = ½ ± iγ is the source's stated form of the zeros — "the first 150 verified on the line; the tail in the same form" — i.e. the displayed form presumes the pairing about the critical line.
- λ₁ = 1 + γ_E/2 − ½ln 4π = 0.0230957089661 is rh10 §5's constant; γ_E is Euler's constant.
- γ₁₅₀ = 318.85 (source §6: γ₁₅₀ = 318.8531).

## Proof / evidence

The source's one-line derivation is the Hadamard factorization of the order-1 entire ξ ("so Hadamard applies: ξ is determined by its zeros"), whose logarithmic derivative with paired zeros gives (1). Verification: ledger from 150 zeros + tail against the direct derivative at s = 2 (4.2e−8) and s = 3+2i (4.5e−7); §6 repeats these rows. The tail is not estimated but paid by λ₁, with Σ_{k≤150} 1/(¼+γ_k²) = 0.02064233715 and 0.00245337 left for the tail.

## Dependencies and related results

- Hadamard factorization of ξ (order 1) — the multiplicative companion is [the horn's gears are its closures](xihorn-horn-helix-revisited-hadamard-product.md) (4).
- rh10 §5's constant λ₁ → [ξ′/ξ(1) = λ₁](xihorn-horn-helix-revisited-lambda-one-at-one.md) (2).
- [The bridge](xihorn-horn-helix-revisited-the-bridge.md) (3) uses ξ′/ξ to express −ζ′/ζ.

## Notes

- The displayed form (1) is stated "with the zeros paired ρ = ½ ± iγ"; the source records only that the first 150 are verified on the line and the tail is taken "in the same form". Reading (1) as unconditional would presume the pairing; the source does not claim that here.
- §1.4 calls the same structure a chiasm: "the horn multiplies over zeros and, by (3), differentiates into the primes."

- **Correction (2025-10-06, session 003 residual-defect repair).** The Status quoted the better of the source's two displayed rows. `xi-horn/horn-helix-revisited.md:68-69` prints both — `4.2e−8` at `s = 2` and `4.5e−7` at `s = 3+2i` — and this document's own body displays both, so the Status was quoting selectively. No committed script or log computes the ledger; the source is prose only. Both facts are now in the label.
