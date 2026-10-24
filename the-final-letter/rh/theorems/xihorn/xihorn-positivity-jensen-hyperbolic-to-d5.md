# Every scanned Jensen polynomial is hyperbolic, max |Im root| = 0 exactly at 60 digits

**Kind:** Claim
**Status:** VERIFIED (numerical, 60 decimal digits)
**Area:** xi-horn
**Source:** [`xi-horn/POSITIVITY.md`](../../xi-horn/POSITIVITY.md) — §5 "Beyond d = 2 — the Jensen polynomials", computed table

## Statement

> Computed for d = 2, 3, 4, 5 and n = 0, 4, 8, …, 28 — **every one hyperbolic, max |Im root| = 0 exactly at 60 digits.** a(n) is also log-concave throughout (ratios 1.0748 at n = 0 falling to 1.0134 at n = 30).
>
> Roots normalized to mean 0, variance 1, compared with the same normalization of the Hermite roots H_d:
>
> ```
>    d    n=0      n=8      n=12     n=20     n=28
>    2    —        —        —        —        —        (vacuous: two points → ±1)
>    3    0.0143   0.0334   0.0339   0.0329   0.0314
>    4    0.0259   0.0347   0.0350   0.0337   0.0321
>    5    0.0389   0.0518   0.0518   0.0498   0.0474
> ```
>
> The deviation peaks near n ≈ 12 and then declines — the Hermite limit of Griffin–Ono–Rolen–Zagier (2019, from memory; verify before citing), arriving slowly. The d = 2 row is struck out because any two points normalized to mean 0 and variance 1 are ±1 regardless of their values; it proves nothing and should not be reported as agreement.

## Hypotheses and notation

- J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j are the Jensen polynomials (POSITIVITY.md (13)); a(n) = γ(n)·n!/(2n)!.
- The scan is d = 2, 3, 4, 5 and n = 0, 4, 8, …, 28, at 60 decimal digits.
- Hyperbolic means all roots real; "max |Im root| = 0 exactly" is the numerical report.
- The normalised comparison places roots at mean 0 and variance 1 and compares the maximum deviation from the same normalisation of the Hermite roots H_d.
- The d = 2 row is vacuous because any two points normalised to mean 0 and variance 1 are ±1.

## Proof / evidence

The source reports the numerical computation at 60 decimal digits: every scanned J^{d,n} is hyperbolic with max |Im root| = 0 exactly; a(n) is log-concave throughout with ratios 1.0748 at n = 0 falling to 1.0134 at n = 30. The normalised root deviation from Hermite is tabulated for d = 3, 4, 5 over n = 0, 8, 12, 20, 28, peaking near n ≈ 12 and declining. The source strikes out the d = 2 row as vacuous.

## Dependencies and related results

- The Jensen criterion (12)–(13): [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md).
- The raw discriminant evidence for the same polynomials: [xihorn-integers-positive-jensen-discriminants.md](xihorn-integers-positive-jensen-discriminants.md).
- The flat, scale-free margin measurement: [xihorn-integers-jensen-margins-are-flat.md](xihorn-integers-jensen-margins-are-flat.md).

## Notes


- The Hermite limit is attributed by the source to Griffin–Ono–Rolen–Zagier (2019, from memory; verify before citing); the source's own contribution here is the numerical deviation table, not the limit theorem, and the limit is not harvested separately from this source.
- The source's §6 caveat stands: this is finitely many conditions verified (d ≤ 5, n ≤ 33), and RH needs all d and all n.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `xi-horn/rust/src/jensen.rs`, `xi-horn/rust/RESULTS.md`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
