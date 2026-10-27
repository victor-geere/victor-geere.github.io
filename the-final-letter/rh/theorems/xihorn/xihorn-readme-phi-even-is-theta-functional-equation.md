# The weight is even, and its evenness is the theta functional equation

**Kind:** Theorem
**Status:** CITED (literature; classical θ(1/x) = √x·θ(x), exhibited numerically)
**Area:** xi-horn
**Source:** [`xi-horn/README.md`](../../xi-horn/README.md) — §1 "The weight", first property

## Statement

> Three properties, all verified numerically below:
>
> * **Even.** Φ(u) = Φ(−u) exactly. This *is* the theta functional equation θ(1/x) = √x·θ(x), and hence the functional equation of ζ. It is not imposed on the construction; it is a property of the weight.
>
> ```
>    u      Φ(u)                Φ(−u) − Φ(u)
>   0.0     0.4466969005        0
>   0.2     0.3042748527        0
>   0.4     0.08624007927       0
>   0.6     0.007423456244      0
>   0.8     0.0001140161852     0
>   1.0     1.377813941e-07     0
>   1.2     3.815292836e-12     0
>   1.4     3.818576539e-19     0
>   1.6     8.752056431e-30     0
> ```
>
> **The entire object lives in |u| ≤ 1.5.** That is the point of the whole exercise; see §6.

## Hypotheses and notation

- Φ(u) = Σ_{n≥1} (2π²n⁴·e^{9u/2} − 3πn²·e^{5u/2})·e^{−πn²·e^{2u}} is the horn's weight (equation (1)).
- θ is the Jacobi theta function; θ(1/x) = √x·θ(x) is its functional equation.
- The tabulated difference Φ(−u) − Φ(u) is zero at u = 0, 0.2, …, 1.6.
- "The entire object lives in |u| ≤ 1.5" because Φ is double-exponentially small there and beyond.

## Proof / evidence

The source states the identification rather than proving it: Φ's defining sum is a theta derivative, and its exact evenness is the theta functional equation θ(1/x) = √x·θ(x), hence the functional equation of ζ. The evidence given is the numerical table showing Φ(−u) − Φ(u) = 0 at u = 0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6. The source stresses: "It is not imposed on the construction; it is a property of the weight."

## Dependencies and related results

- The mirror-side cancellation that exhibits the same equation: [xihorn-integers-cancellation-is-the-functional-equation.md](xihorn-integers-cancellation-is-the-functional-equation.md).
- The Poisson-summation identification (the evenness is (16) applied to a Gaussian): [xihorn-integers-poisson-summation-modes.md](xihorn-integers-poisson-summation-modes.md).
- The normalisation that uses evenness: [xihorn-readme-xi-as-fourier-transform.md](xihorn-readme-xi-as-fourier-transform.md).

## Notes

- The numerical table is float64/mpmath output, not a certified enclosure; INTEGERS.md §3 later corrects that Φ should be evaluated only as Φ(|u|), which is exactly because of this evenness.
- The same source's §0 disclaimer states: "The object is Riemann's Ξ as the Fourier transform of Φ, which is 1859 material".
