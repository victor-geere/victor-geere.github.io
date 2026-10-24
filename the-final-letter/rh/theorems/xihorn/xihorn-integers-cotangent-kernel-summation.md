# (15) The cotangent kernel — π·cot(πz) picks off the integers

**Kind:** Theorem
**Status:** CITED (literature; classical cotangent/pole-comb summation, called exact and not asymptotic by the source)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §4 "The grown-up sin(πx)", item (a), equation (15)

## Statement

> **(a) The cotangent kernel.** π·cot(πz) has a simple pole of residue 1 at every integer and nowhere else. Hence, for f holomorphic in a strip,
>
> ```
> Σ_n f(n) = (1/2πi) ∮ f(z)·π cot(πz) dz                                     (15)
> ```
>
> The contour is the "angle" — it crosses the real axis transversally, and the integers are picked off as residues. This is exact, not asymptotic.

## Hypotheses and notation

- f is holomorphic in a strip containing the real axis (the source's hypothesis for the contour integral).
- π·cot(πz) has simple poles of residue 1 exactly at the integers.
- The contour ∮ crosses the real axis transversally and encloses the integers being summed.

## Proof / evidence

The source states the identity without proof; it is the classical cotangent (pole-comb) summation formula obtained from the residue theorem, with the poles of π·cot(πz) located at the integers and each contributing f(n). The source notes it is "exact, not asymptotic" and that "the contour is the 'angle'" that picks the integers off as residues.

## Dependencies and related results

- The same pole comb in its two other dresses: [xihorn-integers-poisson-summation-modes.md](xihorn-integers-poisson-summation-modes.md) (Poisson summation, (16)) and the Abel–Plana form named in the same section (not separately harvested).
- The application to this horn: the theta functional equation that makes Φ even is Poisson summation applied to a Gaussian.

## Notes

- The source presents the pole comb as the "mature form" of "a function that intersects a smooth object exactly at the integers, at an angle", and calls its three forms — cotangent kernel, Abel–Plana, Poisson summation — "three equivalent dresses".
- The source gives no explicit formula for the Abel–Plana case, only the kernel 1/(e^{2πiz} − 1) and the statement that it is "the honest version of Euler–Maclaurin: no Bernoulli asymptotics, no remainder to bound"; that form is therefore not harvested as a separate theorem.
