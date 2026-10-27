# The theta functional equation as adelic Poisson — θ(1/x) = √x·θ(x)

**Kind:** Theorem
**Status:** CITED (literature; the adelic Poisson summation applied to the self-dual weight, verified here at relative residual 0.0 at 40 digits)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §2.4 "The mirror is adelic Poisson", equation (6)

## Statement

> Both local weights are their own Fourier transforms — the Gaussian at ∞, and 1_{ℤ_p} at every p because ℤ_p is self-dual under the standard additive character. So the adelic Poisson summation formula applies to *f* with no correction beyond the constant terms, and on the slice it is exactly
>
> ```
> θ(1/x) = √x·θ(x),    θ(x) = Σ_{n ∈ ℤ} e^{−πn²x}                            (6)
> ```
>
> verified to the working precision at x = 0.3, 0.7, 1, 3 (relative residual 0.0 at 40 digits). This is [INTEGERS.md](../../xi-horn/INTEGERS.md) §4(c)'s point — "the theta functional equation *is* Poisson summation" — with the summation now taken over ℚ inside 𝔸 rather than over ℤ inside ℝ, which is what makes the two self-duality rows of §1.4 the mechanism rather than a coincidence.

## Hypotheses and notation

- f = (⊗_p 1_{ℤ_p}) ⊗ e^{−πx²} is the adelic weight of §2.2; the slice is x_fin = 1, x_∞ = e^u.
- θ(x) = Σ_{n ∈ ℤ} e^{−πn²x} is the classical theta series.
- "The two self-duality rows of §1.4" are: at v = p, 1̂_{ℤ_p} = 1_{ℤ_p} — self-dual on the nose; at v = ∞, the Gaussian — self-dual on the nose.

## Proof / evidence

The source derives it as the adelic Poisson summation formula applied to a weight whose both local factors are self-dual, and verifies the resulting identity numerically at x = 0.3, 0.7, 1, 3, quoting relative residual 0.0 at 40 digits (§8 repeats: "theta functional equation (6), x = 0.3, 0.7, 1, 3 | rel. residual 0.0 at 40 digits"). It is stated as a rung of §2's argument, not as new mathematics.

## Dependencies and related results

- §1.4's two self-duality rows (Gaussian; ℤ_p) are the stated mechanism.
- INTEGERS.md §4(c) ("the theta functional equation *is* Poisson summation") is the cited precedent.
- The same file's §2.2 orbit sum uses the translation θ_n(u) = θ₁(u + log n) (source (4)) and §2.5 the finite-direction translation (source (7)).

## Notes

- The identity is classical (Jacobi theta); the source's content is the adelic reading — that the two local self-dualities are "the mechanism rather than a coincidence".
- No claim is made here about the zeros; §2.3's honesty note (the exponent ½ is the idele norm's half-power) is separate.
