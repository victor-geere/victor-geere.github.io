# The power-iteration correction: the best response is exact at 8 coefficients but its vector is off by sin(angle) = 6.1×10<sup>-1</sup> at 64

**Kind:** Proposition
**Status:** VERIFIED (numerical, measured against Lanczos with full reorthogonalisation; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh24.html`](../../html/rh24.html) — §3 "(a) Where the families converge", paragraph "A correction first"

## Statement

> rh22 and rh23 computed the family's best response to a test vector as the top generalised eigenpair of (M<sub>c</sub>, G), by a power iteration on the whitened form shifted by σ = max row sum + 1. That shift makes the ratio of successive eigenvalues (σ+λ₂)/(σ+λ₁) approach 1 as the dimension grows. Measured against Lanczos with full reorthogonalisation over eight test vectors: at 8 coefficients the two agree to 5.6×10<sup>-16</sup>; beyond that the *value* drifts by up to 2.2×10<sup>-3</sup>, which is harmless because rh22 and rh23 quoted factors of two and three. The *vector* is what the search follows, and at 64 coefficients it is off by sin(angle) = 6.1×10<sup>-1</sup> — enough that the cutting-plane direction is wrong and the line search finds nothing at any step size. That is what stalled the first attempt at this section.
>
> With Lanczos the ladder runs. It also, uncomfortably, improves rh22 and rh23's own families: re-searching M = 8 and M = 16 beats their published optima by up to 1.35×. **Their searches were local.** Nothing they asserted is wrong — every published value still sits under its published ceiling, and the ceiling is a theorem while the search is a heuristic — but "near the family's best" was a claim about the ceiling, not about the search, and this document is the reason to say so plainly.

## Hypotheses and notation

- The family's best response to a test vector c is the top generalised eigenpair of (M<sub>c</sub>, G), where M<sub>c</sub> is the quadratic-form matrix and G the energy Gram matrix (see [rh22's ceiling (3)](../rh22/rh22-ceiling-for-every-window.md)).
- The shift is σ = max row sum + 1 on the whitened form; λ₁, λ₂ are successive eigenvalues.
- "sin(angle)" is the sine of the angle between the computed and the true eigenvector; Lanczos with full reorthogonalisation is the reference method.

## Proof / evidence

Measured against Lanczos with full reorthogonalisation over eight test vectors:

- at 8 coefficients the two methods agree to 5.6×10<sup>-16</sup>;
- beyond that the value drifts by up to 2.2×10<sup>-3</sup>;
- at 64 coefficients the vector is off by sin(angle) = 6.1×10<sup>-1</sup>, which stalls the cutting-plane search.

The consequence is re-measured: re-searching M = 8 and M = 16 beats the published rh22/rh23 optima by up to 1.35×.

## Dependencies and related results

- [rh22's ceiling (3)](../rh22/rh22-ceiling-for-every-window.md) and the shifted power iteration described there.
- C. Lanczos (1950) — the fix; cited in the source's references.
- The ladder built with the corrected best-response ([family ladder and convergence](rh24-family-ladder-convergence.md)).
- A second correction of the same machinery in rh25: the β-space bundle search beats rh24's cutting plane on the spline family by 2.443× ([notch-free family searched](../rh25/rh25-notch-free-family-searched.md)).

## Notes


- The source frames this explicitly as a correction while limiting its scope: "Nothing they asserted is wrong — every published value still sits under its published ceiling, and the ceiling is a theorem while the search is a heuristic."
- The values 5.6×10<sup>-16</sup>, 2.2×10<sup>-3</sup>, 6.1×10<sup>-1</sup> and 1.35× are quoted exactly.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
