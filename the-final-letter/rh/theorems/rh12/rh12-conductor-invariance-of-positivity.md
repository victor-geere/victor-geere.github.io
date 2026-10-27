# Conductor invariance of the positivity scan

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh12.html`](../../html/rh12.html) — §4 "Dig three — the family: gears wearing characters"

## Statement

> Nothing in the arc's machinery is special to ζ. … Built here from Hurwitz zeta (Euler–Maclaurin, validated against three exact identities including ψ′(¼) = π² + 8G), the L-functions of the real primitive characters mod 3, 4, 5 are anchored absolutely — L(2,χ₄) equals Catalan's constant to 10<sup>−10</sup>, and independently the ℤ[i] lattice sum over 1.1 million points reproduces ζ(2)·G to 3×10<sup>−5</sup> … Zeros: 151, 162, 170 ordinates to height 250, against counting-formula predictions of 150.6, 162.1, 170.8; first ordinates 8.039737 (χ₃) and 6.020949 (χ₄) matching the cited values to 10<sup>−5</sup>, and 6.648453 (χ₅) measured. The explicit formula: re-verified per character to 10<sup>−5</sup> … The scan: Weil positivity per character, nonnegative across the range for all three, dips to 2.5×10<sup>−5</sup> (χ₃), 1.6×10<sup>−2</sup> (χ₅), 1.2×10<sup>−1</sup> (χ₄) — floor depths set by each spectrum's local gaps, exactly as for ζ.

## Hypotheses and notation

- χ₃, χ₄, χ₅ are the real primitive Dirichlet characters of conductors 3, 4, 5; G is Catalan's constant; G = β(2).
- The completed function Λ(½+it,χ) is verified real on the line (root number +1, Gauss's theorem, to 10<sup>−8</sup>).
- The same three instruments are run per conductor: zeros, explicit formula, positivity scan.

## Proof / evidence

The source describes the construction and its checks: Hurwitz-zeta Euler–Maclaurin validated against three exact identities including ψ′(¼) = π² + 8G; L(2,χ₄) = Catalan's constant to 10<sup>−10</sup>; the ℤ[i] lattice sum over 1.1 million points reproducing ζ(2)·G to 3×10<sup>−5</sup>; per-character reality of Λ on the line to 10<sup>−8</sup>; the zero census against the counting formula; the explicit formula per character to 10<sup>−5</sup>; "every scan value ≥ −10<sup>−6</sup>". The reading: "The gears wear characters; the knife edge is conductor-independent."

## Dependencies and related results

- [Weil positivity: W(h) ≥ 0 for every h = |f̂|²](../rh10/rh10-weil-positivity-criterion.md) — the criterion run per character.
- [The optimal-window frontier](rh12-optimal-window-frontier.md) and [GUE statistics at 10⁶](rh12-gue-statistics-at-1e6.md) — the same document's ζ-specific digs.
- The source's conclusion: "the obstruction is uniform. Nothing about ζ's missing foundation is special to ζ."

## Notes


- The values are finite computations to height 250 with the stated tolerances; the source does not claim a theorem about the family.
- Dips differ per character (2.5×10<sup>−5</sup> for χ₃, 1.6×10<sup>−2</sup> for χ₅, 1.2×10<sup>−1</sup> for χ₄), which the source attributes to each spectrum's local gaps.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
