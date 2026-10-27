# The effective count N<sub>eff</sub>

**Kind:** Proposition
**Status:** PROVED (paper argument; VERIFIED numerically to 1 part in 10<sup>12</sup>)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §2 "The effective count", lines 374–410 and boxed table at lines 386–392

## Statement

> N<sub>eff</sub> = ‖μ‖ ∕ (2 max<sub>γ</sub> ĥ(γ)<sup>2</sup>) — the total mass of the measure divided by its heaviest atom. If all the atoms weighed the same there would be exactly N<sub>eff</sub> of them; as it is, it is the reciprocal of the largest relative weight, and it says how spread the measure is rather than how many atoms it has.

Two stated properties:

> First, it is set by the *window alone*. The mesh enters μ only through the positions γΔ′ mod 2π, and N<sub>eff</sub> is a statement about weights, so changing the mesh leaves it exactly unaltered — asserted to 1 part in 10<sup>12</sup> across all five meshes, which is machine zero. Second, it is not the number of atoms carrying appreciable weight: the participation ratio (∑w)<sup>2</sup>/∑w<sup>2</sup> is 190.4 where N<sub>eff</sub> is 95.7, and the two differ by a factor of about two at every support. N<sub>eff</sub> is the more pessimistic of the two, and it is the one that works.

The boxed table of values:

> window Δ′ = 0.48   N<sub>eff</sub> = 7.0   heaviest atom 14.197% of the mass   participation ratio 15.0
> window Δ′ = 0.24   N<sub>eff</sub> = 17.3   heaviest atom 5.781% of the mass   participation ratio 38.4
> window Δ′ = 0.12   N<sub>eff</sub> = 95.7   heaviest atom 1.045% of the mass   participation ratio 190.4
> window Δ′ = 0.06   N<sub>eff</sub> = 207.0   heaviest atom 0.483% of the mass   participation ratio 454.7
> window Δ′ = 0.03   N<sub>eff</sub> = 467.3   heaviest atom 0.214% of the mass   participation ratio 1104.1

## Hypotheses and notation

- μ = ∑<sub>ρ</sub> ĥ(γ<sub>ρ</sub>)<sup>2</sup>δ<sub>γ<sub>ρ</sub>Δ′ mod 2π</sub> is rh29's atomic measure (conditional on RH).
- ‖μ‖ is its total mass; max<sub>γ</sub> ĥ(γ)<sup>2</sup> is its heaviest atom.
- The five meshes and five windows are the arc's searched family; "the arc's own support" Δ′ = 0.12 has 4,308 atoms in the table and N<sub>eff</sub> = 95.7.

## Proof / evidence

The mesh-independence is a paper argument (N<sub>eff</sub> involves only weights) verified to 1 part in 10<sup>12</sup> across all five meshes. The figures in the table are numerical. The source explains the large spread of weights by rh29's mechanism: the searched window's coefficient polynomial A(r) is periodic and the optimiser drove it near zero at small r.

## Dependencies and related results

- [rh29-symbol-is-an-atomic-measure](../rh29/rh29-symbol-is-an-atomic-measure.md) — the measure and its atoms.
- [rh30-collapse-in-n-over-neff](rh30-collapse-in-n-over-neff.md) — the one-coordinate law this number governs.
- [rh30-koksma-lower-bound](rh30-koksma-lower-bound.md) — N<sub>eff</sub> sets that bound's reach via D*<sub>w</sub> ≥ 1/(2N<sub>eff</sub>).

## Notes

- The statement is a definition plus the two properties the source asserts about it; it is harvested because the source presents those properties as results ("Two things about it").
- The source's headline figure: "at the arc's own support Δ′ = 0.12 the measure has 4,308 atoms in the table and N<sub>eff</sub> = 95.7. Ninety-six. That is the whole of the arc's sensitivity."
