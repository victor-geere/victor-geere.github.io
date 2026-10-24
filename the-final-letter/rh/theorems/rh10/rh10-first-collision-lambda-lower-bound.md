# The first collision: γ₄, γ₅ merge at λ* = −0.9885

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §3 "The thermometer: the flow, run cold"

## Statement

> At λ = 0 the computed flow reproduces the first eight ordinates to 2×10<sup>−3</sup>. Run cold, the zeros drift pairwise together, and the first collision is found by bisection: **γ₄ and γ₅ merge at λ* = −0.9885**, at height *t* = 33.10. For λ < λ* that pair is complex — so this computation, by itself, proves Λ ≥ −0.9885.

The scoreboard states the same reading as: "first collision at λ* = −0.9885 ⇒ Λ ≥ −0.9885 from this data".

## Hypotheses and notation

- The flow is *H*<sub>λ</sub>(*t*) = 4 ∫<sub>0</sub><sup>∞</sup> Φ(*u*) *e*<sup>λ*u*²</sup> cos(*ut*) d*u* (§3, equation (3)); γ₁…γ₈ are the first eight ordinates; Λ is the de Bruijn–Newman constant.
- The collision λ* is found by bisection; the source does not state a floating-point error bar for it beyond the reproduction check.

## Proof / evidence

The source describes the computation, not a proof: the flow is computed, run backwards, and the first pairwise collision of γ₄ and γ₅ is located by bisection at λ* = −0.9885 and height *t* = 33.10. It then infers Λ ≥ −0.9885 because for λ < λ* that pair is complex. The source's wording is "this computation, by itself, proves Λ ≥ −0.9885"; the honest status of a floating-point flow computation is recorded here as VERIFIED (numerical).

## Dependencies and related results

- [The de Bruijn–Newman threshold](rh10-de-bruijn-newman-threshold.md) — the threshold against which this bound is read; RH ⟺ Λ = 0, with Λ ≥ 0 proved by Rodgers–Tao.
- rh11 §3 validates its zero-dynamics model against exactly this collision (ODE gives λ* = −0.98899 against −0.9885 from Ξ itself, agreement 0.1%).
- rh11 and rh12 continue the same experiment with tighter Lehmer pairs.

## Notes


- The source's own hedge: "The historical lower bounds improved exactly this experiment: closer pairs higher up — Lehmer pairs — collide at λ much nearer 0, and Rodgers–Tao closed the gap to 0 entirely."
- Do not read this as a proof: it is a computed collision, and the source quotes it beside (not in place of) the literature's rigorous ladder.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
