# The notch at Δ* deletes the first zero

**Kind:** Claim
**Status:** VERIFIED (numerical, 60-digit recursion; the section at Δ* is certified positive definite with minimum Schur error 1.5×10⁻⁵; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh19.html`](../../html/rh19.html) — §4 "What the meshes say"; Figure 2

## Statement

> But not monotonically, and the notch says why. The sweep is not increasing: it dips at Δ = 0.18 and Δ = 0.30, and it dips hard at Δ* = 2π/γ₁ = 0.444521. That mesh is exactly the one whose first null r* = 2π/Δ lands on the first zero ordinate γ₁ = 14.1347 — and there the weight the kernel gives that zero is |B(γ₁)|² = 4.6×10⁻⁶⁷, which is zero to every precision that matters. The first zero is deleted from the kernel's spectral measure, and the certified floor falls by 35× against its neighbour at Δ = 0.42.

The source adds two cautions:

> First, positivity <i>survives</i>: the section at Δ* is positive definite, minimum Schur error 1.5×10⁻⁵, as RH requires of every mesh — what collapses is the certifiable margin, not the truth. Second, the mechanism is not a clean law: the weakest surviving low-zero weight predicts the dips qualitatively but not their size, so the honest statement is that the floor is <i>modulated</i> by which zeros sit near the notch ladder, and only at Δ* is the deletion total.

## Hypotheses and notation

- r* = 2π/Δ is the notch (the first null of B); Δ* = 2π/γ₁ = 0.444521 is the mesh whose notch lands on the first zero ordinate γ₁ = 14.1347.
- The sweep is m₀(Δ), the certified floor, at a fixed physical window v ≈ 11, over Δ from 0.06 to 0.60.
- |B(γ₁)|² is the weight the kernel gives the first zero; at Δ* it is 4.6×10⁻⁶⁷.
- "the certified floor falls by 35×" is measured against the neighbour mesh Δ = 0.42.

## Proof / evidence

The source gives the 60-digit recursion verdicts and the certified sections: the coarse ladder rises 328× from Δ = 0.06 to Δ = 0.60, is not monotone, and dips at Δ = 0.18, Δ = 0.30 and hard at Δ*. At Δ* the section is positive definite with minimum Schur error 1.5×10⁻⁵. Figure 2 shows |B(γ₁)|² as the notch sweeps onto γ₁ and states: "All ten meshes are positive definite: positivity survives the notch, as RH requires. What collapses is the certified margin, not the truth." The document's 40 named checks in 243 s include the Δ* identity and the notch dip.

## Dependencies and related results

- [rh18 T3](../rh18/rh18-t3-escape-ball.md) and rh19's [ceiling](rh19-horizon-ceiling.md) share the "coarse is stronger" sweep.
- rh20 §3 uses this as the reference catastrophe: at Δ* the pair floor F = 4.563×10⁻⁶⁷, and "a pair fixes deletion … nothing fixes starvation" ([rh20's Consequence](../rh20/rh20-pair-does-not-give-windows.md)).
- rh15's soft-mode geography ("λmin measures the hat") is the stated reason a wider hat keeps more low zeros.

## Notes


- Harvested as a stated result of the round, though the source does not label it as a theorem; its status is measurement-backed, not proof.
- The source's own hedge is reproduced in the Statement: the mechanism is "not a clean law", the dips are predicted only qualitatively, and only at Δ* is the deletion total.
- rh21's [window barrier](../rh21/rh21-window-barrier.md) quantifies the general obstruction: |ĥ|² ≤ πC(0)/T bounds how much weight any window can hold, which is why a mesh cannot simply be chosen to avoid starvation.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
