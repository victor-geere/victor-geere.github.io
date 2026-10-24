# The parity-vector coding is a homeomorphism conjugating T to the shift

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q9 item 2, lines 312–315; listed as "Rigorous, classical" in the Part II "Notes on rigor", line 580

## Statement

> **The parity-vector coding.** The map
>
>    x ↦ (x mod 2, T(x) mod 2, T²(x) mod 2, …)
>
> is a **homeomorphism** ℤ₂ → {0,1}ⁿ, and under it T is conjugate to the one-sided shift. So as a 2-adic dynamical system, Collatz is *generic* — it is essentially a full shift.

## Hypotheses and notation

- T is the Collatz map; T is the map extended to ℤ₂ (see [qa-collatz-2-adic-measure-preserving](qa-collatz-2-adic-measure-preserving.md)).
- {0,1}ⁿ denotes the space of one-sided binary sequences with the product topology; the source writes it with a superscript n (its own notation for ℕ, preserved verbatim here).
- "Conjugate to the one-sided shift" means there is a homeomorphism intertwining T with the shift map on {0,1}ⁿ.
- The homeomorphism is the 2-adic conjugacy of Bernstein–Lagarias, cited elsewhere in the same document (line 503): "Bernstein & Lagarias, 'The 3x+1 Conjugacy Map' (Canad. J. Math. 48 (1996), 1154–1169) — the parity-vector coding that makes the orbit series well-defined".

## Proof / evidence

The source states the result and cites it as classical; it supplies no proof of the homeomorphism. The Part II "Notes on rigor" lists "the parity-vector homeomorphism and conjugacy to the shift" among the items that are "Rigorous, classical". The follow-up discussion of Q12 names the reference: Bernstein & Lagarias, "The 3x+1 Conjugacy Map", Canad. J. Math. 48 (1996), 1154–1169.

## Dependencies and related results

- [qa-collatz-2-adic-measure-preserving](qa-collatz-2-adic-measure-preserving.md) — the measure-preservation this coding is used with.
- [qa-artin-mazur-zeta-collapse](qa-artin-mazur-zeta-collapse.md) — the collapse of the Artin–Mazur zeta function to 1/(1 − 2s), which follows because T is conjugate to a full 2-shift.

## Notes

- This is a citation of a standard result, harvested because qa.md sets it out as a labelled item (numbered 2) of its own argument and lists it as rigorous in its own notes. The status CITED (literature) records that the workspace did not prove it.
- The source's inference "Collatz is *generic* — it is essentially a full shift" is its own gloss on the cited conjugacy.
