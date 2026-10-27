# The moments are a prime sum

**Kind:** Theorem
**Status:** PROVED (paper argument, from the explicit formula; VERIFIED numerically against the arc's certified row and the zero table)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §6 "The moments are a prime sum", lines 712–748 and boxed identity at lines 720–724

## Statement

> Here the two halves of the arc meet. For a window ĥ(r) = Û<sub>c</sub>(r)·A(r) with autocorrelation C<sub>h</sub> = the inverse transform of ĥ<sup>2</sup>, the explicit formula gives, for every v,
>
> E(v) = 2·ĥ(i/2)<sup>2</sup>·cosh(v/2) + arch(v) − ∑<sub>m≥2</sub> Λ(m)·m<sup>−1/2</sup> [C<sub>h</sub>(ln m − v) + C<sub>h</sub>(ln m + v)]
>
> and the left-hand side at v = kΔ is precisely the Toeplitz moment of the wrapped-ordinate measure, E(kΔ) = 2∑<sub>γ</sub> ĥ(γ)<sup>2</sup> cos(kΔγ).

The two checks, from opposite directions:

> - Built from the primes, the row reproduces rh17's *certified* row (Δ = 0.06, M = 1, n = 199) to 8.4×10<sup>−16</sup> — so the assembly here is the arc's own, not a re-derivation that might differ by a convention.
> - Built from the zeros — all 22,491 ordinates below 20000 — it agrees with the prime-side row to 7.2×10<sup>−8</sup> of the mass at mesh 0.12, 1.4×10<sup>−7</sup> at 0.06 and 5.7×10<sup>−9</sup> at 0.24, the coarsest support the arc has certified. The loss constants agree to six digits.

and the source's conclusion:

> So the wrapped measure of rh29–rh32 is not a model of the certified row. It *is* the certified row, evaluated on the other side of the explicit formula.

## Hypotheses and notation

- ĥ(r) = Û<sub>c</sub>(r)·A(r) is the window; C<sub>h</sub> is the inverse transform of ĥ<sup>2</sup> (the window's autocorrelation).
- Λ is the von Mangoldt function; m ≥ 2 runs over prime powers; m<sup>−1/2</sup> is the explicit formula's weight.
- arch(v) is the archimedean term; 2·ĥ(i/2)<sup>2</sup>·cosh(v/2) is the pole term.
- γ runs over the zero ordinates; Δ is the mesh; E(kΔ) is the Toeplitz moment of the wrapped-ordinate measure.

## Proof / evidence

Paper argument from the explicit formula (the same identity as [rh29-explicit-formula-right-to-left](../rh29/rh29-explicit-formula-right-to-left.md), written with the autocorrelation C<sub>h</sub>), with two independent numerical checks: against rh17's certified row to 8.4×10<sup>−16</sup>, and against the zero side (all 22,491 ordinates below 20000) to 7.2×10<sup>−8</sup>, 1.4×10<sup>−7</sup> and 5.7×10<sup>−9</sup> of the mass at meshes 0.12, 0.06 and 0.24.

## Dependencies and related results

- [rh29-explicit-formula-right-to-left](../rh29/rh29-explicit-formula-right-to-left.md) — the same explicit-formula identity on the arc's older mesh family.
- [rh33-loss-constant-identification](rh33-loss-constant-identification.md) — the loss constant these moments determine.
- [rh33-prime-comb-cancellation](rh33-prime-comb-cancellation.md) — §6's arithmetic reading of the moment spectrum.
- rh17 (the certified row), rh25 (the positive-definite generator Û<sub>c</sub>).

## Notes

- §6 uses the full 22,491-ordinate table (γ ≤ 20000) rather than the 4,308-ordinate cut of rh29–rh32, "because the identity it checks is sharp enough to see the difference".
- The source's arithmetic observation, not itself the theorem: the six largest moments at mesh 0.12 each sit within 0.0109 in log of a prime power — k = 20 ↔ 11, 28 ↔ 29, 30 ↔ 37, 34 ↔ 59, 39 ↔ 107, 53 ↔ 577 — and the largest, |E|/mass = 0.146, sits at k = 20, where e<sup>2.4</sup> = 11.02.
