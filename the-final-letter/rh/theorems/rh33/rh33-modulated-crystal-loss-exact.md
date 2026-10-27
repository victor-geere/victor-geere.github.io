# The refutation: the modulated crystal

**Kind:** Proposition
**Status:** PROVED (paper argument, exactly; verified to machine zero)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §4 "The refutation", lines 492–506 and boxed statement at lines 497–500

## Statement

> Leave the atoms where they are. Modulate the weights:
>
> w<sub>j</sub> = 1 + ε·cos((n − 1)·t<sub>j</sub>) on the crystal ⇒ ρ = 1 − ε/2, exactly.
>
> Exactly: 0.550 at ε = 0.9 and 0.500 at ε = 1, to machine zero. The mechanism is transparent — the modulation is a single Fourier mode, it lands on the single Toeplitz moment E(n − 1), and ρ = 1 − max|E|/mass for a rank-two perturbation of the identity.

## Hypotheses and notation

- The atoms stay at the crystal's positions ±t<sub>j</sub>; only the weights are modulated, at frequency n − 1.
- ε is the modulation depth; ρ is [rh33-loss-constant-identification](rh33-loss-constant-identification.md)'s loss constant.
- E(n − 1) is the single Toeplitz moment the modulation lands on; the perturbation of the identity has rank two.

## Proof / evidence

Paper argument, exact: the modulation is a single Fourier mode at frequency n − 1, which is exactly the index of one Toeplitz moment, giving ρ = 1 − ε/2 for a rank-two perturbation of the identity. Verified numerically at ε = 0.9 (0.550) and ε = 1 (0.500) to machine zero.

## Dependencies and related results

- [rh33-quadrature-lemma-refuted](rh33-quadrature-lemma-refuted.md) — the refutation this construction drives.
- [rh33-loss-constant-identification](rh33-loss-constant-identification.md) — the quantity computed.
- [rh32-crystal-atom-sum-identity](../rh32/rh32-crystal-atom-sum-identity.md) — the identity on the unmodulated crystal.
- [rh33-moment-bound-vacuous](rh33-moment-bound-vacuous.md) — §5's generalisation ρ = 1 − max|E|/mass "because only one moment is on".

## Notes

- Unconditional: the construction is synthetic (crystal positions, no arithmetic input).
- The source's point is that the modulated measure's emptiness profile barely moves while its loss falls to ½; see [rh33-quadrature-lemma-refuted](rh33-quadrature-lemma-refuted.md).
