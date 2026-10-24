# The de Bruijn–Newman constant: RH ⟺ Λ = 0

**Kind:** Theorem
**Status:** CITED (literature; Λ ≥ 0 PROVED by Rodgers–Tao)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §3 "The thermometer: the flow, run cold"

## Statement

> The de Bruijn–Newman constant Λ is the threshold: all zeros real exactly for λ ≥ Λ. RH ⟺ Λ ≤ 0; Rodgers–Tao proved Λ ≥ 0; so RH ⟺ Λ = 0.

The source's scoreboard row states it as: "the thermometer (de Bruijn–Newman) — Λ ≤ 0 (with Λ ≥ 0 proved: Λ = 0)".

## Hypotheses and notation

- The completed horn's Jacobi kernel Φ (rh6 eq. 8) is deformed by heat: *H*<sub>λ</sub>(*t*) = 4 ∫<sub>0</sub><sup>∞</sup> Φ(*u*) *e*<sup>λ*u*²</sup> cos(*ut*) d*u*, with *H*₀ = Ξ (§3, equation (3)).
- Forward heat (λ > 0) smooths the kernel and herds the zeros toward regularity; backward heat (λ < 0) roughens it; far enough back, real zeros collide in pairs and leave the line.
- Λ is the threshold: all zeros real exactly for λ ≥ Λ.

## Proof / evidence

The source cites the equivalence RH ⟺ Λ ≤ 0 and the Rodgers–Tao theorem Λ ≥ 0 as literature and gives no proof of them. What it computes is the flow itself: at λ = 0 the computed flow reproduces the first eight ordinates to 2×10<sup>−3</sup>; run cold, γ₄ and γ₅ merge at λ* = −0.9885 (see the separate harvested claim); run warm, the normalised spacing spread of the first eight zeros drops from 0.360 at λ = 0 to 0.310 at λ = ½.

## Dependencies and related results

- [The first collision: Λ ≥ −0.9885 from this data](rh10-first-collision-lambda-lower-bound.md) — the computed lower bound made from the same flow.
- [Weil positivity criterion](rh10-weil-positivity-criterion.md), [Li's criterion](rh10-li-criterion.md), [Beurling–Nyman criterion](rh10-beurling-nyman-criterion.md) — the other three instruments.
- rh11 §3 and rh12 §3 continue the same experiment at greater height (Lehmer pairs).

## Notes

- The equivalence RH ⟺ Λ = 0 is classical in form and RH itself is open; the Λ ≥ 0 half is a cited theorem (Rodgers–Tao 2018), not a computation.
- The source's reading: "every instrument says [RH] independently", and "the thermometer sits (by Rodgers–Tao) exactly at its threshold".
