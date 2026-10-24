# The merged kernel: one function, two theories

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh14.html`](../../html/rh14.html) — §2 "The kernel: two registers, one function", equation (1)

## Statement

> E(v) = ∑<sub>ρ</sub> |B(γ<sub>ρ</sub>)|² cos(γ<sub>ρ</sub>v)
> &nbsp;=&nbsp; 2B(*i*/2)²cosh(v/2)
> + (1/π) ∫<sub>0</sub><sup>∞</sup> |B|²cos(rv)[Reψ − lnπ]dr
> − ∑<sub>*n*</sub> (Λ(*n*)/√*n*) C(log *n* ∓ v),
>
> with B the mesh profile's transform and C its autocorrelation bump (support 0.06 — essentially a point on the scale of the gears). The left side is the zeros' theory of E; the right side — pole, place at infinity, gear comb — is the primes' theory, and neither consults the other. Computed independently on 241 points of v ∈ [0, 6]: **one function, two theories, maximum deviation 1.6×10⁻⁵ of scale**.

## Hypotheses and notation

- The alignment: on one helix, arc 2π of phase per unit of height; the phase register ticks at u ∈ ℤ and the scale register at u = log n. Since every log n is irrational against 1, the two tick-trains never coincide twice (rh8 §4).
- On the difference coordinate v, translation invariance collapses rh13's two-index crossing form to E(v).
- γ<sub>ρ</sub> are the zero ordinates; Λ the von Mangoldt function; B the mesh profile's transform, C its autocorrelation bump.
- The dips at v = log n carry exactly the weights Λ(n)/√n (verified at 2, 3, 4, 5 to within 35% of the local baseline in §2's figure).

## Proof / evidence

The source derives E as the difference-coordinate form of the aligned helix — the zeros' theory on the left, the primes' theory on the right — and reports the two independent computations on 241 points of v ∈ [0, 6] agreeing to 1.6×10<sup>−5</sup> of scale. Its reading: "the explicit formula — the arc's equation since rh10 — is revealed as the statement that the dent train and the tone stack are the same function."

## Dependencies and related results

- [The Gram matrix as a fold of the kernel](rh14-gram-matrix-as-fold-of-kernel.md) — the immediate consequence (equation (2)).
- [The Riemann–Weil explicit formula](../rh10/rh10-riemann-weil-explicit-formula.md) — the arc's equation this function embodies.
- [The crossing form: signature (25, 0, 0)](../rh13/rh13-crossing-form-signature.md) — the two-index object E collapses.
- [The nested-slice exhaustion is positive](rh14-nested-slice-exhaustion-positive.md) — the Toeplitz slices of E.

## Notes

- The identity is the explicit formula on the aligned helix; the source gives the derivation and a numerical certificate, not a line-by-line proof of every convergence step.
- The a_ℤ register enters E as its singular support (the dent train at log n); the a_2π register enters as its spectrum (cosines at the zero frequencies).
