# Lemma (confinement)

**Kind:** Lemma
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §7 "The confinement — why ξ cannot run the witnesses' mechanism"

## Statement

> **Lemma (confinement).** Let f be real entire of genus 0 with f(0) ≠ 0 and
> zeros {z_k} satisfying R := sup_k Re z_k < ∞. Then every zero of f′ has
> real part ≤ R.

## Hypotheses and notation

- f real entire of **genus 0** with f(0) ≠ 0, zeros {z_k} with
  `R := sup_k Re z_k < ∞` (so `Σ 1/|z_k| < ∞`).
- Order ½ implies genus 0 for the functions here.
- For ξ: `F(z) = Ξ(√−z)` is real entire of order ½ (hence genus 0) with
  F(0) = a(0) > 0; its zeros are `z = −t²` over the zeros `½ + it` of ξ, and
  `t = γ − iδ` with `|δ| < ½` (the strip) and `|γ| ≥ γ₁ = 14.1347…` (the first
  zero's height, classical).

## Proof / evidence

The source's proof, verbatim: "f = f(0)·Π(1 − z/z_k) with Σ 1/|z_k| < ∞, so
f′/f = Σ 1/(z − z_k) locally uniformly off the zeros. Let f′(w) = 0. If
f(w) = 0, then w is some z_k. Otherwise Σ_k (Re w − Re z_k)/|w − z_k|² = 0; if
Re w > R every summand is positive — impossible. ∎"

**Application to ξ.** With `t = γ − iδ`, `|δ| < ½`,
`|γ| ≥ γ₁ = 14.1347…`:
```
Re z = δ² − γ² ≤ ¼ − γ₁² = −199.5404…
```
Each F^(n) is again real entire of order ½ with F^(n)(0) = a(n) > 0, so the
lemma applies inductively: **every zero of every derivative F^(n) — real or not
— has real part ≤ ¼ − γ₁² < −199.5.** For F itself the non-real zeros are
exactly the off-line zeros of ξ, and a hypothetical off-line zero has
|γ| > 3 000 175 332 800 (Platt–Trudgian, as quoted in [gorz-gap.md](../../xi-horn/gorz-gap.md) §1.3), so
"any defect of F sits left of ¼ − 9.001 × 10²⁴; the derivatives' defects,
wherever the flow puts them, stay left of −199.5 by the lemma."

Verified numbers (§9): γ₁ = 14.13472514173469379, γ₁² = 199.79045483238685946,
¼ − γ₁² = −199.54045483238685946.

## Dependencies and related results

- The classical Laguerre-type argument on a genus-0 log-derivative; the source
  says in §0 that the lemma "is a Laguerre-type argument on a genus-0
  log-derivative, classical in substance".
- The witnesses it excludes are [the (z²−6z+13)e^z witness](xihorn-initial-segments-witness-z2-6z-13.md),
  [Witness A](xihorn-initial-segments-witness-a-order-half.md) and
  [Witness B](xihorn-initial-segments-witness-b-final-segment.md), whose mechanism is "a defect
  center migrating through the origin".
- Platt–Trudgian height quoted via [gorz-gap.md](../../xi-horn/gorz-gap.md) §1.3; [GOR⁺] Corollary 1.3
  ([jensens-polynomials.pdf](../../xi-horn/jensens-polynomials.pdf)).

## Notes

- The source draws the boundary carefully: "It closes the *literal* mechanism:
  no defect of ξ, at any shift, ever approaches the origin; centers stay pinned
  more than 199 units deep (10²⁴ units, for a genuine off-line defect) in the
  left half-plane, for every derivative, forever. It does **not** close the
  abstract mechanism: the witnesses' D dips because the dimensionless ratio
  x₀²/β² falls, and for a defect at Re ≈ −γ² with |Im| ≈ 2|γ|δ nothing here
  constrains how that ratio evolves under differentiation."
- §11 item 5: "**The confinement lemma does not prove ξ's E(d) are initial
  segments.** It closes one mechanism. §7's last paragraph is the honest
  boundary."
- The height ¼ − γ₁² is a bound on the real part of every zero of every
  derivative F^(n); it says nothing about whether the E(d) are initial segments.
