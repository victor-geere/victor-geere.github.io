# Computed discriminants of J^{d,n} on a(n) = γ(n)·n!/(2n)! are all strictly positive

**Kind:** Claim
**Status:** VERIFIED (numerical)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §5 "Beat it in topological space, then bring it back", discriminant table

## Statement

> Computed discriminants of J^{d,n} on a(n) = γ(n)·n!/(2n)!, all strictly positive:
>
> ```
>    d   n     discriminant        normalised margin
>    2   0     3.6746e-05          1.357e-04
>    2  10     9.8744e-41          2.236e-05
>    2  30     5.3285e-118         5.261e-06
>    3   0     2.0170e-13          2.512e-12
>    3  15     7.6910e-123         3.918e-15
>    3  30     2.4317e-240         2.276e-16
>    4   0     1.5931e-25          6.108e-24
>    4  15     8.4217e-191         2.831e-29
>    4  30     1.2401e-367         1.057e-31
> ```
>
> (Normalised by (Σ|coefficients|)^{2d−2} to make the margin scale-free.)

## Hypotheses and notation

- J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j is the Jensen polynomial (POSITIVITY.md (13)).
- a(n) = γ(n)·n!/(2n)! is the Laguerre–Pólya sequence, with γ(n) = 4∫₀^∞ u^{2n}Φ(u)du the even moments of the horn's profile.
- The normalised margin is the discriminant divided by (Σ|coefficients|)^{2d−2}.
- d = 2, 3, 4; n = 0, 10, 15, 30 as tabulated.

## Proof / evidence

The source reports the computed discriminants, all strictly positive, as numerical evidence that the corresponding Jensen polynomials are hyperbolic. The normalisation (Σ|coefficients|)^{2d−2} is stated to make the margin scale-free. The source then corrects its own first reading of these numbers (see the companion file on flat margins): the raw plummet from 1.4e−4 to 1.1e−31 measures the discriminant's dimensionality, not difficulty.

## Dependencies and related results

- The Jensen polynomial definition: [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md).
- Hyperbolicity as a sign: [xihorn-integers-hyperbolicity-is-a-sign.md](xihorn-integers-hyperbolicity-is-a-sign.md).
- The scale-free correction: [xihorn-integers-jensen-margins-are-flat.md](xihorn-integers-jensen-margins-are-flat.md).

## Notes


- These are numerical discriminant values, not certified interval enclosures; the source's companion build-list item 5 ("certify the discriminant signs in interval arithmetic") had not been built at the time of writing.
- The source warns against reading the raw magnitudes as difficulty: the flat-margin file records the correction.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `xi-horn/rust/src/jensen.rs`, `xi-horn/rust/RESULTS.md`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
