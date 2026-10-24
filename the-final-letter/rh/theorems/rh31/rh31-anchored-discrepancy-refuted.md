# The wrong second coordinate: anchored discrepancy refuted

**Kind:** Proposition
**Status:** REFUTED (the anchored-discrepancy coordinate; refuted by construction)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §4 "The wrong second coordinate", lines 984–1016 and boxed table at lines 1004–1008

## Statement

> There is an obvious candidate for the missing position information, and it performs almost perfectly right up until it is refuted. The weighted star discrepancy D*<sub>w</sub> of the atoms (rh30 §5's object) is mesh-dependent, position-sensitive, and orders the destruction's deviations: within the bin [0.1, 0.3), the third of grid points with smallest N<sub>eff</sub>·D*<sub>w</sub> has median λ/E<sub>h</sub>(0) = 0.92 and the third with largest has 0.50. It also explains why one coordinate sufficed before: the searched windows sit near the discrepancy floor D*<sub>w</sub> ≥ 1/(2N<sub>eff</sub>) — their N<sub>eff</sub>·D*<sub>w</sub> stays below 2.4 while the random and interpolated windows reach 5.9. On the floor, the second coordinate is a function of the first.
>
> Then the refutation, by construction. Minimise D*<sub>w</sub> itself over the same coefficient family (coordinate descent from the envelope, at Δ′ = 0.12):
>
> anchored discrepancy D*<sub>x</sub>   searched 0.01362   D*-minimised 0.00681   (halved)
> N<sub>eff</sub>   searched 95.7   D*-minimised 175.5   (×1.83)
> λ<sub>min</sub>   searched 8.55×10<sup>−2</sup>   D*-minimised 3.02×10<sup>−3</sup>   (÷28)
>
> The discrepancy comes out halved and N<sub>eff</sub> nearly doubled — better on *both* candidate coordinates — and λ<sub>min</sub> comes out 28 times *smaller*. Anchored discrepancy is not what the certificate sees.

## Hypotheses and notation

- D*<sub>w</sub> is the weighted star discrepancy of the atoms; D*<sub>x</sub> is the source's anchored discrepancy.
- N<sub>eff</sub> is rh30 §2's effective count; the "same coefficient family" is the window family's 16 free coefficients.
- The minimisation is by coordinate descent from the envelope at Δ′ = 0.12.

## Proof / evidence

Numerical refutation by construction. The source also draws the corollary for thirteen documents of window searching: "thirteen documents of window searching were *not* a discrepancy minimiser in disguise, because the actual discrepancy minimiser is a much worse window."

## Dependencies and related results

- [rh31-collapse-fails-off-searched-family](rh31-collapse-fails-off-searched-family.md) — §3, which motivated looking for a position coordinate.
- [rh30-koksma-lower-bound](../rh30/rh30-koksma-lower-bound.md) — the discrepancy floor D*<sub>w</sub> ≥ 1/(2N<sub>eff</sub>) used here.
- [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md) — the law that survives, under which the D*-window "obeys the law at 1.35".

## Notes

- Status REFUTED applies to D*<sub>w</sub> as the missing second coordinate; the source still records it as "mesh-dependent, position-sensitive" and useful on the searched family.
- The source's own summary in §7: "not a function of the anchored discrepancy (§4 refutes it by construction)".
