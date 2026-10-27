# Selberg's bracket: L¹ deficiency exactly 1/δ, falling in the type

**Kind:** Claim
**Status:** VERIFIED (numerical, pointwise to 3.2×10⁻¹⁵ at four intervals and four types; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh37.html`](../../html/rh37.html) — §3 "The machinery"

## Statement

> From B, Selberg's majorant and minorant bracket any interval's indicator at any type 2πδ, verified pointwise to 3.2×10<sup>−15</sup> at four intervals and four types. Their L¹ deficiency is **exactly 1/δ** — independent of the interval's length, and *falling* in the type rather than growing in it. That last clause is precisely what rh30 §5's three routes lack: Gershgorin, Koksma and Marcinkiewicz–Zygmund all lose *linearly* in the degree. It is why (b) looked worth taking.

## Hypotheses and notation

- B is [Beurling's majorant](rh37-majorant-b-and-pole-free-form.md); the bracket majorises and minorises an interval's indicator at any type 2πδ.
- The L¹ deficiency is ∫(majorant − indicator) + ∫(indicator − minorant); δ is the type parameter.
- The comparison: Gershgorin, Koksma and Marcinkiewicz–Zygmund lose linearly in the degree (rh30 §5).

## Proof / evidence

Numerical: the bracket is verified pointwise to 3.2×10⁻¹⁵ at four intervals and four types; its L¹ deficiency is exactly 1/δ, independent of the interval's length, and falls in the type.

## Dependencies and related results

- [rh37-majorant-b-and-pole-free-form](rh37-majorant-b-and-pole-free-form.md) — the function the bracket is built from.
- [rh37-worst-case-bounds-all-fail](rh37-worst-case-bounds-all-fail.md) — the two ideas rh30 §10 (b) attached to this family, both refuted.
- rh30 §10 (b): "Beurling–Selberg majorants are the obvious family and the arc has never tried them."

## Notes


- The deficiency 1/δ is stated "exactly" in the source; the 3.2×10⁻¹⁵ is the pointwise verification precision of the bracket, not the precision of the deficiency.
- The source says this falling-in-the-type behaviour is why (b) looked worth taking — before both attached ideas failed.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
