# P2 — grid windows are dense; E positive-definite on Δℤ ⟺ Weil's form nonnegative

**Kind:** Theorem
**Status:** PROVED (paper argument, with the analytic care named)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §6 "What is proven, what is certified, what is not", box `P2 — proven, with the analytic care named`

## Statement

> The windows realisable on the grid — f = (hat of width Δ) ⋆ (weights on Δℤ ∩ [−a, a]) — are dense, as Δ → 0 and a → ∞, in the compactly supported test functions of the Weil functional, and the functional is continuous in the relevant norm (its prime sum is bounded by ∑<sub>n≤e<sup>a</sup></sub>Λ(n)n<sup>−1/2</sup>‖g‖<sub>∞</sub>, its archimedean term by ‖ĥ‖<sub>1</sub>). Hence: *E is positive-definite on Δℤ for every Δ > 0* ⟺ *Weil's quadratic form is nonnegative on every compactly supported window*. The step from a dense grid to the line is continuity of E, which is manifest from (1).

## Hypotheses and notation

- The realisable windows are f = (hat of width Δ) ⋆ (weights on Δℤ ∩ [−a, a]).
- The Weil functional is the explicit-formula functional of [rh10 §1](../rh10/rh10-riemann-weil-explicit-formula.md); its prime sum is bounded by ∑<sub>n≤e<sup>a</sup></sub>Λ(n)n<sup>−1/2</sup>‖g‖<sub>∞</sub> and its archimedean term by ‖ĥ‖<sub>1</sub>.
- E is the kernel of (1) in the same section; its continuity is "manifest from (1)".

## Proof / evidence

The source gives the density argument for the realisable windows, names the two continuity bounds, and states the equivalence between positive-definiteness of E on Δℤ for every Δ > 0 and nonnegativity of Weil's quadratic form on every compactly supported window, with the passage from the dense grid to the line by continuity of E. No further proof is written out; the source labels the box "P2 — proven, with the analytic care named".

## Dependencies and related results

- [P1 — Schur/Levinson–Durbin equivalence](rh15-p1-schur-levinson-durbin-equivalence.md) — the finite-section half of the chain.
- [P3 — Weil's positivity criterion](rh15-p3-weil-positivity-criterion.md) — the cited criterion the equivalence feeds into.
- [RH ⟺ the Schur sequence never leaves the open unit disc](rh15-rh-equivalent-schur-sequence.md) — the chained corollary.
- [RH ⟺ E is positive-definite on every interval](../rh14/rh14-bochner-reading-of-rh.md) — rh14's Bochner form of the same statement.

## Notes

- The source's own qualifier is in the box label: "proven, with the analytic care named" — the density statement and the two continuity bounds are the care it names.
