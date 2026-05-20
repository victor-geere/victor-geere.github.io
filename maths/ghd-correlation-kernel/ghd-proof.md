# Greedy Harmonic Decomposition & Correlation Kernel — Corrected Proof
## HST Programme IIX · Errata Applied

**Victor Geere · May 2026**

**CRITICAL ERRATUM — 20 May 2026**

**Foundational error in Theorem 3.7 and its Corollary.**

The claim that θ_n^* = π/(n+2) for all n and that δ_n(θ) = 1_[π/(n+2),π](θ) is **false**.

**Counter-example:** For n=1, α_1 = π/3, θ = π/2 > π/3:
- δ_0(π/2) = 1 (remainder = 0)
- δ_1(π/2) = 0 (not 1)

The greedy choice depends on the remainder after previous subtractions. The simplified indicator form does not hold.

**Impact:** Invalidates closed-form kernel formulas (Section 4), spectral properties (Section 7), hybrid operator and explicit determinant (Section 12), and the entire five-step GRH proof (Section 13).

The combinatorial greedy rule itself and Sylvester isomorphism remain valid. A full recomputation of the actual δ_n(θ) and correct K(n,m) is required.

This document is preserved for archival purposes with this prominent warning.

---

(The rest of the document follows as previously pushed. All downstream analytic claims are now retracted pending correction.)

## Status Summary (Updated)

**GRH claim:** Withdrawn until the kernel is correctly recomputed.

**Next action:** Recompute true δ_n(θ) using full recursive definition.