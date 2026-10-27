# (c) Sharp, and it subsumes the family ceilings

**Kind:** Corollary
**Status:** PROVED (paper argument) — subsumes CITED (rh24 §3, rh25 §4) family ceilings
**Area:** rh-html
**Source:** [`rh27c.html`](../../html/rh27c.html) — §4 "(c) Sharp, and it subsumes the family ceilings"

## Statement

> rh24 §3 computed a ceiling for the M-family by a min–max duality, one family at a time, and rh25 §4 extended the ladder: M = 8: 2.809, M = 16: 3.515, M = 32: 4.211, M = 64: 4.904, M = 128: 5.596. Every one of them is (4) evaluated at that family's own band edge πM/Δ, to within 0.8%. Five theorems, proved separately at increasing cost, are five points on one curve. And the observation that raised the question in the first place — that the ceilings "grow along the ladder" by about ln 2 per doubling of M and do not converge — is now not an observation but an identity: they are ln of a quantity that doubles.
>
> **What that means for the published results.** Nothing rh22–rh25 asserted is affected; those ceilings remain theorems about the families they were computed for, and they are now also corollaries. What changes is that the family index was never the essential penalty. It was a proxy for ‖h′‖<sub>2</sub>/‖h‖<sub>2</sub>, which is what the archimedean term actually sees.

## Hypotheses and notation

- The M-family ceilings are rh24 §3's and rh25 §4's, computed one family at a time by a min–max duality.
- Each is recovered from (4) of rh27c at the family's own band edge πM/Δ.
- The band edge πM/Δ is where the family's generator mesh δ = Δ/M sits at frequency π/δ.
- The values 2.809, 3.515, 4.211, 4.904, 5.596 are the published ceilings at M = 8, 16, 32, 64, 128.

## Proof / evidence

Paper argument plus numerical comparison: each of the five published ceilings equals (4) evaluated at πM/Δ "to within 0.8%". The source states the growth by ≈ ln 2 per doubling of M is "now not an observation but an identity: they are ln of a quantity that doubles". The check suite reports "every one of the five family ceilings rh22–rh25 published is recovered".

## Dependencies and related results

- [rh27c-family-free-ceiling](rh27c-family-free-ceiling.md) — the single bound that recovers them.
- rh24 §3 and rh25 §4 — the cited originals; the source is explicit that they "remain theorems about the families they were computed for".

## Notes

- This is not a refutation of the family ceilings; the source says nothing rh22–rh25 asserted is affected.
- The Kind is Corollary because the source presents the family ceilings as corollaries of the one bound.
