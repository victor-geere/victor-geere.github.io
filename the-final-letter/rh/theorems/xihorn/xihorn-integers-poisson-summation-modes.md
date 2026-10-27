# (16) Poisson summation — the zeros live in the non-zero Fourier modes

**Kind:** Theorem
**Status:** CITED (literature; the source calls it "the one to actually use")
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §4 "The grown-up sin(πx)", item (c), equation (16)

## Statement

> **(c) Poisson summation**, which is the one to actually use:
>
> ```
> Σ_n f(n) − ∫ f  =  Σ_{k≠0} f̂(k)                                            (16)
> ```
>
> Read that against rh3 §11's warning — "the zeros are the sum minus the integral". (16) says precisely where the zeros live: **in the non-zero Fourier modes.** ∫f is the k = 0 mode; everything arithmetic is in k ≠ 0. That is a location, not an obstruction.
>
> And for this horn specifically, (16) is not an extra structure to bolt on. **The theta functional equation that makes Φ even *is* Poisson summation** — θ(1/x) = √x·θ(x) is (16) applied to a Gaussian. So the mirror symmetry of §2, the shells of §1, and the grown-up sin(πx) are one mechanism seen three ways. Nothing needs to be added to the construction; it is already the intersection you asked for.

## Hypotheses and notation

- f is a suitable function (the source does not restate the decay/smoothness hypotheses for Poisson summation).
- f̂ is the Fourier transform of f; ∫ f is the k = 0 Fourier mode.
- The right-hand sum runs over k ≠ 0.
- The identification with the theta functional equation uses the Gaussian: θ(1/x) = √x·θ(x) is (16) applied to a Gaussian.

## Proof / evidence

The source states (16) without proof as the Poisson summation identity and draws two consequences: (i) the zeros of "sum minus integral" live in the non-zero Fourier modes, the k = 0 mode being ∫f; (ii) for this horn, the evenness of Φ is not an extra structure but the same identity applied to a Gaussian, so §2's mirror symmetry, §1's shells and the pole comb are "one mechanism seen three ways".

## Dependencies and related results

- The cotangent kernel form of the same identity: [xihorn-integers-cotangent-kernel-summation.md](xihorn-integers-cotangent-kernel-summation.md).
- The mirror-side cancellation it explains: [xihorn-integers-cancellation-is-the-functional-equation.md](xihorn-integers-cancellation-is-the-functional-equation.md).
- rh3 §11's warning "the zeros are the sum minus the integral" is cited.

## Notes

- The source gives no proof and no explicit hypotheses for (16); it is harvested as a cited classical identity because the section sets it out as a numbered result and as the mechanism of the construction.
- The Abel–Plana "dress" of the same identity (item (b), kernel 1/(e^{2πiz} − 1)) carries no displayed formula in the source and is not harvested separately.
