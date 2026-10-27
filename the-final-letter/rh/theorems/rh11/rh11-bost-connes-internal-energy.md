# Bost–Connes internal energy: U(β) = −ζ′/ζ(β) = ∑ Λ(n) n^{−β}

**Kind:** Theorem
**Status:** CITED (literature, Bost–Connes 1995; verified numerically to 3×10⁻¹¹)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §5 "Spec ℤ over 𝔽₁: the determinant dream, computed", equation (5)

## Statement

> <b>The gas.</b> Bost–Connes (1995) built a quantum statistical system whose partition function is ζ: states indexed by the numerals, energies log *n*, so Tr e<sup>−βH</sup> = ∑n<sup>−β</sup> = ζ(β). Its symmetry group is Ẑ<sup>×</sup> — rh7 §5's profinite dial, the arc's own symmetry — and its internal energy is
>
> U(β) = −(ζ′/ζ)(β) = ∑<sub>*n*≥2</sub> Λ(*n*)&#8202;*n*<sup>−β</sup> :
>
> the von Mangoldt weights — the gear weights the arc has summed since rh5 — are the energy of the gear gas.

## Hypotheses and notation

- H is the Bost–Connes Hamiltonian; β the inverse temperature; states indexed by the numerals with energies log *n*.
- Λ is the von Mangoldt function; ζ′/ζ is the logarithmic derivative of ζ.
- ∑<sub>*n*≥2</sub> Λ(*n*)*n*<sup>−β</sup> = −ζ′/ζ(β) is the Dirichlet series identity in the region of convergence.

## Proof / evidence

The source cites the Bost–Connes system and its thermodynamics (Bost–Connes 1995) and gives no proof. It reports the numerical verification both ways at β = 2 and 2½ (prime side summed to 10⁶ with PNT tail): agreement 3×10<sup>−11</sup>. The source's reading: "The numeral train is not *like* a statistical system; it is one, and its thermodynamics is the prime-counting the arc started from." The pole at β = 1 is the system's phase transition; the symmetry group is Ẑ<sup>×</sup>.

## Dependencies and related results

- [Soulé's ζ over 𝔽₁](rh11-soule-zeta-over-f1.md) and [the Hadamard product for ξ](rh11-hadamard-product-for-xi.md) — the other computed shadows of the base in the same section.
- rh5's gear weights and rh7 §5's profinite dial are the arc's earlier appearances of the same objects.

## Notes

- The identity U(β) = −ζ′/ζ(β) = ∑Λ(n)n<sup>−β</sup> is classical (the von Mangoldt Dirichlet series) and the Bost–Connes system is cited literature; the source contributes the verification to 3×10<sup>−11</sup>.
