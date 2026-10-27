# The row cannot see the winding: E(v) is even, and folded = unwrapped to 3.3×10⁻¹⁴

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh34.html`](../../html/rh34.html) — §2 "The lift, and what the row cannot see"

## Statement

> Now the part that matters. **E(v) is even.** The row the arc has bounded since rh17 is E(kΔ) = ∑<sub>γ</sub> ĥ(γ)² cos(kΔγ), and a cosine cannot tell which way anything turned. Evaluated on the *unwrapped* ordinates it agrees with rh33's wrapped row to 3.3×10⁻¹⁴ of the mass. Nothing but the folded angle multiset survives.

> And the fold is not a technicality. At Δ = 0.12 the 4,308 ordinates below 4800 wind 92 times round the circle, so 47 of them land on each turn on top of one another; at Δ = 0.24, 23.5; at 0.06, 94. The winding count is discarded wholesale.

## Hypotheses and notation

- E(v) = ∑<sub>γ</sub> ĥ(γ)² cos(vγ) is the arc's moment function; the Toeplitz row is E sampled at v = kΔ.
- 4,308 ordinates of rh29's zero table, γ ≤ 4800; Δ ∈ {0.06, 0.12, 0.24}.
- "rh33's wrapped row" is the row built after reducing the ordinates mod 2π/Δ.

## Proof / evidence

Numerical: the unwrapped row reproduces the wrapped row to 3.3×10⁻¹⁴ of the mass; the winding counts at Δ = 0.12, 0.24, 0.06 are 92, 183 and 46 turns with 47.0, 23.5 and 94.0 ordinates landing on every turn. The mechanism is that a cosine keeps nothing but the folded angles, so E on the unwrapped ordinates and E on their folds are the same numbers.

## Dependencies and related results

- [rh17](../rh17/rh17-t1-certified-sections.md) — where the first Toeplitz row was sampled on a lattice; the source's correction is that mod 2π entered *there*, not at rh29.
- [rh29-explicit-formula-right-to-left](../rh29/rh29-explicit-formula-right-to-left.md) — the wrapped measure, cleared of the charge.
- rh30's N<sub>eff</sub>, rh31's emptiest arc, rh32's void law, rh33's refutation — five documents the source says were conducted on an object that had already thrown the winding away.

## Notes


- The source states plainly that this is the objection sustained against the whole line rh29–rh33, and that it is "not comfortable"; the certified row never encoded the winding at all.
- This is a statement about what the sampling can see, not about the underlying measure; the measure and the row are different objects.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
