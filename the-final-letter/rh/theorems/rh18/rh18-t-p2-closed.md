# T — P2, closed

**Kind:** Theorem
**Status:** PROVED (paper argument; conditional on cited Rosser–Schoenfeld and on IEEE-754/libmpdec for the interval-certified envelope; the RH face is CITED, not reproven)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §5 "The theorem", theorem box "T — P2, closed"

## Statement

> Let 𝒜 be the class of real, continuous, compactly supported g with g′ of bounded variation, and for Δ &gt; 0 let E<sub>Δ</sub> be the arc's kernel (rh15 eq. (1); rh17's exact object). Then the three statements are equivalent: (L) every finite section [E<sub>Δ</sub>((j−k)Δ)] is positive semidefinite, for every Δ; (W) 𝒲(g⋆ǧ) ≥ 0 for every g ∈ 𝒜; (Bo) every E<sub>Δ</sub> is a positive-definite function on ℝ. The arrows: (Bo) ⟹ (L) by restriction; (L) ⟹ (W) by the identity (2), the moduli (3)–(5), and closure of nonnegativity under limits; (W) ⟹ (Bo) by the identity (2) at arbitrary nodes. Furthermore each is equivalent to the Riemann Hypothesis, by Weil's criterion applied to the subclass C<sub>c</sub><sup>∞</sup> ⊂ 𝒜 (cited, not reproven — rh15's P3).

## Hypotheses and notation

- 𝒜 = real, continuous, compactly supported g with g′ of bounded variation (the class fixed in §3; the archimedean term diverges on C⁰, so the class is load-bearing).
- E<sub>Δ</sub> is rh15's kernel; 𝒲 is the Weil functional in the arc's normalization.
- The three faces are [(L)](rh18-face-l-lattice.md), [(W)](rh18-face-w-windows.md), [(Bo)](rh18-face-bo-bochner.md).
- "the identity (2)" is [T1a](rh18-t1a-weil-identity.md); "the moduli (3)–(5)" are the spline moduli and the constants of [T2](rh18-t2-epsilon-bound.md).

## Proof / evidence

The source assembles the arrows and labels each with its carrier: (Bo) ⟹ (L) by restriction to lattice nodes; (L) ⟹ (W) by the identity (2), the moduli (3)–(5) and closure of nonnegativity under limits; (W) ⟹ (Bo) by the identity (2) at arbitrary nodes. Each arrow carries a computed constant (Figure 4): T1a identity residual ≤ 6×10⁻¹⁴ relative; ε(0.015; g₁) = 9.6×10⁻² proven against a measured gap of 7×10⁻⁹; zeros side, 1517 zeros to height 2000, geometric − spectral = 9×10⁻¹³ (g₁), 1×10⁻¹³ (g₂); the escape T3; the sub-lattice wall. Cost: 47 named checks in 2.5 minutes.

## Dependencies and related results

- [T1a](rh18-t1a-weil-identity.md), [T2](rh18-t2-epsilon-bound.md), [T3](rh18-t3-escape-ball.md), and the three faces.
- Closes rh15's proposition P2 and the "open link" recorded in [rh17 T3](../rh17/rh17-t3-the-equation.md).
- Cited: A. Weil (1952) — the criterion behind (W) ⟺ RH; S. Bochner (1932); A. P. Guinand (1948) for the zeros-side reading; J. B. Rosser and L. Schoenfeld (1962).

## Notes

- The source's honest scope: "What is not proven. (L) itself — RH. Every certificate this arc possesses is finitely many sections of the diagonal family … The equivalence is closed; the quantifier is the hypothesis."
- Hypotheses in full, as the source lists them: Rosser–Schoenfeld's ψ(t) &lt; 1.03883t (cited, 1962) under the prime constant's displayed envelope — the sieve value itself is exact and hypothesis-free; IEEE-754 and libmpdec directed rounding behaving as specified; Weil's criterion (cited) for the RH face only. "The equivalence (L) ⟺ (W) ⟺ (Bo) stands on the first two alone."
- A finding the source records alongside the theorem: the certificate does not descend — the certified Δ = 0.06 kernel is indefinite on every sub-lattice (60-digit recursion fails at k = 370 at δ = Δ/2, k = 29 at Δ/16), and parity between dropped tail and notch floor would price a sub-lattice verdict at R₀ ≈ 1.4×10⁵.
