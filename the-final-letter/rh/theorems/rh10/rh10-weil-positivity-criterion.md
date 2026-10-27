# Weil positivity: W(h) ≥ 0 for every h = |f̂|²

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh10.html`](../../html/rh10.html) — §1 and the §6 scoreboard table ("the pairing (Weil; rh4 §15)")

## Statement

> W(*h*) ≥ 0 for every *h* = |*f̂*|² &nbsp;⟺&nbsp; RH.

The source's scoreboard states the same equivalence in the form: the pairing (Weil; rh4 §15) has RH-equivalent reading "W(*h*) ≥ 0 for every *h* = |*f̂*|²", and §1 writes that "RH is equivalent to the right-hand side being ≥ 0 whenever *h* = |*f̂*|² — positivity of the arithmetic pairing on all test functions".

## Hypotheses and notation

- W is the explicit-formula functional of §1: the right-hand side of the Riemann–Weil formula evaluated on an admissible test function.
- The quantification is over the whole cone of test functions *h* = |*f̂*|², not over one window.
- "Axiom 8" is the arc's name (rh4 §15) for a pairing with provable positivity.

## Proof / evidence

The source cites the criterion as classical (Weil; built as an instrument in rh10 §1) and gives no proof. What it reports is a measurement: the Gaussian-window scan W(*t*₀) over *t*₀ ∈ [8, 46] is computed from the arithmetic side alone, peaks at each of the eight zeros in range, falls to ≈ 2×10<sup>−5</sup> in the gaps, and has global minimum −1.5×10<sup>−11</sup> (quadrature noise); the same scan from the 138 zeros differs by at most 5×10<sup>−6</sup>. The source itself insists this cannot prove the criterion: "Each reading is one test function; the criterion quantifies over *all* of them", and positivity "for every *h* = |*f̂*|² is a statement about a quadratic form on an infinite-dimensional space, and the present symmetries give that space no basis to be diagonalised in."

## Dependencies and related results

- [The Riemann–Weil explicit formula](rh10-riemann-weil-explicit-formula.md) — the equation whose right-hand side is W.
- [Li's criterion](rh10-li-criterion.md), [de Bruijn–Newman threshold](rh10-de-bruijn-newman-threshold.md), [Beurling–Nyman criterion](rh10-beurling-nyman-criterion.md) — the other three instruments of the same document.
- rh13's crossing form and rh14's merged kernel are later realisations of the same pairing.

## Notes

- Classical (Weil); the source sets it out as one of the four operational criteria it builds, and records that over 𝔽<sub>q</sub>(t) the corresponding positivity is the Hodge index form.
- The measured positivity is "sharp": between zeros the pairing has essentially nothing to spare (dips ≈ 2×10<sup>−5</sup>).
