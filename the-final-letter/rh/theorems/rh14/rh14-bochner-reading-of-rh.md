# RH ⟺ E is positive-definite on every interval (Bochner's reading)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh14.html`](../../html/rh14.html) — §6 "What the alignment settles, and what it sharpens" (and the abstract)

## Statement

> The honest grammar of the continuum claim, stated once. RH is equivalent (Weil; Bochner's language) to: *E* is a positive-definite function on every interval — every finite slice of every mesh has a nonnegative spectrum.

The abstract states the same reading: "What remains open (§6) is unchanged in content and improved in form: RH ⟺ the one function E is positive-definite on every interval — Bochner's reading — and this document's slices are its certificates, now manufacturable at will from a single computed kernel."

## Hypotheses and notation

- E is the merged kernel of equation (1): E(v) = ∑<sub>ρ</sub>|B(γ<sub>ρ</sub>)|²cos(γ<sub>ρ</sub>v).
- "On every interval" means every Toeplitz slice G[j,k] = E(y<sub>j</sub>−y<sub>k</sub>) at every mesh Δ and support a.
- Positive-definiteness is read in Bochner's sense for the function E; the equivalent form is the Weil positivity of rh10 §1.

## Proof / evidence

The source cites the equivalence (Weil; Bochner's language) and gives no proof. Its own contribution is the certificate ladder harvested separately: four nested slices, all positive, λ<sub>min</sub> monotone, 446 eigenvalues none negative — with the explicit warning that "the statement itself quantifies over all levels at once. What the alignment changes is not that gap — nothing finite closes it — but its economics."

## Dependencies and related results

- [Weil positivity: W(h) ≥ 0 for every h = |f̂|²](../rh10/rh10-weil-positivity-criterion.md) — the equivalent criterion.
- [The merged kernel: one function, two theories](rh14-merged-kernel-one-function.md) — the function E.
- [The nested-slice exhaustion is positive](rh14-nested-slice-exhaustion-positive.md) — the finite certificates.
- [RH ⟺ the Schur sequence never leaves the disc](../rh15/rh15-rh-equivalent-schur-sequence.md) — rh15's later, smaller form of the same hypothesis.

## Notes

- Classical (Weil; Bochner's language); the equivalence is stated, not proved, in this source.
- The source is explicit that the finitely many slices are certificates, not the statement: "the slices computed here are certificates of that statement at four levels of a family whose union is dense."
