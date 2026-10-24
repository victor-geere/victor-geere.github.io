# The integers are the horn's layers — the shells are strictly hierarchical and never cancel on u ≥ 0

**Kind:** Claim
**Status:** VERIFIED (numerical)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §1 "The integers are the horn's layers", equation (14)

## Statement

> Φ is not a smooth blob with the integers summed away. It is, by definition, a sum of integer-indexed shells:
>
> ```
> Φ(u) = Σ_{n≥1} φ_n(u),    φ_n(u) = (2π²n⁴e^{9u/2} − 3πn²e^{5u/2})·e^{−πn²e^{2u}}   (14)
> ```
>
> Each φ_n is a bump. On u ≥ 0 they are **strictly hierarchical and never cancel** — the integer lattice is not merely present, it is ordered and separable:
>
> ```
>   u      Φ(u)             φ₁ share      φ₂ share        φ₃ share
>   0.0    0.4466969005     99.7829 %     0.217133 %      1.78e-07 %
>   0.3    0.1834871447     99.9999 %     7.055e-05 %     1.38e-16 %
>   0.6    0.0074234562     100.000 %     4.634e-11 %     5.37e-33 %
>   1.0    1.377813941e-07  100.000 %     9.587e-28 %     1.92e-77 %
>   1.4    3.818576539e-19  100.000 %     8.011e-65 %     2.67e-176 %
> ```
>
> **So: draw the horn as nested shells.** Shell 1 is essentially the whole silhouette; shell 2 is a 2-parts-per-thousand skin at the throat that thins to nothing by u = 0.6; shell 3 is a 10⁻⁹ film. On a log-radial axis all of them are visible, distinct, and labelled by *n*. That is the arithmetic, drawn, on the smooth object — no selector function required, because the object was built out of the integers in the first place.
>
> Note the throat is where the integers are *most* visible (shell 2 at 0.217 %) and they vanish going outward.

## Hypotheses and notation

- Φ is the horn's weight (README (1)); φ_n is the n-th integer-indexed shell, a bump supported near u = 0 and decreasing outward.
- The "share" of shell n is its contribution to Φ(u) as a percentage of Φ(u) at the tabulated u; u ≥ 0 only.
- The throat is u = 0, the interior maximum of Φ.

## Proof / evidence

The source states the hierarchy and supports it with the quoted table of shell shares at u = 0.0, 0.3, 0.6, 1.0, 1.4, computed from (14). It draws the conclusion that the construction needs no selector function: the object is defined as a sum over the integers. The source also notes the throat is where the integers are most visible and that they vanish going outward; the companion figure's §1 report (INTEGERS.md §6) confirms the shells nest as predicted.

## Dependencies and related results

- Φ's definition and properties: [README.md](../../xi-horn/README.md) §1 (1).
- The mirror-side behaviour of the same shells: [xihorn-integers-cancellation-is-the-functional-equation.md](xihorn-integers-cancellation-is-the-functional-equation.md).
- The integer-side/probe relation: [POSITIVITY.md](../../xi-horn/POSITIVITY.md) §4.

## Notes


- The definition (14) is a definition; what is harvested is the stated property that on u ≥ 0 the shells are strictly hierarchical and never cancel, with the tabulated shares as evidence.
- The source's companion figure report (§6) adds throat radii 1.000, 0.911, 0.708, 0.407 on the 30-decade log axis, reaching u = 1.615, 0.920, 0.515, 0.225.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `xi-horn/rust/src/phi.rs`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
