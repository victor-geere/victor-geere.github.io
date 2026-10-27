# T1 (certified sections)

**Kind:** Theorem
**Status:** PROVED (computer-assisted interval certificate; backend α — 40-digit Cholesky, 90-digit exact-product residual, radius row-sums — conditional on IEEE-754 and libmpdec directed rounding)
**Area:** rh-html
**Source:** [`rh17.html`](../../html/rh17.html) — §5 "The theorems"

## Statement

> Every symmetric Toeplitz matrix whose first row lies within the computed enclosures of E<sub>cert</sub> is positive definite, with λ<sub>min</sub> ∈ [5.45×10⁻¹¹, 5.50×10⁻¹¹], [4.17×10⁻¹³, 4.22×10⁻¹³], [1.43×10⁻¹³, 1.45×10⁻¹³] for the three meshes.

Context fixed immediately before the statement:

> Let E be the kernel above with its exact constants, Δ ∈ {0.06, 0.03, 0.015}, n = 199, 399, 799, and let M<sub>Δ</sub> = [E((i−j)Δ)] be the n×n exact sections. Let E<sub>cert</sub> be the explicitly finite object: pole + S<sub>h</sub><sup>[0,R₀]</sup> − comb at h = 0.05, R₀ = 600, 1200, 3200.

## Hypotheses and notation

- E is rh15's kernel, E(v) = 2B<sub>i</sub>²cosh(v/2) + (1/π)∫₀^∞ B(r)²ψ̃(r)cos(rv)dr − Σ Λ(n)n<sup>−1/2</sup>[C(log n − v) + C(log n + v)].
- Δ ∈ {0.06, 0.03, 0.015}, n = 199, 399, 799 (the three meshes, in that order).
- E<sub>cert</sub> = pole + S<sub>h</sub><sup>[0,R₀]</sup> − comb at h = 0.05, with R₀ = 600, 1200, 3200.
- "the computed enclosures" are the outward-rounded interval rows of the pipeline (§3): finished row enclosures of width ≤ 2.2×10⁻²² (3.2×10⁻²³ at the finest mesh), radius row-sums ρ<sub>Σ</sub> ≤ 2.8×10⁻²⁰.
- Backend α: midpoint row M<sub>c</sub>, shift s, one factorization M<sub>c</sub> − sI ≈ R̂ᵀR̂ at 40 digits, residual F = M<sub>c</sub> − sI − R̂ᵀR̂ with exact products, giving λ<sub>min</sub> ≥ s − ‖F‖<sub>∞</sub> − ρ<sub>Σ</sub> (and − ρ<sub>D</sub> for the exact section).

## Proof / evidence

The source's evidence is the certificate (4): λ<sub>min</sub> ≥ s − ‖F‖<sub>∞</sub> − ρ<sub>Σ</sub>, valid because R̂ᵀR̂ ⪰ 0, hence for every symmetric matrix within the radii of M<sub>c</sub>. Reported numbers: residual ‖F‖<sub>∞</sub> at 7×10⁻⁴⁰ (Δ = 0.06), 7×10⁻⁴⁰ (0.03), 1×10⁻³⁹ (0.015); radii 3×10⁻²⁰, 3×10⁻²⁰, 2×10⁻²⁰; certified floors 5.4×10⁻¹¹, 4.2×10⁻¹³, 1.4×10⁻¹³. An interval Rayleigh quotient with the pilot's eigenvector caps each λ<sub>min</sub> from above (1.45×10⁻¹³ at the finest mesh), "so the certificate is tight, not merely true". The source reports that the pipeline re-derives rh15's stored rows bit for bit (difference 0.0) before any new claim, and that all numbers are produced and asserted by `compute_rh17.py` under 54 named checks. **`compute_rh17.py` is not in this repository** — a search of the whole tree finds no `*rh17*` artefact other than the documents and `rh17.html` itself — so the 54 named checks, the bit-for-bit regression and every constant quoted above are *asserted by the source*, not *reproducible here* (audit repair 2/5).

## Dependencies and related results

- Uses the interval kit of §3 (Decimal with directed rounding; enclosures for π, ln, sin, cos, cosh, sinh, exp, Re ψ).
- Uses the cited Trefethen–Weideman strip bound and the digamma Stirling remainder.
- [T2 — exact sections](rh17-t2-exact-sections.md) transfers T1 to the exact sections via [L1](rh17-l1-tail-never-bounded.md) and [L2](rh17-l2-aliasing-bound.md).
- [T3 — the equation](rh17-t3-the-equation.md) converts positive definiteness into the Schur parameters.

## Notes

- The result is explicitly conditional: "the claims at the end are conditional only on two named hypotheses about machine arithmetic (§5)". Hypotheses in full: (i) IEEE-754 double arithmetic behaves as specified; (ii) libmpdec's Decimal arithmetic rounds correctly in directed-rounding contexts.
- The brackets are ~1.0–1.3% wide; T1 certifies positivity with an explicit floor, "not the exact value of λ<sub>min</sub>".
- The source's own scope limit: "RH — three finite sections are certified, not all sections of all meshes".
