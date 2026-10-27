# The Collatz map extends to ℤ₂ and preserves Haar measure

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q9 item 1, lines 307–310; listed as "Rigorous, classical" in the Part II "Notes on rigor", line 579

## Statement

> **Collatz is a genuine 2-adic dynamical system.** The map T extends continuously to the 2-adic integers ℤ₂, and there it is **measure-preserving** with respect to the normalized Haar measure (this is classical; see Lagarias's survey *The 3x+1 problem and its generalizations*).

## Hypotheses and notation

- T is the standard Collatz map: T(n) = n/2 if n is even, T(n) = 3n + 1 if n is odd.
- ℤ₂ is the ring of 2-adic integers; the normalized Haar measure on ℤ₂ is the unique translation-invariant probability measure.
- "Extends continuously" means the map on ℤ is uniformly continuous for the 2-adic metric and so extends to the completion ℤ₂.

## Proof / evidence

The source states the result and cites it as classical, pointing to Lagarias's survey *The 3x+1 problem and its generalizations*; it supplies no proof. The Part II "Notes on rigor" lists "the 2-adic extension of T and its measure-preservation" among the items that are "Rigorous, classical".

## Dependencies and related results

- [qa-parity-vector-homeomorphism](qa-parity-vector-homeomorphism.md) — the refinement used in the next item of the same answer: the parity-vector coding is a homeomorphism onto {0,1}ⁿ under which T is conjugate to the one-sided shift.
- [qa-artin-mazur-zeta-collapse](qa-artin-mazur-zeta-collapse.md) — the dynamical zeta function this conjugacy makes trivial.

## Notes

- This is a citation of a standard result, harvested because qa.md sets it out as a labelled item (numbered 1) of its own argument and lists it as rigorous in its own notes. The status CITED (literature) records that the workspace did not prove it; the source's one citation is the Lagarias survey (no page or URL given).
- The source's Part II "Bottom line" caution applies to this and the neighbouring items: none of them establishes or suggests a relationship between the Collatz conjecture and ζ(s) or any standard L-function.
