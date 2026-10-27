# The collision-time law τ* = g₀²/8 for a tight pair

**Kind:** Proposition
**Status:** PROVED (paper argument; measured to 1%)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §3 "Dig two — the hunt: pushing λ* toward the wall"

## Statement

> For a tight pair the dynamics reduces to a one-line law: keeping only the mutual term, dg/dτ = −4/g gives τ* = g₀²/8 — the collision time is an eighth of the squared gap.

The source's abstract states the measured side: "all measured collision times obey τ* = gap²/8 to 1%".

## Hypotheses and notation

- Under backward heat flow the zeros repel pairwise (equation (1)): d*x*<sub>k</sub>/dτ = −2 ∑<sub>*j*≠*k*</sub> 1/(*x*<sub>k</sub> − *x*<sub>j</sub>), with τ = −λ.
- For a tight pair, only the mutual term is kept: g is the pair's gap, g₀ its initial value, τ* the collision time.
- The four computed collisions give measured ratios τ*/(g²/8) = 1.00, 1.01, 1.01.

## Proof / evidence

The source derives the law analytically from the reduced one-line dynamics (dg/dτ = −4/g) and checks it numerically: the four computed collisions lie on the dashed g²/8 law with measured ratios 1.00, 1.01, 1.01, spanning from the validation pair (γ₄, γ₅, rh10's experiment) down to λ* = −0.00119. The model itself was validated against rh10's direct integral: the ODE collides γ₄, γ₅ at λ* = −0.98899 against −0.9885 from Ξ itself (agreement 0.1%, inside the stated 8% acceptance).

## Dependencies and related results

- [The first collision: γ₄, γ₅ merge at λ* = −0.9885](../rh10/rh10-first-collision-lambda-lower-bound.md) — the validation pair.
- [The Lehmer-pair collision bound λ* = −0.00119](rh11-lehmer-pair-collision-bound.md) — the tightest computed collision, on this law.
- rh12 §3 continues the same law at height 10⁶ (holding to 0.1%).

## Notes

- The source's own reading: "That law is the whole economics of the hunt: the computed bound is set by the tightest pair you have found, quadratically."
- The law is a reduction of the pair dynamics, not a theorem about ζ; the numerical collision times are measurements of the validated dynamical model.
