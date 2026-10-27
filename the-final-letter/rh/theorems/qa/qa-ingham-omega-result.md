# Ingham's Ω-result: one zero of real part β > 1/2 forces ψ(x) − x = Ω(x<sup>β</sup>)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q6, lines 203–208; listed as "Rigorous, classical" in the Part I "Notes on rigor", line 280

## Statement

> The sharp version is classical (Ingham): a single zero with real part β > 1/2 forces ψ(x) − x = Ω(x^β), i.e. it creates genuine oscillations of amplitude x^β. So one counterexample does not merely "slightly" falsify RH — it changes the *order* of the error term. RH is all-or-nothing in exactly this sense: it is the statement that the error term stays at the single minimum possible order x^{1/2+ε}, and even one zero above 1/2 destroys that.

The same fact is stated in Q4 as: "the x^{1/2+δ} 'burst error' claim is exactly the classical fact that a single zero of real part β > 1/2 forces ψ(x) − x to oscillate at amplitude x^β."

## Hypotheses and notation

- ψ(x) is the Chebyshev function (see [qa-explicit-formula-for-psi](qa-explicit-formula-for-psi.md)).
- β > 1/2 is the real part of a zero ρ = β + iγ of ζ(s); Ω is the Knuth/Landau omega symbol: f(x) = Ω(g(x)) means f is not o(g).
- "Oscillates at amplitude x^β" is the source's gloss on the Ω statement.

## Proof / evidence

The source states the result and attributes it to Ingham; it supplies no proof. The Part I "Notes on rigor" lists "Ingham's Ω(x^β) result (Q6)" among the items that are "Rigorous, classical".

## Dependencies and related results

- [qa-explicit-formula-for-psi](qa-explicit-formula-for-psi.md) — the formula through which the single zero's term of magnitude ≈ x^{1/2+δ}/T appears.
- [qa-von-koch-equivalence](qa-von-koch-equivalence.md) — the positive direction: RH is equivalent to the error staying at order x^{1/2} log x.
- The source's surrounding δ–T trade-off curve (a low counterexample with δ > 0 would break the known π(x) tables; a high one must satisfy x^{1/2+δ}/T below the ~x^{1/2} log x noise floor for all x ≤ 10²⁷) is labelled by the source as its own synthesis, not as part of the classical result.

## Notes

- This is a citation of a standard result, harvested only because qa.md states it as a rung of its own argument and lists it as rigorous in its own notes. The status CITED (literature) records that the workspace did not prove it and gives no further reference than the attribution to Ingham.
- The source's own caveat: the trade-off curve construction around it is "Heuristic framing" only insofar as its quantitative form goes; the source calls the Davenport–Heilbronn example classical and rigorous (Q8), and lists the δ–T trade-off curve under "My own synthesis / framing" (line 286).
