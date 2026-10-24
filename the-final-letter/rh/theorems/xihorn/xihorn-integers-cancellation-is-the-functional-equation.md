# The cancellation is the functional equation — the twenty-three-digit collapse on the mirror side

**Kind:** Theorem
**Status:** CITED (literature; classical θ functional equation, exhibited numerically)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §2 "The mirror side: cancellation **is** the functional equation"

## Statement

> On u < 0 the same shells no longer stack — they annihilate:
>
> ```
>     u      Φ(u)              Σ|φ_n|        condition number    digits lost
>   −0.5     0.030188726       0.42041659    13.9                 1
>   −1.0     1.3778139e-07     0.72471281    5.26e+06             6
>   −1.5     6.4883954e-24     0.95255221    1.47e+23            23
> ```
>
> At u = −1.5 the shells sum to ~0.95 in absolute value and produce 6.5e−24. That 23-digit collapse is not a numerical misfortune — **it is the theta functional equation being enforced.** The integers on the negative side conspire to reproduce, exactly, the mirror of the smooth positive side. The cancellation is the arithmetic, and its magnitude is the content.
>
> This is also the sharpest answer available to the standing "the smoothing kills the zeros" worry: here the smooth side and the integer side are *the same function*, related by the mirror, and the exchange between them is quantified above.

## Hypotheses and notation

- Φ(u) = Σ_{n≥1} φ_n(u) with φ_n(u) = (2π²n⁴e^{9u/2} − 3πn²e^{5u/2})·e^{−πn²e^{2u}} (equation (14)).
- Σ|φ_n| is the sum of absolute values of the shells at u; the condition number is Σ|φ_n| / |Φ(u)|; the "digits lost" column counts the decimal digits cancelled.
- Φ is even, and its evenness **is** θ(1/x) = √x·θ(x), the theta functional equation, hence the functional equation of ζ (README §1).
- The mirror side is u < 0.

## Proof / evidence

The source states the identification rather than proving it: the evenness of Φ is the theta functional equation, and the negative-side cancellation is that equation being enforced. The evidence given is numerical: the table of Φ(u), Σ|φ_n|, condition number and digits lost at u = −0.5, −1.0, −1.5, showing a 23-digit collapse at u = −1.5 (Σ|φ_n| ≈ 0.95 producing 6.5e−24, condition number 1.47e+23).

## Dependencies and related results

- Φ's evenness as the theta functional equation: [xihorn-readme-phi-even-is-theta-functional-equation.md](xihorn-readme-phi-even-is-theta-functional-equation.md).
- The integer shells: [xihorn-integers-integer-shells.md](xihorn-integers-integer-shells.md).
- The precision consequence (never evaluate Φ at negative u): [xihorn-integers-precision-rule-six-terms-float64.md](xihorn-integers-precision-rule-six-terms-float64.md).
- The same identification is stated in the companion figure: [figure.html](../../xi-horn/figure.html) §2, already harvested as [xihorn-figure-cancellation-is-the-functional-equation.md](xihorn-figure-cancellation-is-the-functional-equation.md).

## Notes

- The source states this without proof, as a classical identification exhibited numerically; the numerical table is float64/mpmath output, not a certified enclosure.
- The same source's §4 identifies the mechanism behind the mirror as Poisson summation applied to a Gaussian.
