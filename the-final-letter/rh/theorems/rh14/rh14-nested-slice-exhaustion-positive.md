# The nested-slice exhaustion is positive

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh14.html`](../../html/rh14.html) — §4 "The exhaustion: finite slices of one continuous form"

## Statement

> Toeplitz slices G[j,k] = E(y<sub>j</sub>−y<sub>k</sub>) at four nested (support, mesh) levels — 49, 99, 99, 199 dimensions, meshes 0.06 and 0.03, supports 3 and 6 — all positive, with λ<sub>min</sub> falling monotonically along both nesting directions (1.3×10⁻⁸ → 6.6×10⁻¹⁰ → 2.3×10⁻¹¹) exactly as the variational principle demands of a single continuous form exhausted by finite slices, and never through zero.

## Hypotheses and notation

- Refine the mesh (hats of width 0.06 are exact sums of hats of width 0.03) and widen the support; the space of windows grows, and the union over all meshes and supports is dense in every space of admissible windows.
- "Turn the finite slices into a continuum" means: the same kernel serves every level, and eigenvalue monotonicity holds along every nesting (the variational principle — a bigger space can only find softer directions).
- The eigenvalues are those of the Toeplitz slices of the merged kernel E.

## Proof / evidence

The source reports the four nested slices (n = 49, 99, 99, 199; meshes 0.06 and 0.03; supports 3 and 6), all positive, with λ<sub>min</sub> falling monotonically 1.3×10<sup>−8</sup> → 6.6×10<sup>−10</sup> → 2.3×10<sup>−11</sup> and never crossing zero; 446 eigenvalues computed in the document, none negative. The closing audit: "λ<sub>min</sub> monotone along both nesting directions within 2% slack, rh14's four eigenvalues reproduced to 0.15%".

## Dependencies and related results

- [The merged kernel: one function, two theories](rh14-merged-kernel-one-function.md) — the continuous form being exhausted.
- [The Gram matrix as a fold of the kernel](rh14-gram-matrix-as-fold-of-kernel.md) — the fold that makes the slices cheap.
- [RH ⟺ E is positive-definite on every interval](rh14-bochner-reading-of-rh.md) — the statement these slices certify at four levels.
- rh15 §3 continues this ladder (ten slices, supports to 6) and identifies the soft tail as the mesh's own null.

## Notes


- The source states the gap plainly: the slices are certificates at four levels of a dense family; the continuum statement "quantifies over all levels at once", and "nothing finite closes it".
- The monotonicity is a consistency check with the variational principle, not a proof of positivity at unseen levels.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
