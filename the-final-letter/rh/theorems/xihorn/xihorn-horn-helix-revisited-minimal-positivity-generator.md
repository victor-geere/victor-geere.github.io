# A positivity generator — a finite (or finitely generated) family whose Weil-positivity implies it for the whole cone

**Kind:** Theorem
**Status:** OPEN (listed by the source as one of the minimal new theorems that would finish the proof; "none within reach by these methods")
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §4.4 "Smallest sufficient statements", item 4

## Statement

> 4. **A positivity generator**: a finite (or finitely-generated) family of test functions whose Weil-positivity implies it for the whole cone. (rh8 §6 is the statement that no such basis is currently known; this is the wall itself.) — **taken up in positivity-generator.md**, which splits the item in two: *finitely generated* is delivered (one Gaussian window and the translation group; RH ⟺ one explicit kernel is positive-definite), and *finite* is refuted (a family with a positive floor is blind above a computable height, so a generating family has no margin at all).

## Hypotheses and notation

- "Weil positivity" is W(h) ≥ 0 for all h = |f̂|² (the criterion in §4.1's top row: "Weil positivity: W(h) ≥ 0 ∀ h = |f̂|²").
- "The whole cone" is the infinite-dimensional cone of test functions; §4.3's compression turns the quantifier over h into a quantifier over v for sup|Ψ| < ∞, "moved, not removed".
- rh8 §6 is cited as the statement that no such basis is currently known.

## Proof / evidence

None here: the source states the item as one of the minimal sufficient theorems, "none within reach by these methods". The source also records the follow-up in [positivity-generator.md](../../xi-horn/positivity-generator.md): "finitely generated is delivered (one Gaussian window and the translation group; RH ⟺ one explicit kernel is positive-definite), and finite is refuted (a family with a positive floor is blind above a computable height, so a generating family has no margin at all)."

## Dependencies and related results

- rh8 §6 (no such basis currently known).
- [positivity-generator.md](../../xi-horn/positivity-generator.md) (the follow-up that splits and partially resolves the item).
- §4.3's "Positivity has a home address": combining the ledgers, RH ⟺ the closure measure Σ δ_γ is the spectrum of the prime comb minus the archimedean comb, and Weil's criterion says the obstruction is exactly the possible failure of positive-definiteness of that difference.

## Notes

- This is an **open problem** at the level of the file (harvested under the SPEC rule for labelled open statements, with Status OPEN), with the source's own pointer that part of it (*finitely generated*) is delivered and part (*finite*) is refuted elsewhere. Those follow-up results are not restated here.
- §4.2's "common terminus" identifies this item as terminus (i), a positivity quantified over a family with no known finite generating structure.
