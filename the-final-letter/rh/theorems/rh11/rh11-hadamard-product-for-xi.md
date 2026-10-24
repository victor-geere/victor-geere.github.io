# The Hadamard product for ξ, tested at scale

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §5 "Spec ℤ over 𝔽₁: the determinant dream, computed", equation (4)

## Statement

> ξ(s) = ξ(0) ∏<sub>γ>0</sub> [ 1 + s(s−1)/(¼+γ²) ] ,
>
> and with the new table the product is testable at scale: 1517 zero factors, the tail beyond T = 2000 supplied by the density integral (the rh10 constant, log-tail s(s−1)·∑<sub>γ>T</sub> 1/(¼+γ²) with ∑<sub>γ>T</sub> ≈ 5.38×10<sup>−4</sup>). Against direct ξ — Euler–Maclaurin ζ times the Γ-factor — the product agrees to 1.1×10<sup>−8</sup> across the whole interval σ ∈ [−1.5, 3].

## Hypotheses and notation

- γ runs over the positive imaginary parts of the non-trivial zeros; ξ is the completed zeta function.
- The product is truncated at T = 2000 (1517 factors) with a density-integral tail; "direct ξ" is the Euler–Maclaurin ζ times the Γ-factor.
- The source calls this Deninger's dream read at computation's level: ξ as a regularised determinant det(s − Θ) over a hypothetical cohomology.

## Proof / evidence

The source cites the product (Hadamard) and gives no proof. It reports the numerical test: agreement 1.1×10<sup>−8</sup> across σ ∈ [−1.5, 3], "through both trivial-zero-free flanks and the central point ξ(½) = 0.49712…, and the factor at s = ½+iγ₁ vanishes identically to 10<sup>−12</sup>". Its own summary: "The spectrum is the function, eight digits deep. What is missing is only everything: an operator Θ whose eigenvalues those zeros are, acting on a space with a positive form — the determinant exists, the cohomology it would be the determinant of does not."

## Dependencies and related results

- [Soulé's ζ over 𝔽₁](rh11-soule-zeta-over-f1.md) — the factor s(s−1) that completes ζ to ξ, produced from counting.
- [Bost–Connes internal energy](rh11-bost-connes-internal-energy.md) — the other computed shadow of the base in §5.
- rh10 §5's λ₁ and the density tail constant are used in the tail sum.

## Notes

- Classical literature (Hadamard); the source gives no proof and does not claim one.
- The 1.1×10<sup>−8</sup> is a floating-point agreement of a truncated product with direct ξ at the stated band limit, not an identity proof.
