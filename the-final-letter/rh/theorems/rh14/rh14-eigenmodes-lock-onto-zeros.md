# Eigenmodes lock onto the zeros

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh14.html`](../../html/rh14.html) — §5 "The spectrum: the continuum arrives"

## Statement

> at the finest slice the continuum shows its face — the sixteen sharpest eigenmodes sit on the zeros themselves, sixteen measured mode-frequencies landing on seven distinct ordinates with worst offset 0.095 against a resolution cell of 1.05, their eigenvalues riding the per-zero envelope nB(γ)², the trace tying the whole spectrum to the zeros side at 3×10⁻⁴. The finite slices do not approximate some foreign continuum: their continuum is the spectrum of ζ.

## Hypotheses and notation

- The form is ∑<sub>ρ</sub> of rank-one pieces, one pair per zero (a cosine and a sine profile at frequency γ); once the slice resolves frequencies finer than the zero spacing, its top eigenvectors are those pieces.
- The slice is the 199-dimensional one; the resolution cell is π/a = 1.05.
- The sixteen modes land on seven distinct ordinates, in clusters of two and three (the quasi-degenerate cosine/sine pairs mixing where eigenvalues nearly tie); the dashed envelope is the per-zero weight nB(γ)², ratios 0.4–1.8, exact for isolated zeros.

## Proof / evidence

The source reports the mode frequencies, the worst offset 0.095 (thirty times finer than the slice's resolution cell), the eigenvalue envelope nB(γ)², and the trace tying the spectrum to the zeros side at 3×10<sup>−4</sup>. The closing audit adds: "the trace tying the whole spectrum to the zeros side at 3×10⁻⁴."

## Dependencies and related results

- [The nested-slice exhaustion is positive](rh14-nested-slice-exhaustion-positive.md) — the slices whose top eigenvectors these are.
- [The merged kernel: one function, two theories](rh14-merged-kernel-one-function.md) — the form whose rank-one pieces are per-zero.
- rh15 §3 re-reads the bottom of the same spectrum (the soft tail) and rh16 §4 calibrates it against surrogate processes.

## Notes


- This is a spectral observation at one finite slice, not a theorem about the continuum; the source reads it as "the continuum limit … arriving mode by mode".

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
