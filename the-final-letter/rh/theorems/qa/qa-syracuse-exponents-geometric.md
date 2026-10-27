# The Syracuse exponents are geometrically distributed with density 2<sup>−k</sup>

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q10 item 1, lines 354–361; listed as "Rigorous, classical" in the Part II "Notes on rigor", line 581

## Statement

> **The Syracuse exponents are geometrically distributed.** As n runs over odd integers, the natural density of n with v₂(3n + 1) = k is exactly **2^{-k}**. (Proof: 3 is a unit mod 2^k, so 3n + 1 ranges uniformly over the residue classes mod 2^k as n ranges over odd residues.) This is the rigorous backbone of everything that follows, and it is a statement about the *local* (2-adic) zeta function / measure of the Syracuse map: the "valuation jump" has the simplest possible closed form.

## Hypotheses and notation

- v₂(m) is the 2-adic valuation of m, i.e. the exponent of 2 in m; a(n) = v₂(3n + 1) are the "Syracuse steps".
- The Syracuse map is the odd-only accelerated Collatz map S(n) = (3n + 1)/2^{a(n)}.
- "Natural density" is over the odd integers n, as stated.
- 3 is a unit mod 2^k means 3 is invertible in ℤ/2^kℤ.

## Proof / evidence

The source supplies the proof in one parenthetical: 3 is a unit mod 2^k, so as n ranges over the odd residues, 3n + 1 ranges uniformly over the residue classes mod 2^k; the class v₂ = k has density 2^{−k} among those classes. The Part II "Notes on rigor" lists "the geometric distribution of the Syracuse exponents a(n) = v₂(3n + 1) (density 2^{-k}, via 3 being a unit mod 2^k)" among the items that are "Rigorous, classical".

## Dependencies and related results

- The source's use of it in the same answer: under the geometric law the expected log-shrinkage of one Syracuse step is E[log(2^a / 3)] = Σ_{k≥1} 2^{−k} log(2^k / 3) = 2 log 2 − log 3 = log(4/3) > 0, i.e. on average an odd number shrinks by a factor 4/3 per Syracuse step. The source labels this random-walk shrinkage heuristic as conjectural/heuristic in its notes (line 587), while the geometric distribution itself is listed as rigorous.
- [qa-collatz-2-adic-measure-preserving](qa-collatz-2-adic-measure-preserving.md) — the 2-adic measure picture the source says this statement belongs to.

## Notes

- The status is PROVED (paper argument): the source gives the argument, and it is a one-step uniform-distribution computation; the source also labels it classical. It is harvested here rather than marked CITED because qa.md itself sets out the proof, and no external reference is named.
- The source's qualification of the surrounding material: the 3/4-shrinkage heuristic ("almost all orbits descend to 1") is listed under "Conjectural / heuristic"; Tao's 2019 density theorem is listed as "Rigorous but weak".
