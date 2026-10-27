# The Artin–Mazur zeta function of Collatz collapses to 1/(1 − 2s)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q9 item 3, lines 317–324; listed as "Rigorous, classical" in the Part II "Notes on rigor", line 582

## Statement

> **The Artin–Mazur (and Ruelle) zeta function.** From any such system one can form
>
>    ζ_AM(s) = exp( Σ_{m≥1} (P_m / m) s^m ),  P_m = #{fixed points of T^m}.
>
> Because T is conjugate to a full 2-shift, P_m grows like 2^m and this zeta function collapses to the trivial rational function ζ_AM(s) = 1/(1 − 2s). It is the zeta function of the shift, and it knows nothing about arithmetic.

## Hypotheses and notation

- T is the Collatz map on ℤ₂, taken with the parity-vector conjugacy to the full 2-shift (see [qa-parity-vector-homeomorphism](qa-parity-vector-homeomorphism.md)).
- ζ_AM is the Artin–Mazur dynamical zeta function; P_m is the number of fixed points of the m-th iterate T^m.
- The source notes the same construction is also known as the Ruelle zeta function.

## Proof / evidence

The source states the collapse and cites the construction as classical; it supplies no proof. The Part II "Notes on rigor" lists "the Artin–Mazur/Ruelle zeta construction and its collapse to 1/(1 − 2s) for a full shift" among the items that are "Rigorous, classical". Once T is conjugate to the full 2-shift, P_m = 2^m and exp(Σ 2^m s^m/m) = 1/(1 − 2s), which is the source's stated reason.

## Dependencies and related results

- [qa-parity-vector-homeomorphism](qa-parity-vector-homeomorphism.md) — the conjugacy that makes the count P_m = 2^m.
- The source's use of this in Q9: "The dynamical zeta function counts *all* 2-adic orbits uniformly, so it cannot separate the finitely many integer orbits from the continuum of 2-adic ones" — its own conclusion, listed under "My own framing" as "the claim that the dynamical zeta functions are 'wrong invariants' because they ignore the '+1'".

## Notes

- This is a citation of a standard result, harvested because qa.md sets it out as a labelled item (numbered 3) of its own argument and lists it as rigorous in its own notes. The status CITED (literature) records that the workspace did not prove it.
- The source's standing caveat (line 594): none of Part II "establishes — or even suggests — a relationship between the Collatz conjecture and the Riemann zeta function ζ(s) or any standard L-function."
