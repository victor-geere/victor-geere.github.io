# P1 — Schur/Levinson–Durbin equivalence for a Toeplitz section

**Kind:** Theorem
**Status:** PROVED (paper argument, classical)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §6 "What is proven, what is certified, what is not", box `P1 — proven, classical`

## Statement

> For a fixed mesh Δ and every *n*, the section [E((j−k)Δ)]<sub>j,k&lt;n</sub> is positive definite ⟺ σ<sub>k</sub>² > 0 for all k &lt; n ⟺ |ρ<sub>k</sub>| &lt; 1 for all k &lt; n. This is Schur's algorithm and the Levinson–Durbin recursion; the correspondence between such sequences and positive measures on the circle is Verblunsky's theorem. Proof: the recursion computes the Cholesky factorisation of the section, σ<sub>k</sub>² being the successive pivots, so ∏σ<sub>k</sub>² = det — verified numerically here to 1.2×10⁻¹² on a live 60-node slice, alongside the Levinson solver's agreement with Gaussian elimination to 10⁻¹³ and inverse iteration's with the Jacobi eigensolver to 10⁻⁴.

## Hypotheses and notation

- E is the kernel of rh14 (and rh15): built from the primes and the Γ-factor, no zero consulted.
- Δ is the mesh; the section is the Toeplitz matrix [E((j−k)Δ)]<sub>j,k&lt;n</sub>.
- σ<sub>k</sub>² are the prediction errors / successive pivots; ρ<sub>k</sub> the reflection (Schur) coefficients; the recursion is (4): σ₀² = E(0), ρ<sub>k</sub> = [E(kΔ) − ∑<sub>i&lt;k</sub>a<sub>k−1,i</sub>E((k−i)Δ)]/σ<sub>k−1</sub>², σ<sub>k</sub>² = σ<sub>k−1</sub>²(1 − ρ<sub>k</sub>²) > 0 ⟺ |ρ<sub>k</sub>| &lt; 1.

## Proof / evidence

The source gives the classical attribution (Schur's algorithm and the Levinson–Durbin recursion; Verblunsky's theorem for the correspondence with positive measures on the circle) and a proof sketch: the recursion computes the Cholesky factorisation of the section, σ<sub>k</sub>² being the successive pivots, so ∏σ<sub>k</sub>² = det. It reports the numerical checks: ∏σ<sub>k</sub>² against the pivot product to 1.2×10<sup>−12</sup> on a live 60-node slice, the Levinson solver against Gaussian elimination to 10<sup>−13</sup> (10<sup>−8</sup> relative in the closing audit), inverse iteration against the Jacobi eigensolver to 10<sup>−4</sup> (2×10<sup>−3</sup> in the closing audit).

## Dependencies and related results

- [RH ⟺ the Schur sequence never leaves the open unit disc](rh15-rh-equivalent-schur-sequence.md) — the chained corollary of P1–P3.
- [P2 — grid windows are dense](rh15-p2-grid-windows-dense-equivalence.md) — the step from the grid to the line.
- [P3 — Weil's positivity criterion](rh15-p3-weil-positivity-criterion.md) — the cited criterion.
- [The widest positivity certificate](rh15-widest-positivity-certificate.md) — the computed instance of the recursion.

## Notes

- The source labels this box "P1 — proven, classical" and separates it explicitly from the cited P3. The result is classical (Schur 1917; Levinson–Durbin; Verblunsky); the source supplies the proof sketch and numerical checks.
- The source's own framing: the section's positivity, the pivot positivity and the disc conditions |ρ<sub>k</sub>| &lt; 1 are one statement, not three.
