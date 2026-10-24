# T3 (the equation)

**Kind:** Theorem
**Status:** PROVED (paper argument, classical Toeplitz/Schur equivalence; applied to the exact sections via T1–T2; conditional on IEEE-754 and libmpdec directed rounding)
**Area:** rh-html
**Source:** [`rh17.html`](../../html/rh17.html) — §5 "The theorems"

## Statement

> Positive definiteness of a Toeplitz section is equivalent to all its reflection coefficients lying in (−1, 1) with all prediction errors positive. Therefore every one of the 198 + 398 + 798 = 1394 Schur parameters of the three exact sections of E lies strictly inside the open unit disc — rh15's reading, σ<sub>k</sub>² = σ<sub>k−1</sub>²(1 − ρ<sub>k</sub>²) with |ρ<sub>k</sub>| &lt; 1 at every step, as a theorem about the kernel.

## Hypotheses and notation

- The Toeplitz sections are the M<sub>Δ</sub> of [T2](rh17-t2-exact-sections.md), at Δ ∈ {0.06, 0.03, 0.015} with n = 199, 399, 799.
- ρ<sub>k</sub> are the reflection coefficients (Schur parameters) and σ<sub>k</sub>² the prediction errors of the Levinson–Durbin recursion σ<sub>k</sub>² = σ<sub>k−1</sub>²(1 − ρ<sub>k</sub>²).
- The counts 198 + 398 + 798 = 1394 are the n − 1 reflection coefficients of the three sections.

## Proof / evidence

The equivalence is classical (Schur 1917, Verblunsky 1935, Levinson 1947, Durbin 1960 — all in the source's reference list); the content of T3 is its application: the source notes that positive definiteness of the whole section is equivalent to every |ρ<sub>k</sub>| &lt; 1, so the theorem covers all 1394 coefficients without the recursion ever certifying most of them individually. The source reports the complementary numerical backend β: run forward on intervals, the finest mesh certifies only k ≤ 62 of 798, "the wall is dependency, not digits"; β still certifies |ρ<sub>k</sub>| &lt; 1 with margins 0.4034, 0.6338, 0.7808 over its tight prefixes (k ≤ 18, 31, 60).

## Dependencies and related results

- [T1](rh17-t1-certified-sections.md) and [T2](rh17-t2-exact-sections.md) supply the positive definiteness.
- Cited literature: I. Schur (1917), S. Verblunsky (1935), N. Levinson (1947), J. Durbin (1960); B. Simon, *Orthogonal Polynomials on the Unit Circle* (2005).
- The source states that rh15's proposition P2 (the continuity/density step from finite certificates to the full Bochner statement) "is untouched and remains the open link" — closed a round later in rh18's T.

## Notes

- The source is explicit that this is "rh15's reading … as a theorem about the kernel", i.e. the new content is the unconditional availability of the equivalence for these sections, not the equivalence itself.
- The two machine hypotheses of T1/T2 remain in force: IEEE-754 and libmpdec directed rounding behaving as specified.
- The source's scope warning applies: "RH — three finite sections are certified, not all sections of all meshes".
