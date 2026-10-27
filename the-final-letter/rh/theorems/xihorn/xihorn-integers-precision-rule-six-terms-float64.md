# The precision rule — Phi(u) := Phi_series(abs(u)), 6 terms, float64

**Kind:** Claim
**Status:** VERIFIED (numerical, float64 against mpmath 60 dps; correction of README.md §7 and POSITIVITY.md §7)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §3 "Precision: solved, and a correction"

## Statement

> **Correction to README.md §7 and POSITIVITY.md §7.** I told you Φ needs ≥ 50 decimal digits. That diagnosis was wrong in a way that changes what you build. The precision loss is entirely on u < 0, and Φ is even, so **u < 0 never needs to be evaluated.**
>
> Evaluate `Φ(|u|)` with 6 terms in ordinary double precision:
>
> ```
>    u      double, 6 terms            mpmath 60 dps              rel. error
>   0.0     4.466969004671235e-01      0.4466969004671234         3.3e-17
>   0.4     8.624007926801679e-02      0.08624007926801684        6.5e-16
>   0.8     1.140161851518449e-04      0.0001140161851518448      1.3e-15
>   1.2     3.815292835622197e-12      3.815292835622206e-12      2.2e-15
>   1.6     8.752056431082546e-30      8.752056431082448e-30      1.1e-14
> ```
>
> Full double-precision accuracy down to Φ ~ 10⁻³⁰. Compare the *same formula* at negative u in double precision:
>
> ```
>   −1.0    1.377813939664411e-07      rel. error 7.0e-10
>   −1.4    9.296726948523107e-17      rel. error 242
>   −1.6    5.604709853449715e-17      rel. error 6.4e+12
> ```
>
> **Rule for any implementation: `Phi(u) := Phi_series(abs(u))`, 6 terms, float64.** No arbitrary precision anywhere in the figure. The mpmath in the other two files was buying nothing but the right to make a sign error.

The source adds a scope restriction:

> (The moment integrals of POSITIVITY.md still want extended precision, but for a different and honest reason — γ(n) at n ≈ 34 is a 10⁻⁷ quantity extracted from an integrand spanning 30 orders, and the Jensen discriminants of §5 are tiny.)

## Hypotheses and notation

- Φ is the horn's weight; Φ is even, so Φ(−u) = Φ(u) and only |u| need ever be evaluated.
- `Phi_series` is the 6-term truncation of the defining shell sum (14).
- mpmath at 60 dps is the reference; rel. error is double/60-digit relative difference.
- The rule applies to the figure's evaluation of Φ; the moment integrals γ(n) and the Jensen discriminants are explicitly excepted.

## Proof / evidence

The source gives a numerical comparison: on u ≥ 0 the 6-term float64 evaluation matches mpmath at 60 dps with relative errors 3.3e−17, 6.5e−16, 1.3e−15, 2.2e−15, 1.1e−14 down to Φ ~ 10⁻³⁰, whereas the same formula at negative u gives relative errors 7.0e−10, 242 and 6.4e+12 at u = −1.0, −1.4, −1.6. The diagnosis is that the catastrophic cancellation lies entirely on u < 0, which evenness removes.

## Dependencies and related results

- The cancellation on u < 0: [xihorn-integers-cancellation-is-the-functional-equation.md](xihorn-integers-cancellation-is-the-functional-equation.md).
- The corrected reconstruction in [README.md](../../xi-horn/README.md) §7 and [POSITIVITY.md](../../xi-horn/POSITIVITY.md) §7.

## Notes


- The source presents this as a correction of its own earlier advice in README.md §7 and POSITIVITY.md §7 ("I told you Φ needs ≥ 50 decimal digits. That diagnosis was wrong").
- Extended precision is still wanted for the moment integrals γ(n) and the Jensen discriminants; the rule is not claimed for those.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `xi-horn/figure.html`, `xi-horn/rust/src/phi.rs`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
