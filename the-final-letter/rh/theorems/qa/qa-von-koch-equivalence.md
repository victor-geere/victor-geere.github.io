# von Koch's equivalence: RH ⇔ π(x) = Li(x) + O(x<sup>1/2</sup> log x)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q5, lines 148–152; listed as "Rigorous, classical" in the Part I "Notes on rigor", line 279

## Statement

> RH is equivalent (von Koch) to
>
> ```
> π(x) = Li(x) + O(x^{1/2} log x).
> ```
>
> The error is a *global* control.

## Hypotheses and notation

- π(x) is the prime-counting function; Li(x) is the logarithmic integral.
- The equivalence is with the Riemann Hypothesis: all nontrivial zeros of ζ(s) satisfy Re ρ = 1/2.
- The O-constant is absolute; the statement is an asymptotic as x → ∞.

## Proof / evidence

The source states the equivalence and attributes it to von Koch; it supplies no proof. The Part I "Notes on rigor" lists "von Koch's equivalence and the x^{1/2} scale boundary (Q5)" among the items that are "Rigorous, classical".

## Dependencies and related results

- [qa-explicit-formula-for-psi](qa-explicit-formula-for-psi.md) — the explicit formula from which the error term is read.
- The source's derived scale statement in the same answer: RH says nothing about primes in intervals of length h ≪ x^{1/2}, because the O(x^{1/2} log x) error swamps the expected count h/log x; it speaks at the mesoscopic-to-global scale h ≥ x^{1/2+ε}. The source labels the surrounding framing ("RH is the largest-scale, most coarse-grained true statement about primes") as its own synthesis.
- [qa-ingham-omega-result](qa-ingham-omega-result.md) — the companion classical statement about what one off-line zero does to the error term.

## Notes

- This is a citation of a standard result, harvested only because qa.md states it as a rung of its own argument and lists it as rigorous in its own notes. The status CITED (literature) records that the workspace did not prove it.
- The "crisp answer" the source draws from it — that RH says nothing inside intervals shorter than roughly x^{1/2} — is the source's reading of the equivalence, not part of the cited theorem.
